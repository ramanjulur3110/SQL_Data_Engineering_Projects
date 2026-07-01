/*
    This query is used to find the top 10 most demanded skills for Data Engineer (inlcuding Senior Data Engineers as well) jobs that allow working from home.
    It counts the occurrences of each skill associated with job postings that match the criteria and orders them in descending order.
*/

select count(skills), skills from
    (
        select 
            jpf.job_id,
            jpf.job_title_short, 
            jpf.job_work_from_home, 
            sd.skills
        from job_postings_fact jpf
        left join skills_job_dim sjd 
            on sjd.job_id = jpf.job_id
        left join skills_dim sd
            on sd.skill_id = sjd.skill_id
        where jpf.job_title_short like ('%Data Engineer%')
        --where jpf.job_title_short = ('%Data Engineer%')
        and jpf.job_work_from_home is TRUE
    ) as data_engineer_jobs
group by skills
order by count(skills) desc
limit 10;
 
 /*
┌───────────────┬────────────┐
│ count(skills) │   skills   │
│     int64     │  varchar   │
├───────────────┼────────────┤
│         38368 │ sql        │
│         38117 │ python     │
│         24514 │ aws        │
│         18707 │ azure      │
│         17591 │ spark      │
│         13395 │ airflow    │
│         11781 │ snowflake  │
│         10962 │ databricks │
│          9993 │ java       │
│          9315 │ kafka      │
└───────────────┴────────────┘
 */