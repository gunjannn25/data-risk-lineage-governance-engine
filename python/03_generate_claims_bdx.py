
import pandas as pd
import random

policies = pd.read_csv("data/policies.csv")

claim_records = []

for i in range(10000):

    policy = policies.sample(1).iloc[0]

    record = {
        "Claim_ID": f"CLM{i + 1:06d}",
        "Policy_ID": policy["Policy_ID"],
        "Program_ID": policy["Program_ID"],
        "Treaty_ID": policy["Treaty_ID"],
        "Claim_Date": pd.Timestamp(
            "2026-01-01"
        ) + pd.Timedelta(
            days=random.randint(0, 240)
        ),
        "Claim_Status": random.choice(
            ["Open", "Closed", "Pending"]
        ),
        "Claim_Amount": round(
            random.uniform(1000, 300000), 2
        )
    }

    claim_records.append(record)

claims_bdx = pd.DataFrame(claim_records)

print(claims_bdx.head())

print("Number of claims:", len(claims_bdx))

claims_bdx.to_csv(
    "data/claims_bdx.csv",
    index=False
)

print("claims_bdx.csv created successfully!")