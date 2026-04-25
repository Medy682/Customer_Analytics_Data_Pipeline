USE SCHEMA Analytics;

--main table or fact table
--star schema modeling used (fact table, dimension tables( including dim date table)
--aggregated kpi summary view used, and used analytics views that answer business questions:
 --Sales by country
-- sales by category
-- sales by date
--top customers by revenue, and how do they rank
--Number of orders per customer
--Average order value per customer
-- top 5 best-selling products, or which top 5 products generate the most revenue
--how much quantity was sold for each product
--What are the yearly_sales
--What are the yearly_sales_change


CREATE OR REPLACE TABLE Analytics.fact_sales as
select 
customer_id,
product_id,
quantity,
sales_date,
total_amount
from staging.sales_clean;

--dimension customer table
CREATE OR REPLACE TABLE Analytics.dim_customer AS 
select 
id as customer_id,
name as customer_name,
country
from staging.customers_clean;

--dimension products table 
create or replace table Analytics.dim_products as 
select
id as product_id,
name as product_name,
category
from staging.products_clean;

--dimension date table
create or replace table Analytics.dim_date as 
select 
sales_date,
year(sales_date) as year,
month(sales_date) as month,
day( sales_date) as day
from staging.sales_clean;


--AGGREGATED KPI SUMMARY VIEW:
CREATE OR REPLACE VIEW Analytics.vw_kpi_summary_view AS
SELECT 
    SUM(total_amount) AS total_revenue,
    SUM(quantity) AS total_quantity,
    COUNT(*) AS total_orders,
    AVG(total_amount) AS avg_order_value
FROM Analytics.fact_sales;

--Sales by country 
CREATE OR REPLACE view Analytics.vw_sales_by_country AS 
select 
c.country,
sum(total_amount) as total_revenue
from Analytics.fact_sales f 
join Analytics.dim_customer c on f.customer_id= c.customer_id
group by c.country;

-- sales by category
CREATE OR REPLACE view Analytics.vw_sales_by_category AS
SELECT 
p.category,
sum(total_amount)as total_revenue
from Analytics.fact_sales f 
join Analytics.dim_products p on f.product_id = p.product_id
group by p.category;

-- sales by date
CREATE OR REPLACE view Analytics.vw_sales_by_date AS
select 
sales_date,
sum(total_amount) as total_revenue
from Analytics.fact_sales
group by sales_date;

--CUSTOMER TABLES:
--who are the top customers by revenue, and how do they rank
create or replace view Analytics.vw_top_customers as 
select f.customer_id, c.customer_name,sum(f.total_amount) as total_revenue,
row_number()over(order by sum(f.total_amount)desc) as rank_position
from Analytics.fact_sales f
join Analytics.dim_customer c on f.customer_id = c.customer_id
group by f.customer_id, c.customer_name;

--Number of orders per customer
create or replace view Analytics.vw_orders_per_customer as 
select f.customer_id, c.customer_name,count(*) as number_of_orders,
row_number()over(order by count(*) desc) as rank_position,
case when count(*) =1 then 'one time buyer'
else 'repeat buyer'
end as customer_type
from Analytics.fact_sales f 
join Analytics.dim_customer c on f.customer_id = c.customer_id
group by f.customer_id,c.customer_name;

--Average order value per customer
create or replace view Analytics.vw_average_order_value_per_customer as 
select f.customer_id, c.customer_name,avg(f.total_amount) as average_order_value
from Analytics.fact_sales f 
join Analytics.dim_customer c on f.customer_id = c.customer_id
group by f.customer_id, c.customer_name;

--PRODUCT TABLES:
--What are the top 5 best-selling products, or which top 5 products generate the most revenue
create or replace view Analytics.vw_top_5_products as 
select f.product_id,p.product_name ,sum(f.total_amount) as total_revenue,
row_number()over(order by sum(f.total_amount)desc) as rank_position
from Analytics.fact_sales f 
join Analytics.dim_products p on f.product_id = p.product_id
group by f.product_id,p.product_name
qualify rank_position <=5 ;

--how much quantity was sold for each product
create or replace view Analytics.vw_quantity_per_product as 
select f.product_id,p.product_name, sum(f.quantity) as quantity_sold,
dense_rank()over(order by sum(f.quantity) desc) as rank_position
from Analytics.fact_sales f 
join Analytics.dim_products p on f.product_id = p.product_id
group by f.product_id, p.product_name;

--TIME TABLES:
--What are the yearly_sales
create or replace view Analytics.vw_yearly_sales as 
select year(sales_date) as sales_year, sum(total_amount) as yearly_sales
from Analytics.fact_sales 
group by year(sales_date);


--What are the yearly_sales_change
create or replace view Analytics.vw_yearly_sales_change as 
with yearly_sales_change as (

select year(sales_date) as sales_year, sum(total_amount) as yearly_sales
from Analytics.fact_sales
group by year(sales_date)
)

select sales_year,yearly_sales,
lag(yearly_sales)over(order by sales_year) as previous_sales,
yearly_sales-lag(yearly_sales)over(order by sales_year) as sales_change
from yearly_sales_change;

------------------------------------------------------------------------------------------
--ERROR LOGGING TABLE
--Error logging table( Error handling): 
CREATE OR REPLACE TABLE analytics.pipeline_error_log (
pipeline_name STRING,
activity_name STRING,
error_message STRING,
error_time TIMESTAMP
);

INSERT INTO analytics.pipeline_error_log
VALUES (
'customer_data_analytics_pipeline',
'run_staging_layer',
'Pipeline activity failed',
CURRENT_TIMESTAMP
);

--AUDIT TABLE
--Pipeline_Audit table (pipeline_run_log):
 CREATE OR REPLACE TABLE analytics.pipeline_audit(
 run_id string,
 pipeline_name string,
 start_time timestamp,
 end_time timestamp,
 status string
);

--log start( first pipeline activity)
INSERT INTO analytics.pipeline_audit(run_id, pipeline_name, start_time, end_time, status)
SELECT 
    UUID_STRING(), 
    'customer_data_pipeline', 
    CURRENT_TIMESTAMP(), 
    NULL, 
    'RUNNING';

--log end (last pipeline activity)
UPDATE analytics.pipeline_audit
SET end_time = CURRENT_TIMESTAMP,
status = 'SUCCESS'
WHERE pipeline_name = 'customer_data_analytics_pipeline'
AND end_time IS NULL;
--Now every pipeline run is tracked.

UPDATE analytics.pipeline_audit
SET pipeline_name = 'customer_data_analytics_pipeline' 
WHERE pipeline_name = 'customer_data_pipeline';
