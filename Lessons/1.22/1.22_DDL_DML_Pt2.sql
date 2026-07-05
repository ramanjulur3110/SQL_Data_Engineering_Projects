CREATE OR REPLACE TABLE staging.job_postings_flat AS 
select 
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
    cd.name as company_name
from data_jobs.job_postings_fact jpf
left join data_jobs.company_dim cd
    on jpf.company_id = cd.company_id;


select count(*) from staging.job_postings_flat;

CREATE OR REPLACE VIEW staging.priority_jobs_flat_view AS
select 
    jpf.*
from staging.job_postings_flat jpf
join staging.priority_roles pr
    on jpf.job_title_short = pr.role_name
where pr.priority_lvl = 1;

select count(job_title_short)as count, job_title_short 
from staging.priority_jobs_flat_view
group by job_title_short
order by count desc;

CREATE TEMPORARY TABLE senior_jobs_flat_temp AS
select * from staging.priority_jobs_flat_view
where job_title_short = 'Senior Data Engineer';

select count(job_title_short)as count, job_title_short 
from senior_jobs_flat_temp
group by job_title_short
order by count desc;

select count(*) from staging.job_postings_flat;
select count(*) from staging.priority_jobs_flat_view;
select count(*) from senior_jobs_flat_temp;

DELETE from staging.job_postings_flat where job_posted_date < '2024-01-01';

select count(*) from staging.job_postings_flat;
select count(*) from staging.priority_jobs_flat_view;
select count(*) from senior_jobs_flat_temp;

TRUNCATE TABLE staging.job_postings_flat;

--select * from staging.job_postings_flat;

INSERT INTO staging.job_postings_flat
select 
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
    cd.name as company_name
from data_jobs.job_postings_fact jpf
left join data_jobs.company_dim cd
    on jpf.company_id = cd.company_id
where job_posted_date >= '2024-01-01';

select count(*) from staging.job_postings_flat;
select count(*) from staging.priority_jobs_flat_view;
select count(*) from senior_jobs_flat_temp;