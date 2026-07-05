-- Step 4: Mart - Create skills mart table

-- Create the mart schema
DROP SCHEMA IF EXISTS skills_mart CASCADE;
CREATE SCHEMA skills_mart;

-- Skills dimension
SELECT '=== Loading Skills Dim for Skills Mart ===' as info;
DROP TABLE IF EXISTS skills_mart.dim_skills;
CREATE TABLE skills_mart.dim_skills(
    skill_id INTEGER PRIMARY KEY, 
    skills VARCHAR, 
    type VARCHAR
);

INSERT INTO skills_mart.dim_skills(skill_id, skills, type)
    SELECT 
        skill_id, 
        skills, 
        type
    FROM skills_dim;

-- Month-level date dimension (enhanced with quarter and other attributes)
SELECT '=== Loading Date Dim for Skills Mart ===' as info;
DROP TABLE IF EXISTS skills_mart.dim_date_month;
CREATE TABLE skills_mart.dim_date_month(
    month_start_date DATE PRIMARY KEY,
    year INT, 
    month INT, 
    quarter INT, 
    quarter_name VARCHAR, 
    year_quarter VARCHAR
);

INSERT INTO skills_mart.dim_date_month(month_start_date, year, month, quarter, quarter_name, year_quarter)
    select DISTINCT
        DATE_TRUNC('month', job_posted_date) as month_start_date,
        EXTRACT(YEAR from job_posted_date) as year,
        EXTRACT(MONTH from job_posted_date) as month,
        EXTRACT(QUARTER from job_posted_date) as quarter,
        CASE EXTRACT(QUARTER from job_posted_date) 
            WHEN 1 THEN 'Q1'
            WHEN 2 THEN 'Q2'
            WHEN 3 THEN 'Q3'
            WHEN 4 THEN 'Q4'
        END as quarter_name,
        CASE EXTRACT(QUARTER from job_posted_date) 
            WHEN 1 THEN CONCAT(EXTRACT(YEAR from job_posted_date),'-','Q1')
            WHEN 2 THEN CONCAT(EXTRACT(YEAR from job_posted_date),'-','Q2')
            WHEN 3 THEN CONCAT(EXTRACT(YEAR from job_posted_date),'-','Q3')
            WHEN 4 THEN CONCAT(EXTRACT(YEAR from job_posted_date),'-','Q4')
        END as year_quarter
    from job_postings_fact
    ORDER BY month_start_date;


-- Create fact table - fact_skill_demand_monthly
-- Grain: skill_id + month_start_date + job_title_short
-- All measures are additive (counts and sums) - safe to re-aggregate
SELECT '=== Loading Monthtly Skill Fact Dim for Skills Mart ===' as info;
DROP TABLE IF EXISTS skills_mart.fact_skill_demand_monthly;
CREATE TABLE skills_mart.fact_skill_demand_monthly(
    skill_id INT,
    month_start_date DATE,
    job_title_short VARCHAR, 
    postings_count INT, 
    remote_postings_count INT, 
    health_insurance_postings_count INT, 
    no_degree_mentioned_postings_count INT,
    PRIMARY KEY(skill_id, month_start_date, job_title_short),
    FOREIGN KEY(skill_id) REFERENCES skills_mart.dim_skills(skill_id),
    FOREIGN KEY(month_start_date) REFERENCES skills_mart.dim_date_month(month_start_date)
);

INSERT INTO skills_mart.fact_skill_demand_monthly(skill_id, month_start_date, job_title_short, postings_count, remote_postings_count, health_insurance_postings_count, no_degree_mentioned_postings_count)
WITH job_postings_prep AS(
    SELECT 
        sjd.skill_id, 
        DATE_TRUNC('month', jpf.job_posted_date)::DATE as month_start_date,
        jpf.job_title_short,
        -- convert boolean flags to (1 or 0)
        CASE WHEN jpf.job_work_from_home is TRUE then 1 ELSE 0 END as is_remote,
        CASE WHEN jpf.job_health_insurance is TRUE then 1 ELSE 0 END as has_health_insurance, 
        CASE WHEN jpf.job_no_degree_mention is TRUE then 1 ELSE 0 END as no_degree_mentioned, 
    FROM job_postings_fact jpf
    INNER JOIN skills_job_dim sjd
        ON sjd.job_id = jpf.job_id
)

SELECT 
    skill_id,
    month_start_date, 
    job_title_short,
    COUNT(*) as postings_count,
    SUM(is_remote) as remote_postigs_count, 
    SUM(has_health_insurance) as health_insurance_postings_count, 
    SUM(no_degree_mentioned) as no_degree_mentioned_postings_count
FROM job_postings_prep
GROUP BY ALL;

----FINISHED CREATING AND LOADING DIMENSION AND FACT TABLES FOR DEMAND MART IN THE 'skills_mart' SCHEMA----

-- DATA VALIDATION --
-- Verify data was loaded correctly
SELECT 'Skills Dimension' as table_name, COUNT(*) as record_count from skills_mart.dim_skills
UNION ALL
SELECT 'Date Month Dimention', COUNT(*) from skills_mart.dim_date_month
UNION ALL
SELECT 'Skill Demand Monthly Fact', COUNT(*) from skills_mart.fact_skill_demand_monthly;

-- Show sample data
SELECT '=== Skills Dimension Sample ===' AS info;
SELECT * FROM skills_mart.dim_skills LIMIT 5;

SELECT '=== Date Month Dimension Sample ===' AS info;
SELECT * FROM skills_mart.dim_date_month LIMIT 5;

SELECT '=== Skill Demand Montly Fact Sample ===' AS info;
SELECT * FROM skills_mart.fact_skill_demand_monthly LIMIT 5;