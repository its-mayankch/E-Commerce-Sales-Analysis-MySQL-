🛒 E-Commerce Sales Analysis (MySQL)
📌 Project Overview

This project builds an end-to-end E-Commerce Sales Analysis system using MySQL.

Raw transactional data was transformed into a structured relational database, cleaned, and analyzed to generate meaningful business insights.

🎯 Business Problem

The raw dataset contained:

Duplicate records

Missing values

Redundant data

No relational structure

No enforced data integrity

This made revenue reporting, customer tracking, and product analysis unreliable.

💡 Solution

I designed a structured SQL-based system to solve these issues:

✅ Database Normalization

Split raw data into 5 relational tables
(Customers, Orders, Order_Items, Products, Reviews)

Achieved 3NF to remove redundancy

✅ Data Cleaning

Removed duplicates using ROW_NUMBER()

Handled NULL values

Standardized text & numeric fields

Corrected data types

✅ Constraints

Added Primary & Foreign Keys

Enforced Unique & Check constraints

Ensured referential integrity

📊 Key Business Analysis

Total & Monthly Revenue

Month-over-Month Growth (LAG)

Top Selling Products

Category Contribution %

Top 3 Products per Category (DENSE_RANK)

Return Rate & Delivery Performance

Customer Purchase Behavior

⚙ Additional Features

Stored Procedure: Fetch full customer order details

View: Product performance summary for reporting

🛠 Skills Demonstrated

SQL (Advanced Queries & Window Functions)

Database Normalization (3NF)

Data Cleaning & Transformation

Constraint Management

Business-Oriented Analysis

