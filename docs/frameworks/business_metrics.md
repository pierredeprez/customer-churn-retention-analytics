# Business Objective & Key Performance Indicators (KPIs)

## Business Context
Customer churn represents a direct and measurable threat to recurring revenue in subscription-based businesses.  
This project aims to quantify **revenue exposure caused by customer churn**, identify **which customer segments contribute most to that exposure**, and support **data-driven retention prioritization**.

The analysis is designed to answer executive-level questions around *where revenue is leaking*, *why it is happening*, and *where intervention would deliver the highest financial return*.

---

## Business Objective
The primary objective of this analysis is to **quantify monthly revenue at risk due to customer churn**, identify **high-risk customer segments**, and translate churn patterns into **actionable retention insights** that support strategic decision-making.

Rather than predicting churn as a purely technical exercise, this project focuses on **measuring financial impact**, understanding **customer lifecycle dynamics**, and enabling **targeted retention strategies**.

---

## Key Performance Indicators (KPIs)

### Executive-Level KPIs
These KPIs summarize overall business exposure and are designed for senior stakeholders.

- **Churn Rate (%)**  
  Percentage of customers who have churned relative to the total customer base.

- **Revenue at Risk ($/month)**  
  Sum of monthly recurring revenue associated with customers who are churned or classified as at-risk.

---

### Funnel & Lifecycle KPIs
These KPIs describe how customers move through the lifecycle and where risk concentrates.

- **Active Customers (%)**  
  Customers currently retained and not flagged as high risk.

- **At-Risk Customers (%)**  
  Customers exhibiting behavioral or contractual characteristics associated with elevated churn risk.

- **Churned Customers (%)**  
  Customers who have discontinued service.

---

### Segment-Level KPIs
These KPIs identify structural drivers of churn and revenue exposure.

- **Churn Rate by Tenure**
- **Churn Rate by Contract Type**
- **Revenue at Risk by Service Mix**
- **Revenue at Risk by Customer Segment**

---

## KPI → Business Question Mapping

| KPI | Business Question |
|---|---|
| Churn Rate | How significant is customer attrition overall? |
| MRR (Monthly Revenue at Risk) | How much monthly revenue is exposed to churn? |
| Churn Rate by Tenure | At what point in the customer lifecycle does churn concentrate? |
| Churn Rate by Contract Type | Which contract structures increase retention risk? |
| Revenue at Risk by Segment | Which customer segments should be prioritized for retention efforts? |

---

## Assumptions & Definitions

- **Revenue Definition**  
  Monthly revenue is proxied using `MonthlyCharges`. This represents recurring revenue exposure, not invoiced or lifetime revenue.

- **Churn Definition**  
  Churn is treated as a binary customer-level status based on the provided dataset, without reclassification or inferred churn events.

- **Time Granularity**  
  All revenue exposure is calculated on a **monthly basis**. No lifetime value (LTV) modeling is performed.

- **Scope of Analysis**  
  This project focuses on **descriptive and diagnostic analytics**, not causal inference or production-grade churn prediction.

- **Interpretation Guardrails**  
  Insights highlight **associations and patterns**, not causal drivers.

---

## Intended Business Use
The outputs of this analysis are intended to support:
- Executive visibility into churn-driven revenue exposure
- Identification of high-impact retention opportunities
- Prioritization of customer segments for targeted intervention
