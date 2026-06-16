/*=============================================================================
02: STAGING LAYER — RAW INGEST SAFETY
Purpose: Safeguard pipeline from breaking on unexpected format or character errors.
=============================================================================*/

USE customer_churn_retention_analytics;
GO

IF OBJECT_ID('dbo.stg_subscription', 'U') IS NOT NULL 
    DROP TABLE dbo.stg_subscription;

CREATE TABLE dbo.stg_subscription (
    customerID         VARCHAR(MAX),
    tenure             VARCHAR(MAX),
    PhoneService       VARCHAR(MAX),
    MultipleLines      VARCHAR(MAX),
    InternetService    VARCHAR(MAX),
    OnlineSecurity     VARCHAR(MAX),
    OnlineBackup       VARCHAR(MAX),
    DeviceProtection   VARCHAR(MAX),
    TechSupport        VARCHAR(MAX),
    StreamingTV        VARCHAR(MAX),
    StreamingMovies    VARCHAR(MAX),
    Contract           VARCHAR(MAX),
    PaperlessBilling   VARCHAR(MAX),
    PaymentMethod      VARCHAR(MAX),
    MonthlyCharges     VARCHAR(MAX),
    TotalCharges       VARCHAR(MAX),
    Churn              VARCHAR(MAX),
    tenure_group       VARCHAR(MAX),
    Churn_Probability  VARCHAR(MAX),
    lifecycle_stage    VARCHAR(MAX),
    risk_signal_count  VARCHAR(MAX),
    Risk_Level         VARCHAR(MAX)
);
GO