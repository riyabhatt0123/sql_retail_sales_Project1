# 🛍️ Retail Sales Analysis with SQL (SSMS)

This repository contains a complete SQL project that performs data cleaning, transformation, and analysis on a retail sales dataset using SQL Server Management Studio (SSMS).

## 📋 Overview

- The SQL script includes the following operations:

- Viewing and exploring the dataset

- Cleaning and transforming data (e.g., converting text columns to numeric)

- Handling missing values using mean imputation

- Deleting invalid or incomplete rows

- Performing business-related analyses such as:

- Best-selling months

- Sales per category

- Gender-based transactions

- Time-based shift analysis

## 🧩 Dataset Summary
### Table: Retailsales1

| Column Name       | Description                                 |
|-------------------|---------------------------------------------|
| transactions_id   | Unique ID for each transaction             |
| sale_date         | Date of sale                                |
| sale_time         | Time of sale                                |
| customer_id       | Customer identifier                         |
| gender            | Gender of the customer                      |
| age               | Age (initially stored as text)              |
| category          | Product category (e.g., Clothing, Beauty)   |
| quantiy           | Quantity purchased                          |
| price_per_unit    | Unit price (initially as text)              |
| cogs              | Cost of goods sold                          |
| total_sale        | Total amount of the transaction             |

## 🧹 Data Cleaning & Preprocessing

✅ Identified and listed all NULL values using multiple OR conditions.

✅ Converted age and price_per_unit columns from text to integer using TRY_CAST.

✅ Created new integer columns: age_int, price_per_unit_int.

✅ Replaced NULL age_int values using the mean age, rounded using ROUND().

✅ Deleted all rows where any key column was NULL.

✅ Dropped the old text columns after successful conversion.

## 📊 Analysis Performed

### 1️⃣ Total Number of Unique Customers
```sql
SELECT COUNT(DISTINCT customer_id) AS total_customers FROM Retailsales1;
```

### 2️⃣ Unique Categories Present
```sql
SELECT DISTINCT category FROM Retailsales1;
```

### 3️⃣ Sorted Sales by Date and Age
```sql
SELECT * FROM Retailsales1 ORDER BY sale_date, age_int ASC;
```

### 4️⃣ Clothing Orders with Quantity > 2
```sql
SELECT * FROM Retailsales1 
WHERE category = 'Clothing' AND quantiy > 2;
```

### 5️⃣ Transactions from a Specific Date
```sql
SELECT * FROM Retailsales1
WHERE sale_date = '2022-11-05';
```

### 6️⃣ Clothing Sales in November 2022 with Quantity > 2
```sql
SELECT * FROM Retailsales1 
WHERE category = 'Clothing'
  AND quantiy > 2
  AND sale_date BETWEEN '2022-11-01' AND '2022-12-01';
```

### 7️⃣ Total Sales and Orders by Category
```sql
SELECT category, SUM(total_sale) AS net_sale, COUNT(*) AS total_orders
FROM Retailsales1
GROUP BY category;
```

### 8️⃣ Average Age for Beauty Category
```sql
SELECT ROUND(AVG(age_int), 2) AS avg_age
FROM Retailsales1
WHERE category = 'Beauty';
```

### 9️⃣ Transactions with Total Sale > 1000
```sql
SELECT category, gender, COUNT(*) AS total_trans
FROM Retailsales1
GROUP BY category, gender;
```

## 📈 Advanced Analysis

### 🏆 Best-Selling Month per Year
Used RANK() and PARTITION BY to find which month had the highest average sale each year.
```sql
SELECT sale_year, sale_month, avg_sale
FROM (
  SELECT 
    YEAR(sale_date) AS sale_year,
    MONTH(sale_date) AS sale_month,
    AVG(total_sale) AS avg_sale,
    RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS rank
  FROM Retailsales1
  GROUP BY YEAR(sale_date), MONTH(sale_date)
) AS t1
WHERE rank = 1;
```

### 💰 Top 5 Customers by Total Sales
```sql
SELECT TOP 5 customer_id, SUM(total_sale) AS total_sales
FROM Retailsales1
GROUP BY customer_id
ORDER BY total_sales DESC;
```

### 👥 Unique Customers per Category
```sql
SELECT category, COUNT(DISTINCT customer_id) AS total
FROM Retailsales1
GROUP BY category;
```

### 🕒 Orders by Shift (Morning, Afternoon, Evening)
Classified transactions by time of day using DATEPART(HOUR, sale_time) and CASE.
```sql
SELECT 
  CASE 
    WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
    WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
  END AS shift,
  COUNT(*) AS total_orders
FROM Retailsales1
GROUP BY 
  CASE 
    WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
    WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
  END;
```

## 🛠️ How to Run

1. Open SQL Server Management Studio (SSMS).

2. Connect to your SQL Server.

3. Create or switch to the Retailsales database.

4. Copy and execute the code from Project1.sql.

## 📚 Notes

- Data was cleaned using TRY_CAST and AVG() to handle non-numeric and NULL values.

- All analysis is based on a cleaned dataset to ensure accuracy.

- Helpful comments are included within the SQL file for better understanding.

## ✅ Conclusion

This project is a great starting point to practice data cleaning, aggregation, window functions, and business insights using SQL.


