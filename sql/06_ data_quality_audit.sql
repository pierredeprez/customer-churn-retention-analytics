/*=============================================================================
06: DATA INTEGRITY AUDIT & SEGMENT VALIDATION
Purpose: Perform row checking, cross-join integrity reviews, and base health metrics.
=============================================================================*/

USE customer_churn_retention_analytics;
GO

-- 1. PIPELINE RECORD-COUNT RECONCILIATION
SELECT 'Subscriptions' AS Table_Name, COUNT(*) AS Row_Count FROM dbo.fact_subscription
UNION ALL
SELECT 'Customers',     COUNT(*) FROM dbo.dim_customer
UNION ALL
SELECT 'Feedback',      COUNT(*) FROM dbo.fact_feedback;

-- 2. LIFECYCLE DISTRIBUTION SUMMARY
SELECT
    lifecycle_stage,
    COUNT(*)                                   AS Customer_Count,
    CAST(SUM(MonthlyCharges) AS DECIMAL(12,2)) AS Total_Monthly_Revenue,
    CAST(AVG(Churn_Probability) * 100 AS DECIMAL(10,2)) AS Avg_Churn_Risk_Pct
FROM dbo.fact_subscription
GROUP BY lifecycle_stage
ORDER BY Total_Monthly_Revenue DESC;

-- 3. CROSS-FUNCTIONAL JOIN INTEGRITY AUDIT (Demographics vs Risk Profile)
SELECT
    C.SeniorCitizen,
    S.Risk_Level,
    COUNT(*)                                   AS Customer_Count,
    CAST(AVG(S.Churn_Probability) * 100 AS DECIMAL(10,2)) AS Avg_Risk_Score
FROM dbo.dim_customer AS C
INNER JOIN dbo.fact_subscription AS S ON C.customerID = S.customerID
WHERE S.lifecycle_stage = 'Active'
GROUP BY C.SeniorCitizen, S.Risk_Level
ORDER BY C.SeniorCitizen DESC, Avg_Risk_Score DESC;
GO