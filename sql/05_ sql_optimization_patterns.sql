/*=============================================================================
05: ADVANCED SQL DESIGN CHOICES [CTE VS SUBQUERY ARCHITECTURAL PAIRS]
Project: Customer Churn & Revenue Retention Analytics
Author:  Pierre ML Deprez
Purpose: Demonstrate advanced query architectural design patterns, focusing on 
         readable, scalable, and modular SQL structures for senior stakeholders.
=============================================================================*/

USE customer_churn_retention_analytics;
GO

-- ============================================================================
-- PAIR 1: ACTIVE REVENUE EXPOSURE & CONCENTRATION ANALYSIS
-- Scenario: Calculate total monthly revenue exposure for Active customers 
--           across different risk tiers and compute each tier's percentage 
--           share of total active portfolio revenue.
-- ============================================================================

-- ❌ OPTION A: The Subquery Approach (Nested, De-optimized, Less Readable)
SELECT
    Sub.Risk_Level,
    Sub.Customer_Count,
    Sub.Monthly_Revenue_At_Risk,
    CAST((Sub.Monthly_Revenue_At_Risk * 100.0 / Total.Global_Active_Revenue) AS DECIMAL(10,2)) AS Revenue_Share_Pct
FROM 
    (
        /* Subquery 1: Aggregate revenue metrics by Risk Level */
        SELECT
            Risk_Level,
            COUNT(*) AS Customer_Count,
            SUM(MonthlyCharges) AS Monthly_Revenue_At_Risk
        FROM dbo.fact_subscription
        WHERE lifecycle_stage = 'Active'
          AND Risk_Level <> 'Churned'
        GROUP BY Risk_Level
    ) AS Sub
CROSS JOIN 
    (
        /* Subquery 2: Calculate total benchmark active revenue */
        SELECT SUM(MonthlyCharges) AS Global_Active_Revenue
        FROM dbo.fact_subscription
        WHERE lifecycle_stage = 'Active'
          AND Risk_Level <> 'Churned'
    ) AS Total
ORDER BY 
    CASE Sub.Risk_Level
        WHEN 'High Risk'   THEN 1
        WHEN 'Medium Risk' THEN 2
        ELSE 3
    END;
GO

-- ✅ OPTION B: The Chained CTE Approach (Modular, Clean, Enterprise-Grade)
WITH TargetSegments AS (
    /* Step 1: Isolate active accounts and aggregate baseline exposure metrics */
    SELECT
        Risk_Level,
        COUNT(*) AS Customer_Count,
        SUM(MonthlyCharges) AS Monthly_Revenue_At_Risk
    FROM dbo.fact_subscription
    WHERE lifecycle_stage = 'Active'
      AND Risk_Level <> 'Churned'
    GROUP BY Risk_Level
),
GlobalBenchmark AS (
    /* Step 2: Extract total active revenue portfolio context from Step 1 */
    SELECT SUM(Monthly_Revenue_At_Risk) AS Total_Active_Revenue
    FROM TargetSegments
)
/* Step 3: Synthesize metrics into executive-ready percentages */
SELECT
    TS.Risk_Level,
    TS.Customer_Count,
    CAST(TS.Monthly_Revenue_At_Risk AS DECIMAL(12,2)) AS Monthly_Revenue_At_Risk,
    CAST((TS.Monthly_Revenue_At_Risk * 100.0 / GB.Total_Active_Revenue) AS DECIMAL(10,2)) AS Revenue_Share_Pct
FROM TargetSegments AS TS
CROSS JOIN GlobalBenchmark AS GB
ORDER BY 
    CASE TS.Risk_Level
        WHEN 'High Risk'   THEN 1
        WHEN 'Medium Risk' THEN 2
        ELSE 3
    END;
GO


-- ============================================================================
-- PAIR 2: DEMOGRAPHICS × HIGH-RISK VALUE TARGETING
-- Scenario: Isolate vulnerable Senior Citizen accounts, filter for high-value 
--           targets exceeding the average portfolio monthly bill, and 
--           evaluate their model-derived risk exposure.
-- ============================================================================

-- ❌ OPTION A: The Subquery Approach (Deeply Nested & Cluttered)
SELECT 
    C.customerID,
    C.SeniorCitizen,
    HighRiskSubs.MonthlyCharges,
    HighRiskSubs.Churn_Probability
FROM dbo.dim_customer AS C
JOIN 
    (
        /* Inner Subquery: Filter for high risk and compare against a scalar subquery average */
        SELECT 
            customerID, 
            MonthlyCharges, 
            Churn_Probability
        FROM dbo.fact_subscription
        WHERE lifecycle_stage = 'Active'
          AND Risk_Level = 'High Risk'
          AND MonthlyCharges > (SELECT AVG(MonthlyCharges) FROM dbo.fact_subscription)
    ) AS HighRiskSubs ON C.customerID = HighRiskSubs.customerID
WHERE C.SeniorCitizen = 1
ORDER BY HighRiskSubs.MonthlyCharges DESC;
GO

-- ✅ OPTION B: The Chained CTE Approach (Highly Readable & Scalable)
WITH PortfolioBenchmarks AS (
    /* Step 1: Establish the baseline reference average across the whole fleet */
    SELECT AVG(MonthlyCharges) AS Avg_Monthly_Bill
    FROM dbo.fact_subscription
),
HighValueHighRisk AS (
    /* Step 2: Pinpoint active risk candidates based on the benchmark financial baseline */
    SELECT 
        customerID,
        MonthlyCharges,
        Churn_Probability
    FROM dbo.fact_subscription
    CROSS JOIN PortfolioBenchmarks
    WHERE lifecycle_stage = 'Active'
      AND Risk_Level = 'High Risk'
      AND MonthlyCharges > Avg_Monthly_Bill
)
/* Step 3: Enforce demographic cross-functional join mapping */
SELECT
    H.customerID AS Customer_ID,
    CASE C.SeniorCitizen WHEN 1 THEN 'Senior' ELSE 'Non-Senior' END AS Demographic_Group,
    CAST(H.MonthlyCharges AS DECIMAL(12,2)) AS Monthly_Bill,
    CAST(H.Churn_Probability * 100 AS DECIMAL(10,2)) AS Risk_Score_Pct
FROM dbo.dim_customer AS C
INNER JOIN HighValueHighRisk AS H ON C.customerID = H.customerID
WHERE C.SeniorCitizen = 1
ORDER BY Monthly_Bill DESC;
GO