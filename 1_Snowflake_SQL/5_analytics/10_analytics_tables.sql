USE SCHEMA Analytics;

--main table or base table

CREATE OR REPLACE TABLE Analytics.sales_enriched as
select 
s.customer_id,
c.name as customer_name,
p.name as product_name,
p.category,
c.country,
s.product_id,
s.quantity,
s.sales_date,
s.total_amount
from staging.sales_clean s
Join staging.customers_clean c on s.customer_id = c.id
Join staging.products_clean p on s.product_id = p.id;

--KPIS table by country and category
CREATE OR REPLACE TABLE Analytics.sales_by_country_category AS 
select 
country,
category,
sum(total_amount) as total_revenue,
sum(quantity) as total_quantity,
count(*) as total_orders,
AVG(total_amount) AS avg_order_value
from Analytics.sales_enriched
group by country, category;

--Sales by country 
CREATE OR REPLACE TABLE Analytics.sales_by_country AS 
select 
country,
sum(total_amount) as total_revenue,
sum(quantity) as total_quantity,
count(*) as total_orders
from Analytics.sales_enriched
group by country;

-- sales by category
CREATE OR REPLACE TABLE Analytics.sales_by_category AS
SELECT 
category,
sum(total_amount)as total_revenue,
sum(quantity) as total_quantity,
count(*) as total_orders
from Analytics.sales_enriched
group by category;

-- sales by date
CREATE OR REPLACE TABLE Analytics.sales_by_date AS
select 
sales_date,
sum(total_amount) as total_revenue,
sum(quantity) as total_quantity,
count(*) as total_orders
from Analytics.sales_enriched
group by sales_date;

--CUSTOMER TABLES:
--who are the top customers by revenue, and how do they rank
create or replace table analytics.top_customers as 
select customer_id, customer_name,sum(total_amount) as total_revenue,
row_number()over(order by sum(total_amount)desc) as rank_position
from analytics.sales_enriched
group by customer_id, customer_name;

--Number of orders per customer
create or replace table analytics.orders_per_customer as 
select customer_id, customer_name,count(*) as number_of_orders,
row_number()over(order by count(*) desc) as rank_position,
case when count(*) =1 then 'one time buyer'
else 'repeat buyer'
end as customer_type
from analytics.sales_enriched
group by customer_id,customer_name;

--Average order value per customer
create or replace table analytics.average_order_value_per_customer as 
select customer_id, customer_name,avg(total_amount) as average_order_value
from analytics.sales_enriched
group by customer_id, customer_name;

--PRODUCT TABLES:
--What are the top 5 best-selling products, or which top 5 products generate the most revenue
create or replace table analytics.top_5_products as 
select product_id,product_name,sum(total_amount) as total_revenue,
row_number()over(order by sum(total_amount)desc) as rank_position
from analytics.sales_enriched
group by product_id,product_name
qualify rank_position <=5 ;

--how much quantity was sold for each product
create or replace table analytics.quantity_per_product as 
select product_id,product_name,sum(quantity) as quantity_sold,
dense_rank()over(order by sum(quantity) desc) as rank_position
from analytics.sales_enriched
group by product_id, product_name;

--TIME TABLES:
--What are the yearly_sales
create or replace table analytics.yearly_sales as 
select year(sales_date) as sales_year, sum(total_amount) as yearly_sales
from analytics.sales_enriched 
group by year(sales_date);


--What are the yearly_sales_change
create or replace table analytics.yearly_sales_change as 
with yearly_sales_change as (

select year(sales_date) as sales_year, sum(total_amount) as yearly_sales
from analytics.sales_enriched 
group by year(sales_date)
)

select sales_year,yearly_sales,
lag(yearly_sales)over(order by sales_year) as previous_sales,
yearly_sales-lag(yearly_sales)over(order by sales_year) as sales_change
from yearly_sales_change;

--KPIS OVERVIEW:
CREATE OR REPLACE TABLE analytics.kpi_overview AS
SELECT 
    SUM(total_amount) AS total_revenue,
    SUM(quantity) AS total_quantity,
    COUNT(*) AS total_orders,
    AVG(total_amount) AS avg_order_value
FROM analytics.sales_enriched;





