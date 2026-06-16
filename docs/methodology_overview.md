# Methodology Overview — Churn Risk & Retention Analytics

## Executive Summary

This project follows a structured, multi-phase analytics framework designed to transform raw customer data into actionable retention insights. The methodology emphasizes interpretability, validation, and executive decision support over black-box prediction. Each phase is deliberately scoped to separate business framing, data integrity, analytical modeling, and strategic synthesis.

The outcome is a decision-ready retention dashboard supported by transparent SQL and Python workflows.

---

## End-to-End Analytics Framework

### 1. Business Framing & Success Metrics
- Defined churn as a business risk signal, not a causal outcome
- Aligned analysis to executive KPIs:
  - Monthly Revenue at Risk (MRR)
  - Retention prioritization
  - Potential revenue saved under scenario assumptions

---

### 2. Data Understanding (Raw Layer)
- Reviewed customer, contract, service, and billing data
- No transformations applied at this stage
- Identified data limitations early (no campaign response history, no LTV)

---

### 3. ETL & Data Cleaning (Staging Layer)
- Standardized formats and data types
- Handled nulls, duplicates, and inconsistent encodings
- Created analysis-ready tables with documented transformations
- All cleaning steps preserved reproducibility

---

### 4. Analytics Data Model
- Designed a star schema optimized for:
  - Churn analysis
  - Revenue aggregation
  - Power BI performance
- Clear separation between:
  - Fact tables (billing, churn signals)
  - Dimension tables (customers, contracts, services)

---

### 5. Lifecycle Risk Funnel (Rule-Based)
- Built an interpretable customer lifecycle framework:
  - Active → At-Risk → Churned
- Risk segmentation is rule-based, not predictive
- Enables transparent prioritization without model opacity

---

### 6. Revenue at Risk Quantification
- Calculated Monthly Revenue at Risk (MRR) using current charges
- Aggregated exposure by:
  - Risk level
  - Customer segments
  - Contract characteristics
- Focused on near-term, actionable financial impact

---

### 7. Predictive Risk Scoring (Decision Support)
- Developed a bounded churn risk score to support prioritization
- Model outputs are used as signals, not automated decisions
- **Predictive scoring serves strictly as an advanced decision support layer to refine targeting, but it does not override the foundational rule-based prioritization framework.**
- SQL used post-modeling for validation and aggregation

---

### 8. Validation & Sanity Checks
- Cross-validated risk distributions
- Confirmed revenue totals across layers
- Ensured model outputs aligned with business logic

---

### 9. Executive Synthesis & Delivery
- Translated analytical findings into:
  - Retention actions by risk level
  - Scenario-based impact estimates
- Delivered results via Power BI with:
  - Clear assumptions
  - Explicit data gaps
  - Drill-through transparency

---

## Guiding Principles

- Interpretability over complexity
- Business relevance over statistical novelty
- Clear separation between analysis and decision-making
- Reproducibility across SQL and Python workflows

---

## Known Limitations

- No causal inference or uplift modeling
- No long-term lifetime value estimation
- Retention impact assumed uniform across customers

These limitations are documented to ensure responsible use of insights.

---

## Outcome

The final deliverable is a decision-ready retention dashboard supported by clean, optimized SQL and reproducible analytics workflows — suitable for executive review, operational planning, and portfolio demonstration.