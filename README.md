# Credit Card Fraud Detection Analysis using SQL Server

## Project Overview

This project performs an end-to-end SQL-based analysis of credit card transactions to understand fraudulent transaction patterns, transaction amount distributions, time-based trends, and potential fraud indicators.

The project uses Microsoft SQL Server to perform data quality assessment, data cleaning, exploratory data analysis, advanced SQL analysis, and business insight generation.

**Note:** This is a SQL-based descriptive and diagnostic analytics project. It does not build a machine learning model or predict future fraudulent transactions.

## Project Objectives

- Analyze legitimate and fraudulent transactions.
- Identify transaction amount patterns associated with fraud.
- Examine fraud distribution across elapsed-time intervals.
- Investigate duplicate transaction records.
- Generate meaningful business insights and recommendations.
- Use advanced SQL features and optimize analytical queries.

## Dataset Information

**Dataset:** Credit Card Fraud Detection Dataset  
**Source:** [Kaggle – Credit Card Fraud Detection](https://www.kaggle.com/datasets/mlg-ulb/creditcardfraud)

| Dataset Metric | Value |
|---|---:|
| Total Transactions | 284,807 |
| Total Columns | 31 |
| Legitimate Transactions | 284,315 |
| Fraud Transactions | 492 |
| Fraud Percentage | 0.173% |
| Exact Duplicate Rows Flagged | 1,081 |

### Important Columns

| Column | Description |
|---|---|
| Time | Seconds elapsed from the first transaction |
| V1–V28 | Anonymized PCA-transformed numerical features |
| Amount | Transaction amount |
| Class | Target variable: 0 = Legitimate, 1 = Fraud |

The original dataset contains anonymized features. The actual business meaning of V1–V28 is not provided.

## Technology Stack

- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- SQL
- Common Table Expressions (CTEs)
- Window Functions
- Stored Procedures
- Views
- Nonclustered Indexes
- Execution Plans

## Project Workflow

### Stage 1 – Database Setup and Data Import
- Created the project database.
- Imported the CSV dataset into SQL Server.
- Verified table structure, column count, and record count.

### Stage 2 – Data Quality Assessment
- Checked missing values.
- Identified exact duplicate records.
- Validated Class values.
- Examined transaction amounts and time values.
- Analyzed fraud and legitimate transaction distribution.

### Stage 3 – Data Cleaning and Staging
- Created a staging table.
- Added a unique Row_ID.
- Identified and flagged exact duplicate records.
- Preserved the original transaction records for investigation.

### Stage 4 – Exploratory Data Analysis (EDA)
- Analyzed fraud distribution.
- Compared transaction amounts by transaction class.
- Examined fraud across transaction amount ranges.
- Analyzed six-hour elapsed-time intervals.
- Identified high-value fraudulent transactions.
- Evaluated duplicate record distribution.

### Stage 5 – Advanced SQL Analysis
- Used CTEs for structured analysis.
- Applied RANK(), ROW_NUMBER(), and DENSE_RANK().
- Calculated cumulative fraud transactions.
- Used NTILE() for fraud amount quartile segmentation.
- Compared fraud percentages across time intervals.

### Stage 6 – Business Insights and Recommendations
- Calculated overall fraud KPIs.
- Examined fraud exposure across amount ranges.
- Ranked elapsed-time intervals by fraud percentage.
- Analyzed concentration of fraudulent transaction amounts.
- Identified fraud transactions above the overall average.
- Compared fraud exposure by duplicate status.

### Stage 7 – SQL Development and Performance Optimization
- Created four analytical views.
- Created two stored procedures.
- Created two nonclustered indexes.
- Compared baseline and post-index execution plans.
- Validated database objects and indexes.

## Key Business Insights

### 1. Overall Fraud Distribution
- Total transactions: 284,807.
- Fraudulent transactions: 492.
- Overall fraud percentage: 0.173%.
- Total fraudulent transaction amount: 60,127.97.

### 2. Transaction Amount Analysis
- Average legitimate transaction amount: 88.29.
- Average fraudulent transaction amount: 122.21.
- Fraud percentages were comparatively higher in the larger transaction amount ranges.

### 3. High-Value Fraud Concentration
- The highest-value 10% fraud group contained 50 transactions.
- Their combined transaction amount was 37,286.10.
- This represented approximately 62.011% of the total fraudulent transaction amount.

### 4. Above-Average Fraud Transactions
- Overall average transaction amount: 88.35.
- 164 fraudulent transactions were above this average.
- These represented 33.333% of all fraudulent transactions.
- Their combined transaction amount was 56,486.19.

### 5. Duplicate Record Analysis
- Flagged duplicate records: 1,081.
- Fraudulent transactions among flagged duplicates: 19.
- Fraud percentage in flagged duplicates: 1.758%.
- Fraud percentage in original/first-occurrence records: 0.167%.

This difference indicates an association worth investigating. Duplicate status alone does not establish fraudulent activity.

## Business Recommendations

- Give additional analytical attention to high-value fraudulent transactions.
- Monitor transaction amount segments with comparatively higher fraud percentages.
- Investigate duplicate records before deciding whether they should be removed.
- Review elapsed-time intervals with comparatively higher fraud rates.
- Use transaction counts and fraud percentages together when prioritizing investigation.

These are analytical recommendations, not a validated real-time fraud detection policy.

## Repository Structure

```text
Credit-Card-Fraud-Analysis/
│
├── SQL/
│   └── Credit_Card_Fraud_Complete_Analysis.sql
│
├── Screenshots/
│   ├── Stage_01_Database_Import/
│   ├── Stage_02_Data_Quality/
│   ├── Stage_03_Data_Cleaning/
│   ├── Stage_04_EDA/
│   ├── Stage_05_Advanced_SQL/
│   ├── Stage_06_Business_Insights/
│   └── Stage_07_SQL_Development/
│
└── README.md
```

## How to Run the Project

1. Download the dataset from the Kaggle source provided above.
2. Extract `creditcard.csv`.
3. Install Microsoft SQL Server and SQL Server Management Studio.
4. Create the database `Credit_Card_Fraud_Analysis_DB`.
5. Import the CSV into the database.
6. Follow the stages documented in the SQL script.
7. Execute the queries in SSMS to reproduce the analysis.

**Important:** The original CSV is approximately 150 MB and is not included in this repository. Download it directly from Kaggle.

## Limitations

- The dataset contains highly imbalanced classes, with only 0.173% fraudulent transactions.
- V1–V28 are anonymized PCA-transformed features.
- Time represents elapsed seconds, not actual clock time.
- The dataset represents historical transactions from 2013.
- This project performs SQL-based analysis and does not implement predictive machine learning.
- Observed patterns do not establish causation.

## Project Outcome

This project demonstrates practical SQL skills through data quality checks, data cleaning, exploratory analysis, advanced SQL techniques, business insight generation, database development, and query performance investigation.

**Author:** Saswat Nayak  
**Role:** Aspiring Data Analyst
