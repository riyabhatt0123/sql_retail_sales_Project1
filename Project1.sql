SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';


USE Retailsales; --use to identify the database--
GO
SELECT * FROM dbo.Retailsales1;

select top(10) * --to select only top 10 data--
from dbo.Retailsales1;

select count(*) from Retailsales1; -- to count the number of rows--

SELECT * FROM Retailsales1 
	WHERE transactions_id IS NULL; -- Using this we can find the null values for all columns--
--however the easy and right approach would be to use OR after every column---
SELECT * FROM Retailsales1
	WHERE transactions_id IS NULL
	OR 
	sale_date IS NULL --here it will check first column if it is null it will return i if not it will 
	--go to the next column
	OR 
	sale_time IS NULL
	OR 
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age_int IS NULL
	OR 
	category IS NULL
	OR
	quantiy IS NULL
	OR 
	price_per_unit_int IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;
---convert text to number ---
SELECT DISTINCT [age]
FROM dbo.Retailsales1
WHERE ISNUMERIC([age]) = 0 OR [age] IS NULL;

ALTER TABLE dbo.Retailsales1
ADD age_int INT;

UPDATE dbo.Retailsales1
SET age_int = TRY_CAST([age] AS INT);

SELECT [age], age_int
FROM dbo.Retailsales1;

ALTER TABLE dbo.Retailsales1
DROP COLUMN [age];


SELECT DISTINCT [price_per_unit]
from dbo.Retailsales1
where ISNUMERIC([price_per_unit]) = 0 OR [price_per_unit] IS NULL;

ALTER TABLE dbo.Retailsales1
ADD price_per_unit_int INT;

UPDATE dbo.Retailsales1
SET price_per_unit_int = TRY_CAST([price_per_unit] AS INT);

SELECT [price_per_unit], price_per_unit_int
FROM dbo.Retailsales1;

ALTER TABLE dbo.Retailsales1
Drop column [price_per_unit];

select * from Retailsales1;

---Since there are many null values in age we will carry out the avg and fill it--

select AVG(age_int* 1.0) AS age_avg
FROM dbo.Retailsales1
WHERE age_int is not null; 

--update the rows with the avg where there is null values-
UPDATE dbo.Retailsales1
SET age_int =(
	Select ROUND(AVG(age_int * 1.0), 0)
	FROM dbo.Retailsales1
	WHERE age_int is not null
)
WHERE age_int is null;
select distinct age_int
from dbo.Retailsales1;

--dropping/deleting the other rows of price_per_unit where the data are missing, or null--
DELETE from dbo.Retailsales1
WHERE transactions_id IS NULL
	OR 
	sale_date IS NULL 
	OR 
	sale_time IS NULL
	OR 
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age_int IS NULL
	OR 
	category IS NULL
	OR
	quantiy IS NULL
	OR 
	price_per_unit_int IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;
select count(*) from dbo.Retailsales1;

-- Basic data exploration
-- How many customers do we have?
select count(distinct customer_id) as total_sales from Retailsales1;

-- how many unique categories are present?
select distinct category from Retailsales1;

--arrange the data according the sale_date and by their age.
select * from Retailsales1 order by sale_date, age_int ASC;

--FIND OUT IN THE DATASET WHEN THE Customer purchased clothing and the quantity was more than 2.
select * from Retailsales1 
where 
category = 'Clothing' 
AND
quantiy > 2;

--write a sql query to retrieve all columns from sales made on '2022-11-05'

select * from Retailsales1
where sale_date ='2022-11-05'

--write a sql query to retrieve all transaction id where the category is clothing and the quantity sold is more than 2 in the month of 
--Nov-2022

select * from Retailsales1 
where category = 'Clothing'
AND (quantiy >2 and sale_date >= '2022-11-01'
AND sale_date <= '2022-12-01');

--- write a query to calculate the total sales for each category.

select 
	category, --- this is the grouping column
	SUM(total_sale) as net_sale, -- for each category we total the sales, the sum total all the sales of each category, net_sale new column name
	Count(*) as total_orders -- count helps to count the rows of each category, for clothing sale is 20 so the count of rows will be 20
FROM Retailsales1
Group by category; --each category will be combined together, suppose clothing- 10, clothing-20 so this will combine and give the output as 30

-- write a sql query to find the avg age of customers who purchased items from the beauty category

select 
	round(avg(age_int),2) as avg_age --round we use to remove decimals fro the avg 
	from Retailsales1 
	where category = 'Beauty';


--write a query to find all transactions where the total sale is greater than 1000

select * from Retailsales1 
where total_sale > 1000;

--write a query to find the total number of transaction (transaction_id) made by each gender in each category

select 
	category,-- we need to find huw much did male and female purchased
	gender,
	Count(*) as total_trans --gives the total number of transaction of each category and each gender
from Retailsales1
Group by category, gender;-- group by the column,combining the male which purchased electronics, like this

--write a query to calculate the average sale for each month. Find out best selling month in each year
select 
	sale_year,
	sale_month,
	avg_sale
from
(
select --using this whole query as a subquery
	year(sale_date) as sale_year,  -- since we only have sale_date and not year or month we use this method to extract 
	month(sale_date) as sale_month,
	avg(total_sale) as avg_sale,-- carrying out the avg sale for each month and year
	rank()over(partition by year(sale_date)
	order by avg(total_sale) desc) as rank
from Retailsales1
Group by year(sale_date),month(sale_date)
)as t1
where rank=1;

--grouping it by month then year and then ordering the rows basis on the avg which gives best sale in which month
 

 --write a query to find the top 5 customers based on the highest total sales

 select top 5 --to get top 5 rows
	customer_id,
	sum(total_sale) as total_sales
from Retailsales1
Group by customer_id
order by total_sales desc;

---write a query to find the number of unique customers who purchased items from each category

select 
	category,
	count(distinct customer_id) as total
from Retailsales1 
Group by category;

-- write a sql query to create each shift and number of orders(eg: morning < 12, afternoon between 12 & 17, evening >17)

select 
	case --case is used to create condition, just like if else,
		when datepart(hour,sale_time) < 12 Then 'Morning' --datepart is used to part the hour from the sale_time,
		when datepart(hour,sale_time) between 12 and 17 then 'Afternoon' -- it can also used to part year month day
		else 'Evening'
	end as shift, --shift is the new column name to store the after, morning and evening status of the order
	count(*) as total_orders --extracting and making note of total sale made in each shift
	from Retailsales1
	group by --grouping each shift and their total order. 
	case	
		when datepart(hour,sale_time) < 12 then 'Morning'
		when datepart(hour,sale_time) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end; 

