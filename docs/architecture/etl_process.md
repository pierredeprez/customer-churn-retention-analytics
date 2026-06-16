# ETL & Data Cleaning Process

## Purpose
This document describes the **end-to-end ETL pipeline** used to transform raw datasets
into analytics-ready tables while preserving data integrity and business meaning.

The pipeline follows a strict:
**Raw → Staging → Analytics** structure.

All transformations are **business-justified**, explicitly documented, and aligned
with defined KPIs.

---

## ETL Design Principles

- Raw data is immutable and never overwritten
- All assumptions are explicitly stated
- Transformations exist only to support defined KPIs
- No feature is created without a business rationale
- Reproducibility and auditability are prioritized

---

## Stage 1 — Raw Layer

### Description
The raw layer contains unmodified source data as obtained from external datasets.

### Datasets
- IBM Telco Churn Dataset
- Comcast Telecom Complaints Dataset

### Actions Performed
- File ingestion only
- Column names preserved
- No type casting
- No missing value handling

📌 **Rationale:**  
Preserve original data state for traceability and validation.

---

## Stage 2 — Staging Layer

### Description
The staging layer prepares data for analysis through **light standardization**
without altering analytical meaning.

### Transformations Applied

#### Customer Subscriptions
- Standardize categorical labels for consistency
- Convert numeric fields to appropriate data types
- Handle missing values where required for aggregation
  (e.g., TotalCharges)

#### Customer Complaints
- Normalize text fields (case, whitespace)
- Remove non-informative records (e.g., empty descriptions)

📌 **Business Justification:**  
These steps enable accurate aggregation and segmentation without introducing bias.

---

## Stage 3 — Analytics Layer

### Description
The analytics layer produces finalized datasets used directly in Python analysis,
SQL validation, and Power BI dashboards.

### Outputs

#### `dim_customer`
- One row per customer
- Demographic and contract attributes
- Stable segmentation reference

#### `fact_subscription`
- Customer-level churn status
- MonthlyCharges used as revenue proxy
- Lifecycle stage classification (Active / At-Risk / Churned)

#### `fact_feedback`
- Complaint-level records
- Sentiment or category annotations
- Used as qualitative VoC input only

📌 **Design Choice:**  
`fact_feedback` is not joined to customer-level tables to avoid false attribution.

---

## Assumptions & Limitations

- Missing values are handled conservatively to avoid inflating KPIs
- Revenue is proxied using monthly subscription charges
- Churn is treated as a static customer status
- No temporal churn modeling is performed
- Complaint data provides context, not behavioral causality

---

## KPI Alignment

| Transformation | Supported KPI |
|---|---|
| Lifecycle classification | Churn Rate, Revenue at Risk |
| Revenue proxy creation | Revenue at Risk |
| Segmentation attributes | Segment-Level KPIs |
| Complaint normalization | Qualitative churn insights |

---

## Scope Guardrails

- No data enrichment from external sources
- No feature engineering beyond defined metrics
- No predictive modeling at this stage
- No joins between subscriptions and complaints
