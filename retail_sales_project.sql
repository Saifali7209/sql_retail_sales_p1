-- SQL Retail Sales Analysis - P1

CREATE DATABASE sql_project_p2;

CREATE TABLE retail_sales (
    transactions_id INT,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(50),
    quantity INT,
    price_per_unit DECIMAL(10,2),
    cogs DECIMAL(10,2),
    total_sale DECIMAL(10,2)
)
SELECT * FROM retail_sales
LIMIT 10;

SELECT
     COUNT(*)
 FROM retail_sales;
 
 SELECT * FROM retail_sales
 WHERE transactions_id IS NULL;
 
  SELECT * FROM retail_sales
 WHERE sale_date IS NULL;
 
 SELECT * FROM retail_sales
 WHERE sale_time IS NULL;
 
 SELECT * FROM retail_sales
 WHERE
      transactions_id IS NULL
      OR
      sale_date IS NULL
      OR
      sale_time IS NULL
      OR
      gender IS NULL
      OR
	  category IS NULL 
	  OR
      quantiy IS NULL
      OR
      cogs IS NULL
      OR
      total_sale IS NULL;
      
 -- Data Exploration
 
 -- Now many sales we have?
 SELECT COUNT(*) as total_sales FROM retail_sales;
 
 
 SELECT DISTINCT category FROM retail_sales;
 
 -- Data Analysis & Business key problems & Answers
 
 -- Q.1 write a SQL query to retrieve all columns for sales made on '2022-11-05'
      
    SELECT * 
    FROM retail_sales
	WHERE sale_date = '2022-11-05';
    
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'clothing' and the quentity sold is more than 10 in the month of NOV-2022
SELECT *
FROM retail_sales
WHERE category = 'clothing'
  AND sale_date >= '2022-11-01'
  AND sale_date < '2022-12-01'
  AND quantiy >= 4;
  
  SHOW COLUMNS FROM retail_sales;
  
-- Q.3  Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
   category,
   SUM(total_sale) as net_sale,
   COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1;

-- Q.4  Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT
    AVG(age) as avg_age
FROM retail_sales
WHERE category = 'Beauty';    

-- Q.5 Write SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sales
WHERE total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of  transactions (transaction_id) made by each gender in each category.

SELECT
   category,
   gender,
   COUNT(*) as total_trans
FROM retail_sales
GROUP 
    BY
    category,
    gender
ORDER BY 1 ;

-- Q.7 Write a SQL   query to to calculate the average sale for each month. Find out best selling month in each year 

WITH monthly_sales AS (
    SELECT
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale
    FROM retail_sales
    GROUP BY 1, 2
)
SELECT
    year,
    month,
    avg_sale,
    RANK() OVER (
        PARTITION BY year
        ORDER BY avg_sale DESC
    ) AS sales_rank
FROM monthly_sales;



-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT 
     customer_id,
     SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC 
LIMIT 5 ;
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category


SELECT 
     category,
    COUNT(DISTINCT  customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category;

-- Q. 10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17 Evening>17)
WITH hourly_sale
As
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT
      shift,
      COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift

-- END PRIJECT 
