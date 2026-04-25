USE DATABASE CUSTOMER_ANALYTICS;

CREATE OR REPLACE TABLE raw.customers (
    id           STRING,
    name         STRING,
    gender       STRING,
    dateofbirth  STRING,
    email        STRING,
    country      CHAR(2),
    city         STRING,
    created_at   STRING,
    updated_at   STRING
);

CREATE OR REPLACE TABLE raw.products (
    id           STRING,
    name         STRING,
    code         STRING,
    category     STRING,
    price        NUMBER(10,2),
    currency     CHAR(3),
    color        STRING,
    created_at   STRING,
    updated_at   STRING
);

CREATE TABLE raw.country (
    code CHAR(2) PRIMARY KEY,
    name STRING
);

CREATE OR REPLACE TABLE raw.sales (
    customer_id  STRING,
    product_id   STRING,
    sales_date   DATE,
    quantity     INT,
    total_amount NUMBER(12,2),
    currency     CHAR(3),
    created_at   STRING,
    updated_at   STRING
);

