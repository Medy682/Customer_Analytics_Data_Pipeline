USE DATABASE customer_analytics;

SELECT COUNT(*) AS null_customer_id
FROM analytics.fact_sales
WHERE customer_id IS NULL;