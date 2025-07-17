🛍️ Retail Sales Analysis with SQL (SSMS)

This repository contains a complete SQL project that performs data cleaning, transformation, and analysis on a retail sales dataset using SQL Server Management Studio (SSMS).

📋 Overview

The SQL script includes the following operations:

Viewing and exploring the dataset

Cleaning and transforming data (e.g., converting text columns to numeric)

Handling missing values using mean imputation

Deleting invalid or incomplete rows

Performing business-related analyses such as:

Best-selling months

Sales per category

Gender-based transactions

Time-based shift analysis

🧩 Dataset Summary
Table: Retailsales1

Column Name	Description
transactions_id	Unique ID for each transaction
sale_date	Date of sale
sale_time	Time of sale
customer_id	Customer identifier
gender	Gender of the customer
age	Age (initially stored as text)
category	Product category (e.g., Clothing, Beauty)
quantiy	Quantity purchased
price_per_unit	Unit price (initially as text)
cogs	Cost of goods sold
total_sale	Total amount of the transaction