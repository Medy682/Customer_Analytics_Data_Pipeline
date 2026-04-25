![CI/CD Pipeline](https://github.com/YOUR_USERNAME/YOUR_REPO/actions/workflows/snowflake_pipeline.yml/badge.svg)

CI/CD Pipeline ✔ passing


Customer Data Analytics Pipeline

Author: Kidima Medy Masuka Date: 2026


✔ Project Overview

The Customer Data Analytics Pipeline is an end-to-end ELT data engineering pipeline designed to ingest, process, and analyze customer sales data using a modern cloud data stack.

The pipeline uses Snowflake as the cloud data warehouse, where raw data is extracted from csv sources, loaded into a raw layer , and progressively tansformed through a staging layer (cleaning and preparation) and an analytics layer.

The final analytics layer is designed using dimensional modelling (star schema) to support business reporting and insights. 

Beyond the core pipeline, i have implemented key engineering practices including orchestration, ci/cd and testing. Orchestration is handled through azure data factory to automate and schedule pipeline.

the solution incorporates a multi_layered validation strategy applied accross the entire pipeline lifecycle. i have aslo impplemented logging for error handling and incremental loads 

within azure data factory to ensure pipeline reliability and fault tolerance.



The implementation follows a structured approach inspired by the CRISP-DM framework, ensuring that the pipeline design aligns with industry best practices for scalable data engineering systems.



CRISP-DM Alignment

CRISP-DM Phase	                  Implementation in This Project

Business Understanding	         Identify how customer and sales data can generate business insights
Data Understanding	         Explore raw CSV datasets containing customer, product, and sales information
Data Preparation	         Load raw datasets into Snowflake and clean data in staging layer
Modeling	                 Implement dimensional modeling using a star schema
Evaluation	                 Perform SQL-based data quality validation checks                                  
Deployment                       Automate pipeline execution using Azure Data Factory and CI/CD


	                          
✔ Architecture


The pipeline follows a layered ELT architecture, where raw data is ingested first and transformations are performed inside the data warehouse.

                    Raw Data (CSV)
                         │
                         ▼
                   RAW Schema
                         │
                         ▼
                 STAGING Schema
             (Cleaning & Standardisation)
                         │
                         ▼
                ANALYTICS Schema
              (Star Schema Modelling)
                         │
                         ▼
             Fact & Dimension Tables
                         │
                         ▼
                  KPI Summary Views
                         │
                         ▼
                Business Analytics Views


Supporting Schemas

DATA_QUALITY
• Validation checks
• Null checks
• Duplicate checks

METADATA
• Watermark tables

Pipeline loggging and audit tables are inside the analytics schema



This layered architecture ensures:

Data traceability
Transformation transparency
Strong data quality controls
Analytics-ready datasets


✔ Technologies Used

Technology	                  Purpose

Snowflake	                  Cloud data warehouse used for storage and transformations
SQL	                          Data cleaning, transformation, and modeling
Azure Data Factory	          Pipeline orchestration and scheduling
GitHub	                          Version control and project documentation
GitHub Actions	                  CI/CD automation for validating SQL scripts
YAML	                          Pipeline configuration files
CSV	                          Raw input datasets 


✔ Data Pipeline Layers

🔰 Raw Layer

The Raw Layer stores ingested datasets in their original format.

Purpose:

Preserve original source data
Enable data lineage tracking
Provide reproducibility for transformations

Tables in this layer mirror the structure of the source CSV files.


🔰 Staging Layer

The Staging Layer prepares the raw data for transformation and modeling.

Key operations include:

Data cleaning
Schema standardization
Data type corrections

This layer ensures the data is standardized before analytics modeling. 


🔰 Data Quality Layer

The Data Quality Layer validates the integrity of the data.

Validation checks include:

Null value detection
Duplicate record identification
Schema validation
Data consistency checks

These checks ensure that only reliable and trustworthy data progresses into the analytics layer.


🔰 Analytics Layer

The Analytics Layer contains the final analytical data model optimized for reporting and insights.

The analytics layer implements a dimensional star schema consisting of:

Fact Table
fact_sales

Dimension Tables
dim_customer
dim_products
dim_date

This modeling approach simplifies analytical queries and improves query performance.

🔰 Analytical Views

On top of the dimensional model, several analytical views were created to answer key business questions.

Examples include:

Sales by country
Sales by category
Sales by date
Top customers by revenue
Number of orders per customer
Average order value per customer
Top 5 best-selling products
Quantity sold per product
Yearly sales trends
Year-over-year sales change

A global KPI summary view was also created to provide high-level business metrics.

✔ Pipeline Orchestration

Pipeline orchestration is implemented using Azure Data Factory.

Azure Data Factory is responsible for:

Scheduling pipeline execution
Automating SQL transformation workflows
Managing pipeline dependencies
Running the pipeline in the cloud


✔ The orchestrated pipeline executes the following workflow:

Load Raw Data
        ↓
Run Staging Transformations
        ↓
Run Data Quality Checks
        ↓
Build Fact Table
        ↓
Build Dimension Tables
        ↓
Create Analytics Views


This ensures the pipeline runs automatically without manual intervention.


✔ CI/CD Automation

The project implements Continuous Integration and Continuous Deployment (CI/CD) using GitHub Actions.

The CI/CD workflow automatically:

Validates SQL scripts
Runs pipeline checks
Tests data transformations
Detects errors before deployment

This ensures that changes to the pipeline code or SQL transformations are tested before being integrated.

✔ Testing and Validation

A dedicated tests folder contains SQL validation scripts that verify pipeline outputs.
The tests folder acts as the final validation stage, ensuring that the pipeline produced the expected analytics tables and views after execution.
or it's like our post execution validation

These tests check for:

Null values in critical columns
Duplicate records
Expected row counts
Table integrity

✅ the multi_layered validation strategy talked about earlier goes as follows:

🔰 In_pipeline validation

🔰 pre_deployment validation 

🔰 post_execution validation 

the three layers of validation are what we call data reliability engineering and they are widely used in modern data platforms 

These validations ensure that the pipeline maintains strong data quality standards.

Configuration Management

✔ Pipeline configurations are stored in a dedicated configuration folder.

This includes:

Pipeline settings
Environment variables
YAML configuration files

Separating configuration from code improves maintainability and scalability.

✔ Repository Structure

snowflake-data-pipeline


├── .github/
│   └── workflows/
│       └── snowflake_pipeline.yml
│
├── config/
│   ├── snowflake_config.yml
│   ├── pipeline_config.yml
│   └── .env.example
│
├── data/
│   └── raw/
│       ├── country_raw.csv
│       ├── customer_raw.csv
│       ├── product_raw.csv
│       └── sales_raw.csv
│
├── snowflake_sql/
│
│   ├── 01_setup/
│   │   └── create_database.sql
│
│   ├── 02_schemas/
│   │   └── create_schemas.sql
│
│   ├── 03_external_stage/
│   │   ├── create_stage.sql
│   │   └── create_file_format.sql
│
│   ├── 04_metadata/
│   │   ├── create_metadata_tables.sql
│   │   ├── create_logging_tables.sql
│   │   └── create_dq_results_tables.sql
│
│   ├── 05_raw/
│   │   ├── create_raw_tables.sql
│   │   └── load_raw_data.sql
│
│   ├── 06_staging/
│   │   └── staging_transformations.sql
│
│   ├── 07_data_quality/
│   │   └── data_quality_checks.sql
│
│   ├── 08_analytics/
│   │   └── analytics.sql
│
│   ├── 09_incremental/
│   │   ├── get_watermark.sql
│   │   ├── incremental_extract.sql
│   │   ├── merge_logic.sql
│   │   └── update_watermark.sql
│
├── adf/
│   ├── linked_services/
│   └── pipelines/
│
├── tests/
│   ├── test_null_values.sql
│   ├── test_duplicates.sql
│   ├── test_row_counts.sql
│   └── test_table_exists.sql
│
├── docs/
│   ├── pipeline_architecture.png
│   ├── elt_workflow.png
│   └── adf_pipeline.png
│
└── README.md





Monitoring & Observability

Pipeline monitoring is supported through logging tables that capture pipeline errors and execution metadata.

These logs allow engineers to audit pipeline execution and diagnose failures.
This modular structure ensures the project remains organized, scalable, and easy to maintain.


Python Automation (Optional Step)

The repository includes a folder prepared for Python automation scripts.

However, Python was not implemented in this project, as it represents an advanced automation layer typically used for tasks such as:

pipeline monitoring
automated deployments
advanced data ingestion
API integrations

Since the pipeline already includes SQL transformations, Azure Data Factory orchestration, and CI/CD automation, the core objectives of the project were successfully completed without requiring Python automation.

✔ Summary

This project demonstrates the design and implementation of a modern ELT data engineering pipeline using:

Snowflake for data warehousing
Azure Data Factory for orchestration
GitHub Actions for CI/CD
SQL for data transformation and modeling

By combining layered architecture, dimensional modeling, automated workflows, and data quality validation, the pipeline represents a scalable and production-ready framework for customer data analytics.


👤 Author

Kidima Medy Masuka 

junior data analyst | data engineer 

Focused on:

Data engineering
Data analytics
Machine learning
Data-driven decision making

Usage & Attribution This project is shared for educational and portfolio purposes.
If reused or adapted, appropriate credit must be given to the author.

📰This project is part of my personal data science and analyitcs portfolio ✅