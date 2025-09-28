-- sql retail sales analysis
create database sql_projectdb;
use sql_projectdb;
drop table retail_sales_analysis;
create table retail_sales_analysis 
     (
         transactions_id int primary key,
	     sale_date date,
         sale_time time,	
         customer_id int,
		 gender varchar(15),	
         age int,	
         category varchar(15),	
         quantity int,
		 price_per_unit float,	
		 cogs float,	
         total_sale float
     );
select * from retail_sales_analysis
LIMIT 10;
use sql_projectdb;
show tables;

select * from retail_sales_analysis
where
transactions_id 
or
 sale_date is null
or
sale_time is null
or
customer_id is null
or
gender is null
or
 age is null
 or
category is null 
or
quantity is null
or
price_per_unit is null
or
cogs is null
or
total_sale is null;
 
 -- data exploration
 -- how many sales we have
    select count(*) as total_sale from retail_sales_analysis;
    
   -- how many customers we have
   select count(distinct customer_id) as total_sale  from retail_sales_analysis;
   select distinct category from retail_sales_analysis;
   
   -- Data analysis & business key problems & answers
   
-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
   
   
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
   SELECT * FROM retail_sales_analysis
   WHERE sale_date = '2022-11-05';
   
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
   SELECT * FROM retail_sales_analysis
   where 
     category = 'Clothing' 
   and
     DATE_FORMAT(sale_date, 'YYYY-MM') = '2022-11'
  AND
     quantity >= 4;
   
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
   SELECT
      category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
    from
     retail_sales_analysis
    GROUP BY 1;
    
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
     SELECT
    ROUND(AVG(age), 2) as avg_age
     FROM retail_sales_analysis
     WHERE category = 'Beauty';
    
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
     SELECT * FROM retail_sales_analysis
	 WHERE total_sale > 1000;
    
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
	SELECT 
     category,
     gender,
     COUNT(*) as total_trans
	FROM retail_sales_analysis
    GROUP 
    BY 
     category,
     gender
    ORDER BY 1;
    
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
    SELECT 
       year,
       month,
    avg_sale
   FROM 
   (    
   SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rn
    FROM retail_sales_analysis
    GROUP BY 1, 2
    ) as t1
    WHERE rn = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
   SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales_analysis
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales_analysis
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales_analysis
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift

-- End of the project