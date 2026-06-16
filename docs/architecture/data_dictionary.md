# Data Dictionary

## Purpose
This document defines the **business meaning** of each column used in the analysis.
Definitions focus on **interpretation and analytical usage**, not technical data types.

---

## Dataset: Customer Subscriptions (IBM Telco Churn)

| Column Name | Business Meaning | Notes / Interpretation Guardrails |
|---|---|---|
| customerID | Unique identifier for each customer | Stable customer-level key |
| gender | Customer-reported gender | Used only in aggregate analysis |
| SeniorCitizen | Indicator of senior status (1 = Yes) | Binary demographic flag |
| Partner | Whether customer has a partner | Household context |
| Dependents | Whether customer has dependents | Household context |
| tenure | Number of months customer has been active | Proxy for lifecycle stage |
| PhoneService | Subscription to phone service | Service availability |
| MultipleLines | Multiple phone lines | Dependent on PhoneService |
| InternetService | Type of internet service | Key segmentation variable |
| OnlineSecurity | Online security add-on | Value-added service |
| OnlineBackup | Online backup add-on | Value-added service |
| DeviceProtection | Device protection add-on | Value-added service |
| TechSupport | Technical support add-on | Retention-related service |
| StreamingTV | Streaming TV service | Entertainment service |
| StreamingMovies | Streaming movies service | Entertainment service |
| Contract | Contract duration | Major churn driver |
| PaperlessBilling | Electronic billing indicator | Billing preference |
| PaymentMethod | Method of payment | Operational characteristic |
| MonthlyCharges | Monthly subscription charge | Revenue exposure proxy |
| TotalCharges | Cumulative customer charges | Not used for revenue modeling |
| Churn | Customer churn status (Yes/No) | Binary outcome variable |

---

## Dataset: Customer Complaints (Comcast Telecom Complaints)

| Column Name | Business Meaning | Notes / Interpretation Guardrails |
|---|---|---|
| complaint_id | Unique complaint record | Dataset-specific |
| date | Date complaint was submitted | Used for trend analysis |
| state | Customer-reported state | Geographic aggregation only |
| category | High-level complaint category | Issue classification |
| description | Free-text complaint narrative | Used for sentiment analysis |
| status | Complaint resolution status | Operational context |

---

## Interpretation Guardrails

- Complaints data is **not linked** to individual customers.
- Text-based sentiment reflects **experience signals**, not behavior.
- `MonthlyCharges` is treated as **revenue exposure**, not realized revenue.
- Demographic attributes are used only in aggregate form.

---

## Scope Notes

- Columns not listed here are excluded from analysis.
- No transformations are implied by this document.
- Definitions apply consistently across Python, SQL, and Power BI.
