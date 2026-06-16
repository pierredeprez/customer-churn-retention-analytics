# Data Inventory & Join Feasibility Assessment

## Purpose
This document audits the raw datasets used in the project prior to any cleaning,
transformation, or modeling.  
The objective is to assess **data structure, quality, granularity, and join feasibility**
while explicitly documenting **assumptions and limitations**.

No modifications are performed at this stage.

---

## Dataset Overview

| Dataset Name | Source | Grain | Rows | Key Fields | Description |
|---|---|---|---|---|---|
| Customer Subscriptions | IBM Telco Churn Dataset | One row per customer | ~7,000 | customerID | Customer demographics, contract details, services, charges, and churn status |
| Customer Complaints | Comcast Telecom Complaints (Kaggle) | One row per complaint | ~2,200 | complaint_id (implicit) | Free-text customer complaints submitted to Comcast regarding telecom services |

---

## Dataset 1 — Customer Subscriptions (IBM Telco Churn)

### Structure
- **Grain:** One row per customer
- **Primary Identifier:** `customerID`
- **Time Representation:** Snapshot-style (no transaction history)
- **Target Variable:** `Churn` (binary)

### Key Characteristics
- Mix of categorical, binary, and numeric fields
- Revenue represented via `MonthlyCharges`
- Tenure expressed in months
- No explicit timestamp for churn event occurrence

### Data Quality Observations
- No duplicate customer IDs
- Some categorical fields contain service-dependent values
  (e.g., `"No internet service"`)
- Numeric fields are within reasonable business ranges at the raw stage

---

## Dataset 2 — Customer Complaints (Comcast Telecom Complaints)

### Structure
- **Grain:** One row per complaint
- **Primary Identifier:** Complaint index (no customer identifier)
- **Time Representation:** Complaint date
- **Content Type:** Categorical + unstructured text

### Key Characteristics
- Complaints reference issues such as billing, service outages, and customer support
- Free-text narratives vary in length and clarity
- Multiple complaints may relate to the same underlying customer (not identifiable)

### Data Quality Observations
- Text data contains spelling variations and informal language
- Complaint categories may overlap conceptually
- Dataset captures **sentiment and experience**, not transactional behavior

---

## Join Feasibility Assessment

| Criterion | Assessment |
|---|---|
| Shared Customer Identifier | ❌ None available |
| Temporal Alignment | ⚠️ Partial (complaint dates exist; churn timing does not) |
| Granularity Compatibility | ❌ Customer-level vs complaint-level |
| Risk of False Joins | 🔴 High |

### Join Decision
The **Customer Subscriptions** and **Customer Complaints** datasets **will not be joined**.

Complaints data will be treated as a **parallel analytical source** representing
**Voice of Customer (VoC)** signals, used to complement churn insights at an
aggregate level only.

---

## Assumptions & Limitations

- The subscriptions dataset represents a **static snapshot**, not a time series.
- Churn timing is inferred from status, not from event history.
- Revenue values represent **monthly recurring charges**, not invoiced revenue.
- Comcast complaints cannot be reliably mapped to individual customers.
- No causal relationship between complaints and churn is assumed.

---

## Scope Guardrails

- No data cleaning is performed at this stage.
- No feature engineering or transformation is applied.
- No datasets are merged or enriched.
- Observations remain descriptive and structural only.
