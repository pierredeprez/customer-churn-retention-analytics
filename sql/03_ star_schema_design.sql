/*=============================================================================
03: PRODUCTION SCHEMA — STAR MODEL DEFINITION
Purpose: Establish optimized primary constraints and analytics performance indexes.
=============================================================================*/

USE customer_churn_retention_analytics;
GO

-- DIMENSION: CUSTOMER DEMOGRAPHICS
IF OBJECT_ID('dbo.dim_customer', 'U') IS NOT NULL 
    DROP TABLE dbo.dim_customer;

CREATE TABLE dbo.dim_customer (
    customerID     VARCHAR(50) NOT NULL,
    gender         VARCHAR(10),
    SeniorCitizen  INT,
    Partner        VARCHAR(10),
    Dependents     VARCHAR(10),
    CONSTRAINT PK_dim_customer PRIMARY KEY CLUSTERED (customerID)
);

-- FACT: ENRICHED SUBSCRIPTION & RISK DATA
IF OBJECT_ID('dbo.fact_subscription', 'U') IS NOT NULL 
    DROP TABLE dbo.fact_subscription;

CREATE TABLE dbo.fact_subscription (
    customerID         VARCHAR(50) NOT NULL,
    tenure             INT,
    PhoneService       VARCHAR(10),
    MultipleLines      VARCHAR(30),
    InternetService    VARCHAR(30),
    OnlineSecurity     VARCHAR(30),
    OnlineBackup       VARCHAR(30),
    DeviceProtection   VARCHAR(30),
    TechSupport        VARCHAR(30),
    StreamingTV        VARCHAR(30),
    StreamingMovies    VARCHAR(30),
    Contract           VARCHAR(30),
    PaperlessBilling   VARCHAR(10),
    PaymentMethod      VARCHAR(100),
    MonthlyCharges     DECIMAL(12,2),
    TotalCharges       DECIMAL(12,2),
    Churn              VARCHAR(10),
    tenure_group       VARCHAR(30),
    Churn_Probability  DECIMAL(10,4),
    lifecycle_stage    VARCHAR(30),
    risk_signal_count  INT,
    Risk_Level         VARCHAR(30),
    CONSTRAINT PK_fact_subscription PRIMARY KEY CLUSTERED (customerID)
);

-- FACT: CUSTOMER FEEDBACK
IF OBJECT_ID('dbo.fact_feedback', 'U') IS NOT NULL 
    DROP TABLE dbo.fact_feedback;

CREATE TABLE dbo.fact_feedback (
    Ticket              VARCHAR(100),
    Customer_Complaint  VARCHAR(MAX),
    Date                VARCHAR(100),
    Received_Via        VARCHAR(100),
    City                VARCHAR(100),
    State               VARCHAR(100),
    Status              VARCHAR(100),
    Clean_Complaint     VARCHAR(MAX),
    Clean_Date          DATE
);
GO

-- INDEX OPTIMIZATION: Accelerate performance on visualization slices
CREATE NONCLUSTERED INDEX IX_fact_subscription_Lifecycle ON dbo.fact_subscription (lifecycle_stage);
CREATE NONCLUSTERED INDEX IX_fact_subscription_Risk      ON dbo.fact_subscription (Risk_Level);
GO