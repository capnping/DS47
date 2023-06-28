use market_star_schema;
SET SQL_SAFE_UPDATES = 0;


-- Module: Database Design and Introduction to SQL
-- Session: Database Creation in MySQL Workbench
-- DDL Statements

-- 1. Create a table shipping_mode_dimen having columns with their respective data types as the following:
--    (i) Ship_Mode VARCHAR(25)
--    (ii) Vehicle_Company VARCHAR(25)
--    (iii) Toll_Required BOOLEAN

-- 2. Make 'Ship_Mode' as the primary key in the above table.


-- -----------------------------------------------------------------------------------------------------------------
-- DML Statements

-- 1. Insert two rows in the table created above having the row-wise values:
--    (i)'DELIVERY TRUCK', 'Ashok Leyland', false
--    (ii)'REGULAR AIR', 'Air India', false

-- 2. The above entry has an error as land vehicles do require tolls to be paid. Update the ‘Toll_Required’ attribute
-- to ‘Yes’.

-- 3. Delete the entry for Air India.


-- -----------------------------------------------------------------------------------------------------------------
-- Adding and Deleting Columns

-- 1. Add another column named 'Vehicle_Number' and its data type to the created table. 

-- 2. Update its value to 'MH-05-R1234'.

-- 3. Delete the created column.


-- -----------------------------------------------------------------------------------------------------------------
-- Changing Column Names and Data Types

-- 1. Change the column name ‘Toll_Required’ to ‘Toll_Amount’. Also, change its data type to integer.

-- 2. The company decides that this additional table won’t be useful for data analysis. Remove it from the database.


-- -----------------------------------------------------------------------------------------------------------------
-- Session: Querying in SQL
-- Basic SQL Queries

-- 1. Print the entire data of all the customers.
select * from cust_dimen;
-- 2. List the names of all the customers.
select cust_dimen.Customer_Name from cust_dimen;
-- 3. Print the name of all customers along with their city and state.

-- 4. Print the total number of customers.
select count(*) as Total_Customers
from cust_dimen;

-- 5. How many customers are from West Bengal?
select count(*) as total_west_bengal_cust, City
from cust_dimen
where cust_dimen.State = 'West Bengal';
-- 6. Print the names of all customers who belong to West Bengal.


-- -----------------------------------------------------------------------------------------------------------------
-- Operators(IN, AND, OR)

-- 1. Print the names of all customers who are either corporate or belong to Mumbai.
select count(*) as cust_Mum_corp from cust_dimen
where cust_dimen.Customer_Segment = 'corporate' or state = 'Maharastra';
-- 2. Print the names of all corporate customers from Mumbai.

-- 3. List the details of all the customers from southern India: namely Tamil Nadu, Karnataka, Telangana and Kerala.
select * from cust_dimen
where state in ('Tamil Nadu', 'Karnataka', 'Telangana', 'Kerala');
-- 4. Print the details of all non-small-business customers.

-- 5. List the order ids of all those orders which caused losses.

-- 6. List the orders with '_5' in their order ids and shipping costs between 10 and 15.
select * from orders_dimen
where orders_dimen.Ord_id like '%\_5%';

-- -----------------------------------------------------------------------------------------------------------------
-- Aggregate Functions

-- 1. Find the total number of sales made.
select count(sales) as No_of_Sales
from market_fact_full;
-- 2. What are the total numbers of customers from each city?
select count(customer_name) as City_Wise_Customer, city
from cust_dimen
group by City;
-- segment wise
select count(customer_name) as City_Wise_Customer, city, customer_segment
from cust_dimen
group by City, cust_dimen.customer_segment;

-- 3. Find the number of orders which have been sold at a loss.
select count(Ord_id) as Loss_count from market_fact_full
where market_fact_full.profit < 0;
-- 4. Find the total number of customers from Bihar in each segment.
select count(state) as segment_wise_customer, state, customer_segment
from cust_dimen
where state = 'bihar'
group by cust_dimen.customer_segment;

-- 5. Find the customers who incurred a shipping cost of more than 50. 
select sum(Shipping_Cost) as total_shipping_cost, Cust_id
from market_fact_full
group by Cust_id
having total_shipping_cost > 50;

-- -----------------------------------------------------------------------------------------------------------------
-- Ordering

-- 1. List the customer names in alphabetical order.
select customer_name
from cust_dimen
order by customer_name;
-- 2. Print the three most ordered products.
select sum(Order_Quantity) as total_order_by_prod, ord_id
from market_fact_full
group by ord_id
order by total_order_by_prod desc 
limit 3;
-- 3. Print the three least ordered products.
select sum(Order_Quantity) as total_order_by_prod, ord_id
from market_fact_full
group by ord_id
order by total_order_by_prod asc 
limit 3;
-- 4. Find the sales made by the five most profitable products.
select sales, sum(profit) as profit_product_wise
from market_fact_full
group by prod_id
order by profit_product_wise desc 
limit 3;
-- 5. Arrange the order ids in the order of their recency.

-- 6. Arrange all consumers from Coimbatore in alphabetical order.


-- -----------------------------------------------------------------------------------------------------------------
-- String and date-time functions
select reverse(substring('Sachin Tendulkar', -7, 3));
-- 1. Print the customer names in proper case.

-- 2. Print the product names in the following format: Category_Subcategory.
select Product_Category, Product_Sub_Category,
concat(Product_Category, '_', Product_Sub_Category) as product_name
from prod_dimen;
-- 3. In which month were the most orders shipped?
select count(Ship_id) as ship_qty, month(ship_date) shipping_month
from shipping_dimen
group by shipping_month
order by ship_qty DESC
limit 3;
-- 4. Which month and year combination saw the most number of critical orders?

-- 5. Find the most commonly used mode of shipment in 2011.
select count(Ship_id) as ship_qty, month(ship_date) shipping_month
from shipping_dimen
where year(ship_date) = 2011
group by shipping_month
order by ship_qty DESC
limit 3;

-- -----------------------------------------------------------------------------------------------------------------
-- Regular Expressions

-- 1. Find the names of all customers having the substring 'car'.

-- 2. Print customer names starting with A, B, C or D and ending with 'er'.
select customer_name
from cust_dimen
where customer_name like '[abcd]%er';

select customer_name
from cust_dimen
where customer_name regexp '^[abcd].*er$';

-- -----------------------------------------------------------------------------------------------------------------
-- Nested Queries

-- 1. Print the order number of the most valuable order by sales. Most valuable sales means most sold product.
select Ord_id,Sales, round(Sales) as rounded_sales
from market_fact_full
where Sales = (select max(sales) from market_fact_full);
-- 2. Return the product categories and subcategories of all the products which don’t have details about the product base margin.product base margin is null
select * from prod_dimen
where prod_id in (select prod_id from market_fact_full 
					where Product_Base_Margin is null
				);

select prod_id from market_fact_full 
					where Product_Base_Margin is null;
-- 3. Print the name of the most frequent customer. most buying customer, data present in market table
select Customer_Name from cust_dimen
where cust_dimen.cust_id = (select cust_id from market_fact_full group by(cust_id) order by count(cust_id) desc limit 1);
select count(cust_id), cust_id from market_fact_full group by(cust_id) order by count(cust_id) desc;
-- 4. Print the three most common products.


-- -----------------------------------------------------------------------------------------------------------------
-- CTEs

-- 1. Find the 5 products which resulted in the least losses. Which product had the highest product base margin among these?
WITH least_losses as (
		select prod_id, profit, Product_base_margin
        from market_fact_full
        where profit < 0
        order by profit desc
        limit 5
        ) select * from least_losses
        where Product_Base_Margin = (select max(product_base_margin) from least_losses);
-- 2. Find all low-priority orders made in the month of April. Out of them, how many were made in the first half of
-- the month?
WITH low_priority_order as (
		select month(Order_Date) as order_month, day(Order_Date) as Order_day, Order_Date
        from orders_dimen
        where Order_Priority = 'low' and month(Order_Date) = 4
        ) select * from low_priority_order
        where order_day between 1 and 16;
        


-- -----------------------------------------------------------------------------------------------------------------
-- Views

-- 1. Create a view to display the sales amounts, the number of orders, profits made and the shipping costs of all
-- orders. Query it to return all orders which have a profit of greater than 1000.
Create View Order_Info As
Select Ord_ID, Sales, Order_quantity, Profit, Shipping_cost
from market_fact_full;

select * from order_info;

-- 2. Which year generated the highest profit?


-- -----------------------------------------------------------------------------------------------------------------
-- Session: Joins and Set Operations
-- Inner Join

-- 1. Print the product categories and subcategories along with the profits made for each order.
select p.Product_Category, p.Product_Sub_Category, m.Ord_id, m.profit
from prod_dimen p
inner join market_fact_full m
on p.prod_id = m.prod_id;


-- 2. Find the shipment date, mode and profit made for every single order.

-- 3. Print the shipment mode, profit made and product category for each product.

-- 4. Which customer ordered the most number of products?
select m.Cust_id, Customer_Name, count(prod_id) as total_prod, sum(Order_Quantity) as total_order
from market_fact_full m
inner join cust_dimen c
on m.cust_id = c.cust_id
group by m.cust_id
order by total_prod DESC
limit 5;

-- 5. Selling office supplies was more profitable in Delhi as compared to Patna. True or false?

-- 6. Print the name of the customer with the maximum number of orders.

-- 7. Print the three most common products.


-- -----------------------------------------------------------------------------------------------------------------
-- Outer Join

-- 1. Return the order ids which are present in the market facts table.

-- Execute the below queries before solving the next question.
create table manu (
	Manu_Id int primary key,
	Manu_Name varchar(30),
	Manu_City varchar(30)
);

insert into manu values
(1, 'Navneet', 'Ahemdabad'),
(2, 'Wipro', 'Hyderabad'),
(3, 'Furlanco', 'Mumbai');

alter table Prod_Dimen
add column Manu_Id int;

update Prod_Dimen
set Manu_Id = 2
where Product_Category = 'technology';

-- 2. Display the products sold by all the manufacturers using both inner and outer joins.
select distinct manu_id from prod_dimen;
-- 3. Display the number of products sold by each manufacturer.
select m.manu_name, p.prod_id
from manu m LEFT JOIN prod_dimen p on m.manu_id = p.manu_id;
-- 4. Create a view to display the customer names, segments, sales, product categories and
-- subcategories of all orders. Use it to print the names and segments of those customers who ordered more than 20
-- pens and art supplies products.


-- -----------------------------------------------------------------------------------------------------------------
-- Union, Union all, Intersect and Minus

-- 1. Combine the order numbers for orders and order ids for all shipments in a single column.

-- 2. Return non-duplicate order numbers from the orders and shipping tables in a single column.

-- 3. Find the shipment details of products with no information on the product base margin.

-- 4. What are the two most and the two least profitable products?


-- -----------------------------------------------------------------------------------------------------------------
-- Module: Advanced SQL
-- Session: Window Functions	
-- Window Functions in Detail

-- 1. Rank the orders made by Aaron Smayling in the decreasing order of the resulting sales.

-- 2. For the above customer, rank the orders in the increasing order of the discounts provided. Also display the
-- dense ranks.

-- 3. Rank the customers in the decreasing order of the number of orders placed.

-- 4. Create a ranking of the number of orders for each mode of shipment based on the months in which they were
-- shipped. 


-- -----------------------------------------------------------------------------------------------------------------
-- Named Windows

-- 1. Rank the orders in the increasing order of the shipping costs for all orders placed by Aaron Smayling. Also
-- display the row number for each order.


-- -----------------------------------------------------------------------------------------------------------------
-- Frames

-- 1. Calculate the month-wise moving average shipping costs of all orders shipped in the year 2011.


-- -----------------------------------------------------------------------------------------------------------------
-- Session: Programming Constructs in Stored Functions and Procedures
-- IF Statements

-- 1. Classify an order as 'Profitable' or 'Not Profitable'.


-- -----------------------------------------------------------------------------------------------------------------
-- CASE Statements

-- 1. Classify each market fact in the following ways:
--    Profits less than -500: Huge loss
--    Profits between -500 and 0: Bearable loss 
--    Profits between 0 and 500: Decent profit
--    Profits greater than 500: Great profit

-- 2. Classify the customers on the following criteria (TODO)
--    Top 20% of customers: Gold
--    Next 35% of customers: Silver
--    Next 45% of customers: Bronze


-- -----------------------------------------------------------------------------------------------------------------
-- Stored Functions

-- 1. Create and use a stored function to classify each market fact in the following ways:
--    Profits less than -500: Huge loss
--    Profits between -500 and 0: Bearable loss 
--    Profits between 0 and 500: Decent profit
--    Profits greater than 500: Great profit


-- -----------------------------------------------------------------------------------------------------------------
-- Stored Procedures

-- 1. Classify each market fact in the following ways:
--    Profits less than -500: Huge loss
--    Profits between -500 and 0: Bearable loss 
--    Profits between 0 and 500: Decent profit
--    Profits greater than 500: Great profit

-- The market facts with ids '1234', '5678' and '90' belong to which categories of profits?


-- -----------------------------------------------------------------------------------------------------------------
-- Outer Join

-- 1. Return the order ids which are present in the market facts table


-- Execute the below queries before solving the next question.
create table manu(
    Manu_Id int primary key,
    Manu_name varchar(30),
    Manu_city varchar(30),
);

insert into manu values
(1,'Navneet','Ahemdabad'),
(2,'Wipro','Hyderabad'),
(3,'Furlanco','Mumbai');

alter table Prod_Dimen
add column Manu_Id int;

update Prod_dimen
set Manu_Id = 2
where Product_Category = 'technology';

-- 2. Display the products sold by all the manufacturers using both inner and outer joins


-- 3. Display the number of products sold by each manufacturer