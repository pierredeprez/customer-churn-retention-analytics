# Derived Features Dictionary
**Project:** Customer Churn & Revenue Retention Analytics  
**Phase:** Post-ETL Analytics & Modeling  
**Status:** Locked (Derived Features Only)

---

## Purpose

This document defines all **derived, engineered, or calculated columns** created
after the ETL process (Phase 3) for analytical, segmentation, and prioritization
purposes.

It explicitly separates:
- **Raw & staging variables** (documented elsewhere)
- **Analytics-layer features** created in Python, SQL, or Power BI

This ensures **auditability, interpretability, and governance clarity**.

---

## Scope Rules

- Only columns **not present in raw datasets** are documented here
- No raw or staging columns are redefined
- Every feature must have a **clear business rationale**
- No feature exists without a defined analytical or KPI purpose

---

## Derived Feature Definitions

### 1. `tenure_group`
- **Source Columns:** `tenure`
- **Type:** Categorical
- **Logic:**  
  Customers are grouped into lifecycle buckets:
  - 0–6 months
  - 7–12 months
  - 13–24 months
  - 25-48 months
  - 49-72 months

- **Business Purpose:**  
  Identify lifecycle stages where churn and revenue exposure concentrate.
- **Used In:**  
  Python analysis, SQL validation, Power BI lifecycle visuals

---

### 2. `risk_month_to_month`
- **Source Columns:** `Contract`
- **Type:** Binary Flag (0/1)
- **Logic:**  
  1 if customer is on a Month-to-Month contract, else 0
- **Business Purpose:**  
  Capture contractual instability linked to higher churn risk.
- **Used In:**  
  At-Risk segmentation, funnel classification

---

### 3. `risk_short_tenure`
- **Source Columns:** `tenure`
- **Type:** Binary Flag (0/1)
- **Logic:**  
  1 if tenure < 6 months, else 0
- **Business Purpose:**  
  Identify early-lifecycle churn vulnerability.
- **Used In:**  
  At-Risk scoring logic, onboarding risk analysis

---

### 4. `risk_high_charges`
- **Source Columns:** `MonthlyCharges`
- **Type:** Binary Flag (0/1)
- **Logic:**  
  1 if MonthlyCharges above dataset median, else 0
- **Business Purpose:**  
  Detect revenue-weighted churn exposure.
- **Used In:**  
  Revenue-at-risk segmentation, prioritization logic

---

### 5. `risk_score`
- **Source Columns:**  
  `risk_month_to_month`, `risk_short_tenure`, `risk_high_charges`
- **Type:** Integer (0–3)
- **Logic:**  
  Sum of individual risk flags
- **Business Purpose:**  
  Create a simple, explainable risk index.
- **Used In:**  
  Funnel classification, SQL and BI aggregation

---

### 6. `funnel_stage`
- **Source Columns:** `Churn`, `risk_score`
- **Type:** Categorical
- **Logic:**  
  - `Churned` → Churn = Yes  
  - `At-Risk` → Churn = No AND risk_score ≥ 2  
  - `Active` → Otherwise
- **Business Purpose:**  
  Translate analytical signals into operational lifecycle stages.
- **Used In:**  
  Core KPIs, dashboards, executive summaries

---

### 7. `Churn_Probability`
- **Source Columns:** Multiple (Logistic Regression Inputs)
- **Type:** Continuous (0–1)
- **Logic:**  
  Output probability from logistic regression model
- **Business Purpose:**  
  Prioritize retention actions based on likelihood of churn.
- **Used In:**  
  Python modeling, Power BI risk ranking

📌 **Note:**  
This score is **decision-support only** and not used for automated actions.

---

### 8. `Risk_Level`
- **Source Columns:** `Churn_Probability`
- **Type:** Categorical
- **Logic:**  
  - Low: < 0.30  
  - Medium: 0.30 – 0.70  
  - High: > 0.70
- **Business Purpose:**  
  Simplify probabilistic output for stakeholder interpretation.
- **Used In:**  
  Power BI dashboards, executive segmentation views

---

### 9. `Clean_Complaint`
- **Source Columns:** `Customer Complaint Description`
- **Type:** Text
- **Logic:**  
  Normalized text (case, whitespace, null handling)
- **Business Purpose:**  
  Improve readability and category analysis of VoC data.
- **Used In:**  
  Qualitative complaint analysis only

---

## Interpretation Guardrails

- Derived features represent **associations**, not causal relationships
- Risk flags and scores are **heuristics**, not predictions
- Complaint features are **contextual signals**, not behavioral truth

---

## Governance Note

This dictionary must be updated **only if new derived features are introduced**.
Raw and staging definitions remain immutable.
