/*=============================================================================
04: TRANSFORMATION — ETL PROCESS ENGINES
Purpose: Safely parse numbers, apply date-normalization, and populate core facts.
=============================================================================*/

USE customer_churn_retention_analytics;
GO

-- 1. SUBSCRIPTION FACT PIPELINE
TRUNCATE TABLE dbo.fact_subscription;

INSERT INTO dbo.fact_subscription (
    customerID, tenure, PhoneService, MultipleLines, InternetService, 
    OnlineSecurity, OnlineBackup, DeviceProtection, TechSupport, 
    StreamingTV, StreamingMovies, Contract, PaperlessBilling, 
    PaymentMethod, MonthlyCharges, TotalCharges, Churn, 
    tenure_group, Churn_Probability, lifecycle_stage, 
    risk_signal_count, Risk_Level
)
SELECT 
    customerID,
    TRY_CAST(tenure AS INT),
    PhoneService,
    MultipleLines,
    InternetService,
    OnlineSecurity,
    OnlineBackup,
    DeviceProtection,
    TechSupport,
    StreamingTV,
    StreamingMovies,
    Contract,
    PaperlessBilling,
    PaymentMethod,
    ISNULL(TRY_PARSE(MonthlyCharges AS DECIMAL(12,2) USING 'en-US'), 0),
    ISNULL(TRY_PARSE(TotalCharges AS DECIMAL(12,2) USING 'en-US'), 0),
    Churn,
    tenure_group,
    ISNULL(TRY_PARSE(Churn_Probability AS DECIMAL(10,4) USING 'en-US'), 0),
    lifecycle_stage,
    TRY_CAST(risk_signal_count AS INT),
    Risk_Level
FROM dbo.stg_subscription;
GO

-- 2. UNSTRUCTURED FEEDBACK CLEANING PIPELINE
UPDATE dbo.fact_feedback
SET 
    Date               = LTRIM(RTRIM(Date)),
    Customer_Complaint = LTRIM(RTRIM(Customer_Complaint)),
    Clean_Date         = TRY_CAST(LTRIM(RTRIM(Date)) AS DATE);
GO