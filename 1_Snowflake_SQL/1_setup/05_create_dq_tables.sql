USE DATABASE CUSTOMER_ANALYTICS;

CREATE TABLE IF NOT EXISTS dq.dq_results (
    table_name STRING,
    check_name STRING,
    failed_count INT,
    check_timestamp TIMESTAMP
);

