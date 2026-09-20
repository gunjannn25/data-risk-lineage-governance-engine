import pandas as pd
import random


policies = pd.read_csv("data/policies.csv")


premium_records = []

for i in range(20000):

   
    policy = policies.sample(1).iloc[0]

   
    record = {
        "Transaction_ID": f"TXN{i + 1:06d}",
        "Policy_ID": policy["Policy_ID"],
        "Program_ID": policy["Program_ID"],
        "Treaty_ID": policy["Treaty_ID"],
        "Transaction_Type": random.choice(
            ["New Business", "Renewal", "Adjustment"]
        ),
        "Transaction_Date": pd.Timestamp(
            "2026-01-01"
        ) + pd.Timedelta(days=random.randint(0, 240)),
        "Premium_Amount": round(
            random.uniform(5000, 500000), 2
        )
    }

    premium_records.append(record)



premium_bdx = pd.DataFrame(premium_records)


print(premium_bdx.head())


print("Number of premium transactions:", len(premium_bdx))


premium_bdx.to_csv(
    "data/premium_bdx.csv",
    index=False
)

print("premium_bdx.csv created successfully!")