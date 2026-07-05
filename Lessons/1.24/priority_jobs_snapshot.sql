--CREATE TEMP TABLE
CREATE or REPLACE TEMP TABLE src_priority_jobs as 
    select 
    jpf.job_id,
    jpf.job_title_short, 
    cd.name as company_name,
    jpf.job_posted_date as job_posting_date,
    jpf.salary_year_avg,
    r.priority_level,
    current_timestamp as updated_at
from data_jobs.job_postings_fact jpf
left join data_jobs.company_dim cd 
    on jpf.company_id = cd.company_id
inner join staging.priority_roles r
    on jpf.job_title_short = r.role_name;


-- --UPDATE statement
-- UPDATE main.priority_jobs_snapshot as tgt
-- SET
--     priority_level = src.priority_level,
--     updated_at = src.updated_at
-- FROM src_priority_jobs as src
-- WHERE tgt.job_id = src.job_id
--     and tgt.priority_level IS DISTINCT FROM src.priority_level;

-- --INSERT statement
-- INSERT INTO main.priority_jobs_snapshot (job_id, job_title_short, company_name, job_posting_date, salary_year_avg, priority_level, updated_at)
-- select 
--     src.job_id,
--     src.job_title_short, 
--     src.company_name,
--     src.job_posting_date,
--     src.salary_year_avg,
--     src.priority_level,
--     src.updated_at
-- from src_priority_jobs as src
-- where not exists (
--     select 1
--     from main.priority_jobs_snapshot as tgt
--     where tgt.job_id = src.job_id
-- );

-- --DELETE statement
-- DELETE FROM main.priority_jobs_snapshot 
-- where job_id not in (select job_id from src_priority_jobs);
-- ------ You can also run the following instead of the above if you are more comfortable with 'WHERE EXISTS' ------
-- --where not EXISTS (
-- --    select 1 
-- --    from src_priority_jobs as src
-- --    where tgt.job_id = src.job_id)


--MERGE INTO
MERGE INTO main.priority_jobs_snapshot as tgt 
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

select 
    job_title_short, 
    count(*) as job_count,
    min(priority_level) as min_priority_level,
    min(updated_at) as earliest_at
from main.priority_jobs_snapshot
group by job_title_short
order by job_count desc;
