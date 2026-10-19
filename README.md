# E-Commerce-Customer-Churn-Analysis-Using-MySQL

## 📌 Project Overview
This project focuses on analyzing customer churn in an e-commerce business using MySQL. The main objective is to understand customer behavior, identify factors influencing customer churn, and gain useful insights to support business decisions.

## 🎯 Objectives
- Analyze customer details and purchasing behavior.
- Identify customers who have churned.
- Analyze customer complaints and churn patterns.
- Explore the relationship between tenure, order count, and customer churn.
- Identify preferred payment modes and order categories.
- Generate meaningful insights using SQL queries.

-  Create a customer_returns table in the ecomm database.
-  Insert customer return records into the table.
-  Retrieve return details along with customer information.
-  Identify customers who have both churned and made complaints.

     ##    Table Structure

## Customer Returns Table

The customer_returns table contains the following columns:

Column Name  ---    Description

ReturnID   ---      Unique ID for each return

CustomerID ---      ID of the customer who returned the product

ReturnDate ---      Date of the return

RefundAmount ---    Amount refunded to the customer

## 🛠️ Tools Used
- **MySQL** – Data querying and analysis
- **MySQL Workbench** – Writing and executing SQL queries
- **CSV Dataset** – Customer churn data

## 📂 Dataset Description
The dataset contains customer information and shopping behavior, including:

- Customer ID
- Tenure
- Warehouse to Home Distance
- Preferred Payment Mode
- Preferred Order Category
- City Tier
- Marital Status
- Number of Orders
- Coupon Usage
- Customer Complaints
- Churn Status

## 🔍 Key Analysis Performed

### 1. Data Cleaning
- Handled missing values using appropriate methods.
- Replaced missing values in selected columns with mode values.
- Identified and removed records with `WarehouseToHome` values greater than 100.
- Created a new column named `ComplaintReceived` to represent complaint status as Yes or No.

### 2. Customer Churn Analysis
- Calculated the percentage of churned customers who complained.
- Identified the city tier with the highest number of churned customers in the Laptop & Accessory category.
- Analyzed customer churn based on different customer characteristics.

### 3. Customer Behavior Analysis
- Identified preferred payment modes for customers meeting specific tenure and order-count conditions.
- Retrieved order details for married customers living in City Tier 1 whose order counts exceeded the overall average.
- Explored relationships between customer tenure, order count, and purchasing preferences.

### 4. SQL Concepts Used
- `SELECT`, `WHERE`, and `ORDER BY`
- Aggregate functions such as `COUNT()`, `SUM()`, and `AVG()`
- `GROUP BY` and `HAVING`
- `UPDATE` and `DELETE`
- `ALTER TABLE`
- `CASE` statements
- Subqueries
- Conditional filtering
- Data cleaning and transformation

## 📊 Key Learnings
- Improved my understanding of SQL queries and data manipulation.
- Learned how to clean and prepare data for analysis.
- Practiced aggregate functions, grouping, and subqueries.
- Developed skills in analyzing customer churn and purchasing behavior.
- Learned how SQL can help businesses understand customer retention.
