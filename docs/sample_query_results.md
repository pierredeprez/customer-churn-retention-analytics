# Sample SQL Query Results — Validation & Interpretability Appendix

This appendix provides **representative SQL queries and outputs** used to validate
key analytical conclusions presented in the main README and Power BI dashboard.

The purpose of this document is to reinforce:
- **Analytical transparency**
- **Auditability of business insights**
- **Trust in revenue and risk calculations**

All queries shown below are executed directly against the
analytics-ready production tables defined in `/sql`.

---

## Example 1 — Revenue at Risk by Risk Level (Active Customers)

### Business Question
Where is **preventable monthly revenue exposure** concentrated within the active
customer base?

### Query
```sql
SELECT
    Risk_Level,
    COUNT(*)                                   AS Customer_Count,
    CAST(SUM(MonthlyCharges) AS DECIMAL(12,2)) AS Monthly_Revenue_At_Risk,
    CAST((SUM(MonthlyCharges) * 100.0 
          / SUM(SUM(MonthlyCharges)) OVER()) AS DECIMAL(10,2)) AS Revenue_Share_Pct
FROM dbo.fact_subscription
WHERE lifecycle_stage = 'Active'
  AND Risk_Level      <> 'Churned'
GROUP BY Risk_Level
ORDER BY 
    CASE Risk_Level
        WHEN 'Medium Risk' THEN 1
        WHEN 'High Risk'   THEN 2
        ELSE 3
    END;
```

### Sample Output

| Risk Level  | Customer Count | Monthly Revenue at Risk ($) | Revenue Share (%) |
|-------------|----------------|-----------------------------|-------------------|
| Medium Risk | 1,821          | 136,697.30                  | 43.12             |
| High Risk   | 1,344          | 84,706.25                   | 26.72             |
| Low Risk    | 2,009          | 95,582.20                   | 30.15             |

### Interpretation
While high-risk customers require immediate tactical attention, **medium-risk, high-revenue customers represent the largest opportunity for proactive retention**, 
as intervention at this stage prevents future escalation into high-risk churn.

---

## Example 2 — High-Value Retention Target List (Tactical Execution)

### Business Question
Which **specific customers** should be prioritized for immediate retention action
based on **financial impact and churn risk**?

### Query
```sql
SELECT TOP 20
    customerID                                 AS Customer_ID,
    CAST(MonthlyCharges AS DECIMAL(12,2))      AS Monthly_Bill,
    Contract,
    CAST(Churn_Probability * 100 AS DECIMAL(10,2)) AS Risk_Score_Pct
FROM dbo.fact_subscription
WHERE lifecycle_stage = 'Active' 
  AND Risk_Level      = 'High Risk'
ORDER BY Monthly_Bill DESC;
```

### Sample Output

| Customer ID | Monthly Bill ($) | Contract       | Risk Score (%) |
|-------------|------------------|----------------|----------------|
| 8016-NCFVO  | 116.50           | Month-to-month | 66.04          |
| 9659-QEQSY  | 115.65           | Month-to-month | 71.94          |
| 6710-HSJRD  | 114.10           | Month-to-month | 61.85          |
| ...         | ...              | ...            | ...            |

### Interpretation
This query supports **tactical execution** by isolating high-revenue customers
with elevated churn probability, enabling focused retention outreach.

---

## Usage Notes
- Outputs are representative and may vary slightly by refresh timing
- All values originate from analytics-ready fact tables
- Queries align with transformations documented in `/sql` and KPIs in `/docs`

---

_End of Sample Query Results Appendix_