USE DATABASE customer_analytics;
USE SCHEMA raw;

COPY INTO raw.customers
FROM @raw.raw_stage/customer_raw.csv
FILE_FORMAT = (FORMAT_NAME = raw.csv_format);

COPY INTO raw.products
FROM @raw.raw_stage/product_raw.csv
FILE_FORMAT = (FORMAT_NAME = raw.csv_format);

COPY INTO raw.country
FROM @raw.raw_stage/country_raw.csv
FILE_FORMAT = (FORMAT_NAME = raw.csv_format);

COPY INTO raw.sales
FROM @raw.raw_stage/sales_raw.csv
FILE_FORMAT = (FORMAT_NAME = raw.csv_format);
