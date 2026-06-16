# 🛠 Technical Challenges & Resolutions

---

## 1. Schema Misclassification (BIT vs VARCHAR)
**Issue:**  
SQL Server automatically cast churn indicators as `BIT`, breaking conditional
logic and downstream joins.

**Resolution:**  
Manually overrode schema during import and validated churn logic against a Python
baseline to ensure consistency across environments.

---

## 2. Integer Division in KPI Calculations
**Issue:**  
Churn rate calculations incorrectly returned `0%` due to integer division.

**Resolution:**  
Explicitly enforced floating-point arithmetic in KPI formulas to preserve
decimal precision and avoid silent metric corruption.

---

## 3. Relational Integrity During Star Schema Migration
**Issue:**  
Risk of row loss when decomposing flat files into fact and dimension tables.

**Resolution:**  
Implemented primary/foreign key constraints and row-count reconciliation,
validating **7,043 records** end-to-end with zero loss.

---

## 4. Handling Structural Anomalies & Delimiter Corruption in Unstructured Text Data

### Situation
During ingestion of the customer feedback dataset, raw CSV files exhibited:
- Unescaped line breaks
- Nested semicolons
- Irregular spacing
- Mixed-format date fields across multiple columns

These issues caused parsing failures and downstream SQL load errors.

---

### Task
Build a repeatable, defensive preprocessing pipeline in Python to normalize
structure, sanitize text fields, and validate date integrity before loading
into the production star schema.

---

### Action
A three-stage remediation process was implemented in Google Colab using Pandas:

1. **Column Header Normalization**  
   Cleaned headers using `.str.replace()` and `.str.strip()` to remove illegal
   characters, replace spaces with underscores, and standardize SQL-friendly
   naming conventions.

2. **String Sanitization & Delimiter Protection**  
   Applied global regex transformations to:
   - Replace inline semicolons with hyphens  
   - Compress carriage returns and line breaks (`\r+|\n+`) into single spaces  
   This prevented delimiter corruption during ETL.

3. **Mixed-Format Datetime Standardization & Validation**  
   Used `pd.to_datetime()` with `dayfirst=True` and `format='mixed'` to safely
   parse international date formats.  
   Implemented an automated integrity check to audit mismatches across unified
   date columns.

---

### Result
- Eliminated all parsing and truncation errors
- Achieved **zero mismatches** across date dimensions
- Preserved **100% row-count integrity** when loading into
  `dbo.fact_feedback`
- Enabled reliable downstream text analytics and reporting
