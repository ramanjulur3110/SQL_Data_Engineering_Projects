-- Step 3: Mart - Create flat mart table

DROP SCHEMA IF EXISTS flat_mart CASCADE;
CREATE SCHEMA flat_mart;

SELECT '=== Creating Flat Mart and loading data ====' as info;
CREATE OR REPLACE TABLE flat_mart.job_postings as 
    SELECT 
        --Fact table fields
        jpf.job_id, 
        jpf.job_title_short, 
        jpf.job_title, 
        jpf.job_location, 
        jpf.job_via, 
        jpf.job_schedule_type, 
        jpf.job_work_from_home, 
        jpf.search_location,
        jpf.job_posted_date, 
        jpf.job_no_degree_mention, 
        jpf.job_health_insurance, 
        jpf.job_country, 
        jpf.salary_rate, 
        jpf.salary_year_avg, 
        jpf.salary_hour_avg,
        --Company Dimension Fields
        cd.company_id,
        cd.name as company_name,
        ARRAY_AGG(
            STRUCT_PACK(
                type := sd.type,
                name := sd.skills
            )
        ) as skills_and_types
    FROM job_postings_fact as jpf
    LEFT JOIN company_dim cd  
        on jpf.company_id = cd.company_id
    LEFT JOIN skills_job_dim sjd
        on sjd.job_id = jpf.job_id
    LEFT JOIN skills_dim sd
        on sd.skill_id = sjd.skill_id
    GROUP BY     jpf.job_id, 
        jpf.job_title_short, 
        jpf.job_title, 
        jpf.job_location, 
        jpf.job_via, 
        jpf.job_schedule_type, 
        jpf.job_work_from_home, 
        jpf.search_location,
        jpf.job_posted_date, 
        jpf.job_no_degree_mention, 
        jpf.job_health_insurance, 
        jpf.job_country, 
        jpf.salary_rate, 
        jpf.salary_year_avg, 
        jpf.salary_hour_avg,
        cd.company_id,
        cd.name
    ORDER BY job_id;

-- DATA VALIDATION
SELECT 'Flat Mart Job Postings' as table_name, count(*) as record_count
FROM flat_mart.job_postings;

SELECT '=== Flat Mart Sample ====' as info;
SELECT * FROM flat_mart.job_postings LIMIT 10;