COPY INTO raw.customers
FROM @raw_stage/customer_raw.csv
FILE_FORMAT = (FORMAT_NAME= raw.csv_format);

COPY INTO raw.products
FROM @raw_stage/product_raw.csv
FILE_FORMAT =(FORMAT_NAME = raw.csv_format);

COPY INTO raw.country
FROM @raw_stage/country_raw.csv
FILE_FORMAT = (FORMAT_NAME = raw.csv_format);

COPY INTO raw.sales
FROM @raw_stage/sales_raw.csv
FILE_FORMAT = (FORMAT_NAME = raw.csv_format);