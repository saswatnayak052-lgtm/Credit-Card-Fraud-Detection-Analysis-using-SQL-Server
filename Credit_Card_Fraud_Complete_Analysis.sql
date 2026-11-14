/*
============================================================
PROJECT TITLE: CREDIT CARD FRAUD DETECTION ANALYSIS
DATABASE: Microsoft SQL Server
DATABASE NAME: Credit_Card_Fraud_Analysis_DB

PROJECT OBJECTIVE:
Analyze historical credit card transactions using SQL.
Compare fraudulent and legitimate transactions and
identify transaction patterns for business insights.

DATASET:
284,807 transactions
31 columns
Class 0 = Legitimate transaction
Class 1 = Fraudulent transaction

============================================================
STAGE 1: DATABASE SETUP AND DATA IMPORT VERIFICATION
============================================================

Purpose:
1. Select the project database.
2. Verify the imported raw table.
3. Check total records.
4. Verify the column structure.
5. Preview sample records.

============================================================
*/

-- Step 1: Select project database
USE Credit_Card_Fraud_Analysis_DB;
GO

-- Step 2: Verify current database
SELECT DB_NAME() AS Current_Database;
GO

-- Step 3: Verify imported table
SELECT
    SCHEMA_NAME(schema_id) AS Schema_Name,
    name AS Table_Name
FROM sys.tables
WHERE name = 'creditcard_raw';
GO

-- Step 4: Check total imported transactions
SELECT
    COUNT(*) AS Total_Records
FROM dbo.creditcard_raw;
GO

-- Step 5: Verify total number of columns
SELECT
    COUNT(*) AS Total_Columns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'creditcard_raw';
GO

-- Step 6: Display column names and data types
SELECT
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'creditcard_raw'
ORDER BY ORDINAL_POSITION;
GO

-- Step 7: Preview first five transactions
SELECT TOP 5 *
FROM dbo.creditcard_raw;
GO
/*
============================================================
STAGE 2: DATA QUALITY ASSESSMENT
============================================================

Project: Credit Card Fraud Detection Analysis
Database: Credit_Card_Fraud_Analysis_DB
Source Table: dbo.creditcard_raw

OBJECTIVE:
Inspect the raw dataset before performing data cleaning.

CHECKS:
1. Total records and columns
2. NULL values in all columns
3. Exact duplicate transactions
4. Invalid Class values
5. Amount and Time validation
6. Fraud vs legitimate transaction distribution

IMPORTANT:
No records will be deleted or modified in this stage.
============================================================
*/

USE Credit_Card_Fraud_Analysis_DB;
GO


/*----------------------------------------------------------
CHECK 1: TOTAL RECORDS AND COLUMNS
Purpose: Verify the size of the imported dataset.
Expected: 284807 records and 31 columns.
----------------------------------------------------------*/

SELECT
    COUNT(*) AS Total_Records
FROM dbo.creditcard_raw;
GO

SELECT
    COUNT(*) AS Total_Columns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'creditcard_raw';
GO


/*----------------------------------------------------------
CHECK 2: NULL VALUE ANALYSIS
Purpose: Identify missing values in all 31 columns.
Expected from original CSV: All NULL counts should be 0.
----------------------------------------------------------*/

SELECT
    COUNT(*) AS Total_Records,

    SUM(CASE WHEN Time IS NULL THEN 1 ELSE 0 END) AS Time_NULL,
    SUM(CASE WHEN V1 IS NULL THEN 1 ELSE 0 END) AS V1_NULL,
    SUM(CASE WHEN V2 IS NULL THEN 1 ELSE 0 END) AS V2_NULL,
    SUM(CASE WHEN V3 IS NULL THEN 1 ELSE 0 END) AS V3_NULL,
    SUM(CASE WHEN V4 IS NULL THEN 1 ELSE 0 END) AS V4_NULL,
    SUM(CASE WHEN V5 IS NULL THEN 1 ELSE 0 END) AS V5_NULL,
    SUM(CASE WHEN V6 IS NULL THEN 1 ELSE 0 END) AS V6_NULL,
    SUM(CASE WHEN V7 IS NULL THEN 1 ELSE 0 END) AS V7_NULL,
    SUM(CASE WHEN V8 IS NULL THEN 1 ELSE 0 END) AS V8_NULL,
    SUM(CASE WHEN V9 IS NULL THEN 1 ELSE 0 END) AS V9_NULL,
    SUM(CASE WHEN V10 IS NULL THEN 1 ELSE 0 END) AS V10_NULL,
    SUM(CASE WHEN V11 IS NULL THEN 1 ELSE 0 END) AS V11_NULL,
    SUM(CASE WHEN V12 IS NULL THEN 1 ELSE 0 END) AS V12_NULL,
    SUM(CASE WHEN V13 IS NULL THEN 1 ELSE 0 END) AS V13_NULL,
    SUM(CASE WHEN V14 IS NULL THEN 1 ELSE 0 END) AS V14_NULL,
    SUM(CASE WHEN V15 IS NULL THEN 1 ELSE 0 END) AS V15_NULL,
    SUM(CASE WHEN V16 IS NULL THEN 1 ELSE 0 END) AS V16_NULL,
    SUM(CASE WHEN V17 IS NULL THEN 1 ELSE 0 END) AS V17_NULL,
    SUM(CASE WHEN V18 IS NULL THEN 1 ELSE 0 END) AS V18_NULL,
    SUM(CASE WHEN V19 IS NULL THEN 1 ELSE 0 END) AS V19_NULL,
    SUM(CASE WHEN V20 IS NULL THEN 1 ELSE 0 END) AS V20_NULL,
    SUM(CASE WHEN V21 IS NULL THEN 1 ELSE 0 END) AS V21_NULL,
    SUM(CASE WHEN V22 IS NULL THEN 1 ELSE 0 END) AS V22_NULL,
    SUM(CASE WHEN V23 IS NULL THEN 1 ELSE 0 END) AS V23_NULL,
    SUM(CASE WHEN V24 IS NULL THEN 1 ELSE 0 END) AS V24_NULL,
    SUM(CASE WHEN V25 IS NULL THEN 1 ELSE 0 END) AS V25_NULL,
    SUM(CASE WHEN V26 IS NULL THEN 1 ELSE 0 END) AS V26_NULL,
    SUM(CASE WHEN V27 IS NULL THEN 1 ELSE 0 END) AS V27_NULL,
    SUM(CASE WHEN V28 IS NULL THEN 1 ELSE 0 END) AS V28_NULL,

    SUM(CASE WHEN Amount IS NULL THEN 1 ELSE 0 END) AS Amount_NULL,
    SUM(CASE WHEN Class IS NULL THEN 1 ELSE 0 END) AS Class_NULL

FROM dbo.creditcard_raw;
GO


/*----------------------------------------------------------
CHECK 3: EXACT DUPLICATE TRANSACTIONS
Purpose: Identify rows where all 31 column values match.

Duplicate Groups:
Number of distinct repeated records.

Extra Duplicate Rows:
Number of additional copies beyond the first occurrence.

Expected based on original CSV inspection:
1081 extra duplicate rows.
----------------------------------------------------------*/

WITH DuplicateGroups AS
(
    SELECT
        Time,
        V1, V2, V3, V4, V5, V6, V7,
        V8, V9, V10, V11, V12, V13, V14,
        V15, V16, V17, V18, V19, V20, V21,
        V22, V23, V24, V25, V26, V27, V28,
        Amount,
        Class,
        COUNT_BIG(*) AS Duplicate_Count
    FROM dbo.creditcard_raw
    GROUP BY
        Time,
        V1, V2, V3, V4, V5, V6, V7,
        V8, V9, V10, V11, V12, V13, V14,
        V15, V16, V17, V18, V19, V20, V21,
        V22, V23, V24, V25, V26, V27, V28,
        Amount,
        Class
    HAVING COUNT_BIG(*) > 1
)
SELECT
    COUNT(*) AS Duplicate_Groups,
    SUM(Duplicate_Count - 1) AS Extra_Duplicate_Rows
FROM DuplicateGroups;
GO


/*----------------------------------------------------------
CHECK 4: CLASS VALUE VALIDATION
Purpose:
Class 0 = Legitimate transaction
Class 1 = Fraudulent transaction

Any other value is considered invalid.
----------------------------------------------------------*/

SELECT
    Class,
    COUNT(*) AS Transaction_Count
FROM dbo.creditcard_raw
GROUP BY Class
ORDER BY Class;
GO

-- Identify records with invalid Class values
SELECT
    COUNT(*) AS Invalid_Class_Records
FROM dbo.creditcard_raw
WHERE Class IS NULL
   OR Class NOT IN (0, 1);
GO


/*----------------------------------------------------------
CHECK 5: AMOUNT AND TIME VALIDATION
Purpose:
Inspect minimum, maximum and average values.
Identify negative Amount and Time values.
----------------------------------------------------------*/

SELECT
    MIN(Amount) AS Minimum_Amount,
    MAX(Amount) AS Maximum_Amount,
    AVG(Amount) AS Average_Amount,
    MIN(Time) AS Minimum_Time,
    MAX(Time) AS Maximum_Time,
    AVG(Time) AS Average_Time
FROM dbo.creditcard_raw;
GO

-- Check negative transaction amounts
SELECT
    COUNT(*) AS Negative_Amount_Records
FROM dbo.creditcard_raw
WHERE Amount < 0;
GO

-- Check negative transaction times
SELECT
    COUNT(*) AS Negative_Time_Records
FROM dbo.creditcard_raw
WHERE Time < 0;
GO


/*----------------------------------------------------------
CHECK 6: FRAUD VS LEGITIMATE TRANSACTION DISTRIBUTION
Purpose:
Calculate transaction counts and fraud percentage.

Class 0 = Legitimate
Class 1 = Fraud
----------------------------------------------------------*/

SELECT
    Class,
    COUNT(*) AS Transaction_Count,

    CAST(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER ()
        AS DECIMAL(10,3)
    ) AS Transaction_Percentage

FROM dbo.creditcard_raw
GROUP BY Class
ORDER BY Class;
GO

-- Calculate overall fraud percentage
SELECT
    COUNT(*) AS Total_Transactions,

    SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END)
        AS Fraud_Transactions,

    SUM(CASE WHEN Class = 0 THEN 1 ELSE 0 END)
        AS Legitimate_Transactions,

    CAST(
        SUM(CASE WHEN Class = 1 THEN 1.0 ELSE 0 END)
        * 100.0 / COUNT(*)
        AS DECIMAL(10,4)
    ) AS Fraud_Percentage

FROM dbo.creditcard_raw;
GO
/*
============================================================
PROJECT: CREDIT CARD FRAUD DETECTION ANALYSIS
STAGE 3: DATA CLEANING AND STAGING
============================================================

Database: Credit_Card_Fraud_Analysis_DB
Source Table: dbo.creditcard_raw

OBJECTIVES:
1. Preserve original raw data.
2. Create a staging table.
3. Generate a unique Row_ID.
4. Identify exact duplicate transactions.
5. Flag duplicate records without deleting them.
6. Verify staging table integrity.

IMPORTANT:
No original records will be deleted.
Duplicate records will only be flagged.

============================================================
*/

USE Credit_Card_Fraud_Analysis_DB;
GO


/*----------------------------------------------------------
STEP 1: CREATE STAGING TABLE

Purpose:
Create a working copy of the original raw dataset.

IDENTITY:
Generates a unique sequential Row_ID for each record.

The original raw table remains unchanged.
----------------------------------------------------------*/

-- Avoid accidental duplicate staging table creation
IF OBJECT_ID('dbo.creditcard_staging', 'U') IS NOT NULL
BEGIN
    DROP TABLE dbo.creditcard_staging;
END;
GO

-- Create staging table with a unique Row_ID
SELECT
    IDENTITY(BIGINT, 1, 1) AS Row_ID,
    *
INTO dbo.creditcard_staging
FROM dbo.creditcard_raw;
GO


/*----------------------------------------------------------
STEP 2: VERIFY STAGING TABLE

Purpose:
Check whether all raw records were copied successfully.
----------------------------------------------------------*/

SELECT
    COUNT(*) AS Staging_Records
FROM dbo.creditcard_staging;
GO

-- Preview staging table
SELECT TOP 5 *
FROM dbo.creditcard_staging;
GO


/*----------------------------------------------------------
STEP 3: ADD DUPLICATE FLAG

Purpose:
Create a column to identify duplicate transactions.

0 = First occurrence / not flagged
1 = Additional exact duplicate occurrence

No records are deleted.
----------------------------------------------------------*/

ALTER TABLE dbo.creditcard_staging
ADD Is_Duplicate BIT NOT NULL
CONSTRAINT DF_creditcard_staging_Is_Duplicate
DEFAULT 0;
GO


/*----------------------------------------------------------
STEP 4: IDENTIFY EXACT DUPLICATES

Purpose:
Compare all original 31 transaction columns.

ROW_NUMBER:
Assigns a sequence number to identical records.

First occurrence = 1
Additional occurrences = 2, 3, etc.

Only additional occurrences are flagged as duplicates.
----------------------------------------------------------*/

;WITH DuplicateCheck AS
(
    SELECT
        Row_ID,

        ROW_NUMBER() OVER
        (
            PARTITION BY
                Time,
                V1, V2, V3, V4, V5, V6, V7,
                V8, V9, V10, V11, V12, V13, V14,
                V15, V16, V17, V18, V19, V20, V21,
                V22, V23, V24, V25, V26, V27, V28,
                Amount,
                Class
            ORDER BY Row_ID
        ) AS Duplicate_Number

    FROM dbo.creditcard_staging
)

UPDATE S
SET Is_Duplicate =
    CASE
        WHEN D.Duplicate_Number > 1 THEN 1
        ELSE 0
    END

FROM dbo.creditcard_staging AS S
INNER JOIN DuplicateCheck AS D
    ON S.Row_ID = D.Row_ID;
GO


/*----------------------------------------------------------
STEP 5: DUPLICATE FLAG SUMMARY

Purpose:
Calculate the number of original and flagged records.
----------------------------------------------------------*/

SELECT
    COUNT(*) AS Total_Records,

    SUM(
        CASE WHEN Is_Duplicate = 0
        THEN 1 ELSE 0 END
    ) AS Original_Records,

    SUM(
        CASE WHEN Is_Duplicate = 1
        THEN 1 ELSE 0 END
    ) AS Duplicate_Records

FROM dbo.creditcard_staging;
GO


/*----------------------------------------------------------
STEP 6: VERIFY DUPLICATE SAMPLES

Purpose:
Display sample records marked as duplicates.
----------------------------------------------------------*/

SELECT TOP 10 *
FROM dbo.creditcard_staging
WHERE Is_Duplicate = 1
ORDER BY Row_ID;
GO


/*----------------------------------------------------------
STEP 7: FINAL STAGING VALIDATION

Purpose:
Verify the staging table structure and record count.
----------------------------------------------------------*/

SELECT
    COUNT(*) AS Total_Staging_Records,
    COUNT(DISTINCT Row_ID) AS Unique_Row_IDs,
    SUM(CASE WHEN Is_Duplicate = 1 THEN 1 ELSE 0 END)
        AS Flagged_Duplicates
FROM dbo.creditcard_staging;
GO

/*
============================================================
END OF STAGE 3
============================================================

Raw data preserved.
Staging table created.
Unique Row_ID generated.
Exact duplicates identified and flagged.

The final clean table will be created after
reviewing the Stage 2 and Stage 3 results.

============================================================
*/
/*
============================================================
PROJECT: CREDIT CARD FRAUD DETECTION ANALYSIS
STAGE 4: EXPLORATORY DATA ANALYSIS (EDA)
============================================================

Database: Credit_Card_Fraud_Analysis_DB
Table: dbo.creditcard_staging

OBJECTIVE:
Explore transaction patterns and compare fraudulent
transactions with legitimate transactions.

BUSINESS QUESTIONS:
1. What is the distribution of fraud and legitimate transactions?
2. How do transaction amounts differ by Class?
3. Which transaction amount ranges contain more fraud?
4. How does fraud activity vary across elapsed-time intervals?
5. What are the highest-value fraudulent transactions?
6. Do flagged duplicate records affect the fraud distribution?

IMPORTANT:
- Class 0 = Legitimate transaction
- Class 1 = Fraudulent transaction
- Time = Seconds elapsed from the first transaction
- V1 to V28 = Anonymized PCA-transformed features
- No records will be deleted or modified in this stage.

============================================================
*/

USE Credit_Card_Fraud_Analysis_DB;
GO


/*----------------------------------------------------------
EDA 1: FRAUD VS LEGITIMATE TRANSACTION DISTRIBUTION

Purpose:
Calculate the number and percentage of fraud and
legitimate transactions.

Business question:
How common are fraudulent transactions in this dataset?
----------------------------------------------------------*/

SELECT
    Class,

    CASE
        WHEN Class = 0 THEN 'Legitimate'
        WHEN Class = 1 THEN 'Fraud'
        ELSE 'Invalid / Unknown'
    END AS Transaction_Type,

    COUNT(*) AS Transaction_Count,

    CAST(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER ()
        AS DECIMAL(10,3)
    ) AS Transaction_Percentage

FROM dbo.creditcard_staging
GROUP BY Class
ORDER BY Class;
GO


/*----------------------------------------------------------
EDA 2: TRANSACTION AMOUNT ANALYSIS BY CLASS

Purpose:
Compare transaction amounts between legitimate
and fraudulent transactions.

Metrics:
- Transaction count
- Total transaction amount
- Average transaction amount
- Minimum transaction amount
- Maximum transaction amount

Business question:
Are fraudulent transactions generally higher in value?
----------------------------------------------------------*/

SELECT
    Class,

    CASE
        WHEN Class = 0 THEN 'Legitimate'
        WHEN Class = 1 THEN 'Fraud'
        ELSE 'Invalid / Unknown'
    END AS Transaction_Type,

    COUNT(*) AS Transaction_Count,

    CAST(SUM(Amount) AS DECIMAL(18,2))
        AS Total_Transaction_Amount,

    CAST(AVG(Amount) AS DECIMAL(18,2))
        AS Average_Transaction_Amount,

    CAST(MIN(Amount) AS DECIMAL(18,2))
        AS Minimum_Transaction_Amount,

    CAST(MAX(Amount) AS DECIMAL(18,2))
        AS Maximum_Transaction_Amount

FROM dbo.creditcard_staging
GROUP BY Class
ORDER BY Class;
GO


/*----------------------------------------------------------
EDA 3: FRAUD ANALYSIS BY TRANSACTION AMOUNT RANGE

Purpose:
Group transactions into amount ranges and calculate
fraud counts and fraud percentages within each range.

Amount ranges:
1. Zero
2. 0.01 - 25
3. 25.01 - 50
4. 50.01 - 100
5. 100.01 - 250
6. 250.01 - 500
7. Above 500

Business question:
Which transaction amount ranges have a higher
proportion of fraudulent transactions?

Note:
Always consider fraud count along with fraud percentage.
----------------------------------------------------------*/

;WITH AmountAnalysis AS
(
    SELECT
        CASE
            WHEN Amount = 0 THEN 'Zero'
            WHEN Amount <= 25 THEN '0.01 - 25'
            WHEN Amount <= 50 THEN '25.01 - 50'
            WHEN Amount <= 100 THEN '50.01 - 100'
            WHEN Amount <= 250 THEN '100.01 - 250'
            WHEN Amount <= 500 THEN '250.01 - 500'
            ELSE 'Above 500'
        END AS Amount_Range,

        CASE
            WHEN Amount = 0 THEN 1
            WHEN Amount <= 25 THEN 2
            WHEN Amount <= 50 THEN 3
            WHEN Amount <= 100 THEN 4
            WHEN Amount <= 250 THEN 5
            WHEN Amount <= 500 THEN 6
            ELSE 7
        END AS Range_Order,

        Class

    FROM dbo.creditcard_staging
)

SELECT
    Amount_Range,

    COUNT(*) AS Total_Transactions,

    SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END)
        AS Fraud_Transactions,

    SUM(CASE WHEN Class = 0 THEN 1 ELSE 0 END)
        AS Legitimate_Transactions,

    CAST(
        SUM(CASE WHEN Class = 1 THEN 1.0 ELSE 0 END)
        * 100.0 / COUNT(*)
        AS DECIMAL(10,3)
    ) AS Fraud_Percentage

FROM AmountAnalysis
GROUP BY Amount_Range, Range_Order
ORDER BY Range_Order;
GO


/*----------------------------------------------------------
EDA 4: TIME-BASED TRANSACTION ANALYSIS

Purpose:
Analyze transactions across six-hour intervals.

Time is measured in seconds from the first transaction.
It is NOT an actual clock time.

One interval = 21600 seconds = 6 hours.

Business question:
How does transaction and fraud activity vary
over elapsed-time intervals?
----------------------------------------------------------*/

;WITH TimeAnalysis AS
(
    SELECT
        CAST(FLOOR(Time / 21600.0) AS INT)
            AS Time_Interval,

        Class

    FROM dbo.creditcard_staging
)

SELECT
    CONCAT(
        'Hour ',
        Time_Interval * 6,
        ' - ',
        (Time_Interval + 1) * 6
    ) AS Elapsed_Time_Range,

    COUNT(*) AS Total_Transactions,

    SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END)
        AS Fraud_Transactions,

    SUM(CASE WHEN Class = 0 THEN 1 ELSE 0 END)
        AS Legitimate_Transactions,

    CAST(
        SUM(CASE WHEN Class = 1 THEN 1.0 ELSE 0 END)
        * 100.0 / COUNT(*)
        AS DECIMAL(10,3)
    ) AS Fraud_Percentage

FROM TimeAnalysis
GROUP BY Time_Interval
ORDER BY Time_Interval;
GO


/*----------------------------------------------------------
EDA 5: TOP 10 HIGHEST-VALUE FRAUDULENT TRANSACTIONS

Purpose:
Identify the ten highest transaction amounts
among records classified as fraud.

Business question:
What are the highest-value fraudulent transactions?

Note:
This is historical analysis, not fraud prediction.
----------------------------------------------------------*/

SELECT TOP 10
    Row_ID,
    Time,
    Amount,
    Class

FROM dbo.creditcard_staging

WHERE Class = 1

ORDER BY Amount DESC;
GO


/*----------------------------------------------------------
EDA 6: DUPLICATE IMPACT ON FRAUD DISTRIBUTION

Purpose:
Compare flagged duplicate and non-duplicate records
across legitimate and fraudulent classes.

Business question:
Are flagged duplicate records concentrated in
either transaction class?

Note:
Duplicate records are not deleted.
----------------------------------------------------------*/

SELECT
    Is_Duplicate,

    CASE
        WHEN Is_Duplicate = 0 THEN 'Original / First Occurrence'
        WHEN Is_Duplicate = 1 THEN 'Flagged Duplicate'
    END AS Duplicate_Status,

    Class,

    COUNT(*) AS Transaction_Count

FROM dbo.creditcard_staging

GROUP BY
    Is_Duplicate,
    Class

ORDER BY
    Is_Duplicate,
    Class;
GO


/*
============================================================
END OF STAGE 4: EXPLORATORY DATA ANALYSIS
============================================================

Analysis completed:
1. Transaction class distribution
2. Transaction amount comparison
3. Fraud by amount range
4. Fraud by elapsed-time interval
5. Highest-value fraudulent transactions
6. Duplicate impact analysis

No original or staging records were deleted.

============================================================
*/

/*====================================================================
  PROJECT  : CREDIT CARD FRAUD DETECTION ANALYSIS
  DATABASE : Credit_Card_Fraud_Analysis_DB
  TABLE    : dbo.creditcard_staging
  STAGE    : 05 - ADVANCED SQL ANALYSIS

  OBJECTIVE:
  Perform advanced transaction analysis using CTEs, window functions,
  ranking functions, cumulative calculations and quartile segmentation.

  IMPORTANT:
  1. No records are deleted or modified in this stage.
  2. All analysis uses the staging table.
  3. Class = 0 represents Legitimate transactions.
  4. Class = 1 represents Fraud transactions.
  5. Time represents elapsed seconds from the first transaction,
     NOT actual clock time.

  QUERIES:
  5.1 Fraud vs Legitimate Transaction Comparison
  5.2 Ranking of Highest-Value Fraud Transactions
  5.3 Ranking Time Intervals by Fraud Percentage
  5.4 Cumulative Fraud Transaction Analysis
  5.5 Fraud Transaction Amount Quartile Analysis
  5.6 Fraud Rate Comparison by Duplicate Status
====================================================================*/

USE Credit_Card_Fraud_Analysis_DB;
GO


/*====================================================================
  QUERY 5.1: FRAUD VS LEGITIMATE TRANSACTION COMPARISON

  PURPOSE:
  Compare transaction count, total amount, average amount,
  maximum amount and minimum amount for both transaction classes.

  SQL CONCEPTS:
  - Common Table Expression (CTE)
  - GROUP BY
  - COUNT(), SUM(), AVG(), MAX(), MIN()
  - CASE WHEN

  BUSINESS QUESTION:
  How do fraudulent transactions differ from legitimate
  transactions in terms of transaction amount and volume?
====================================================================*/

WITH Transaction_Summary AS
(
    SELECT
        Class,
        COUNT(*) AS Total_Transactions,
        SUM(Amount) AS Total_Amount,
        AVG(Amount) AS Average_Amount,
        MAX(Amount) AS Maximum_Amount,
        MIN(Amount) AS Minimum_Amount
    FROM dbo.creditcard_staging
    GROUP BY Class
)
SELECT
    CASE
        WHEN Class = 0 THEN 'Legitimate'
        WHEN Class = 1 THEN 'Fraud'
        ELSE 'Unknown'
    END AS Transaction_Type,

    Total_Transactions,

    CAST(Total_Amount AS DECIMAL(18,2))
        AS Total_Amount,

    CAST(Average_Amount AS DECIMAL(18,2))
        AS Average_Amount,

    CAST(Maximum_Amount AS DECIMAL(18,2))
        AS Maximum_Amount,

    CAST(Minimum_Amount AS DECIMAL(18,2))
        AS Minimum_Amount

FROM Transaction_Summary
ORDER BY Class;
GO


/*====================================================================
  QUERY 5.2: RANKING OF HIGHEST-VALUE FRAUD TRANSACTIONS

  PURPOSE:
  Identify the 20 highest-value fraudulent transactions.

  SQL CONCEPTS:
  - CTE
  - RANK()
  - ROW_NUMBER()
  - ORDER BY
  - TOP

  BUSINESS QUESTION:
  Which fraudulent transactions have the highest transaction
  amounts in the available dataset?

  NOTE:
  RANK() assigns the same rank to tied amounts.
  ROW_NUMBER() assigns a unique sequential number to each row.
====================================================================*/

WITH Fraud_Ranking AS
(
    SELECT
        Row_ID,
        Time,
        Amount,

        RANK() OVER
        (
            ORDER BY Amount DESC
        ) AS Fraud_Rank,

        ROW_NUMBER() OVER
        (
            ORDER BY Amount DESC, Row_ID
        ) AS Row_Number

    FROM dbo.creditcard_staging
    WHERE Class = 1
)
SELECT TOP 20
    Row_ID,
    Time,
    Amount,
    Fraud_Rank,
    Row_Number
FROM Fraud_Ranking
ORDER BY Fraud_Rank, Row_ID;
GO


/*====================================================================
  QUERY 5.3: RANKING TIME INTERVALS BY FRAUD PERCENTAGE

  PURPOSE:
  Calculate fraud percentage for each six-hour elapsed-time
  interval and rank the intervals from highest to lowest rate.

  SQL CONCEPTS:
  - Multiple CTEs
  - FLOOR()
  - CASE WHEN
  - NULLIF()
  - DENSE_RANK()
  - Window Functions

  BUSINESS QUESTION:
  Which elapsed-time intervals have comparatively higher
  fraud percentages?

  NOTE:
  One interval = 21,600 seconds = 6 hours.
  Time intervals are elapsed-time groups, not clock-time periods.
====================================================================*/

WITH Time_Analysis AS
(
    SELECT
        FLOOR(Time / 21600.0) AS Time_Interval,

        COUNT(*) AS Total_Transactions,

        SUM(CASE
            WHEN Class = 1 THEN 1
            ELSE 0
        END) AS Fraud_Transactions,

        SUM(CASE
            WHEN Class = 0 THEN 1
            ELSE 0
        END) AS Legitimate_Transactions

    FROM dbo.creditcard_staging
    WHERE Time IS NOT NULL
    GROUP BY FLOOR(Time / 21600.0)
),
Fraud_Rate_Analysis AS
(
    SELECT
        Time_Interval,
        Total_Transactions,
        Fraud_Transactions,
        Legitimate_Transactions,

        CAST(
            Fraud_Transactions * 100.0 /
            NULLIF(Total_Transactions, 0)
            AS DECIMAL(10,3)
        ) AS Fraud_Percentage

    FROM Time_Analysis
)
SELECT
    Time_Interval,
    Total_Transactions,
    Fraud_Transactions,
    Legitimate_Transactions,
    Fraud_Percentage,

    DENSE_RANK() OVER
    (
        ORDER BY Fraud_Percentage DESC
    ) AS Fraud_Rank

FROM Fraud_Rate_Analysis
ORDER BY Fraud_Rank, Time_Interval;
GO


/*====================================================================
  QUERY 5.4: CUMULATIVE FRAUD TRANSACTION ANALYSIS

  PURPOSE:
  Calculate the running total of fraudulent transactions
  across six-hour elapsed-time intervals.

  SQL CONCEPTS:
  - CTE
  - SUM() OVER()
  - ORDER BY inside Window Functions
  - ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

  BUSINESS QUESTION:
  How does the cumulative number of fraudulent transactions
  increase across the dataset's elapsed-time intervals?
====================================================================*/

WITH Time_Fraud AS
(
    SELECT
        FLOOR(Time / 21600.0) AS Time_Interval,

        COUNT(*) AS Total_Transactions,

        SUM(CASE
            WHEN Class = 1 THEN 1
            ELSE 0
        END) AS Fraud_Transactions

    FROM dbo.creditcard_staging
    WHERE Time IS NOT NULL
    GROUP BY FLOOR(Time / 21600.0)
)
SELECT
    Time_Interval,
    Total_Transactions,
    Fraud_Transactions,

    SUM(Fraud_Transactions) OVER
    (
        ORDER BY Time_Interval
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS Cumulative_Fraud

FROM Time_Fraud
ORDER BY Time_Interval;
GO


/*====================================================================
  QUERY 5.5: FRAUD TRANSACTION AMOUNT QUARTILE ANALYSIS

  PURPOSE:
  Divide fraudulent transactions into four approximately
  equal-sized groups according to transaction amount.

  SQL CONCEPTS:
  - CTE
  - NTILE(4)
  - GROUP BY
  - MIN(), MAX(), AVG(), COUNT()

  BUSINESS QUESTION:
  How are fraudulent transactions distributed across
  four transaction-amount groups?

  NOTE:
  Quartile 1 contains the lower amounts.
  Quartile 4 contains the higher amounts.
  Groups may differ slightly in size.
====================================================================*/

WITH Fraud_Quartiles AS
(
    SELECT
        Row_ID,
        Amount,

        NTILE(4) OVER
        (
            ORDER BY Amount, Row_ID
        ) AS Amount_Quartile

    FROM dbo.creditcard_staging
    WHERE Class = 1
)
SELECT
    Amount_Quartile,

    COUNT(*) AS Total_Fraud_Transactions,

    CAST(MIN(Amount) AS DECIMAL(18,2))
        AS Minimum_Amount,

    CAST(MAX(Amount) AS DECIMAL(18,2))
        AS Maximum_Amount,

    CAST(AVG(Amount) AS DECIMAL(18,2))
        AS Average_Amount

FROM Fraud_Quartiles
GROUP BY Amount_Quartile
ORDER BY Amount_Quartile;
GO


/*====================================================================
  QUERY 5.6: FRAUD RATE COMPARISON BY DUPLICATE STATUS

  PURPOSE:
  Compare fraud and legitimate transaction counts between
  original/first-occurrence records and flagged duplicate records.

  SQL CONCEPTS:
  - CASE WHEN
  - Conditional Aggregation
  - GROUP BY
  - NULLIF()
  - Percentage Calculation

  BUSINESS QUESTION:
  Is the fraud percentage different between flagged duplicate
  records and original/first-occurrence records?

  NOTE:
  Duplicate status does not automatically indicate fraud.
  This analysis is for comparison, not a fraud classification rule.
====================================================================*/

SELECT
    CASE
        WHEN Is_Duplicate = 0
            THEN 'Original / First Occurrence'

        WHEN Is_Duplicate = 1
            THEN 'Flagged Duplicate'

        ELSE 'Unknown'
    END AS Record_Type,

    COUNT(*) AS Total_Transactions,

    SUM(CASE
        WHEN Class = 1 THEN 1
        ELSE 0
    END) AS Fraud_Transactions,

    SUM(CASE
        WHEN Class = 0 THEN 1
        ELSE 0
    END) AS Legitimate_Transactions,

    CAST(
        SUM(CASE
            WHEN Class = 1 THEN 1
            ELSE 0
        END) * 100.0 / NULLIF(COUNT(*), 0)
        AS DECIMAL(10,3)
    ) AS Fraud_Percentage

FROM dbo.creditcard_staging
GROUP BY Is_Duplicate
ORDER BY Is_Duplicate;
GO


/*====================================================================
  END OF STAGE 05 - ADVANCED SQL ANALYSIS

  VALIDATION:
  - All six analytical queries should execute successfully.
  - No data should be deleted or modified.
  - Fraud and legitimate transaction counts should be checked
    against the previous stage's results.
====================================================================*/

/*====================================================================
  PROJECT  : CREDIT CARD FRAUD DETECTION ANALYSIS
  DATABASE : Credit_Card_Fraud_Analysis_DB
  TABLE    : dbo.creditcard_staging
  STAGE    : 06 - BUSINESS INSIGHTS & RECOMMENDATIONS

  OBJECTIVE:
  Convert analytical results into meaningful business insights
  to understand fraud exposure, transaction patterns and
  potential areas requiring additional monitoring.

  BUSINESS ANALYSIS:
  6.1 Overall Fraud Performance Summary
  6.2 Fraud Analysis by Transaction Amount Range
  6.3 Fraud Risk Comparison Across Time Intervals
  6.4 Fraud Amount Concentration Analysis
  6.5 Fraud Transactions Above Average Transaction Amount
  6.6 Fraud Exposure by Duplicate Record Status

  IMPORTANT:
  - Class = 0: Legitimate transaction
  - Class = 1: Fraud transaction
  - Time is elapsed seconds, not actual clock time.
  - Duplicate records are flagged, not deleted.
  - This is descriptive analysis, not predictive modelling.
====================================================================*/

USE Credit_Card_Fraud_Analysis_DB;
GO


/*====================================================================
  QUERY 6.1: OVERALL FRAUD PERFORMANCE SUMMARY

  PURPOSE:
  Calculate important business KPIs such as total transactions,
  fraud count, fraud rate, total fraud amount and average amounts.

  BUSINESS QUESTION:
  What is the overall scale of fraud in this dataset?

  BUSINESS USE:
  Provides an executive-level summary of fraud exposure.
====================================================================*/

SELECT
    COUNT(*) AS Total_Transactions,

    SUM(CASE
        WHEN Class = 0 THEN 1 ELSE 0
    END) AS Legitimate_Transactions,

    SUM(CASE
        WHEN Class = 1 THEN 1 ELSE 0
    END) AS Fraud_Transactions,

    CAST(
        SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END)
        * 100.0 / NULLIF(COUNT(*), 0)
        AS DECIMAL(10,3)
    ) AS Fraud_Percentage,

    CAST(
        SUM(CASE WHEN Class = 1 THEN Amount ELSE 0 END)
        AS DECIMAL(18,2)
    ) AS Total_Fraud_Amount,

    CAST(
        AVG(CASE WHEN Class = 1 THEN Amount END)
        AS DECIMAL(18,2)
    ) AS Average_Fraud_Amount,

    CAST(
        AVG(CASE WHEN Class = 0 THEN Amount END)
        AS DECIMAL(18,2)
    ) AS Average_Legitimate_Amount

FROM dbo.creditcard_staging
WHERE Class IN (0,1);
GO


/*====================================================================
  QUERY 6.2: FRAUD ANALYSIS BY TRANSACTION AMOUNT RANGE

  PURPOSE:
  Compare transaction volume, fraud count, fraud percentage
  and fraud amount across different transaction amount ranges.

  BUSINESS QUESTION:
  Which transaction amount ranges have comparatively higher
  fraud rates and fraud exposure?

  BUSINESS USE:
  Helps identify amount segments that may deserve closer
  monitoring, while considering the number of transactions.
====================================================================*/

WITH Amount_Range_Analysis AS
(
    SELECT
        CASE
            WHEN Amount IS NULL THEN 'Missing Amount'
            WHEN Amount < 0 THEN 'Negative'
            WHEN Amount = 0 THEN 'Zero'
            WHEN Amount <= 25 THEN '0.01 - 25'
            WHEN Amount <= 50 THEN '25.01 - 50'
            WHEN Amount <= 100 THEN '50.01 - 100'
            WHEN Amount <= 250 THEN '100.01 - 250'
            WHEN Amount <= 500 THEN '250.01 - 500'
            ELSE 'Above 500'
        END AS Amount_Range,

        CASE
            WHEN Amount IS NULL THEN 9
            WHEN Amount < 0 THEN 1
            WHEN Amount = 0 THEN 2
            WHEN Amount <= 25 THEN 3
            WHEN Amount <= 50 THEN 4
            WHEN Amount <= 100 THEN 5
            WHEN Amount <= 250 THEN 6
            WHEN Amount <= 500 THEN 7
            ELSE 8
        END AS Sort_Order,

        Class,
        Amount

    FROM dbo.creditcard_staging
    WHERE Class IN (0,1)
)
SELECT
    Amount_Range,

    COUNT(*) AS Total_Transactions,

    SUM(CASE
        WHEN Class = 1 THEN 1 ELSE 0
    END) AS Fraud_Transactions,

    SUM(CASE
        WHEN Class = 0 THEN 1 ELSE 0
    END) AS Legitimate_Transactions,

    CAST(
        SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END)
        * 100.0 / NULLIF(COUNT(*),0)
        AS DECIMAL(10,3)
    ) AS Fraud_Percentage,

    CAST(
        SUM(CASE WHEN Class = 1 THEN Amount ELSE 0 END)
        AS DECIMAL(18,2)
    ) AS Fraud_Amount

FROM Amount_Range_Analysis
GROUP BY Amount_Range, Sort_Order
ORDER BY Sort_Order;
GO


/*====================================================================
  QUERY 6.3: FRAUD RISK COMPARISON ACROSS TIME INTERVALS

  PURPOSE:
  Calculate fraud percentage and fraud transaction count
  for each six-hour elapsed-time interval.

  BUSINESS QUESTION:
  Which elapsed-time intervals show relatively higher
  fraud percentages?

  BUSINESS USE:
  Helps identify time segments for further investigation.

  NOTE:
  These intervals are based on elapsed seconds from the first
  transaction. They must not be interpreted as clock-time hours.
====================================================================*/

WITH Time_Analysis AS
(
    SELECT
        FLOOR(Time / 21600.0) AS Time_Interval,

        COUNT(*) AS Total_Transactions,

        SUM(CASE
            WHEN Class = 1 THEN 1 ELSE 0
        END) AS Fraud_Transactions,

        SUM(CASE
            WHEN Class = 0 THEN 1 ELSE 0
        END) AS Legitimate_Transactions

    FROM dbo.creditcard_staging
    WHERE Time IS NOT NULL
      AND Class IN (0,1)

    GROUP BY FLOOR(Time / 21600.0)
),
Fraud_Rate AS
(
    SELECT
        Time_Interval,
        Total_Transactions,
        Fraud_Transactions,
        Legitimate_Transactions,

        CAST(
            Fraud_Transactions * 100.0 /
            NULLIF(Total_Transactions,0)
            AS DECIMAL(10,3)
        ) AS Fraud_Percentage

    FROM Time_Analysis
)
SELECT
    Time_Interval,
    Total_Transactions,
    Fraud_Transactions,
    Legitimate_Transactions,
    Fraud_Percentage,

    DENSE_RANK() OVER
    (
        ORDER BY Fraud_Percentage DESC
    ) AS Fraud_Rank

FROM Fraud_Rate
ORDER BY Fraud_Rank, Time_Interval;
GO


/*====================================================================
  QUERY 6.4: FRAUD AMOUNT CONCENTRATION ANALYSIS

  PURPOSE:
  Divide fraud transactions into ten groups based on
  transaction amount, starting from the highest amount.

  BUSINESS QUESTION:
  How much of the total fraud amount is contributed by
  the highest-value fraud transaction groups?

  BUSINESS USE:
  Helps understand whether a relatively small group of
  high-value fraud transactions contributes a large share
  of the total fraudulent transaction amount.

  NOTE:
  NTILE(10) creates approximately equal-sized groups.
  Group 1 contains the highest transaction amounts.
====================================================================*/

WITH Fraud_Amount_Groups AS
(
    SELECT
        Row_ID,
        Amount,

        NTILE(10) OVER
        (
            ORDER BY Amount DESC, Row_ID
        ) AS Amount_Group

    FROM dbo.creditcard_staging
    WHERE Class = 1
      AND Amount IS NOT NULL
),
Group_Summary AS
(
    SELECT
        Amount_Group,

        COUNT(*) AS Fraud_Transactions,

        SUM(Amount) AS Fraud_Amount,

        AVG(Amount) AS Average_Fraud_Amount

    FROM Fraud_Amount_Groups
    GROUP BY Amount_Group
)
SELECT
    Amount_Group,
    Fraud_Transactions,

    CAST(Fraud_Amount AS DECIMAL(18,2))
        AS Fraud_Amount,

    CAST(Average_Fraud_Amount AS DECIMAL(18,2))
        AS Average_Fraud_Amount,

    CAST(
        Fraud_Amount * 100.0 /
        NULLIF(SUM(Fraud_Amount) OVER (),0)
        AS DECIMAL(10,3)
    ) AS Percentage_Of_Total_Fraud_Amount

FROM Group_Summary
ORDER BY Amount_Group;
GO


/*====================================================================
  QUERY 6.5: FRAUD TRANSACTIONS ABOVE OVERALL AVERAGE AMOUNT

  PURPOSE:
  Identify fraudulent transactions whose amounts are greater
  than the average transaction amount across the entire dataset.

  BUSINESS QUESTION:
  How many fraud transactions exceed the overall average
  transaction amount, and what is their total amount?

  BUSINESS USE:
  Helps assess the contribution of above-average transactions
  to total fraud exposure.

  NOTE:
  The threshold is calculated using all transactions,
  not only fraudulent transactions.
====================================================================*/

WITH Overall_Average AS
(
    SELECT
        AVG(Amount) AS Average_Transaction_Amount
    FROM dbo.creditcard_staging
    WHERE Amount IS NOT NULL
),
Fraud_Above_Average AS
(
    SELECT
        S.Row_ID,
        S.Amount,
        A.Average_Transaction_Amount

    FROM dbo.creditcard_staging AS S
    CROSS JOIN Overall_Average AS A

    WHERE S.Class = 1
      AND S.Amount > A.Average_Transaction_Amount
)
SELECT
    CAST(
        MAX(Average_Transaction_Amount)
        AS DECIMAL(18,2)
    ) AS Overall_Average_Amount,

    COUNT(*) AS Fraud_Transactions_Above_Average,

    CAST(
        COUNT(*) * 100.0 /
        NULLIF(
            (SELECT COUNT(*)
             FROM dbo.creditcard_staging
             WHERE Class = 1), 0
        )
        AS DECIMAL(10,3)
    ) AS Percentage_Of_Fraud_Transactions,

    CAST(SUM(Amount) AS DECIMAL(18,2))
        AS Total_Fraud_Amount_Above_Average,

    CAST(AVG(Amount) AS DECIMAL(18,2))
        AS Average_Amount_Of_These_Fraud_Transactions

FROM Fraud_Above_Average;
GO


/*====================================================================
  QUERY 6.6: FRAUD EXPOSURE BY DUPLICATE RECORD STATUS

  PURPOSE:
  Compare transaction counts, fraud counts and fraud amounts
  between original/first-occurrence and flagged duplicate rows.

  BUSINESS QUESTION:
  How much fraud exposure is present in flagged duplicate
  records compared with original/first-occurrence records?

  BUSINESS USE:
  Helps determine whether flagged duplicate records deserve
  additional data-quality investigation.

  NOTE:
  Duplicate records are not automatically fraudulent.
  This query does not recommend deleting duplicate records.
====================================================================*/

SELECT
    CASE
        WHEN Is_Duplicate = 0
            THEN 'Original / First Occurrence'
        WHEN Is_Duplicate = 1
            THEN 'Flagged Duplicate'
        ELSE 'Unknown'
    END AS Record_Type,

    COUNT(*) AS Total_Transactions,

    SUM(CASE
        WHEN Class = 1 THEN 1 ELSE 0
    END) AS Fraud_Transactions,

    SUM(CASE
        WHEN Class = 0 THEN 1 ELSE 0
    END) AS Legitimate_Transactions,

    CAST(
        SUM(CASE
            WHEN Class = 1 THEN Amount ELSE 0
        END)
        AS DECIMAL(18,2)
    ) AS Total_Fraud_Amount,

    CAST(
        SUM(CASE
            WHEN Class = 1 THEN 1 ELSE 0
        END) * 100.0 / NULLIF(COUNT(*),0)
        AS DECIMAL(10,3)
    ) AS Fraud_Percentage

FROM dbo.creditcard_staging
GROUP BY Is_Duplicate
ORDER BY Is_Duplicate;
GO


/*====================================================================
  END OF STAGE 06 - BUSINESS INSIGHTS & RECOMMENDATIONS

  VALIDATION:
  - All six queries should execute successfully.
  - Total counts should be reconciled with previous stages.
  - No staging records should be modified or deleted.
  - Findings must be interpreted using counts and percentages.
  - Correlation or association must not be presented as causation.
====================================================================*/

/*====================================================================
  PROJECT  : CREDIT CARD FRAUD DETECTION ANALYSIS
  DATABASE : Credit_Card_Fraud_Analysis_DB
  TABLE    : dbo.creditcard_staging
  STAGE    : 07 - SQL DEVELOPMENT & PERFORMANCE OPTIMIZATION

  OBJECTIVE:
  Create reusable SQL database objects and improve analytical
  query performance through views, stored procedures and indexes.

  PARTS:
  7.1 Create Analytical Views
  7.2 Create Stored Procedures
  7.3 Execute Baseline Performance Queries
  7.4 Create Nonclustered Indexes
  7.5 Execute Optimized Queries
  7.6 Validate Database Objects and Indexes

  IMPORTANT:
  - No transaction records are deleted or updated.
  - All objects are created on dbo.creditcard_staging.
  - Indexes improve data access for selected query patterns.
  - Actual performance improvement depends on the execution plan
    and SQL Server's cost estimates.
====================================================================*/

USE Credit_Card_Fraud_Analysis_DB;
GO


/*====================================================================
  PART 7.1: CREATE ANALYTICAL VIEWS

  PURPOSE:
  Views store reusable SELECT definitions.
  They help users access frequently required analytical results
  without rewriting the complete query every time.

  VIEWS:
  1. v_Fraud_Overall_Summary
  2. v_Fraud_Amount_Range
  3. v_Fraud_Time_Interval
  4. v_Fraud_Duplicate_Status
====================================================================*/


/*-------------------- VIEW 7.1.1: OVERALL FRAUD SUMMARY --------------------

  PURPOSE:
  Provide overall transaction KPIs, including fraud count,
  legitimate count, fraud percentage and total fraud amount.
-------------------------------------------------------------------------*/

IF OBJECT_ID('dbo.v_Fraud_Overall_Summary', 'V') IS NOT NULL
    DROP VIEW dbo.v_Fraud_Overall_Summary;
GO

CREATE VIEW dbo.v_Fraud_Overall_Summary
AS
SELECT
    COUNT(*) AS Total_Transactions,

    SUM(CASE
        WHEN Class = 0 THEN 1 ELSE 0
    END) AS Legitimate_Transactions,

    SUM(CASE
        WHEN Class = 1 THEN 1 ELSE 0
    END) AS Fraud_Transactions,

    CAST(
        SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END)
        * 100.0 / NULLIF(COUNT(*),0)
        AS DECIMAL(10,3)
    ) AS Fraud_Percentage,

    CAST(
        SUM(CASE WHEN Class = 1 THEN Amount ELSE 0 END)
        AS DECIMAL(18,2)
    ) AS Total_Fraud_Amount

FROM dbo.creditcard_staging
WHERE Class IN (0,1);
GO


/*-------------------- VIEW 7.1.2: FRAUD BY AMOUNT RANGE -------------------

  PURPOSE:
  Summarize fraud transactions across transaction amount ranges.
-------------------------------------------------------------------------*/

IF OBJECT_ID('dbo.v_Fraud_Amount_Range', 'V') IS NOT NULL
    DROP VIEW dbo.v_Fraud_Amount_Range;
GO

CREATE VIEW dbo.v_Fraud_Amount_Range
AS
SELECT
    CASE
        WHEN Amount IS NULL THEN 'Missing Amount'
        WHEN Amount < 0 THEN 'Negative'
        WHEN Amount = 0 THEN 'Zero'
        WHEN Amount <= 25 THEN '0.01 - 25'
        WHEN Amount <= 50 THEN '25.01 - 50'
        WHEN Amount <= 100 THEN '50.01 - 100'
        WHEN Amount <= 250 THEN '100.01 - 250'
        WHEN Amount <= 500 THEN '250.01 - 500'
        ELSE 'Above 500'
    END AS Amount_Range,

    COUNT(*) AS Total_Transactions,

    SUM(CASE
        WHEN Class = 1 THEN 1 ELSE 0
    END) AS Fraud_Transactions,

    CAST(
        SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END)
        * 100.0 / NULLIF(COUNT(*),0)
        AS DECIMAL(10,3)
    ) AS Fraud_Percentage,

    CAST(
        SUM(CASE WHEN Class = 1 THEN Amount ELSE 0 END)
        AS DECIMAL(18,2)
    ) AS Fraud_Amount

FROM dbo.creditcard_staging
WHERE Class IN (0,1)
GROUP BY
    CASE
        WHEN Amount IS NULL THEN 'Missing Amount'
        WHEN Amount < 0 THEN 'Negative'
        WHEN Amount = 0 THEN 'Zero'
        WHEN Amount <= 25 THEN '0.01 - 25'
        WHEN Amount <= 50 THEN '25.01 - 50'
        WHEN Amount <= 100 THEN '50.01 - 100'
        WHEN Amount <= 250 THEN '100.01 - 250'
        WHEN Amount <= 500 THEN '250.01 - 500'
        ELSE 'Above 500'
    END;
GO


/*-------------------- VIEW 7.1.3: FRAUD BY TIME INTERVAL ------------------

  PURPOSE:
  Show fraud and legitimate transaction counts across
  six-hour elapsed-time intervals.
-------------------------------------------------------------------------*/

IF OBJECT_ID('dbo.v_Fraud_Time_Interval', 'V') IS NOT NULL
    DROP VIEW dbo.v_Fraud_Time_Interval;
GO

CREATE VIEW dbo.v_Fraud_Time_Interval
AS
SELECT
    FLOOR(Time / 21600.0) AS Time_Interval,

    COUNT(*) AS Total_Transactions,

    SUM(CASE
        WHEN Class = 1 THEN 1 ELSE 0
    END) AS Fraud_Transactions,

    SUM(CASE
        WHEN Class = 0 THEN 1 ELSE 0
    END) AS Legitimate_Transactions,

    CAST(
        SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END)
        * 100.0 / NULLIF(COUNT(*),0)
        AS DECIMAL(10,3)
    ) AS Fraud_Percentage

FROM dbo.creditcard_staging
WHERE Time IS NOT NULL
  AND Class IN (0,1)
GROUP BY FLOOR(Time / 21600.0);
GO


/*-------------------- VIEW 7.1.4: FRAUD BY DUPLICATE STATUS ---------------

  PURPOSE:
  Compare original/first-occurrence records and flagged duplicates.
-------------------------------------------------------------------------*/

IF OBJECT_ID('dbo.v_Fraud_Duplicate_Status', 'V') IS NOT NULL
    DROP VIEW dbo.v_Fraud_Duplicate_Status;
GO

CREATE VIEW dbo.v_Fraud_Duplicate_Status
AS
SELECT
    Is_Duplicate,

    COUNT(*) AS Total_Transactions,

    SUM(CASE
        WHEN Class = 1 THEN 1 ELSE 0
    END) AS Fraud_Transactions,

    SUM(CASE
        WHEN Class = 0 THEN 1 ELSE 0
    END) AS Legitimate_Transactions,

    CAST(
        SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END)
        * 100.0 / NULLIF(COUNT(*),0)
        AS DECIMAL(10,3)
    ) AS Fraud_Percentage

FROM dbo.creditcard_staging
GROUP BY Is_Duplicate;
GO


/*====================================================================
  PART 7.1 VALIDATION: EXECUTE ALL FOUR VIEWS

  PURPOSE:
  Verify that all analytical views return expected results.
====================================================================*/

SELECT * FROM dbo.v_Fraud_Overall_Summary;
GO

SELECT * FROM dbo.v_Fraud_Amount_Range;
GO

SELECT * FROM dbo.v_Fraud_Time_Interval
ORDER BY Time_Interval;
GO

SELECT * FROM dbo.v_Fraud_Duplicate_Status;
GO


/*====================================================================
  PART 7.2: CREATE STORED PROCEDURES

  PURPOSE:
  Stored procedures save reusable SQL logic inside the database.
  They can accept parameters and return results when executed.

  PROCEDURES:
  1. usp_Get_Fraud_Summary
  2. usp_Get_High_Value_Fraud
====================================================================*/


/*-------------------- PROCEDURE 7.2.1: FRAUD SUMMARY ---------------------

  PURPOSE:
  Return overall fraud and legitimate transaction statistics.

  BUSINESS USE:
  Generate a reusable fraud summary whenever required.
-------------------------------------------------------------------------*/

IF OBJECT_ID('dbo.usp_Get_Fraud_Summary', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_Get_Fraud_Summary;
GO

CREATE PROCEDURE dbo.usp_Get_Fraud_Summary
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        COUNT(*) AS Total_Transactions,

        SUM(CASE
            WHEN Class = 0 THEN 1 ELSE 0
        END) AS Legitimate_Transactions,

        SUM(CASE
            WHEN Class = 1 THEN 1 ELSE 0
        END) AS Fraud_Transactions,

        CAST(
            SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END)
            * 100.0 / NULLIF(COUNT(*),0)
            AS DECIMAL(10,3)
        ) AS Fraud_Percentage,

        CAST(
            SUM(CASE WHEN Class = 1 THEN Amount ELSE 0 END)
            AS DECIMAL(18,2)
        ) AS Total_Fraud_Amount

    FROM dbo.creditcard_staging
    WHERE Class IN (0,1);
END;
GO


/*-------------------- PROCEDURE 7.2.2: HIGH-VALUE FRAUD -------------------

  PURPOSE:
  Return fraud transactions above a user-defined minimum amount.

  PARAMETERS:
  @MinimumAmount = Minimum transaction amount.
  @TopN          = Maximum number of records to return.

  BUSINESS USE:
  Investigate high-value fraudulent transactions.
-------------------------------------------------------------------------*/

IF OBJECT_ID('dbo.usp_Get_High_Value_Fraud', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_Get_High_Value_Fraud;
GO

CREATE PROCEDURE dbo.usp_Get_High_Value_Fraud
    @MinimumAmount DECIMAL(18,2) = 500,
    @TopN INT = 20
AS
BEGIN
    SET NOCOUNT ON;

    IF @MinimumAmount < 0 OR @TopN <= 0
    BEGIN
        THROW 50001,
              'Minimum amount must be non-negative and TopN must be positive.',
              1;
    END;

    SELECT TOP (@TopN)
        Row_ID,
        Time,
        Amount,
        Class,
        Is_Duplicate

    FROM dbo.creditcard_staging

    WHERE Class = 1
      AND Amount >= @MinimumAmount

    ORDER BY Amount DESC, Row_ID;
END;
GO


/*====================================================================
  PART 7.2 VALIDATION: EXECUTE STORED PROCEDURES

  PURPOSE:
  Verify that both procedures return the expected results.
====================================================================*/

EXEC dbo.usp_Get_Fraud_Summary;
GO

EXEC dbo.usp_Get_High_Value_Fraud;
GO

-- Example: Find up to 10 fraud transactions with amount >= 1000.
EXEC dbo.usp_Get_High_Value_Fraud
    @MinimumAmount = 1000,
    @TopN = 10;
GO


/*====================================================================
  PART 7.3: BASELINE QUERY PERFORMANCE

  PURPOSE:
  Execute representative queries before creating the new indexes.

  INSTRUCTIONS:
  1. In SSMS, enable Include Actual Execution Plan using Ctrl + M.
  2. Execute these queries.
  3. Save the execution plan screenshot.
  4. We will repeat the same queries after index creation.

  NOTE:
  The execution plan is SQL Server's chosen execution strategy.
====================================================================*/

-- Baseline Query A: Fraud transaction filtering.
SELECT
    Row_ID,
    Time,
    Amount,
    Is_Duplicate
FROM dbo.creditcard_staging
WHERE Class = 1
ORDER BY Amount DESC, Row_ID;
GO

-- Baseline Query B: Time-based transaction aggregation.
SELECT
    FLOOR(Time / 21600.0) AS Time_Interval,
    COUNT(*) AS Total_Transactions,
    SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END)
        AS Fraud_Transactions
FROM dbo.creditcard_staging
WHERE Time IS NOT NULL
GROUP BY FLOOR(Time / 21600.0);
GO


/*====================================================================
  PART 7.4: CREATE NONCLUSTERED INDEXES

  PURPOSE:
  Create indexes to support fraud filtering and time-based analysis.

  INDEX 1:
  IX_creditcard_staging_Class
  Supports filtering by Class and retrieving fraud-related columns.

  INDEX 2:
  IX_creditcard_staging_Time
  Supports time-based filtering and aggregation.

  IMPORTANT:
  Indexes consume storage and add overhead to future data changes.
  We create these indexes for the analytical query patterns used
  in this project, not as a claim that every query will be faster.
====================================================================*/


/*-------------------- INDEX 7.4.1: CLASS INDEX ----------------------------*/

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_creditcard_staging_Class'
      AND object_id = OBJECT_ID('dbo.creditcard_staging')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_creditcard_staging_Class
    ON dbo.creditcard_staging (Class)
    INCLUDE (Amount, Time, Is_Duplicate, Row_ID);
END;
GO


/*-------------------- INDEX 7.4.2: TIME INDEX -----------------------------*/

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_creditcard_staging_Time'
      AND object_id = OBJECT_ID('dbo.creditcard_staging')
)
BEGIN
    CREATE NONCLUSTERED INDEX IX_creditcard_staging_Time
    ON dbo.creditcard_staging (Time)
    INCLUDE (Class, Amount);
END;
GO


/*====================================================================
  PART 7.5: OPTIMIZED QUERY PERFORMANCE

  PURPOSE:
  Execute the same queries again after index creation.

  INSTRUCTIONS:
  Keep Include Actual Execution Plan enabled (Ctrl + M).
  Compare the new plans with the baseline plans from Part 7.3.

  LOOK FOR:
  - Index Seek or Index Scan
  - Table Scan
  - Estimated and actual row counts
  - Relative operator costs

  NOTE:
  An Index Scan is not automatically bad. SQL Server may choose
  a scan when it is cheaper for a query returning many rows.
====================================================================*/

-- Optimized Query A: Repeat the fraud filtering query.
SELECT
    Row_ID,
    Time,
    Amount,
    Is_Duplicate
FROM dbo.creditcard_staging
WHERE Class = 1
ORDER BY Amount DESC, Row_ID;
GO

-- Optimized Query B: Repeat the time aggregation query.
SELECT
    FLOOR(Time / 21600.0) AS Time_Interval,
    COUNT(*) AS Total_Transactions,
    SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END)
        AS Fraud_Transactions
FROM dbo.creditcard_staging
WHERE Time IS NOT NULL
GROUP BY FLOOR(Time / 21600.0);
GO


/*====================================================================
  PART 7.6: FINAL DATABASE OBJECT AND INDEX VALIDATION

  PURPOSE:
  Verify that the views, stored procedures and indexes exist
  in the current database.
====================================================================*/

-- Verify created views and stored procedures.
SELECT
    name AS Object_Name,
    type_desc AS Object_Type
FROM sys.objects
WHERE name IN
(
    'v_Fraud_Overall_Summary',
    'v_Fraud_Amount_Range',
    'v_Fraud_Time_Interval',
    'v_Fraud_Duplicate_Status',
    'usp_Get_Fraud_Summary',
    'usp_Get_High_Value_Fraud'
)
ORDER BY type_desc, name;
GO

-- Verify indexes created on the staging table.
SELECT
    name AS Index_Name,
    type_desc AS Index_Type,
    is_unique AS Is_Unique
FROM sys.indexes
WHERE object_id = OBJECT_ID('dbo.creditcard_staging')
  AND name IN
(
    'IX_creditcard_staging_Class',
    'IX_creditcard_staging_Time'
)
ORDER BY name;
GO

-- Final staging table record count validation.
SELECT
    COUNT(*) AS Total_Staging_Records
FROM dbo.creditcard_staging;
GO


/*====================================================================
  END OF STAGE 07

  EXPECTED:
  - Four analytical views created.
  - Two stored procedures created and executed.
  - Two nonclustered indexes created.
  - Baseline and optimized execution plans captured.
  - Staging record count remains unchanged.

  NEXT:
  STAGE 08 - GITHUB DOCUMENTATION AND PROJECT FINALIZATION.
====================================================================*/
