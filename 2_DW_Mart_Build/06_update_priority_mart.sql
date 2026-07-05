-- Step 6: Mart - Update priority roles mart

SELECT '=== Updating Roles for Priority Mart ===' as info;
-- Update Data Engineer to Priority 1
UPDATE priority_mart.priority_roles
    SET priority_level = 1 
    WHERE role_name = 'Data Engineer';

-- Add Data Scientist as Level 3
INSERT INTO priority_mart.priority_roles (role_id, role_name, priority_level)
VALUES (4, 'Data Scientist', 3);

SELECT * FROM priority_mart.priority_roles;

SELECT '=== Creating Temp Source Table for Priority Mart ===' as info;
-- CREATE TEMP Table
CREATE or REPLACE TEMP TABLE src_priority_jobs as 
    select 
    jpf.job_id,
    jpf.job_title_short, 
    cd.name as company_name,
    jpf.job_posted_date as job_posting_date,
    jpf.salary_year_avg,
    r.priority_level,
    current_timestamp as updated_at
from job_postings_fact jpf
left join company_dim cd 
    on jpf.company_id = cd.company_id
inner join priority_mart.priority_roles r
    on jpf.job_title_short = r.role_name;


SELECT '=== Batch Updating priority_jobs_snapshot Priority Mart ===' as info;
--MERGE INTO
MERGE INTO priority_mart.priority_jobs_snapshot as tgt 
USING src_priority_jobs as src
ON tgt.job_id = src.job_id
WHEN MATCHED and tgt.priority_level IS DISTINCT FROM src.priority_level THEN
    UPDATE SET
        priority_level = src.priority_level,
        updated_at = src.updated_at
WHEN NOT MATCHED THEN
    INSERT (job_id, job_title_short, company_name, job_posting_date, salary_year_avg, priority_level, updated_at)
    VALUES (
        src.job_id,
        src.job_title_short, 
        src.company_name,
        src.job_posting_date,
        src.salary_year_avg,
        src.priority_level,
        src.updated_at
    )
WHEN NOT MATCHED BY SOURCE THEN DELETE;

--Final Check Query--
select 
    job_title_short, 
    count(*) as job_count,
    min(priority_level) as min_priority_level,
    min(updated_at) as earliest_at
from priority_mart.priority_jobs_snapshot
group by job_title_short
order by job_count desc;
