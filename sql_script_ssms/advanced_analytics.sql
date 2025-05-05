-- Change over time (trends) analysis
SELECT 
	YEAR(order_date) AS order_year,
	MONTH(order_date) AS order_month,
	SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) AS total_customer,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);


SELECT 
	DATETRUNC(year,order_date) as order_month,
	SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) AS total_customer,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(year,order_date)
ORDER BY DATETRUNC(year,order_date)

SELECT 
FORMAT(order_date,'yyyy-MMM') as order_month,
SUM(sales_amount) AS total_sales,
COUNT(DISTINCT customer_key) AS total_customer,
SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date,'yyyy-MMM')
ORDER BY FORMAT(order_date,'yyyy-MMM')

-- calculate the total sales per month
-- and the running total of sales over time

SELECT 
    order_date,
    total_sales,
    SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales,
	AVG(avg_price) OVER (ORDER BY order_date) AS moving_average_price

FROM (
    SELECT
        DATETRUNC(month, order_date) AS order_date,
        SUM(sales_amount) AS total_sales,
		AVG(price) AS avg_price
    FROM GOLD.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(month, order_date)
) t;

/*
 analyze the yearly performane of products by comparing their sales to both 
 the average sales performance of the product and the pervious year's sales
*/

WITH yearly_product_sales AS (
SELECT 
	year(f.order_date) AS order_year,
	d.product_name,
	SUM(f.sales_amount) AS current_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products d
	ON f.product_key = d.product_key
WHERE order_date IS NOT NULL
GROUP BY 
	year(f.order_date),
	d.product_name
)

SELECT 
	order_year,
	product_name,
	current_sales,
	AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
	current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg,

	CASE 
		WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
		WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
		ELSE 'Avg'
	END AS avg_change,

	-- year over year analysis
	LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS py_sales,
	current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS diff_py,

	CASE 
		WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
		WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
		ELSE 'No change'
	END AS py_change

FROM yearly_product_sales
ORDER BY product_name, order_year;


-- which categories contribute the most to overall sales

WITH category_sales AS (
SELECT 
    p.category,
    SUM(s.sales_amount) AS total_sales
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
    ON s.product_key = p.product_key
GROUP BY p.category
)

SELECT
    category,
    total_sales,
    SUM(total_sales) OVER () AS overall_sales,
    CONCAT(ROUND((CAST(total_sales AS FLOAT) / SUM(total_sales) OVER ()) * 100, 2), '%') AS percentage_of_total

FROM category_sales
ORDER  BY total_sales DESC;


/*
 segment products into cost ranges and count how many
 products fall into each segment
*/

WITH product_segment AS (
	SELECT 
		product_key,
		product_name,
		cost,

		CASE 
			WHEN cost < 100 THEN 'Below 100'
			WHEN cost BETWEEN 100 AND 500 THEN '100-500'
			WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
			ELSE 'Above 1000'
		END AS cost_range

	FROM gold.dim_products 
)

SELECT
	cost_range,
	COUNT(product_key) AS total_products
FROM product_segment
GROUP BY cost_range
ORDER BY total_products DESC;


/*
group customers into theree segments  based on their spending behavior:
	- VIP: customers with at least 12 months of history and spending more than 5000.
	- Regular: customers with at least 12 months of history but spending 5000 or less.
	- New: customer with a lifespan less than 12 months.
and find the total number of customers by each group
*/

-- 1st cte
WITH customer_spending AS ( 
	SELECT 
		c.customer_key,
		SUM(s.sales_amount) total_spending,
		MIN(s.order_date) AS first_order,
		MAX(s.order_date) AS last_order,
		DATEDIFF(MONTH, MIN(s.order_date), MAX(s.order_date)) AS lifespan
	FROM gold.fact_sales s
	LEFT JOIN gold.dim_customers c
		ON s.customer_key = c.customer_key
	GROUP BY c.customer_key
),
-- 2nd cte
customer_segments AS ( 
	SELECT 
		customer_key,
		total_spending,
		lifespan,

		CASE 
			WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
			WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
			ELSE 'New'
		END AS customer_segment

	FROM customer_spending
)
SELECT 
	customer_segment,
	COUNT(customer_key) AS total_customers
FROM customer_segments
GROUP BY customer_segment
ORDER BY COUNT(customer_key) DESC;
