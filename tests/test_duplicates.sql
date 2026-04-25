USE DATABASE customer_analytics;
--this will show duplicate customers, which is fine
SELECT COUNT(*) AS duplicate_customers
FROM (
    SELECT customer_id, COUNT(*)
    FROM analytics.fact_sales
    GROUP BY customer_id
    HAVING COUNT(*) > 1
);

--This will show duplicate customer transactions, which is what we
--are looking for 
SELECT COUNT(*) AS duplicate_records
FROM (
    SELECT customer_id, product_id, sales_date, COUNT(*)
    FROM analytics.fact_sales
    GROUP BY customer_id, product_id, sales_date
    HAVING COUNT(*) > 1
);