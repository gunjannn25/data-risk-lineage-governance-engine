# Data Risk & Lineage Governance Engine: Identifying 15 Data-Quality Failures Across Insurance Policy, Premium, and Claims Data

## 1. Business Problem

Insurance data teams need reliable policy, premium BDX, and claims BDX data for reconciliation, financial reporting, claims operations, and risk analysis.

This project helps data-governance stakeholders identify data-quality failures, understand their downstream lineage impact, prioritize remediation, and monitor the issues through a management dashboard.

## 2. Dataset

The project uses synthetic insurance data generated with Python.

| Dataset | Rows | Columns | Key Fields |
|---|---:|---:|---|
| Policies | 10,000 | 8 | Policy_ID, Program_ID, Treaty_ID, Effective_Date, Expiry_Date, Premium |
| Premium BDX | 20,000 | 7 | Transaction_ID, Policy_ID, Premium_Amount, Transaction_Date |
| Claims BDX | 10,000 | 7 | Claim_ID, Policy_ID, Claim_Amount, Claim_Status, Claim_Date |

The policy data covers 2025–2026. Premium and claims BDX records cover January–August 2026.

## 3. Tools Used

- **SQL / MySQL Workbench:** tables, joins, CTEs, window functions, data-quality controls, root-cause analysis, remediation tracking, risk scoring, and lineage analysis
- **Python:** pandas and mysql-connector-python for synthetic data generation and automated data-quality checks
- **Excel:** management dashboard, KPI cards, root-cause charts, Pareto analysis, quality matrix, RCA, and lineage reporting
- **GitHub:** project documentation and portfolio publication

## 4. Approach

### 1. Data Generation and Validation

Python generated policy, premium BDX, and claims BDX datasets. The clean source data was validated for unique IDs, valid policy relationships, valid dates, valid claim statuses, and positive financial amounts.

### 2. Data-Governance Foundation

SQL created and populated:

- A data dictionary with 22 data elements and criticality classifications
- A data-lineage map with 9 upstream/downstream relationships
- Data-quality control-result tables
- Remediation, risk-score, schema-monitoring, and lineage-impact tables

### 3. Data-Quality Analysis

Ten controls were applied across completeness, validity, and integrity dimensions:

- Missing Policy_ID, Premium_Amount, and Claim_Amount checks
- Duplicate Policy_ID check
- Invalid premium and claim amount checks
- Invalid Claim_Status check
- Premium and claims Policy_ID integrity checks
- Invalid policy date-range check

### 4. Root-Cause, Risk, and Impact Analysis

Controlled defects were assessed using root-cause analysis, remediation actions, risk scoring, and data lineage.

The analysis focused on the downstream impact of critical fields including Policy_ID, Premium_Amount, Claim_Amount, Claim_Status, Effective_Date, and Expiry_Date.

### 5. Visualisation

The Excel dashboard contains:

- KPI summary cards
- Failed-records-by-root-cause chart
- Failed-records-by-source-table chart
- Pareto analysis of data-quality failures
- Data-quality matrix by table and dimension
- Root-cause-analysis detail
- Data-lineage impact detail

## 5. Key Insights

- **8 of 10 data-quality controls failed**, producing **15 failed-record occurrences**.
- **Validity failures represented 46.67%** of all failures, with 7 failed-record occurrences.
- **claims_bdx contained 8 of 15 failures (53.33%)**, making it the most affected source table.
- **Completeness and integrity each represented 26.67%** of failures, with 4 failed-record occurrences each.
- The Pareto analysis showed that 80% of failures were distributed across six controls, indicating a broad source-data validation issue rather than one isolated defect.
- Policy_ID-related issues can propagate into premium and claims reconciliation, reporting, and downstream risk analysis.

## 6. Recommendations

1. Enforce mandatory validation for Premium_Amount and Claim_Amount before data is loaded.
2. Apply positive-value checks to prevent invalid premium and claim amounts.
3. Restrict Claim_Status to approved values: Open, Closed, or Pending.
4. Validate Policy_ID against the policy master before loading premium and claims BDX records.
5. Reject policies where Expiry_Date is earlier than Effective_Date.
6. Monitor data-quality controls regularly through the governance dashboard and assign remediation ownership for failed controls.

## 7. Dashboard

The management dashboard is available here:

```text
excel/Data_Risk_Governance_Dashboard.xlsx
```

It includes KPI cards, root-cause analysis, control summaries, lineage impact, Pareto analysis, and a quality matrix.

## 8. Repo Structure

```text
data-risk-lineage-governance-engine/
│
├── data/
│   ├── policies.csv
│   ├── premium_bdx.csv
│   └── claims_bdx.csv
│
├── python/
│   ├── 01_generate_data.py
│   ├── 02_generate_premium_bdx.py
│   ├── 03_generate_claims_bdx.py
│   ├── 04_data_quality_automation.py
│   └── requirements.txt
│
├── sql/
│    └── data_risk_lineage_original.sql
│
├── excel/
│   └── Data_Risk_Governance_Dashboard.xlsx
│
├── documentation/
│   └── SQL_README.md
│
└── README.md
```

## 9. How to Run

1. Install the Python dependencies:

```text
pip install -r python/requirements.txt
```

2. From the project root, generate the source data:

```text
python python/01_generate_data.py
python python/02_generate_premium_bdx.py
python python/03_generate_claims_bdx.py
```

3. Open MySQL Workbench and review the SQL implementation in:

```text
sql/archive/data_risk_lineage_original.sql
```

4. Set the `MYSQL_PASSWORD` environment variable before running `04_data_quality_automation.py`. Database credentials are intentionally not stored in this repository.

5. Open the Excel dashboard:

```text
excel/Data_Risk_Governance_Dashboard.xlsx
```
## 9. Contact
Name: Gunjan Aggarwal
Email: gunjan250103@gmail.com
