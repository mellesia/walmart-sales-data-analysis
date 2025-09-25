Create database walmart;

create table sales(
	invoice_id     VARCHAR(30) primary key,
	branch         VARCHAR(5) NOT NULL,
    city           VARCHAR(30) NOT NULL,
    customer_type  VARCHAR(30) NOT NULL,
    gender         VARCHAR(10) NOT NULL,
    product_line   VARCHAR(100) NOT NULL,
    unit_price     DECIMAL(10,2) NOT NULL,
    quantity       INT NOT NULL,
    VAT            FLOAT(6,4) NOT NULL,
    total          DECIMAL(12,4) NOT NULL,
    date		   DATETIME NOT NULL,
    time 		   Time  NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    cogs 		   DECIMAL(10,2) NOT NULL,
    gross_margin_percent FLOAT(11.9) NOT NULL,
    gross_income   DECIMAL(10,2) NOT NULL,
    rating  	   FLOAT(2.1) NOT NULL
);

select * from sales;

/*-----------------------------Feature Engineering-------------------------------*/
/*-----------------------------time_of_day--------------------------------------*/

select time,
			(CASE 
				when time between "00:00:00" and "12:00:00" then "Morning"
                when time between "12:01:00" and "16:00:00" then "Afternoon"
                else "Evening"
			END
                ) AS time_of_date
 from sales;

Alter Table sales ADD COLUMN time_of_day varchar(15);

UPDATE sales 
SET time_of_day = (
CASE 
	when time between "00:00:00" and "12:00:00" then "Morning"
	when time between "12:01:00" and "16:00:00" then "Afternoon"
	else "Evening"
END
);

/*-----------------------------day_name-------------------------------*/


select date, 
dayname(date) as day_name
from sales;

alter table sales add column day_name varchar(15);

update sales 
set day_name = dayname(date);

/*-----------------------------month_name-------------------------------*/


select date ,
 monthname(date)  as month_name
 from sales;
 
 alter table sales add column month_name varchar(15);
 
 update sales 
 set month_name =  monthname(date) ;
 
 select * from sales;

/*-----------------------------Generic Question-------------------------------*/
-- How many unique cities does the data have?

select distinct city 
from sales;

select distinct branch 
from sales;

-- In which city is each branch?
select distinct city , branch 
from sales;

/*-----------------------------product-------------------------------*/
-- How many unique product lines does the data have?
select count(distinct product_line) from sales;

-- What is the most common payment method?
select  count(payment_method) as pay_count , payment_method
from sales
group by payment_method
order by pay_count desc;

-- What is the most selling product line?

 
 select  count(product_line) as pro_count , product_line
from sales
group by product_line
order by pro_count desc
limit 1;
 
 -- 4- What is the total revenue by month?

select  month_name as month, 
sum(total) as total_revenue 
from sales
group by month_name
order by total_revenue;

-- 5- What month had the largest COGS?
select 
	month_name as month,
	sum(cogs) as cogs
from sales 
group by month_name
order by cogs desc;

-- 6- What product line had the largest revenue?
select product_line, 
sum(total) as total_revenue 
from sales
group by product_line
order by total_revenue desc;

-- 7- What is the city with the largest revenue?
select branch , city, 
sum(total) as total_revenue 
from sales
group by city , branch
order by total_revenue desc;


-- 8-What product line had the largest VAT?
select product_line, 
avg(VAT) as avg_tax
from sales
group by product_line
order by avg_tax desc;

-- Fetch each product line and add column to those product line showing "Good", "Bad".
-- Good if its greater than average sales

select product_line as pro, avg(total) as avg_sales from sales
group by product_line
having product_line > avg_sales;

alter table sales add column rate varchar(10);

update sales 
set rate = product_line > avg_sales;

-- 10- Which branch sold more products than average product sold?
select branch , sum(quantity) as qty
from sales
group by branch 
having sum(quantity) > (select avg(quantity) 
from sales);

-- 11- What is the most common product line by gender?
select gender , product_line, count(gender) as total_count
from sales
group by gender , product_line
order by total_count desc;

-- 12- What is the average rating of each product line?
select round(avg(rating) , 2) as avg_rating, 
product_line 
from sales
group by product_line
order by avg_rating desc; 


-- -------------------------------------------------------------------------- --
-- --------------------------------sales ------------------------------------ -- 
-- Number of sales made in each time of the day per weekday
select 
    day_name,
    time_of_day,
    count(*) as total_sales
from sales
where day_name not in ('Saturday', 'Sunday')
group by day_name, time_of_day
order by day_name, time_of_day desc;


-- Which of the customer types brings the most revenue?
select 
	customer_type , 
	round(sum(total),2) as total_revenue
from sales
group by customer_type
order by total_revenue desc;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
select city ,
	avg(VAT) as VAT 
from sales
group by city 
order by VAT desc ;

-- Which customer type pays the most in VAT?
select customer_type ,
	avg(VAT) as VAT 
from sales
group by customer_type 
order by VAT desc ;


-- -------------------------------------------------------------------------- --
-- --------------------------------customer --------------------------------- -- 
-- How many unique customer types does the data have?
select distinct(customer_type) from sales;

-- How many unique payment methods does the data have?
select distinct(payment_method) from sales;

-- Which customer type buys the most?
select customer_type , count(total) as cnt_buys
 from sales
 group by customer_type
 order by cnt_buys desc;

-- What is the gender of most of the customers?
 select gender , count(*) as gender_cnt
 from sales
 group by gender 
 order by gender_cnt;

-- What is the gender distribution per branch?
select  branch , gender ,count(*) as gender_cnt 
from sales 
where branch in ('A' , 'B' , 'C')
group by branch , gender
order by branch ,gender_cnt desc;

-- Which time of the day do customers give most ratings?
select time_of_day , 
	round(avg(rating), 5) as avg_rating
from sales
group by time_of_day 
order by avg_rating desc ;

-- Which time of the day do customers give most ratings per branch?
select branch , time_of_day , 
	round(avg(rating), 5) as avg_rating
from sales
group by branch , time_of_day 
order by branch , avg_rating desc ;

-- Which day of the week has the best avg ratings?
select day_name, 
	round(avg(rating),6) as avg_rating
from sales
group by day_name
order by avg_rating desc;

 -- Which day of the week has the best average ratings per branch?
 select branch, day_name, 
	round(avg(rating),6) as avg_rating
from sales
group by branch, day_name
order by branch , avg_rating desc;
