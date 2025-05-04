# 🧾 SQL Adcanced Analytics Project (Customer & Product KPIs)

This repository contains SQL scripts used to generate consolidated reports on **customer** and **product** performance from a sales data warehouse. The insights are designed to support business intelligence initiatives such as segmentation, performance tracking, and KPI measurement.

---

## 📊 Project Overview

This project demonstrates the use of advanced SQL techniques to extract insights and build performance reports for customers and products in a data warehouse environment.

Key focus areas include:

- 🚀 Customer segmentation (VIP, Regular, New)
- 📦 Product performance classification (High-Performer, Mid-Range, Low-Performer)
- 📈 Lifecycle metrics (Lifespan, Recency)
- 📊 KPI calculations (Average Order Value, Monthly Spend/Revenue)
- 🧱 Structured using modern SQL and joins on dimension/fact tables

### 📦 Product Report

**Purpose:**  
Consolidates key product metrics and behaviors to help identify top-performing products and monitor product-level KPIs.

**Key Highlights:**

- Extracts essential fields:
  - Product Name  
  - Category  
  - Subcategory  
  - Cost
    
- Segments products based on total revenue:
  - `High-Performer`
  - `Mid-Range`
  - `Low-Performer`
    
- Aggregated Metrics:
  - Total Orders  
  - Total Sales  
  - Total Quantity Sold  
  - Unique Customers  
  - Lifespan (Months between first and last sale)
    
- Calculated KPIs:
  - **Recency** (Months since last sale)  
  - **Average Order Revenue**  
  - **Average Monthly Revenue**

---

### 👤 Customer Report

**Purpose:**  
Provides a comprehensive summary of customer purchase behaviors and lifetime value analysis.

**Key Highlights:**

- Extracts essential fields:
  - Full Name  
  - Age (calculated from birthdate)  
  - Transaction Details  
- Customer Segmentation:
  - By Spending & Lifespan: `VIP`, `Regular`, `New`
  - By Age Group: `Under 20`, `20-29`, `30-39`, etc.
- Aggregated Metrics:
  - Total Orders  
  - Total Sales  
  - Total Quantity Purchased  
  - Total Products Purchased  
  - Lifespan (Months between first and last purchase)
    
- Calculated KPIs:
  - **Recency** (Months since last order)  
  - **Average Order Value**  
  - **Average Monthly Spend**

---

## 📂 SQL Reports

- 📄 **Customer Report**  
  [View Script on GitHub](https://github.com/Injamam001/SQL_Advanced_Analytics_Project/blob/main/sql_script_ssms/customer_report.sql)

- 📄 **Product Report**  
  [View Script on GitHub](https://github.com/Injamam001/SQL_Advanced_Analytics_Project/blob/main/sql_script_ssms/product_report.sql)

---

## 📁 Dataset

This project uses a fictional sales dataset modeled in a star schema format, containing:

- 🧾 **Fact Table:** `fact_sales`
- 🧍 **Dimension Tables:** `dim_customers`, `dim_products`.

[📥 Download Dataset](https://github.com/Injamam001/SQL_Advanced_Analytics_Project/tree/main/dataset)
---


## 🛠 Tech Stack

- **SQL Server (T-SQL)**
- **SSMS** (SQL Server Management Studio)

---

## 📬 Contact

- 💼 [**LinkedIn**](https://www.linkedin.com/in/i-haque/)

## 📌 Notes

- All SQL keywords are written in uppercase for readability.
- Views are created to support self-service BI tools and downstream analytics.

