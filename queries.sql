USE WALMART_DB1

select * from SalesTable

alter table SalesTable
add time_of_day varchar(20);

update SalesTable
set time_of_day =
    case

	------------------- Feature Engineering -----------------------------
---1. Time_of_day

SELECT time,
(CASE 
	WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
	WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
	ELSE "Evening" 
END) AS time_of_day
FROM SalesTable;

ALTER TABLE SalesTable ADD COLUMN time_of_day VARCHAR(20);

UPDATE SalesTable
SET time_of_day = (
	CASE 
		WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
		WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
		ELSE "Evening" 
	END
);


---2.Day_name

SELECT date,
DAYNAME(date) AS day_name
FROM SalesTable;

ALTER TABLE SalesTable ADD COLUMN day_name VARCHAR(10);

UPDATE SalesTable
SET day_name = DAYNAME(date);

---3.Momth_name

SELECT date,
    DATENAME(MONTH,date) AS month_name
FROM SalesTable;

ALTER TABLE SalesTable
ADD month_name VARCHAR(10);

UPDATE SalesTable
SET month_name = DATENAME(MONTH,date);

---***3.  Exploratory Data Analysis (EDA)***

---### Generic Questions

----1.	How many distinct cities are present in the dataset?

SELECT COUNT(DISTINCT city) as distinct_cities
FROM SalesTable;

--2.	In which city is each branch situated?

SELECT DISTINCT Branch,City
from SalesTable;

---### Product Analysis

----1.	How many distinct product lines are there in the dataset?

SELECT COUNT(DISTINCT Product_line)
from SalesTable;

----2.	What is the most common payment method?

SELECT TOP 1 Payment,COUNT(Payment) as payment_count FROM SalesTable
GROUP BY Payment
ORDER BY payment_count DESC;

---3.	What is the most selling product line?

SELECT TOP 1 Product_line,COUNT(Product_line) as selling_product_line 
FROM SalesTable
GROUP BY Product_line
ORDER BY selling_product_line
;
---4.	What is the total revenue by month?

SELECT month_name,sum(Total) as total_revenue
FROM SalesTable
GROUP BY month_name
ORDER By total_revenue
;

---5.	Which month recorded the highest Cost of Goods Sold (COGS)?

SELECT TOP 1 month_name,sum(cogs) as total_cogs
FROM SalesTable
GROUP BY month_name
ORDER BY total_cogs DESC
;

---6.	Which product line generated the highest revenue?

SELECT TOP 1 Product_line,sum(Total) as total_revenue
FROM SalesTable
GROUP BY Product_line
ORDER BY total_revenue DESC
;

---7.	Which city has the highest revenue?

SELECT TOP 1 City,sum(Total) as total_revenue
FROM SalesTable
GROUP BY City
ORDER BY total_revenue DESC
;

---8.	Which product line incurred the highest VAT?

SELECT TOP 1 Product_line,sum(Tax_5) as total_VAT
FROM SalesTable
GROUP BY Product_line
ORDER BY total_VAT DESC
;

---9.	Retrieve each product line and
        --add a column product_category, indicating
        --'Good' or 'Bad,' based on whether its sales are above the average.


ALTER TABLE SalesTable
ADD product_category varchar(20);

UPDATE SalesTable
SET product_category =
    CASE
	    WHEN total > (SELECT avg(Total)FROM SalesTable) THEN 'GOOD'
		ELSE 'BAD'
    END
;
---10.	Which branch sold more products than average product sold?

SELECT TOP 1 Branch,sum(Quantity) as total_quantity_sold
from SalesTable
GROUP BY Branch
HAVING SUM(Quantity) > (SELECT AVG(Quantity)FROM SalesTable)
ORDER BY  total_quantity_sold DESC
;

---11.	What is the most common product line by gender?

SELECT Product_line,Gender,COUNT(*) as product_count
FROM SalesTable
GROUP BY Product_line, Gender
ORDER BY Gender,product_count DESC
;

---12.	What is the average rating of each product line?

SELECT Product_line,round(avg(Rating),2) as avg_rating
FROM SalesTable
GROUP BY Product_line
ORDER BY avg_rating DESC
;
---### Sales Analysis

---1.	Number of sales made in each time of the day per weekday

select day_name,time_of_day,count(*) as Sales_count
from SalesTable
group by day_name,time_of_day 
having day_name not in ('Saturday','Sunday')
;

---2.	Identify the customer type that generates the highest revenue.

select TOP 1 Customer_type,sum(Total) as total_revenue
from SalesTable
group by Customer_type
order by total_revenue DESC
;

--3.Which city has the largest tax percent/ VAT (Value Added Tax)?

select TOP 1 City,avg(Tax_5) as avg_VAT
from SalesTable
group by City
order by avg_VAT DESC
;
---4.	Which customer type pays the most VAT?
select TOP 1 Customer_type,avg(Tax_5) as avg_VAT
from SalesTable
group by Customer_type
order by avg_VAT DESC
;

---### Customer Analysis

---1.	How many unique customer types does the data have?

select Customer_type,count(distinct Customer_type) as unique_customer_type
from SalesTable
group by Customer_type
order by unique_customer_type;

--2.	How many unique payment methods does the data have?
select Payment,count(distinct Payment) as unique_payment
from SalesTable
group by Payment
order by unique_payment;

---3.	Which is the most common customer type?
select top 1 Customer_type,count(*) as most_common_cutomertype
from SalesTable
group by Customer_type
order by most_common_cutomertype DESC;

---4.	Which customer type buys the most?

select top 1 Customer_type,count(*) as most_common_cutomertype
from SalesTable
group by Customer_type
order by most_common_cutomertype DESC;



---5.	What is the gender of most of the customers?

select TOP 1 Gender,count(*) as most_customers
from SalesTable
group by Gender
order by most_customers DESC
;

--6.	What is the gender distribution per branch?
select Branch, Gender,count(*) as gender_distribution_per_branch
from SalesTable
group by Branch,Gender
order by Branch,gender_distribution_per_branch DESC
;

---7.	Which time of the day do customers give most ratings?

select top 1 time_of_day,avg(Rating) as avg_rating
from SalesTable
group by time_of_day
order by avg_rating  DESC
;

--8.	Which time of the day do customers give most ratings per branch?

select top 1 Branch,time_of_day,avg(Rating) as rating_count
from SalesTable
group by Branch,time_of_day
order by Branch,rating_count DESC
;
----9.	Which day of the week has the best avg ratings?
select top 1 day_name,round(avg(Rating),2) as avg_rating
from SalesTable
group by day_name
order by avg_rating DESC
;

---10.	Which day of the week has the best average ratings per branch?

select top 1 Branch,day_name,avg(Rating) as avg_rating
from SalesTable
group by Branch,day_name
order by avg_rating DESC
;







