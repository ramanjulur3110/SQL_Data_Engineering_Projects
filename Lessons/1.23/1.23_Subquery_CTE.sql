-- Subuery

select * from 
    (
        SELECT * FROM job_postings_fact
        where salary_year_avg is not NULL
            or salary_hour_avg is not NULL
    ) as subquery
LIMIT 10;


-- Scenario 1 - Subqeuery in 'SELECT'
-- Show Each job's salary next to the overall market median. 

select job_title_short, salary_year_avg, (select median(salary_year_avg) from job_postings_fact) as job_market_median_salary
from job_postings_fact
where salary_year_avg is not NULL;

-- Scenario 2 - Subquery in 'FROM'
-- Stage only jobs that are remote before aggregating. 

select job_title_short, median(salary_year_avg) as job_market_median_salary, (select median(salary_year_avg) from job_postings_fact where job_work_from_home = 'Yes') as job_market_median_salary 
from 
    (
        select * from job_postings_fact
        where job_work_from_home = 'Yes'
    ) as remote_jobs
where salary_year_avg is not NULL
group by job_title_short;

--Scenario 3 - Subquery in 'WHERE'
-- Keep only jobs titles whos median salary is above the overall market median.

select * from 
    (
        select job_title_short, median(salary_year_avg) as job_title_median_salary, (select median(salary_year_avg) from job_postings_fact where job_work_from_home = 'Yes') as job_market_median_salary 
        from 
            (
                select * from job_postings_fact
                where job_work_from_home = 'Yes'
            ) as remote_jobs
        where salary_year_avg is not NULL
        group by job_title_short
    ) as subquery
where job_title_median_salary > job_market_median_salary;


-- CTE Example
-- Compare how much more (or less) remote roles pay compared to onsite roles for each job title.
-- USe a CTE to calculate the median salary by title and work arrangement, the compare those medians. 
with job_salary_location_preference as (
    select job_title_short, job_work_from_home, median(salary_year_avg) as median_salary
    from job_postings_fact
    where salary_year_avg is not NULL
    group by job_title_short, job_work_from_home
    order by job_title_short, job_work_from_home
    )


select job_title_short, remote_median_salary, onsite_median_salary, remote_median_salary - onsite_median_salary as salary_difference from 
(
    select a.job_title_short, a.job_work_from_home as remote, a.median_salary as remote_median_salary, b.job_work_from_home as onsite, b.median_salary as onsite_median_salary
    from job_salary_location_preference a
    left join (
        select * from job_salary_location_preference 
        where job_work_from_home is FALSE
        )b
        on a.job_title_short = b.job_title_short
    where a.job_work_from_home is TRUE
) as subquery;



select * from range (3) as src(key);
select * from range (2) as tgt(key);

select * from range (3) as src(key)
where not exists (
    SELECT 1 from range (2) as tgt(key)
    where tgt.key = src.key
);


-- Final Example 
-- Identify job postings that have no associated skills before loading them into the data mart. 

select * from job_postings_fact
limit 10;

select * from skills_job_dim
limit 10;

select count(*) from job_postings_fact
where job_id not in (select job_id from skills_job_dim);