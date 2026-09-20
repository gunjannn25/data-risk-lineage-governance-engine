# SQL Guide

## Database

Database name: `data_risk_lineage`

## Core Source Tables

- `policies` — policy master data
- `premium_bdx` — premium transactions
- `claims_bdx` — claims transactions

## Governance Tables

- `data_dictionary` — business definitions and data criticality
- `data_lineage` — upstream/downstream data dependencies
- `data_control_results` — automated data-quality control outcomes
- `remediation_issues` — remediation actions for identified issues
- `data_risk_scores` — risk prioritization output
- `lineage_impact_summary` — downstream impact assessment
- `schema_monitor` — expected schema and criticality reference

## Analysis Performed

1. Completeness checks for missing premium and claim values
2. Validity checks for invalid amounts, statuses, and policy date ranges
3. Integrity checks for policy-to-BDX relationships
4. Root-cause analysis by completeness, validity, and integrity
5. Remediation tracking and risk scoring
6. Data-lineage impact analysis
7. Premium, claims, reconciliation, and loss-ratio reporting

## Verified Result

The final control run identified 8 failed controls and 15 failed-record occurrences across the insurance data estate.

## Note

`sql/archive/data_risk_lineage_original.sql` contains the original combined SQL development script. The existing MySQL database was verified and should not be recreated for this project submission.