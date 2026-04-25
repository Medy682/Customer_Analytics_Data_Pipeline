USE DATABASE customer_analytics;

SELECT COUNT(*) AS table_exists
FROM information_schema.tables
WHERE table_schema = 'ANALYTICS'
AND table_name = 'FACT_SALES';