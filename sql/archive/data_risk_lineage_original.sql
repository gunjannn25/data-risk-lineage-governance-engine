CREATE DATABASE IF NOT EXISTS data_risk_lineage;

USE data_risk_lineage;
USE data_risk_lineage;

CREATE TABLE policies (
    Policy_ID VARCHAR(20) PRIMARY KEY,
    Program_ID VARCHAR(20),
    Treaty_ID VARCHAR(20),
    Effective_Date DATE,
    Expiry_Date DATE,
    Premium DECIMAL(15,2),
    Region VARCHAR(50),
    Risk_Category VARCHAR(30)
);
SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';
SHOW VARIABLES LIKE 'secure_file_priv';
LOAD DATA LOCAL INFILE 'C:/Users/lenovo/Desktop/data_risk_lineage_engine/data/policies.csv'
INTO TABLE policies
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT COUNT(*) AS policy_count
FROM policies;
USE data_risk_lineage;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/policies.csv'
INTO TABLE policies
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT *
FROM policies
LIMIT 5;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/premium_bdx.csv'
INTO TABLE premium_bdx
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
USE data_risk_lineage;

CREATE TABLE premium_bdx (
    Transaction_ID VARCHAR(20) PRIMARY KEY,
    Policy_ID VARCHAR(20),
    Program_ID VARCHAR(20),
    Treaty_ID VARCHAR(20),
    Transaction_Type VARCHAR(30),
    Transaction_Date DATE,
    Premium_Amount DECIMAL(15,2),
    FOREIGN KEY (Policy_ID) REFERENCES policies(Policy_ID)
);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/premium_bdx.csv'
INTO TABLE premium_bdx
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/premium_bdx.csv'
INTO TABLE premium_bdx
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/premium_bdx.csv'
INTO TABLE premium_bdx
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
CREATE TABLE claims_bdx (
    Claim_ID VARCHAR(20) PRIMARY KEY,
    Policy_ID VARCHAR(20),
    Program_ID VARCHAR(20),
    Treaty_ID VARCHAR(20),
    Claim_Date DATE,
    Claim_Status VARCHAR(20),
    Claim_Amount DECIMAL(15,2),
    FOREIGN KEY (Policy_ID) REFERENCES policies(Policy_ID)
);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/claims_bdx.csv'
INTO TABLE claims_bdx
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT COUNT(*) AS claim_count
FROM claims_bdx;

SELECT *
FROM claims_bdx
LIMIT 5;
USE data_risk_lineage;

CREATE TABLE data_dictionary (
    Data_Element_ID INT AUTO_INCREMENT PRIMARY KEY,
    Table_Name VARCHAR(50),
    Column_Name VARCHAR(60),
    Data_Type VARCHAR(25),
    Business_Definition VARCHAR(275),
    Criticality VARCHAR(20)
);
INSERT INTO data_dictionary
(Table_Name, Column_Name, Data_Type, Business_Definition, Criticality)
VALUES
('policies', 'Policy_ID', 'VARCHAR', 'Unique identifier for an insurance policy', 'Critical'),
('policies', 'Program_ID', 'VARCHAR', 'Identifier of the insurance program', 'High'),
('policies', 'Treaty_ID', 'VARCHAR', 'Identifier of the reinsurance treaty', 'Critical'),
('policies', 'Effective_Date', 'DATE', 'Policy coverage start date', 'High'),
('policies', 'Expiry_Date', 'DATE', 'Policy coverage end date', 'High'),
('policies', 'Premium', 'DECIMAL', 'Policy premium amount', 'Critical'),
('policies', 'Region', 'VARCHAR', 'Geographic region of the policy', 'Medium'),
('policies', 'Risk_Category', 'VARCHAR', 'Risk classification of the policy', 'High'),

('premium_bdx', 'Transaction_ID', 'VARCHAR', 'Unique identifier for premium transaction', 'Critical'),
('premium_bdx', 'Policy_ID', 'VARCHAR', 'Policy associated with the premium transaction', 'Critical'),
('premium_bdx', 'Program_ID', 'VARCHAR', 'Insurance program associated with the transaction', 'High'),
('premium_bdx', 'Treaty_ID', 'VARCHAR', 'Reinsurance treaty associated with the transaction', 'Critical'),
('premium_bdx', 'Transaction_Type', 'VARCHAR', 'Type of premium transaction', 'Medium'),
('premium_bdx', 'Transaction_Date', 'DATE', 'Date of premium transaction', 'High'),
('premium_bdx', 'Premium_Amount', 'DECIMAL', 'Premium amount recorded in the transaction', 'Critical'),

('claims_bdx', 'Claim_ID', 'VARCHAR', 'Unique identifier for a claim', 'Critical'),
('claims_bdx', 'Policy_ID', 'VARCHAR', 'Policy associated with the claim', 'Critical'),
('claims_bdx', 'Program_ID', 'VARCHAR', 'Insurance program associated with the claim', 'High'),
('claims_bdx', 'Treaty_ID', 'VARCHAR', 'Reinsurance treaty associated with the claim', 'Critical'),
('claims_bdx', 'Claim_Date', 'DATE', 'Date on which the claim was recorded', 'High'),
('claims_bdx', 'Claim_Status', 'VARCHAR', 'Current status of the claim', 'Medium'),
('claims_bdx', 'Claim_Amount', 'DECIMAL', 'Financial amount of the claim', 'Critical');
USE data_risk_lineage;

CREATE TABLE data_lineage (
    Lineage_ID INT AUTO_INCREMENT PRIMARY KEY,
    Source_Table VARCHAR(50),
    Source_Column VARCHAR(50),
    Target_Table VARCHAR(50),
    Target_Column VARCHAR(50),
    Dependency_Type VARCHAR(30),
    Criticality VARCHAR(20)
);
INSERT INTO data_lineage
(Source_Table, Source_Column, Target_Table, Target_Column, Dependency_Type, Criticality)
VALUES
('policies', 'Policy_ID', 'premium_bdx', 'Policy_ID', 'Direct Dependency', 'Critical'),
('policies', 'Policy_ID', 'claims_bdx', 'Policy_ID', 'Direct Dependency', 'Critical'),
('policies', 'Program_ID', 'premium_bdx', 'Program_ID', 'Direct Dependency', 'High'),
('policies', 'Program_ID', 'claims_bdx', 'Program_ID', 'Direct Dependency', 'High'),
('policies', 'Treaty_ID', 'premium_bdx', 'Treaty_ID', 'Direct Dependency', 'Critical'),
('policies', 'Treaty_ID', 'claims_bdx', 'Treaty_ID', 'Direct Dependency', 'Critical'),
('policies', 'Premium', 'premium_bdx', 'Premium_Amount', 'Financial Dependency', 'Critical'),
('premium_bdx', 'Premium_Amount', 'claims_bdx', 'Claim_Amount', 'Analytical Dependency', 'High'),
('premium_bdx', 'Policy_ID', 'claims_bdx', 'Policy_ID', 'Analytical Dependency', 'High');
SELECT *
FROM data_lineage;
CREATE TABLE data_control_results (
    Control_ID INT AUTO_INCREMENT PRIMARY KEY,
    Control_Name VARCHAR(100),
    Table_Name VARCHAR(50),
    Column_Name VARCHAR(50),
    Failed_Records INT,
    Total_Records INT,
    Failure_Rate DECIMAL(10,4),
    Risk_Level VARCHAR(20),
    Control_Status VARCHAR(20)
);
INSERT INTO data_control_results
(Control_Name, Table_Name, Column_Name, Failed_Records, Total_Records, Failure_Rate, Risk_Level, Control_Status)
SELECT
    'Policy ID Null Check',
    'policies',
    'Policy_ID',
    COUNT(*),
    (SELECT COUNT(*) FROM policies),
    COUNT(*) / (SELECT COUNT(*) FROM policies),
    CASE
        WHEN COUNT(*) > 0 THEN 'High'
        ELSE 'Low'
    END,
    CASE
        WHEN COUNT(*) > 0 THEN 'Failed'
        ELSE 'Passed'
    END
FROM policies
WHERE Policy_ID is NULL;
INSERT INTO data_control_results
(Control_Name, Table_Name, Column_Name, Failed_Records, Total_Records, Failure_Rate, Risk_Level, Control_Status)
SELECT
    'Premium Amount Null Check',
    'premium_bdx',
    'Premium_Amount',
    COUNT(*),
    (SELECT COUNT(*) FROM premium_bdx),
    COUNT(*) / (SELECT COUNT(*) FROM premium_bdx),
    CASE
        WHEN COUNT(*) > 0 THEN 'High'
        ELSE 'Low'
    END,
    CASE
        WHEN COUNT(*) > 0 THEN 'Failed'
        ELSE 'Passed'
    END
FROM premium_bdx
WHERE Premium_Amount IS NULL;
INSERT INTO data_control_results
(Control_Name, Table_Name, Column_Name, Failed_Records, Total_Records, Failure_Rate, Risk_Level, Control_Status)
SELECT
    'Claim Amount Null Check',
    'claims_bdx',
    'Claim_Amount',
    COUNT(*),
    (SELECT COUNT(*) FROM claims_bdx),
    COUNT(*) / (SELECT COUNT(*) FROM claims_bdx),
    CASE
        WHEN COUNT(*) > 0 THEN 'High'
        ELSE 'Low'
    END,
    CASE
        WHEN COUNT(*) > 0 THEN 'Failed'
        ELSE 'Passed'
    END
FROM claims_bdx
WHERE Claim_Amount IS NULL;
INSERT INTO data_control_results
(Control_Name, Table_Name, Column_Name, Failed_Records, Total_Records, Failure_Rate, Risk_Level, Control_Status)
SELECT
    'Duplicate Policy ID Check',
    'policies',
    'Policy_ID',
    COUNT(*) - COUNT(DISTINCT Policy_ID),
    COUNT(*),
    (COUNT(*) - COUNT(DISTINCT Policy_ID)) / COUNT(*),
    CASE
        WHEN COUNT(*) - COUNT(DISTINCT Policy_ID) > 0 THEN 'High'
        ELSE 'Low'
    END,
    CASE
        WHEN COUNT(*) - COUNT(DISTINCT Policy_ID) > 0 THEN 'Failed'
        ELSE 'Passed'
    END
FROM policies;
INSERT INTO data_control_results
(Control_Name, Table_Name, Column_Name, Failed_Records, Total_Records, Failure_Rate, Risk_Level, Control_Status)
SELECT
    'Invalid Premium Amount Check',
    'premium_bdx',
    'Premium_Amount',
    COUNT(*),
    (SELECT COUNT(*) FROM premium_bdx),
    COUNT(*) / (SELECT COUNT(*) FROM premium_bdx),
    CASE
        WHEN COUNT(*) > 0 THEN 'High'
        ELSE 'Low'
    END,
    CASE
        WHEN COUNT(*) > 0 THEN 'Failed'
        ELSE 'Passed'
    END
FROM premium_bdx
WHERE Premium_Amount <= 0;
INSERT INTO data_control_results
(Control_Name, Table_Name, Column_Name, Failed_Records, Total_Records, Failure_Rate, Risk_Level, Control_Status)
SELECT
    'Invalid Claim Amount Check',
    'claims_bdx',
    'Claim_Amount',
    COUNT(*),
    (SELECT COUNT(*) FROM claims_bdx),
    COUNT(*) / (SELECT COUNT(*) FROM claims_bdx),
    CASE
        WHEN COUNT(*) > 0 THEN 'High'
        ELSE 'Low'
    END,
    CASE
        WHEN COUNT(*) > 0 THEN 'Failed'
        ELSE 'Passed'
    END
FROM claims_bdx
WHERE Claim_Amount <= 0;
INSERT INTO data_control_results
(Control_Name, Table_Name, Column_Name, Failed_Records, Total_Records, Failure_Rate, Risk_Level, Control_Status)
SELECT
    'Invalid Claim Status Check',
    'claims_bdx',
    'Claim_Status',
    COUNT(*),
    (SELECT COUNT(*) FROM claims_bdx),
    COUNT(*) / (SELECT COUNT(*) FROM claims_bdx),
    CASE
        WHEN COUNT(*) > 0 THEN 'Medium'
        ELSE 'Low'
    END,
    CASE
        WHEN COUNT(*) > 0 THEN 'Failed'
        ELSE 'Passed'
    END
FROM claims_bdx
WHERE Claim_Status NOT IN ('Open', 'Closed', 'Pending');
INSERT INTO data_control_results
(Control_Name, Table_Name, Column_Name, Failed_Records, Total_Records, Failure_Rate, Risk_Level, Control_Status)
SELECT
    'Premium Policy Referential Integrity Check',
    'premium_bdx',
    'Policy_ID',
    COUNT(*),
    (SELECT COUNT(*) FROM premium_bdx),
    COUNT(*) / (SELECT COUNT(*) FROM premium_bdx),
    CASE
        WHEN COUNT(*) > 0 THEN 'Critical'
        ELSE 'Low'
    END,
    CASE
        WHEN COUNT(*) > 0 THEN 'Failed'
        ELSE 'Passed'
    END
FROM premium_bdx p
LEFT JOIN policies po
    ON p.Policy_ID = po.Policy_ID
WHERE po.Policy_ID IS NULL;
INSERT INTO data_control_results
(Control_Name, Table_Name, Column_Name, Failed_Records, Total_Records, Failure_Rate, Risk_Level, Control_Status)
SELECT
    'Claims Policy Referential Integrity Check',
    'claims_bdx',
    'Policy_ID',
    COUNT(*),
    (SELECT COUNT(*) FROM claims_bdx),
    COUNT(*) / (SELECT COUNT(*) FROM claims_bdx),
    CASE
        WHEN COUNT(*) > 0 THEN 'Critical'
        ELSE 'Low'
    END,
    CASE
        WHEN COUNT(*) > 0 THEN 'Failed'
        ELSE 'Passed'
    END
FROM claims_bdx c
LEFT JOIN policies p
    ON c.Policy_ID = p.Policy_ID
WHERE p.Policy_ID IS NULL;
INSERT INTO data_control_results
(Control_Name, Table_Name, Column_Name, Failed_Records, Total_Records, Failure_Rate, Risk_Level, Control_Status)
SELECT
    'Invalid Policy Date Range Check',
    'policies',
    'Effective_Date / Expiry_Date',
    COUNT(*),
    (SELECT COUNT(*) FROM policies),
    COUNT(*) / (SELECT COUNT(*) FROM policies),
    CASE
        WHEN COUNT(*) > 0 THEN 'High'
        ELSE 'Low'
    END,
    CASE
        WHEN COUNT(*) > 0 THEN 'Failed'
        ELSE 'Passed'
    END
FROM policies
WHERE Effective_Date > Expiry_Date;
SELECT
    Control_Name,
    Table_Name,
    Column_Name,
    Failed_Records,
    Total_Records,
    Failure_Rate,
    Risk_Level,
    Control_Status
FROM data_control_results
ORDER BY
    CASE
        WHEN Risk_Level = 'Critical' THEN 1
        WHEN Risk_Level = 'High' THEN 2
        WHEN Risk_Level = 'Medium' THEN 3
        ELSE 4
    END,
    Failed_Records DESC;
    CREATE TABLE remediation_issues (
    Issue_ID INT AUTO_INCREMENT PRIMARY KEY,
    Control_ID INT,
    Table_Name VARCHAR(50),
    Column_Name VARCHAR(50),
    Issue_Type VARCHAR(100),
    Failed_Records INT,
    Risk_Level VARCHAR(20),
    Issue_Status VARCHAR(30),
    Remediation_Action VARCHAR(255),
    Created_Date DATE
);
INSERT INTO remediation_issues
(Control_ID, Table_Name, Column_Name, Issue_Type, Failed_Records, Risk_Level, Issue_Status, Remediation_Action, Created_Date)
SELECT
    Control_ID,
    Table_Name,
    Column_Name,
    Control_Name,
    Failed_Records,
    Risk_Level,
    CASE
        WHEN Failed_Records > 0 THEN 'Open'
        ELSE 'No Issue'
    END,
    CASE
        WHEN Failed_Records > 0 THEN 'Investigate and correct source data'
        ELSE 'No Action Required'
    END,
    CURRENT_DATE
FROM data_control_results;
SELECT
    Risk_Level,
    Issue_Status,
    COUNT(*) AS Issue_Count
FROM remediation_issues
GROUP BY Risk_Level, Issue_Status
ORDER BY Issue_Count DESC;
SELECT
    p.Program_ID,
    COUNT(DISTINCT p.Policy_ID) AS Policy_Count,
    SUM(p.Premium) AS Total_Policy_Premium,
    COUNT(DISTINCT pr.Transaction_ID) AS Premium_Transactions,
    SUM(pr.Premium_Amount) AS BDX_Premium,
    COUNT(DISTINCT c.Claim_ID) AS Claim_Count,
    SUM(c.Claim_Amount) AS Total_Claims
FROM policies p
LEFT JOIN premium_bdx pr
    ON p.Policy_ID = pr.Policy_ID
LEFT JOIN claims_bdx c
    ON p.Policy_ID = c.Policy_ID
GROUP BY p.Program_ID
ORDER BY Total_Claims DESC;
SELECT
    p.Treaty_ID,
    COUNT(DISTINCT p.Policy_ID) AS Policy_Count,
    SUM(p.Premium) AS Policy_Premium,
    SUM(pr.Premium_Amount) AS BDX_Premium,
    SUM(c.Claim_Amount) AS Claims
FROM policies p
LEFT JOIN premium_bdx pr
    ON p.Policy_ID = pr.Policy_ID
LEFT JOIN claims_bdx c
    ON p.Policy_ID = c.Policy_ID
GROUP BY p.Treaty_ID
ORDER BY Claims DESC;
SELECT
    p.Policy_ID,
    p.Premium AS Policy_Premium,
    COALESCE(SUM(pr.Premium_Amount), 0) AS BDX_Premium,
    COALESCE(SUM(c.Claim_Amount), 0) AS Total_Claims,
    CASE
        WHEN p.Premium > 0
        THEN ROUND(
            COALESCE(SUM(c.Claim_Amount), 0) / p.Premium * 100,
            2
        )
        ELSE NULL
    END AS Loss_Ratio_Percent
FROM policies p
LEFT JOIN premium_bdx pr
    ON p.Policy_ID = pr.Policy_ID
LEFT JOIN claims_bdx c
    ON p.Policy_ID = c.Policy_ID
GROUP BY
    p.Policy_ID,
    p.Premium
ORDER BY Loss_Ratio_Percent DESC
LIMIT 20;
CREATE VIEW policy_financial_summary AS
SELECT
    p.Policy_ID,
    p.Program_ID,
    p.Treaty_ID,
    p.Premium AS Policy_Premium,
    COALESCE(pr.BDX_Premium, 0) AS BDX_Premium,
    COALESCE(c.Total_Claims, 0) AS Total_Claims
FROM policies p
LEFT JOIN (
    SELECT
        Policy_ID,
        SUM(Premium_Amount) AS BDX_Premium
    FROM premium_bdx
    GROUP BY Policy_ID
) pr
    ON p.Policy_ID = pr.Policy_ID
LEFT JOIN (
    SELECT
        Policy_ID,
        SUM(Claim_Amount) AS Total_Claims
    FROM claims_bdx
    GROUP BY Policy_ID
) c
    ON p.Policy_ID = c.Policy_ID;
    SELECT *
FROM policy_financial_summary
LIMIT 20;
SELECT
    Policy_ID,
    Policy_Premium,
    BDX_Premium,
    Total_Claims,
    ROUND(
        CASE
            WHEN BDX_Premium > 0
            THEN Total_Claims / BDX_Premium * 100
            ELSE 0
        END, 2
    ) AS Loss_Ratio_Percent
FROM policy_financial_summary
ORDER BY Loss_Ratio_Percent DESC
LIMIT 20;
SELECT
    Policy_ID,
    Policy_Premium,
    BDX_Premium,
    ROUND(BDX_Premium - Policy_Premium, 2) AS Premium_Variance,
    ROUND(
        CASE
            WHEN Policy_Premium > 0
            THEN (BDX_Premium - Policy_Premium) / Policy_Premium * 100
            ELSE 0
        END, 2
    ) AS Variance_Percent
FROM policy_financial_summary
WHERE ABS(BDX_Premium - Policy_Premium) > 0
ORDER BY ABS(BDX_Premium - Policy_Premium) DESC
LIMIT 20
CREATE TABLE risk_impact_analysis (
    Impact_ID INT AUTO_INCREMENT PRIMARY KEY,
    Data_Element_ID INT,
    Source_Table VARCHAR(50),
    Source_Column VARCHAR(50),
    Impacted_Table VARCHAR(50),
    Impacted_Column VARCHAR(50),
    Impact_Type VARCHAR(100),
    Risk_Level VARCHAR(20),
    Recommended_Action VARCHAR(255)
);
INSERT INTO risk_impact_analysis
(Data_Element_ID, Source_Table, Source_Column, Impacted_Table, Impacted_Column, Impact_Type, Risk_Level, Recommended_Action)
SELECT
    dd.Data_Element_ID,
    dl.Source_Table,
    dl.Source_Column,
    dl.Target_Table,
    dl.Target_Column,
    'Upstream Data Failure',
    dl.Criticality,
    'Investigate source data and downstream dependencies'
FROM data_lineage dl
JOIN data_dictionary dd
    ON dd.Table_Name = dl.Source_Table
    AND dd.Column_Name = dl.Source_Column;
    SELECT
    Risk_Level,
    COUNT(*) AS Impact_Count
FROM risk_impact_analysis
GROUP BY Risk_Level
ORDER BY
    CASE
        WHEN Risk_Level = 'Critical' THEN 1
        WHEN Risk_Level = 'High' THEN 2
        WHEN Risk_Level = 'Medium' THEN 3
        ELSE 4
    END;
    SELECT
    dl.Source_Table,
    dl.Source_Column,
    COUNT(*) AS Downstream_Dependencies
FROM data_lineage dl
GROUP BY
    dl.Source_Table,
    dl.Source_Column
ORDER BY Downstream_Dependencies DESC;
SELECT
    dl.Source_Table,
    dl.Source_Column,
    COUNT(*) AS Downstream_Dependencies
FROM data_lineage dl
GROUP BY
    dl.Source_Table,
    dl.Source_Column
ORDER BY Downstream_Dependencies DESC;
SELECT
    p.Program_ID,
    COUNT(DISTINCT p.Policy_ID) AS Policy_Count,
    ROUND(SUM(p.Premium), 2) AS Policy_Premium,
    ROUND(COALESCE(SUM(pr.Premium_Amount), 0), 2) AS BDX_Premium,
    ROUND(COALESCE(SUM(c.Claim_Amount), 0), 2) AS Claims,
    ROUND(
        CASE
            WHEN COALESCE(SUM(pr.Premium_Amount), 0) > 0
            THEN COALESCE(SUM(c.Claim_Amount), 0)
                 / SUM(pr.Premium_Amount) * 100
            ELSE 0
        END, 2
    ) AS Loss_Ratio_Percent
FROM policies p
LEFT JOIN premium_bdx pr
    ON p.Policy_ID = pr.Policy_ID
LEFT JOIN claims_bdx c
    ON p.Policy_ID = c.Policy_ID
GROUP BY p.Program_ID;
SELECT
    p.Program_ID,
    COUNT(DISTINCT p.Policy_ID) AS Policy_Count,
    ROUND(SUM(p.Premium), 2) AS Policy_Premium,
    ROUND(COALESCE(SUM(pr.Premium_Amount), 0), 2) AS BDX_Premium,
    ROUND(COALESCE(SUM(c.Claim_Amount), 0), 2) AS Claims,
    ROUND(
        CASE
            WHEN COALESCE(SUM(pr.Premium_Amount), 0) > 0
            THEN COALESCE(SUM(c.Claim_Amount), 0)
                 / SUM(pr.Premium_Amount) * 100
            ELSE 0
        END, 2
    ) AS Loss_Ratio_Percent
FROM policies p
LEFT JOIN premium_bdx pr
    ON p.Policy_ID = pr.Policy_ID
LEFT JOIN claims_bdx c
    ON p.Policy_ID = c.Policy_ID
GROUP BY p.Program_ID;
SELECT
    Treaty_ID,
    COUNT(DISTINCT Policy_ID) AS Policy_Count,
    ROUND(SUM(Policy_Premium), 2) AS Total_Premium,
    ROUND(SUM(BDX_Premium), 2) AS Total_BDX_Premium,
    ROUND(SUM(Total_Claims), 2) AS Total_Claims
FROM policy_financial_summary
GROUP BY Treaty_ID
ORDER BY Total_Claims DESC;
USE data_risk_lineage;

SHOW TABLES;
SELECT 'policies' AS table_name, COUNT(*) AS row_count FROM policies
UNION ALL
SELECT 'premium_bdx', COUNT(*) FROM premium_bdx
UNION ALL
SELECT 'claims_bdx', COUNT(*) FROM claims_bdx
UNION ALL
SELECT 'data_dictionary', COUNT(*) FROM data_dictionary
UNION ALL
SELECT 'data_lineage', COUNT(*) FROM data_lineage
UNION ALL
SELECT 'data_control_results', COUNT(*) FROM data_control_results
UNION ALL
SELECT 'remediation_issues', COUNT(*) FROM remediation_issues
UNION ALL
SELECT 'risk_impact_analysis', COUNT(*) FROM risk_impact_analysis;
USE data_risk_lineage;

SELECT 'policies' AS table_name, COUNT(*) AS row_count FROM policies
UNION ALL
SELECT 'premium_bdx', COUNT(*) FROM premium_bdx
UNION ALL
SELECT 'claims_bdx', COUNT(*) FROM claims_bdx
UNION ALL
SELECT 'data_dictionary', COUNT(*) FROM data_dictionary
UNION ALL
SELECT 'data_lineage', COUNT(*) FROM data_lineage
UNION ALL
SELECT 'data_control_results', COUNT(*) FROM data_control_results;
USE data_risk_lineage;

SELECT
    Control_ID,
    Control_Name,
    Table_Name,
    Column_Name,
    Failed_Records,
    Total_Records,
    Failure_Rate,
    Risk_Level,
    Control_Status
FROM data_control_results
ORDER BY Control_ID;
USE data_risk_lineage;

UPDATE premium_bdx
SET Premium_Amount = NULL
WHERE Transaction_ID = 'TXN000001';

UPDATE premium_bdx
SET Premium_Amount = -5000
WHERE Transaction_ID = 'TXN000002';

UPDATE claims_bdx
SET Claim_Amount = NULL
WHERE Claim_ID = 'CLM000001';

UPDATE claims_bdx
SET Claim_Amount = -10000
WHERE Claim_ID = 'CLM000002';

UPDATE claims_bdx
SET Claim_Status = 'INVALID'
WHERE Claim_ID = 'CLM000003';

UPDATE premium_bdx
SET Policy_ID = NULL
WHERE Transaction_ID = 'TXN000003';

UPDATE claims_bdx
SET Policy_ID = NULL
WHERE Claim_ID = 'CLM000004';

UPDATE policies
SET Effective_Date = '2026-12-31',
    Expiry_Date = '2026-01-01'
WHERE Policy_ID = 'POL000001';
SELECT
    Transaction_ID,
    Policy_ID,
    Premium_Amount
FROM premium_bdx
WHERE Transaction_ID IN
(
    'TXN000001',
    'TXN000002',
    'TXN000003'
);
SELECT
    Claim_ID,
    Policy_ID,
    Claim_Status,
    Claim_Amount
FROM claims_bdx
WHERE Claim_ID IN
(
    'CLM000001',
    'CLM000002',
    'CLM000003',
    'CLM000004'
);
SELECT
    Policy_ID,
    Effective_Date,
    Expiry_Date
FROM policies
WHERE Policy_ID = 'POL000001';
USE data_risk_lineage;

SELECT Policy_ID
FROM policies
LIMIT 10;
USE data_risk_lineage;

UPDATE policies
SET Effective_Date = '2026-12-31',
    Expiry_Date = '2026-01-01'
WHERE Policy_ID = 'POL00001';
SELECT
    Policy_ID,
    Effective_Date,
    Expiry_Date
FROM policies
WHERE Policy_ID = 'POL00001';
SELECT Transaction_ID
FROM premium_bdx
LIMIT 5;
SELECT Claim_ID
FROM claims_bdx
LIMIT 5;
SELECT
    Transaction_ID,
    Premium_Amount
FROM premium_bdx
ORDER BY Transaction_ID
LIMIT 5;
SELECT
    Claim_ID,
    Claim_Status,
    Claim_Amount
FROM claims_bdx
ORDER BY Claim_ID
LIMIT 5;
UPDATE policies
SET Effective_Date = '2026-12-31',
    Expiry_Date = '2026-01-01'
WHERE Policy_ID = 'POL00001';
USE data_risk_lineage;

UPDATE premium_bdx
SET Premium_Amount = NULL
WHERE Transaction_ID = 'TXN000003';

UPDATE premium_bdx
SET Premium_Amount = -5000
WHERE Transaction_ID = 'TXN019595';

UPDATE claims_bdx
SET Claim_Amount = NULL
WHERE Claim_ID = 'CLM000004';

UPDATE claims_bdx
SET Claim_Amount = -10000
WHERE Claim_ID = 'CLM007254';

UPDATE claims_bdx
SET Claim_Status = 'INVALID'
WHERE Claim_ID = 'CLM008146';

UPDATE premium_bdx
SET Policy_ID = NULL
WHERE Transaction_ID = 'TXN003639';

UPDATE claims_bdx
SET Policy_ID = NULL
WHERE Claim_ID = 'CLM001960';
SELECT
    Transaction_ID,
    Policy_ID,
    Premium_Amount
FROM premium_bdx
WHERE Transaction_ID IN
(
    'TXN000003',
    'TXN019595',
    'TXN003639'
);

SELECT
    Claim_ID,
    Policy_ID,
    Claim_Status,
    Claim_Amount
FROM claims_bdx
WHERE Claim_ID IN
(
    'CLM000004',
    'CLM007254',
    'CLM008146',
    'CLM001960'
);

SELECT
    Policy_ID,
    Effective_Date,
    Expiry_Date
FROM policies
WHERE Policy_ID = 'POL00001';
USE data_risk_lineage;

SELECT
    Transaction_ID,
    Policy_ID,
    Premium_Amount
FROM premium_bdx
WHERE Transaction_ID IN
(
    'TXN000003',
    'TXN019595',
    'TXN003639'
);

SELECT
    Claim_ID,
    Policy_ID,
    Claim_Status,
    Claim_Amount
FROM claims_bdx
WHERE Claim_ID IN
(
    'CLM000004',
    'CLM007254',
    'CLM008146',
    'CLM001960'
);
USE data_risk_lineage;

SELECT
    Control_ID,
    Control_Name,
    Failed_Records,
    Total_Records,
    Failure_Rate,
    Risk_Level,
    Control_Status
FROM data_control_results
ORDER BY Control_ID;
USE data_risk_lineage;

SELECT
    (SELECT COUNT(*) FROM premium_bdx WHERE Premium_Amount IS NULL) AS Premium_Null,
    (SELECT COUNT(*) FROM premium_bdx WHERE Premium_Amount <= 0) AS Premium_Invalid,
    (SELECT COUNT(*) FROM claims_bdx WHERE Claim_Amount IS NULL) AS Claim_Null,
    (SELECT COUNT(*) FROM claims_bdx WHERE Claim_Amount <= 0) AS Claim_Invalid,
    (SELECT COUNT(*) FROM claims_bdx WHERE Claim_Status NOT IN ('Open','Closed','Pending')) AS Invalid_Status,
    (SELECT COUNT(*)
     FROM premium_bdx pr
     LEFT JOIN policies p
     ON pr.Policy_ID = p.Policy_ID
     WHERE p.Policy_ID IS NULL) AS Premium_Orphans,
    (SELECT COUNT(*)
     FROM claims_bdx c
     LEFT JOIN policies p
     ON c.Policy_ID = p.Policy_ID
     WHERE p.Policy_ID IS NULL) AS Claim_Orphans,
    (SELECT COUNT(*)
     FROM policies
     WHERE Effective_Date > Expiry_Date) AS Invalid_Dates;
     USE data_risk_lineage;

CREATE TABLE remediation_issues (
    Issue_ID INT AUTO_INCREMENT PRIMARY KEY,
    Control_ID INT,
    Table_Name VARCHAR(50),
    Column_Name VARCHAR(100),
    Issue_Type VARCHAR(100),
    Failed_Records INT,
    Risk_Level VARCHAR(20),
    Issue_Status VARCHAR(30),
    Remediation_Action VARCHAR(255),
    Created_Date DATE
);
INSERT INTO remediation_issues
(
    Control_ID,
    Table_Name,
    Column_Name,
    Issue_Type,
    Failed_Records,
    Risk_Level,
    Issue_Status,
    Remediation_Action,
    Created_Date
)
SELECT
    Control_ID,
    Table_Name,
    Column_Name,
    Control_Name,
    Failed_Records,
    Risk_Level,
    CASE
        WHEN Failed_Records > 0 THEN 'Open'
        ELSE 'No Issue'
    END,
    CASE
        WHEN Failed_Records > 0
        THEN 'Investigate and correct source data'
        ELSE 'No Action Required'
    END,
    CURRENT_DATE
FROM data_control_results;
SELECT *
FROM remediation_issues
ORDER BY
    CASE
        WHEN Risk_Level = 'Critical' THEN 1
        WHEN Risk_Level = 'High' THEN 2
        ELSE 3
    END,
    Failed_Records DESC;
    USE data_risk_lineage;

UPDATE data_control_results
SET
    Failed_Records = CASE Control_ID
        WHEN 1 THEN (
            SELECT COUNT(*)
            FROM policies
            WHERE Policy_ID IS NULL
        )
        WHEN 2 THEN (
            SELECT COUNT(*)
            FROM premium_bdx
            WHERE Premium_Amount IS NULL
        )
        WHEN 3 THEN (
            SELECT COUNT(*)
            FROM claims_bdx
            WHERE Claim_Amount IS NULL
        )
        WHEN 4 THEN (
            SELECT COUNT(*) - COUNT(DISTINCT Policy_ID)
            FROM policies
        )
        WHEN 5 THEN (
            SELECT COUNT(*)
            FROM premium_bdx
            WHERE Premium_Amount <= 0
        )
        WHEN 6 THEN (
            SELECT COUNT(*)
            FROM claims_bdx
            WHERE Claim_Amount <= 0
        )
        WHEN 7 THEN (
            SELECT COUNT(*)
            FROM claims_bdx
            WHERE Claim_Status NOT IN ('Open','Closed','Pending')
        )
        WHEN 8 THEN (
            SELECT COUNT(*)
            FROM premium_bdx pr
            LEFT JOIN policies p
                ON pr.Policy_ID = p.Policy_ID
            WHERE p.Policy_ID IS NULL
        )
        WHEN 9 THEN (
            SELECT COUNT(*)
            FROM claims_bdx c
            LEFT JOIN policies p
                ON c.Policy_ID = p.Policy_ID
            WHERE p.Policy_ID IS NULL
        )
    END,

    Failure_Rate = CASE Control_ID
        WHEN 1 THEN (
            SELECT COUNT(*) / 10000
            FROM policies
            WHERE Policy_ID IS NULL
        )
        WHEN 2 THEN (
            SELECT COUNT(*) / 20000
            FROM premium_bdx
            WHERE Premium_Amount IS NULL
        )
        WHEN 3 THEN (
            SELECT COUNT(*) / 10000
            FROM claims_bdx
            WHERE Claim_Amount IS NULL
        )
        WHEN 4 THEN 0
        WHEN 5 THEN (
            SELECT COUNT(*) / 20000
            FROM premium_bdx
            WHERE Premium_Amount <= 0
        )
        WHEN 6 THEN (
            SELECT COUNT(*) / 10000
            FROM claims_bdx
            WHERE Claim_Amount <= 0
        )
        WHEN 7 THEN (
            SELECT COUNT(*) / 10000
            FROM claims_bdx
            WHERE Claim_Status NOT IN ('Open','Closed','Pending')
        )
        WHEN 8 THEN (
            SELECT COUNT(*) / 20000
            FROM premium_bdx pr
            LEFT JOIN policies p
                ON pr.Policy_ID = p.Policy_ID
            WHERE p.Policy_ID IS NULL
        )
        WHEN 9 THEN (
            SELECT COUNT(*) / 10000
            FROM claims_bdx c
            LEFT JOIN policies p
                ON c.Policy_ID = p.Policy_ID
            WHERE p.Policy_ID IS NULL
        )
    END,

    Risk_Level = CASE
        WHEN
            CASE Control_ID
                WHEN 1 THEN (
                    SELECT COUNT(*) FROM policies
                    WHERE Policy_ID IS NULL
                )
                WHEN 2 THEN (
                    SELECT COUNT(*) FROM premium_bdx
                    WHERE Premium_Amount IS NULL
                )
                WHEN 3 THEN (
                    SELECT COUNT(*) FROM claims_bdx
                    WHERE Claim_Amount IS NULL
                )
                WHEN 4 THEN 0
                WHEN 5 THEN (
                    SELECT COUNT(*) FROM premium_bdx
                    WHERE Premium_Amount <= 0
                )
                WHEN 6 THEN (
                    SELECT COUNT(*) FROM claims_bdx
                    WHERE Claim_Amount <= 0
                )
                WHEN 7 THEN (
                    SELECT COUNT(*) FROM claims_bdx
                    WHERE Claim_Status NOT IN ('Open','Closed','Pending')
                )
                WHEN 8 THEN (
                    SELECT COUNT(*)
                    FROM premium_bdx pr
                    LEFT JOIN policies p
                    ON pr.Policy_ID = p.Policy_ID
                    WHERE p.Policy_ID IS NULL
                )
                WHEN 9 THEN (
                    SELECT COUNT(*)
                    FROM claims_bdx c
                    LEFT JOIN policies p
                    ON c.Policy_ID = p.Policy_ID
                    WHERE p.Policy_ID IS NULL
                )
            END > 0
        THEN 'High'
        ELSE 'Low'
    END,

    Control_Status = CASE
        WHEN
            CASE Control_ID
                WHEN 1 THEN (
                    SELECT COUNT(*) FROM policies
                    WHERE Policy_ID IS NULL
                )
                WHEN 2 THEN (
                    SELECT COUNT(*) FROM premium_bdx
                    WHERE Premium_Amount IS NULL
                )
                WHEN 3 THEN (
                    SELECT COUNT(*) FROM claims_bdx
                    WHERE Claim_Amount IS NULL
                )
                WHEN 4 THEN 0
                WHEN 5 THEN (
                    SELECT COUNT(*) FROM premium_bdx
                    WHERE Premium_Amount <= 0
                )
                WHEN 6 THEN (
                    SELECT COUNT(*) FROM claims_bdx
                    WHERE Claim_Amount <= 0
                )
                WHEN 7 THEN (
                    SELECT COUNT(*) FROM claims_bdx
                    WHERE Claim_Status NOT IN ('Open','Closed','Pending')
                )
                WHEN 8 THEN (
                    SELECT COUNT(*)
                    FROM premium_bdx pr
                    LEFT JOIN policies p
                    ON pr.Policy_ID = p.Policy_ID
                    WHERE p.Policy_ID IS NULL
                )
                WHEN 9 THEN (
                    SELECT COUNT(*)
                    FROM claims_bdx c
                    LEFT JOIN policies p
                    ON c.Policy_ID = p.Policy_ID
                    WHERE p.Policy_ID IS NULL
                )
            END > 0
        THEN 'Failed'
        ELSE 'Passed'
    END;
    SELECT
    Control_ID,
    Control_Name,
    Failed_Records,
    Failure_Rate,
    Risk_Level,
    Control_Status
FROM data_control_results
ORDER BY Control_ID;
USE data_risk_lineage;

TRUNCATE TABLE data_control_results;
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

SELECT
    'Policy ID Null Check',
    'policies',
    'Policy_ID',
    COUNT(*),
    (SELECT COUNT(*) FROM policies),
    COUNT(*) / (SELECT COUNT(*) FROM policies),
    CASE WHEN COUNT(*) > 0 THEN 'High' ELSE 'Low' END,
    CASE WHEN COUNT(*) > 0 THEN 'Failed' ELSE 'Passed' END
FROM policies
WHERE Policy_ID IS NULL

UNION ALL

SELECT
    'Premium Amount Null Check',
    'premium_bdx',
    'Premium_Amount',
    COUNT(*),
    (SELECT COUNT(*) FROM premium_bdx),
    COUNT(*) / (SELECT COUNT(*) FROM premium_bdx),
    CASE WHEN COUNT(*) > 0 THEN 'High' ELSE 'Low' END,
    CASE WHEN COUNT(*) > 0 THEN 'Failed' ELSE 'Passed' END
FROM premium_bdx
WHERE Premium_Amount IS NULL

UNION ALL

SELECT
    'Claim Amount Null Check',
    'claims_bdx',
    'Claim_Amount',
    COUNT(*),
    (SELECT COUNT(*) FROM claims_bdx),
    COUNT(*) / (SELECT COUNT(*) FROM claims_bdx),
    CASE WHEN COUNT(*) > 0 THEN 'High' ELSE 'Low' END,
    CASE WHEN COUNT(*) > 0 THEN 'Failed' ELSE 'Passed' END
FROM claims_bdx
WHERE Claim_Amount IS NULL

UNION ALL

SELECT
    'Duplicate Policy ID Check',
    'policies',
    'Policy_ID',
    COUNT(*) - COUNT(DISTINCT Policy_ID),
    (SELECT COUNT(*) FROM policies),
    (COUNT(*) - COUNT(DISTINCT Policy_ID)) / (SELECT COUNT(*) FROM policies),
    CASE WHEN COUNT(*) - COUNT(DISTINCT Policy_ID) > 0 THEN 'High' ELSE 'Low' END,
    CASE WHEN COUNT(*) - COUNT(DISTINCT Policy_ID) > 0 THEN 'Failed' ELSE 'Passed' END
FROM policies

UNION ALL

SELECT
    'Invalid Premium Amount Check',
    'premium_bdx',
    'Premium_Amount',
    COUNT(*),
    (SELECT COUNT(*) FROM premium_bdx),
    COUNT(*) / (SELECT COUNT(*) FROM premium_bdx),
    CASE WHEN COUNT(*) > 0 THEN 'High' ELSE 'Low' END,
    CASE WHEN COUNT(*) > 0 THEN 'Failed' ELSE 'Passed' END
FROM premium_bdx
WHERE Premium_Amount <= 0

UNION ALL

SELECT
    'Invalid Claim Amount Check',
    'claims_bdx',
    'Claim_Amount',
    COUNT(*),
    (SELECT COUNT(*) FROM claims_bdx),
    COUNT(*) / (SELECT COUNT(*) FROM claims_bdx),
    CASE WHEN COUNT(*) > 0 THEN 'High' ELSE 'Low' END,
    CASE WHEN COUNT(*) > 0 THEN 'Failed' ELSE 'Passed' END
FROM claims_bdx
WHERE Claim_Amount <= 0

UNION ALL

SELECT
    'Invalid Claim Status Check',
    'claims_bdx',
    'Claim_Status',
    COUNT(*),
    (SELECT COUNT(*) FROM claims_bdx),
    COUNT(*) / (SELECT COUNT(*) FROM claims_bdx),
    CASE WHEN COUNT(*) > 0 THEN 'High' ELSE 'Low' END,
    CASE WHEN COUNT(*) > 0 THEN 'Failed' ELSE 'Passed' END
FROM claims_bdx
WHERE Claim_Status NOT IN ('Open','Closed','Pending')

UNION ALL

SELECT
    'Premium Policy Referential Integrity Check',
    'premium_bdx',
    'Policy_ID',
    COUNT(*),
    (SELECT COUNT(*) FROM premium_bdx),
    COUNT(*) / (SELECT COUNT(*) FROM premium_bdx),
    CASE WHEN COUNT(*) > 0 THEN 'High' ELSE 'Low' END,
    CASE WHEN COUNT(*) > 0 THEN 'Failed' ELSE 'Passed' END
FROM premium_bdx pr
LEFT JOIN policies p
    ON pr.Policy_ID = p.Policy_ID
WHERE p.Policy_ID IS NULL

UNION ALL

SELECT
    'Claims Policy Referential Integrity Check',
    'claims_bdx',
    'Policy_ID',
    COUNT(*),
    (SELECT COUNT(*) FROM claims_bdx),
    COUNT(*) / (SELECT COUNT(*) FROM claims_bdx),
    CASE WHEN COUNT(*) > 0 THEN 'High' ELSE 'Low' END,
    CASE WHEN COUNT(*) > 0 THEN 'Failed' ELSE 'Passed' END
FROM claims_bdx c
LEFT JOIN policies p
    ON c.Policy_ID = p.Policy_ID
WHERE p.Policy_ID IS NULL;
SELECT
    Control_ID,
    Control_Name,
    Failed_Records,
    Failure_Rate,
    Risk_Level,
    Control_Status
FROM data_control_results
ORDER BY Control_ID;
USE data_risk_lineage;

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
SELECT
    'Invalid Policy Date Range Check',
    'policies',
    'Effective_Date / Expiry_Date',
    COUNT(*),
    (SELECT COUNT(*) FROM policies),
    COUNT(*) / (SELECT COUNT(*) FROM policies),
    CASE WHEN COUNT(*) > 0 THEN 'High' ELSE 'Low' END,
    CASE WHEN COUNT(*) > 0 THEN 'Failed' ELSE 'Passed' END
FROM policies
WHERE Effective_Date > Expiry_Date;
SELECT
    Control_ID,
    Control_Name,
    Failed_Records,
    Failure_Rate,
    Risk_Level,
    Control_Status
FROM data_control_results
ORDER BY Control_ID;
TRUNCATE TABLE remediation_issues;
INSERT INTO remediation_issues
(
    Control_ID,
    Table_Name,
    Column_Name,
    Issue_Type,
    Failed_Records,
    Risk_Level,
    Issue_Status,
    Remediation_Action,
    Created_Date
)
SELECT
    Control_ID,
    Table_Name,
    Column_Name,
    Control_Name,
    Failed_Records,
    Risk_Level,
    CASE
        WHEN Failed_Records > 0 THEN 'Open'
        ELSE 'No Issue'
    END,
    CASE
        WHEN Failed_Records > 0
        THEN 'Investigate and correct source data'
        ELSE 'No Action Required'
    END,
    CURRENT_DATE
FROM data_control_results;
SELECT
    Issue_ID,
    Control_ID,
    Table_Name,
    Column_Name,
    Issue_Type,
    Failed_Records,
    Risk_Level,
    Issue_Status,
    Remediation_Action
FROM remediation_issues
ORDER BY
    CASE
        WHEN Risk_Level = 'Critical' THEN 1
        WHEN Risk_Level = 'High' THEN 2
        ELSE 3
    END,
    Failed_Records DESC;
    USE data_risk_lineage;

CREATE TABLE data_risk_scores (
    Risk_ID INT AUTO_INCREMENT PRIMARY KEY,
    Control_ID INT,
    Table_Name VARCHAR(50),
    Column_Name VARCHAR(100),
    Failed_Records INT,
    Failure_Rate DECIMAL(10,4),
    Criticality VARCHAR(20),
    Risk_Score DECIMAL(10,2),
    Risk_Level VARCHAR(20),
    Assessment_Date DATE
);
INSERT INTO data_risk_scores
(
    Control_ID,
    Table_Name,
    Column_Name,
    Failed_Records,
    Failure_Rate,
    Criticality,
    Risk_Score,
    Risk_Level,
    Assessment_Date
)
SELECT
    d.Control_ID,
    d.Table_Name,
    d.Column_Name,
    d.Failed_Records,
    d.Failure_Rate,
    COALESCE(dd.Criticality, 'Medium'),

    ROUND(
        d.Failure_Rate * 100 *
        CASE
            WHEN COALESCE(dd.Criticality, 'Medium') = 'Critical' THEN 3
            WHEN COALESCE(dd.Criticality, 'Medium') = 'High' THEN 2
            ELSE 1
        END,
        2
    ),

    CASE
        WHEN d.Failed_Records > 0
             AND COALESCE(dd.Criticality, 'Medium') = 'Critical'
            THEN 'Critical'

        WHEN d.Failed_Records > 0
            THEN 'High'

        ELSE 'Low'
    END,

    CURRENT_DATE

FROM data_control_results d
LEFT JOIN data_dictionary dd
    ON d.Table_Name = dd.Table_Name
    AND d.Column_Name = dd.Column_Name;
SELECT
    Risk_ID,
    Control_ID,
    Table_Name,
    Column_Name,
    Failed_Records,
    Failure_Rate,
    Criticality,
    Risk_Score,
    Risk_Level,
    Assessment_Date
FROM data_risk_scores    
ORDER BY Risk_Score DESC;
SELECT
    Risk_Level,
    COUNT(*) AS Number_of_Risks,
    SUM(Failed_Records) AS Total_Failed_Records
FROM data_risk_scores
GROUP BY Risk_Level
ORDER BY
    CASE
        WHEN Risk_Level = 'Critical' THEN 1
        WHEN Risk_Level = 'High' THEN 2
        ELSE 3
    END;
    USE data_risk_lineage;

CREATE TABLE lineage_impact_summary (
    Impact_ID INT AUTO_INCREMENT PRIMARY KEY,
    Source_Table VARCHAR(50),
    Source_Column VARCHAR(50),
    Downstream_Table VARCHAR(50),
    Downstream_Column VARCHAR(50),
    Dependency_Type VARCHAR(50),
    Criticality VARCHAR(20),
    Impact_Score INT,
    Impact_Level VARCHAR(20)
);

INSERT INTO lineage_impact_summary
(
    Source_Table,
    Source_Column,
    Downstream_Table,
    Downstream_Column,
    Dependency_Type,
    Criticality,
    Impact_Score,
    Impact_Level
)
SELECT
    Source_Table,
    Source_Column,
    Target_Table,
    Target_Column,
    Dependency_Type,
    Criticality,
    CASE
        WHEN Criticality = 'Critical' THEN 3
        WHEN Criticality = 'High' THEN 2
        ELSE 1
    END,
    CASE
        WHEN Criticality = 'Critical' THEN 'Critical'
        WHEN Criticality = 'High' THEN 'High'
        ELSE 'Medium'
    END
FROM data_lineage;
SELECT
    Source_Table,
    Source_Column,
    Downstream_Table,
    Downstream_Column,
    Dependency_Type,
    Criticality,
    Impact_Score,
    Impact_Level
FROM lineage_impact_summary
ORDER BY Impact_Score DESC;
SELECT
    Impact_Level,
    COUNT(*) AS Dependency_Count
FROM lineage_impact_summary
GROUP BY Impact_Level
ORDER BY
    CASE
        WHEN Impact_Level = 'Critical' THEN 1
        WHEN Impact_Level = 'High' THEN 2
        ELSE 3
    END;
    USE data_risk_lineage;

CREATE TABLE schema_monitor (
    Schema_Check_ID INT AUTO_INCREMENT PRIMARY KEY,
    Table_Name VARCHAR(50),
    Column_Name VARCHAR(50),
    Expected_Data_Type VARCHAR(30),
    Expected_Criticality VARCHAR(20),
    Check_Date DATE
);
INSERT INTO schema_monitor
(
    Table_Name,
    Column_Name,
    Expected_Data_Type,
    Expected_Criticality,
    Check_Date
)
SELECT
    Table_Name,
    Column_Name,
    Data_Type,
    Criticality,
    CURRENT_DATE
FROM data_dictionary;
SELECT
    Table_Name,
    COUNT(*) AS Expected_Columns,
    SUM(
        CASE
            WHEN Expected_Criticality = 'Critical' THEN 1
            ELSE 0
        END
    ) AS Critical_Columns,
    SUM(
        CASE
            WHEN Expected_Criticality = 'High' THEN 1
            ELSE 0
        END
    ) AS High_Criticality_Columns
FROM schema_monitor
GROUP BY Table_Name
ORDER BY Table_Name;
SELECT
    Table_Name,
    Column_Name,
    Expected_Data_Type,
    Expected_Criticality,
    Check_Date
FROM schema_monitor
ORDER BY Table_Name, Column_Name;
CREATE OR REPLACE VIEW governance_dashboard AS
SELECT
    d.Control_ID,
    d.Control_Name,
    d.Table_Name,
    d.Column_Name,
    d.Failed_Records,
    d.Total_Records,
    d.Failure_Rate,
    d.Risk_Level,
    d.Control_Status,
    COALESCE(r.Issue_Status, 'No Issue') AS Issue_Status
FROM data_control_results d
LEFT JOIN remediation_issues r
    ON d.Control_ID = r.Control_ID;
    SELECT *
FROM governance_dashboard
ORDER BY
    CASE
        WHEN Risk_Level = 'Critical' THEN 1
        WHEN Risk_Level = 'High' THEN 2
        ELSE 3
    END,
    Failed_Records DESC;
    USE data_risk_lineage;

SELECT
    p.Program_ID,
    p.Treaty_ID,
    COUNT(DISTINCT p.Policy_ID) AS Policy_Count,
    ROUND(SUM(p.Premium), 2) AS Policy_Premium,
    ROUND(COALESCE(SUM(pr.BDX_Premium), 0), 2) AS BDX_Premium,
    ROUND(COALESCE(SUM(c.Total_Claims), 0), 2) AS Total_Claims,
    ROUND(
        COALESCE(SUM(c.Total_Claims), 0) /
        NULLIF(SUM(p.Premium), 0),
        4
    ) AS Loss_Ratio
FROM policies p
LEFT JOIN
(
    SELECT
        Policy_ID,
        SUM(Premium_Amount) AS BDX_Premium
    FROM premium_bdx
    GROUP BY Policy_ID
) pr
    ON p.Policy_ID = pr.Policy_ID
LEFT JOIN
(
    SELECT
        Policy_ID,
        SUM(Claim_Amount) AS Total_Claims
    FROM claims_bdx
    GROUP BY Policy_ID
) c
    ON p.Policy_ID = c.Policy_ID
GROUP BY
    p.Program_ID,
    p.Treaty_ID
ORDER BY
    Loss_Ratio DESC;
    SELECT
    Region,
    Risk_Category,
    COUNT(*) AS Policy_Count,
    ROUND(SUM(Premium), 2) AS Total_Premium,
    ROUND(AVG(Premium), 2) AS Average_Premium
FROM policies
GROUP BY
    Region,
    Risk_Category
ORDER BY
    Total_Premium DESC;
    SELECT
    YEAR(Claim_Date) AS Claim_Year,
    MONTH(Claim_Date) AS Claim_Month,
    COUNT(*) AS Claim_Count,
    ROUND(SUM(Claim_Amount), 2) AS Total_Claims
FROM claims_bdx
GROUP BY
    YEAR(Claim_Date),
    MONTH(Claim_Date)
ORDER BY
    Claim_Year,
    Claim_Month;
    
    SELECT
    YEAR(Transaction_Date) AS Transaction_Year,
    MONTH(Transaction_Date) AS Transaction_Month,
    COUNT(*) AS Transaction_Count,
    ROUND(SUM(Premium_Amount), 2) AS Total_BDX_Premium
FROM premium_bdx
GROUP BY
    YEAR(Transaction_Date),
    MONTH(Transaction_Date)
ORDER BY
    Transaction_Year,
    Transaction_Month;
    
    SELECT
    Risk_Level,
    COUNT(*) AS Risk_Count,
    SUM(Failed_Records) AS Failed_Records
FROM data_risk_scores
GROUP BY Risk_Level
ORDER BY
    CASE
        WHEN Risk_Level = 'Critical' THEN 1
        WHEN Risk_Level = 'High' THEN 2
        ELSE 3
    END;
    
    SELECT
    Table_Name,
    COUNT(*) AS Open_Issues,
    SUM(Failed_Records) AS Failed_Records
FROM remediation_issues
WHERE Issue_Status = 'Open'
GROUP BY Table_Name
ORDER BY Failed_Records DESC;
SELECT
    Risk_Level,
    COUNT(*) AS Number_of_Controls,
    SUM(Failed_Records) AS Total_Failed_Records,
    ROUND(AVG(Failure_Rate), 4) AS Average_Failure_Rate
FROM data_control_results
GROUP BY Risk_Level
ORDER BY
    CASE Risk_Level
        WHEN 'Critical' THEN 1
        WHEN 'High' THEN 2
        WHEN 'Medium' THEN 3
        ELSE 4
    END;
    
   

SELECT
    Control_Name,
    Table_Name,
    Column_Name,
    Failed_Records,
    Total_Records,
    Failure_Rate,
    Risk_Level,
    Control_Status
FROM data_control_results
WHERE Failed_Records > 0
ORDER BY Failed_Records DESC;



SELECT
    Table_Name,
    Column_Name,
    Failed_Records,
    Failure_Rate,
    Risk_Level
FROM data_control_results
WHERE Risk_Level IN ('Critical', 'High')
  AND Failed_Records > 0
ORDER BY
    CASE Risk_Level
        WHEN 'Critical' THEN 1
        WHEN 'High' THEN 2
        ELSE 3
    END,
    Failure_Rate DESC;



SELECT
    r.Issue_ID,
    r.Table_Name,
    r.Column_Name,
    r.Issue_Type,
    r.Failed_Records,
    r.Risk_Level,
    r.Issue_Status,
    r.Remediation_Action,
    r.Created_Date
FROM remediation_issues r
WHERE r.Issue_Status <> 'Resolved'
ORDER BY
    CASE r.Risk_Level
        WHEN 'Critical' THEN 1
        WHEN 'High' THEN 2
        WHEN 'Medium' THEN 3
        ELSE 4
    END,
    r.Failed_Records DESC;



SELECT
    p.Program_ID,
    p.Treaty_ID,
    COUNT(DISTINCT p.Policy_ID) AS Policy_Count,
    ROUND(SUM(p.Premium), 2) AS Total_Policy_Premium,
    ROUND(COALESCE(SUM(pr.BDX_Premium), 0), 2) AS Total_BDX_Premium,
    ROUND(COALESCE(SUM(c.Total_Claims), 0), 2) AS Total_Claims
FROM policies p
LEFT JOIN (
    SELECT
        Policy_ID,
        SUM(Premium_Amount) AS BDX_Premium
    FROM premium_bdx
    GROUP BY Policy_ID
) pr
    ON p.Policy_ID = pr.Policy_ID
LEFT JOIN (
    SELECT
        Policy_ID,
        SUM(Claim_Amount) AS Total_Claims
    FROM claims_bdx
    GROUP BY Policy_ID
) c
    ON p.Policy_ID = c.Policy_ID
GROUP BY
    p.Program_ID,
    p.Treaty_ID
ORDER BY Total_Claims DESC;



SELECT
    p.Region,
    COUNT(DISTINCT p.Policy_ID) AS Policy_Count,
    ROUND(SUM(p.Premium), 2) AS Total_Premium,
    ROUND(COALESCE(SUM(c.Claim_Amount), 0), 2) AS Total_Claims,
    ROUND(
        COALESCE(SUM(c.Claim_Amount), 0) / NULLIF(SUM(p.Premium), 0) * 100,
        2
    ) AS Loss_Ratio_Percent
FROM policies p
LEFT JOIN claims_bdx c
    ON p.Policy_ID = c.Policy_ID
GROUP BY p.Region
ORDER BY Loss_Ratio_Percent DESC;



SELECT
    p.Risk_Category,
    COUNT(DISTINCT p.Policy_ID) AS Policy_Count,
    ROUND(SUM(p.Premium), 2) AS Total_Premium,
    ROUND(COALESCE(SUM(c.Claim_Amount), 0), 2) AS Total_Claims,
    ROUND(
        COALESCE(SUM(c.Claim_Amount), 0) / NULLIF(SUM(p.Premium), 0) * 100,
        2
    ) AS Loss_Ratio_Percent
FROM policies p
LEFT JOIN claims_bdx c
    ON p.Policy_ID = c.Policy_ID
GROUP BY p.Risk_Category
ORDER BY Loss_Ratio_Percent DESC;



SELECT
    DATE_FORMAT(Transaction_Date, '%Y-%m') AS Transaction_Month,
    COUNT(*) AS Transaction_Count,
    ROUND(SUM(Premium_Amount), 2) AS Total_BDX_Premium,
    ROUND(AVG(Premium_Amount), 2) AS Average_Transaction_Premium
FROM premium_bdx
GROUP BY DATE_FORMAT(Transaction_Date, '%Y-%m')
ORDER BY Transaction_Month;



SELECT
    DATE_FORMAT(Claim_Date, '%Y-%m') AS Claim_Month,
    COUNT(*) AS Claim_Count,
    ROUND(SUM(Claim_Amount), 2) AS Total_Claims,
    ROUND(AVG(Claim_Amount), 2) AS Average_Claim
FROM claims_bdx
GROUP BY DATE_FORMAT(Claim_Date, '%Y-%m')
ORDER BY Claim_Month;



SELECT
    Claim_Status,
    COUNT(*) AS Claim_Count,
    ROUND(SUM(Claim_Amount), 2) AS Total_Claim_Amount,
    ROUND(AVG(Claim_Amount), 2) AS Average_Claim_Amount
FROM claims_bdx
GROUP BY Claim_Status
ORDER BY Total_Claim_Amount DESC;



SELECT
    dl.Source_Table,
    dl.Source_Column,
    dl.Target_Table,
    dl.Target_Column,
    dl.Dependency_Type,
    dl.Criticality,
    CASE
        WHEN dl.Criticality = 'Critical' THEN 3
        WHEN dl.Criticality = 'High' THEN 2
        ELSE 1
    END AS Impact_Score
FROM data_lineage dl
ORDER BY
    Impact_Score DESC,
    dl.Source_Table,
    dl.Source_Column;
    

SELECT
    p.Policy_ID,
    p.Program_ID,
    p.Treaty_ID,
    p.Premium AS Policy_Premium,
    COALESCE(SUM(pr.Premium_Amount), 0) AS BDX_Premium,
    ROUND(
        COALESCE(SUM(pr.Premium_Amount), 0) - p.Premium,
        2
    ) AS Premium_Variance
FROM policies p
LEFT JOIN premium_bdx pr
    ON p.Policy_ID = pr.Policy_ID
GROUP BY
    p.Policy_ID,
    p.Program_ID,
    p.Treaty_ID,
    p.Premium
HAVING ABS(Premium_Variance) > 0
ORDER BY ABS(Premium_Variance) DESC;



SELECT
    p.Program_ID,
    COUNT(DISTINCT p.Policy_ID) AS Policy_Count,
    COUNT(DISTINCT pr.Transaction_ID) AS BDX_Transactions,
    COUNT(DISTINCT c.Claim_ID) AS Claims_Count,
    ROUND(SUM(p.Premium), 2) AS Policy_Premium,
    ROUND(COALESCE(SUM(pr.Premium_Amount), 0), 2) AS BDX_Premium,
    ROUND(COALESCE(SUM(c.Claim_Amount), 0), 2) AS Claims
FROM policies p
LEFT JOIN premium_bdx pr
    ON p.Policy_ID = pr.Policy_ID
LEFT JOIN claims_bdx c
    ON p.Policy_ID = c.Policy_ID
GROUP BY p.Program_ID
ORDER BY Claims DESC;



SELECT
    p.Treaty_ID,
    COUNT(DISTINCT p.Policy_ID) AS Policy_Count,
    ROUND(SUM(p.Premium), 2) AS Total_Premium,
    ROUND(COALESCE(SUM(c.Claim_Amount), 0), 2) AS Total_Claims,
    ROUND(
        COALESCE(SUM(c.Claim_Amount), 0)
        / NULLIF(SUM(p.Premium), 0) * 100,
        2
    ) AS Loss_Ratio_Percent
FROM policies p
LEFT JOIN claims_bdx c
    ON p.Policy_ID = c.Policy_ID
GROUP BY p.Treaty_ID
ORDER BY Loss_Ratio_Percent DESC;



SELECT
    Policy_ID,
    COUNT(*) AS Transaction_Count,
    ROUND(SUM(Premium_Amount), 2) AS Total_BDX_Premium
FROM premium_bdx
GROUP BY Policy_ID
HAVING COUNT(*) > 1
ORDER BY Transaction_Count DESC;



SELECT
    Policy_ID,
    COUNT(*) AS Claim_Count,
    ROUND(SUM(Claim_Amount), 2) AS Total_Claims
FROM claims_bdx
GROUP BY Policy_ID
HAVING COUNT(*) > 1
ORDER BY Claim_Count DESC;



SELECT
    p.Policy_ID,
    p.Program_ID,
    p.Treaty_ID,
    p.Premium,
    COALESCE(SUM(c.Claim_Amount), 0) AS Total_Claims,
    ROUND(
        COALESCE(SUM(c.Claim_Amount), 0)
        / NULLIF(p.Premium, 0) * 100,
        2
    ) AS Policy_Loss_Ratio
FROM policies p
LEFT JOIN claims_bdx c
    ON p.Policy_ID = c.Policy_ID
GROUP BY
    p.Policy_ID,
    p.Program_ID,
    p.Treaty_ID,
    p.Premium
HAVING Policy_Loss_Ratio > 100
ORDER BY Policy_Loss_Ratio DESC;


-- Query 17
SELECT
    p.Program_ID,
    p.Treaty_ID,
    COUNT(DISTINCT p.Policy_ID) AS Policy_Count,
    ROUND(SUM(p.Premium), 2) AS Total_Premium,
    ROUND(COALESCE(SUM(c.Claim_Amount), 0), 2) AS Total_Claims,
    ROUND(
        COALESCE(SUM(c.Claim_Amount), 0)
        / NULLIF(SUM(p.Premium), 0) * 100,
        2
    ) AS Loss_Ratio_Percent,
    CASE
        WHEN COALESCE(SUM(c.Claim_Amount), 0)
             / NULLIF(SUM(p.Premium), 0) > 1
            THEN 'High Risk'
        WHEN COALESCE(SUM(c.Claim_Amount), 0)
             / NULLIF(SUM(p.Premium), 0) > 0.70
            THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS Portfolio_Risk
FROM policies p
LEFT JOIN claims_bdx c
    ON p.Policy_ID = c.Policy_ID
GROUP BY
    p.Program_ID,
    p.Treaty_ID
ORDER BY Loss_Ratio_Percent DESC;



SELECT
    Table_Name,
    Column_Name,
    Data_Type,
    Business_Definition,
    Criticality
FROM data_dictionary
WHERE Criticality IN ('Critical', 'High')
ORDER BY
    CASE Criticality
        WHEN 'Critical' THEN 1
        WHEN 'High' THEN 2
        ELSE 3
    END,
    Table_Name,
    Column_Name;



SELECT
    Source_Table,
    Source_Column,
    COUNT(*) AS Downstream_Dependencies,
    GROUP_CONCAT(
        CONCAT(Target_Table, '.', Target_Column)
        SEPARATOR ', '
    ) AS Impacted_Fields
FROM data_lineage
GROUP BY
    Source_Table,
    Source_Column
ORDER BY Downstream_Dependencies DESC;



SELECT
    d.Table_Name,
    COUNT(*) AS Total_Controls,
    SUM(CASE WHEN d.Failed_Records > 0 THEN 1 ELSE 0 END) AS Failed_Controls,
    SUM(CASE WHEN d.Failed_Records = 0 THEN 1 ELSE 0 END) AS Passed_Controls,
    ROUND(
        SUM(CASE WHEN d.Failed_Records > 0 THEN 1 ELSE 0 END)
        / COUNT(*) * 100,
        2
    ) AS Control_Failure_Percent
FROM data_control_results d
GROUP BY d.Table_Name
ORDER BY Control_Failure_Percent DESC;






SELECT
    Risk_Level,
    COUNT(*) AS Issue_Count,
    SUM(Failed_Records) AS Failed_Records,
    ROUND(AVG(Failure_Rate), 4) AS Avg_Failure_Rate
FROM data_control_results
WHERE Failed_Records > 0
GROUP BY Risk_Level
ORDER BY
    CASE Risk_Level
        WHEN 'Critical' THEN 1
        WHEN 'High' THEN 2
        WHEN 'Medium' THEN 3
        ELSE 4
    END;



SELECT
    r.Table_Name,
    r.Column_Name,
    r.Failed_Records,
    r.Failure_Rate,
    d.Criticality,
    ROUND(
        r.Failure_Rate *
        CASE
            WHEN d.Criticality = 'Critical' THEN 3
            WHEN d.Criticality = 'High' THEN 2
            ELSE 1
        END,
        4
    ) AS Calculated_Risk_Score
FROM data_control_results r
LEFT JOIN data_dictionary d
    ON r.Table_Name = d.Table_Name
    AND r.Column_Name = d.Column_Name
WHERE r.Failed_Records > 0
ORDER BY Calculated_Risk_Score DESC;



SELECT
    r.Table_Name,
    r.Column_Name,
    r.Issue_Type,
    r.Failed_Records,
    r.Risk_Level,
    r.Issue_Status,
    r.Remediation_Action
FROM remediation_issues r
ORDER BY
    CASE r.Issue_Status
        WHEN 'Open' THEN 1
        WHEN 'In Progress' THEN 2
        WHEN 'Resolved' THEN 3
        ELSE 4
    END,
    CASE r.Risk_Level
        WHEN 'Critical' THEN 1
        WHEN 'High' THEN 2
        WHEN 'Medium' THEN 3
        ELSE 4
    END;



SELECT
    dl.Source_Table,
    dl.Source_Column,
    COUNT(*) AS Downstream_Impact_Count,
    MAX(
        CASE
            WHEN dl.Criticality = 'Critical' THEN 3
            WHEN dl.Criticality = 'High' THEN 2
            ELSE 1
        END
    ) AS Highest_Impact_Score
FROM data_lineage dl
GROUP BY
    dl.Source_Table,
    dl.Source_Column
ORDER BY
    Highest_Impact_Score DESC,
    Downstream_Impact_Count DESC;



SELECT
    p.Program_ID,
    COUNT(DISTINCT p.Policy_ID) AS Policy_Count,
    COUNT(DISTINCT c.Claim_ID) AS Claim_Count,
    ROUND(SUM(p.Premium), 2) AS Premium,
    ROUND(COALESCE(SUM(c.Claim_Amount), 0), 2) AS Claims,
    ROUND(
        COALESCE(SUM(c.Claim_Amount), 0)
        / NULLIF(SUM(p.Premium), 0) * 100,
        2
    ) AS Loss_Ratio_Percent
FROM policies p
LEFT JOIN claims_bdx c
    ON p.Policy_ID = c.Policy_ID
GROUP BY p.Program_ID
ORDER BY Loss_Ratio_Percent DESC;



SELECT
    p.Program_ID,
    p.Region,
    p.Risk_Category,
    COUNT(DISTINCT p.Policy_ID) AS Policy_Count,
    ROUND(SUM(p.Premium), 2) AS Total_Premium
FROM policies p
GROUP BY
    p.Program_ID,
    p.Region,
    p.Risk_Category
ORDER BY
    p.Program_ID,
    Total_Premium DESC;



SELECT
    Claim_Status,
    COUNT(*) AS Claims,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS Claim_Percentage
FROM claims_bdx
GROUP BY Claim_Status
ORDER BY Claims DESC;



SELECT
    Transaction_Type,
    COUNT(*) AS Transaction_Count,
    ROUND(SUM(Premium_Amount), 2) AS Total_Premium,
    ROUND(AVG(Premium_Amount), 2) AS Average_Premium
FROM premium_bdx
GROUP BY Transaction_Type
ORDER BY Total_Premium DESC;



SELECT
    p.Policy_ID,
    p.Program_ID,
    p.Treaty_ID,
    p.Effective_Date,
    p.Expiry_Date,
    DATEDIFF(p.Expiry_Date, p.Effective_Date) AS Coverage_Days
FROM policies p
WHERE p.Expiry_Date < p.Effective_Date
ORDER BY Coverage_Days;



SELECT
    COUNT(*) AS Total_Policies,
    SUM(
        CASE
            WHEN Expiry_Date < Effective_Date THEN 1
            ELSE 0
        END
    ) AS Invalid_Date_Policies,
    ROUND(
        SUM(
            CASE
                WHEN Expiry_Date < Effective_Date THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS Invalid_Date_Rate
FROM policies;


SELECT
    p.Program_ID,
    COUNT(DISTINCT p.Policy_ID) AS Policy_Count,
    COUNT(DISTINCT pr.Transaction_ID) AS BDX_Transaction_Count,
    COUNT(DISTINCT c.Claim_ID) AS Claim_Count
FROM policies p
LEFT JOIN premium_bdx pr
    ON p.Policy_ID = pr.Policy_ID
LEFT JOIN claims_bdx c
    ON p.Policy_ID = c.Policy_ID
GROUP BY p.Program_ID
ORDER BY Policy_Count DESC;



SELECT
    p.Treaty_ID,
    COUNT(DISTINCT p.Policy_ID) AS Policy_Count,
    COUNT(DISTINCT c.Claim_ID) AS Claim_Count,
    ROUND(SUM(p.Premium), 2) AS Total_Premium,
    ROUND(COALESCE(SUM(c.Claim_Amount), 0), 2) AS Total_Claims
FROM policies p
LEFT JOIN claims_bdx c
    ON p.Policy_ID = c.Policy_ID
GROUP BY p.Treaty_ID
ORDER BY Total_Claims DESC;



SELECT
    p.Region,
    p.Risk_Category,
    COUNT(DISTINCT p.Policy_ID) AS Policy_Count,
    ROUND(SUM(p.Premium), 2) AS Total_Premium
FROM policies p
GROUP BY
    p.Region,
    p.Risk_Category
ORDER BY Total_Premium DESC;



SELECT
    p.Program_ID,
    COUNT(DISTINCT p.Policy_ID) AS Policy_Count,
    ROUND(SUM(p.Premium), 2) AS Total_Premium,
    ROUND(
        SUM(p.Premium) /
        NULLIF(SUM(SUM(p.Premium)) OVER (), 0) * 100,
        2
    ) AS Premium_Share_Percent
FROM policies p
GROUP BY p.Program_ID
ORDER BY Premium_Share_Percent DESC;



SELECT
    p.Treaty_ID,
    COUNT(DISTINCT p.Policy_ID) AS Policy_Count,
    ROUND(SUM(p.Premium), 2) AS Total_Premium,
    ROUND(
        SUM(p.Premium) /
        NULLIF(SUM(SUM(p.Premium)) OVER (), 0) * 100,
        2
    ) AS Premium_Share_Percent
FROM policies p
GROUP BY p.Treaty_ID
ORDER BY Premium_Share_Percent DESC;



SELECT
    p.Program_ID,
    COUNT(DISTINCT p.Policy_ID) AS Policy_Count,
    ROUND(SUM(p.Premium), 2) AS Total_Premium,
    ROUND(COALESCE(SUM(c.Claim_Amount), 0), 2) AS Total_Claims,
    ROUND(
        COALESCE(SUM(c.Claim_Amount), 0) /
        NULLIF(SUM(p.Premium), 0) * 100,
        2
    ) AS Loss_Ratio_Percent
FROM policies p
LEFT JOIN claims_bdx c
    ON p.Policy_ID = c.Policy_ID
GROUP BY p.Program_ID
HAVING SUM(p.Premium) > 0
ORDER BY Loss_Ratio_Percent DESC;



SELECT
    p.Risk_Category,
    COUNT(DISTINCT p.Policy_ID) AS Policy_Count,
    ROUND(SUM(p.Premium), 2) AS Total_Premium,
    ROUND(AVG(p.Premium), 2) AS Average_Premium,
    ROUND(MAX(p.Premium), 2) AS Maximum_Premium,
    ROUND(MIN(p.Premium), 2) AS Minimum_Premium
FROM policies p
GROUP BY p.Risk_Category
ORDER BY Total_Premium DESC;



SELECT
    DATE_FORMAT(c.Claim_Date, '%Y-%m') AS Claim_Month,
    c.Claim_Status,
    COUNT(*) AS Claim_Count,
    ROUND(SUM(c.Claim_Amount), 2) AS Claim_Amount
FROM claims_bdx c
GROUP BY
    DATE_FORMAT(c.Claim_Date, '%Y-%m'),
    c.Claim_Status
ORDER BY
    Claim_Month,
    c.Claim_Status;



SELECT
    p.Program_ID,
    COUNT(DISTINCT p.Policy_ID) AS Policy_Count,
    COUNT(DISTINCT CASE
        WHEN c.Claim_ID IS NOT NULL THEN p.Policy_ID
    END) AS Policies_With_Claims,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN c.Claim_ID IS NOT NULL THEN p.Policy_ID
        END) * 100.0 /
        NULLIF(COUNT(DISTINCT p.Policy_ID), 0),
        2
    ) AS Claim_Affected_Policy_Percent
FROM policies p
LEFT JOIN claims_bdx c
    ON p.Policy_ID = c.Policy_ID
GROUP BY p.Program_ID
ORDER BY Claim_Affected_Policy_Percent DESC;



SELECT
    d.Table_Name,
    d.Column_Name,
    d.Criticality,
    d.Business_Definition,
    COUNT(l.Lineage_ID) AS Downstream_Dependencies
FROM data_dictionary d
LEFT JOIN data_lineage l
    ON d.Table_Name = l.Source_Table
    AND d.Column_Name = l.Source_Column
GROUP BY
    d.Table_Name,
    d.Column_Name,
    d.Criticality,
    d.Business_Definition
HAVING
    d.Criticality IN ('Critical', 'High')
ORDER BY
    CASE d.Criticality
        WHEN 'Critical' THEN 1
        WHEN 'High' THEN 2
        ELSE 3
    END,
    Downstream_Dependencies DESC;
    

SELECT
    d.Control_ID,
    d.Control_Name,
    d.Table_Name,
    d.Column_Name,
    d.Failed_Records,
    d.Total_Records,
    d.Failure_Rate,
    d.Risk_Level,
    d.Control_Status
FROM data_control_results d
ORDER BY
    CASE d.Risk_Level
        WHEN 'Critical' THEN 1
        WHEN 'High' THEN 2
        WHEN 'Medium' THEN 3
        ELSE 4
    END,
    d.Failed_Records DESC;



SELECT
    d.Table_Name,
    COUNT(*) AS Total_Controls,
    SUM(CASE WHEN d.Control_Status = 'FAIL' THEN 1 ELSE 0 END) AS Failed_Controls,
    SUM(CASE WHEN d.Control_Status = 'PASS' THEN 1 ELSE 0 END) AS Passed_Controls,
    ROUND(
        SUM(CASE WHEN d.Control_Status = 'FAIL' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS Control_Failure_Rate
FROM data_control_results d
GROUP BY d.Table_Name
ORDER BY Control_Failure_Rate DESC;



SELECT
    d.Control_Name,
    d.Table_Name,
    d.Column_Name,
    d.Failed_Records,
    d.Failure_Rate,
    d.Risk_Level
FROM data_control_results d
WHERE d.Failed_Records > 0
ORDER BY d.Failure_Rate DESC;



SELECT
    r.Table_Name,
    r.Column_Name,
    COUNT(*) AS Issue_Count,
    SUM(r.Failed_Records) AS Total_Failed_Records
FROM remediation_issues r
GROUP BY
    r.Table_Name,
    r.Column_Name
ORDER BY Total_Failed_Records DESC;



SELECT
    r.Risk_Level,
    r.Issue_Status,
    COUNT(*) AS Issue_Count,
    SUM(r.Failed_Records) AS Failed_Records
FROM remediation_issues r
GROUP BY
    r.Risk_Level,
    r.Issue_Status
ORDER BY
    CASE r.Risk_Level
        WHEN 'Critical' THEN 1
        WHEN 'High' THEN 2
        WHEN 'Medium' THEN 3
        ELSE 4
    END;



SELECT
    ris.Table_Name,
    ris.Column_Name,
    ris.Failed_Records,
    ris.Failure_Rate,
    ris.Criticality,
    ris.Risk_Score,
    ris.Risk_Level
FROM data_risk_scores ris
ORDER BY ris.Risk_Score DESC;



SELECT
    Source_Table,
    Source_Column,
    Downstream_Table,
    Downstream_Column,
    Dependency_Type,
    Criticality,
    Impact_Score,
    Impact_Level
FROM lineage_impact_summary
ORDER BY
    Impact_Score DESC,
    Criticality;



SELECT
    Source_Table,
    Source_Column,
    COUNT(*) AS Downstream_Dependencies,
    SUM(Impact_Score) AS Total_Impact_Score
FROM lineage_impact_summary
GROUP BY
    Source_Table,
    Source_Column
ORDER BY Total_Impact_Score DESC;


SELECT
    Table_Name,
    Column_Name,
    Expected_Data_Type,
    Expected_Criticality,
    Check_Date
FROM schema_monitor
ORDER BY
    Table_Name,
    Column_Name;



SELECT
    Control_ID,
    Control_Name,
    Table_Name,
    Column_Name,
    Failed_Records,
    Failure_Rate,
    Risk_Level,
    Control_Status,
    Issue_Status
FROM governance_dashboard
ORDER BY
    CASE Risk_Level
        WHEN 'Critical' THEN 1
        WHEN 'High' THEN 2
        WHEN 'Medium' THEN 3
        ELSE 4
    END,
    Failed_Records DESC;



SELECT
    COUNT(*) AS Total_Data_Controls,
    SUM(CASE WHEN Failed_Records > 0 THEN 1 ELSE 0 END) AS Failed_Controls,
    SUM(CASE WHEN Failed_Records = 0 THEN 1 ELSE 0 END) AS Passed_Controls,
    SUM(Failed_Records) AS Total_Failed_Records,
    ROUND(AVG(Failure_Rate), 4) AS Average_Failure_Rate
FROM data_control_results;



SELECT
    COUNT(*) AS Total_Lineage_Relationships,
    SUM(
        CASE
            WHEN Criticality = 'Critical' THEN 1
            ELSE 0
        END
    ) AS Critical_Dependencies,
    SUM(
        CASE
            WHEN Criticality = 'High' THEN 1
            ELSE 0
        END
    ) AS High_Dependencies
FROM data_lineage;



SELECT
    COUNT(*) AS Total_Data_Elements,
    SUM(
        CASE
            WHEN Criticality = 'Critical' THEN 1
            ELSE 0
        END
    ) AS Critical_Data_Elements,
    SUM(
        CASE
            WHEN Criticality = 'High' THEN 1
            ELSE 0
        END
    ) AS High_Data_Elements,
    SUM(
        CASE
            WHEN Criticality = 'Medium' THEN 1
            ELSE 0
        END
    ) AS Medium_Data_Elements
FROM data_dictionary;



SELECT
    COUNT(*) AS Total_Policies,
    ROUND(SUM(Premium), 2) AS Total_Policy_Premium,
    ROUND(AVG(Premium), 2) AS Average_Policy_Premium,
    COUNT(DISTINCT Program_ID) AS Programs,
    COUNT(DISTINCT Treaty_ID) AS Treaties
FROM policies;



SELECT
    COUNT(*) AS Total_BDX_Transactions,
    ROUND(SUM(Premium_Amount), 2) AS Total_BDX_Premium,
    ROUND(AVG(Premium_Amount), 2) AS Average_BDX_Premium,
    SUM(
        CASE
            WHEN Premium_Amount IS NULL THEN 1
            ELSE 0
        END
    ) AS Null_Premium_Records,
    SUM(
        CASE
            WHEN Premium_Amount < 0 THEN 1
            ELSE 0
        END
    ) AS Negative_Premium_Records
FROM premium_bdx;



SELECT
    COUNT(*) AS Total_Claims,
    ROUND(SUM(Claim_Amount), 2) AS Total_Claim_Amount,
    ROUND(AVG(Claim_Amount), 2) AS Average_Claim_Amount,
    SUM(
        CASE
            WHEN Claim_Amount IS NULL THEN 1
            ELSE 0
        END
    ) AS Null_Claim_Records,
    SUM(
        CASE
            WHEN Claim_Amount < 0 THEN 1
            ELSE 0
        END
    ) AS Negative_Claim_Records
FROM claims_bdx;



SELECT
    p.Policy_ID,
    p.Program_ID,
    p.Treaty_ID,
    p.Premium AS Policy_Premium,
    COALESCE(pr.BDX_Premium, 0) AS BDX_Premium,
    COALESCE(c.Total_Claims, 0) AS Total_Claims,
    ROUND(
        COALESCE(c.Total_Claims, 0)
        / NULLIF(p.Premium, 0) * 100,
        2
    ) AS Loss_Ratio_Percent
FROM policies p
LEFT JOIN (
    SELECT
        Policy_ID,
        SUM(Premium_Amount) AS BDX_Premium
    FROM premium_bdx
    GROUP BY Policy_ID
) pr
    ON p.Policy_ID = pr.Policy_ID
LEFT JOIN (
    SELECT
        Policy_ID,
        SUM(Claim_Amount) AS Total_Claims
    FROM claims_bdx
    GROUP BY Policy_ID
) c
    ON p.Policy_ID = c.Policy_ID
ORDER BY Loss_Ratio_Percent DESC
LIMIT 100;



SELECT
    p.Program_ID,
    p.Treaty_ID,
    COUNT(DISTINCT p.Policy_ID) AS Policy_Count,
    ROUND(SUM(p.Premium), 2) AS Policy_Premium,
    ROUND(COALESCE(SUM(c.Total_Claims), 0), 2) AS Total_Claims,
    ROUND(
        COALESCE(SUM(c.Total_Claims), 0)
        / NULLIF(SUM(p.Premium), 0) * 100,
        2
    ) AS Loss_Ratio_Percent
FROM policies p
LEFT JOIN (
    SELECT
        Policy_ID,
        SUM(Claim_Amount) AS Total_Claims
    FROM claims_bdx
    GROUP BY Policy_ID
) c
    ON p.Policy_ID = c.Policy_ID
GROUP BY
    p.Program_ID,
    p.Treaty_ID
ORDER BY Loss_Ratio_Percent DESC;



SELECT
    p.Region,
    COUNT(DISTINCT p.Policy_ID) AS Policy_Count,
    ROUND(SUM(p.Premium), 2) AS Total_Premium,
    ROUND(COALESCE(SUM(c.Claim_Amount), 0), 2) AS Total_Claims,
    ROUND(
        COALESCE(SUM(c.Claim_Amount), 0)
        / NULLIF(SUM(p.Premium), 0) * 100,
        2
    ) AS Loss_Ratio_Percent
FROM policies p
LEFT JOIN claims_bdx c
    ON p.Policy_ID = c.Policy_ID
GROUP BY p.Region
ORDER BY Loss_Ratio_Percent DESC;



SELECT 
    'Policies' AS Data_Source, COUNT(*) AS Record_Count
FROM
    policies 
UNION ALL SELECT 
    'Premium BDX', COUNT(*)
FROM
    premium_bdx 
UNION ALL SELECT 
    'Claims BDX', COUNT(*)
FROM
    claims_bdx 
UNION ALL SELECT 
    'Data Dictionary', COUNT(*)
FROM
    data_dictionary 
UNION ALL SELECT 
    'Data Lineage', COUNT(*)
FROM
    data_lineage 
UNION ALL SELECT 
    'Data Controls', COUNT(*)
FROM
    data_control_results 
UNION ALL SELECT 
    'Remediation Issues', COUNT(*)
FROM
    remediation_issues;
    
    -- Power BI Dataset 1: Data Quality Overview
SELECT
    Control_Name,
    Table_Name,
    Column_Name,
    Failed_Records,
    Total_Records,
    Failure_Rate,
    Risk_Level,
    Control_Status
FROM data_control_results
ORDER BY Failed_Records DESC;

-- Power BI Dataset 2: Risk & Remediation
SELECT
    r.Issue_ID,
    r.Table_Name,
    r.Column_Name,
    r.Issue_Type,
    r.Failed_Records,
    r.Risk_Level,
    r.Issue_Status,
    r.Remediation_Action,
    r.Created_Date
FROM remediation_issues r
ORDER BY r.Failed_Records DESC;


-- Power BI Dataset 3: Lineage Impact
SELECT
    Source_Table,
    Source_Column,
    Downstream_Table,
    Downstream_Column,
    Dependency_Type,
    Criticality,
    Impact_Score,
    Impact_Level
FROM lineage_impact_summary
ORDER BY Impact_Score DESC;

-- Power BI Dataset 4: Program Financial Risk
SELECT
    p.Program_ID,
    p.Treaty_ID,
    COUNT(DISTINCT p.Policy_ID) AS Policy_Count,
    ROUND(SUM(p.Premium), 2) AS Total_Premium,
    ROUND(COALESCE(SUM(c.Total_Claims), 0), 2) AS Total_Claims,
    ROUND(
        COALESCE(SUM(c.Total_Claims), 0)
        / NULLIF(SUM(p.Premium), 0) * 100,
        2
    ) AS Loss_Ratio_Percent
FROM policies p
LEFT JOIN (
    SELECT
        Policy_ID,
        SUM(Claim_Amount) AS Total_Claims
    FROM claims_bdx
    GROUP BY Policy_ID
) c
    ON p.Policy_ID = c.Policy_ID
GROUP BY
    p.Program_ID,
    p.Treaty_ID
ORDER BY Loss_Ratio_Percent DESC;


-- Power BI Dataset 5: Critical Data Elements
SELECT
    d.Table_Name,
    d.Column_Name,
    d.Data_Type,
    d.Business_Definition,
    d.Criticality,
    COUNT(l.Lineage_ID) AS Downstream_Dependencies
FROM data_dictionary d
LEFT JOIN data_lineage l
    ON d.Table_Name = l.Source_Table
    AND d.Column_Name = l.Source_Column
GROUP BY
    d.Table_Name,
    d.Column_Name,
    d.Data_Type,
    d.Business_Definition,
    d.Criticality
ORDER BY
    CASE d.Criticality
        WHEN 'Critical' THEN 1
        WHEN 'High' THEN 2
        ELSE 3
    END,
    Downstream_Dependencies DESC;
