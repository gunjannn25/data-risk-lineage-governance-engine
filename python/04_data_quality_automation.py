print("SCRIPT STARTED")
import mysql.connector

import os
print("Trying MySQL connection...")

connection = mysql.connector.connect(
    host="localhost",
    user="root",
    password=os.getenv("MYSQL_PASSWORD"),
    database="data_risk_lineage"
)

print("MySQL connection successful.")

cursor = connection.cursor()

print("Connected to MySQL.")

cursor.execute("DELETE FROM data_control_results")

controls = [
    (
        "Policy ID Null Check",
        "policies",
        "Policy_ID",
        "SELECT COUNT(*) FROM policies WHERE Policy_ID IS NULL"
    ),
    (
        "Premium Amount Null Check",
        "premium_bdx",
        "Premium_Amount",
        "SELECT COUNT(*) FROM premium_bdx WHERE Premium_Amount IS NULL"
    ),
    (
        "Claim Amount Null Check",
        "claims_bdx",
        "Claim_Amount",
        "SELECT COUNT(*) FROM claims_bdx WHERE Claim_Amount IS NULL"
    ),
    (
        "Duplicate Policy ID Check",
        "policies",
        "Policy_ID",
        "SELECT COUNT(*) - COUNT(DISTINCT Policy_ID) FROM policies"
    ),
    (
        "Invalid Premium Amount Check",
        "premium_bdx",
        "Premium_Amount",
        "SELECT COUNT(*) FROM premium_bdx WHERE Premium_Amount <= 0"
    ),
    (
        "Invalid Claim Amount Check",
        "claims_bdx",
        "Claim_Amount",
        "SELECT COUNT(*) FROM claims_bdx WHERE Claim_Amount <= 0"
    ),
    (
        "Invalid Claim Status Check",
        "claims_bdx",
        "Claim_Status",
        """
        SELECT COUNT(*)
        FROM claims_bdx
        WHERE Claim_Status NOT IN ('Open', 'Closed', 'Pending')
        """
    ),
    (
        "Premium Policy Referential Integrity Check",
        "premium_bdx",
        "Policy_ID",
        """
        SELECT COUNT(*)
        FROM premium_bdx pr
        LEFT JOIN policies p
        ON pr.Policy_ID = p.Policy_ID
        WHERE p.Policy_ID IS NULL
        """
    ),
    (
        "Claims Policy Referential Integrity Check",
        "claims_bdx",
        "Policy_ID",
        """
        SELECT COUNT(*)
        FROM claims_bdx c
        LEFT JOIN policies p
        ON c.Policy_ID = p.Policy_ID
        WHERE p.Policy_ID IS NULL
        """
    ),
    (
        "Invalid Policy Date Range Check",
        "policies",
        "Effective_Date / Expiry_Date",
        """
        SELECT COUNT(*)
        FROM policies
        WHERE Effective_Date > Expiry_Date
        """
    )
]

for name, table_name, column_name, query in controls:

    cursor.execute(query)

    failed_records = cursor.fetchone()[0]

    cursor.execute(
        f"SELECT COUNT(*) FROM {table_name}"
    )

    total_records = cursor.fetchone()[0]

    failure_rate = (
        failed_records / total_records
        if total_records > 0
        else 0
    )

    if failed_records == 0:
        risk_level = "Low"
        control_status = "Passed"

    elif failure_rate >= 0.05:
        risk_level = "Critical"
        control_status = "Failed"

    else:
        risk_level = "High"
        control_status = "Failed"

    cursor.execute(
        """
        INSERT INTO data_control_results
        (
            Control_Name,
            Table_Name,
            Column_Name,
            Failed_Records,
            Total_Records,
            Failure_Rate,
            Risk_Level,
            Control_Status
        )
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """,
        (
            name,
            table_name,
            column_name,
            failed_records,
            total_records,
            failure_rate,
            risk_level,
            control_status
        )
    )

    print(
        name,
        "->",
        failed_records,
        "failures"
    )

connection.commit()

cursor.close()
connection.close()

print("Data quality automation completed.")