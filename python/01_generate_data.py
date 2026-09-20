import pandas as pd
import random
from datetime import datetime, timedelta


number_of_policies = 10000


policy_ids = [f"POL{i:05d}" for i in range(1, number_of_policies + 1)]


program_ids = [f"PRG{i:03d}" for i in range(1, 26)]


treaty_ids = [f"TRT{i:03d}" for i in range(1, 101)]


regions = ["North", "South", "East", "West"]


risk_categories = ["Low", "Medium", "High", "Critical"]


selected_programs = []
selected_treaties = []
effective_dates = []
expiry_dates = []
premiums = []
selected_regions = []
selected_risks = []
for i in range(number_of_policies):

    selected_programs.append(random.choice(program_ids))
    selected_treaties.append(random.choice(treaty_ids))

    start_date = datetime(2025, 1, 1) + timedelta(
        days=random.randint(0, 730)
    )

    effective_dates.append(start_date)
    end_date = start_date + timedelta(
        days=random.randint(180, 730)
    )

    expiry_dates.append(end_date)
    premiums.append(round(random.uniform(5000, 500000), 2))

    selected_regions.append(random.choice(regions))
    selected_risks.append(random.choice(risk_categories))
policies = pd.DataFrame({
    "Policy_ID": policy_ids,
    "Program_ID": selected_programs,
    "Treaty_ID": selected_treaties,
    "Effective_Date": effective_dates,
    "Expiry_Date": expiry_dates,
    "Premium": premiums,
    "Region": selected_regions,
    "Risk_Category": selected_risks
})



print(policies.head())


print("Number of policies:", len(policies))


policies.to_csv("data/policies.csv", index=False)

print("policies.csv created successfully!")