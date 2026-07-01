/*
    This SQL query retrieves the top paying skills for the job title 'Data Engineer' that allow for remote work. 
    It calculates the median salary for each skill and filters out skills that appear in fewer than 100 job postings.
    The results are ordered by median salary in descending order, and only the top 25 skills are returned.
*/

select count(skills) as skill_count, skills, ROUND(median(salary_year_avg), 2) as median_salary_year_avg from 
(
    select 
        jpf.job_id,
        jpf.job_title_short, 
        jpf.job_work_from_home, 
        sd.skills,
        jpf.salary_year_avg
    from job_postings_fact jpf
    inner join skills_job_dim sjd 
        on sjd.job_id = jpf.job_id
    inner join skills_dim sd
        on sd.skill_id = sjd.skill_id
    where jpf.job_title_short = 'Data Engineer'
    --where jpf.job_title_short like ('%Data Engineer%')
    --and sd.skills is not null
    --and salary_year_avg is not null
        and jpf.job_work_from_home is TRUE
) as data_engineer_jobs
group by skills
having count(skills) > 100
order by median_salary_year_avg desc
limit 25;

/*
┌─────────────┬────────────┬────────────────────────┐
│ skill_count │   skills   │ median_salary_year_avg │
│    int64    │  varchar   │         double         │
├─────────────┼────────────┼────────────────────────┤
│         232 │ rust       │               210000.0 │
│        3248 │ terraform  │               184000.0 │
│         912 │ golang     │               184000.0 │
│         364 │ spring     │               175500.0 │
│         277 │ neo4j      │               170000.0 │
│         582 │ gdpr       │               169615.5 │
│         127 │ zoom       │               168437.5 │
│         445 │ graphql    │               167500.0 │
│         265 │ mongo      │               162250.0 │
│         204 │ fastapi    │               157500.0 │
│         478 │ bitbucket  │               155000.0 │
│         265 │ django     │               155000.0 │
│         129 │ crystal    │               154223.5 │
│         249 │ atlassian  │               151500.0 │
│         444 │ c          │               151500.0 │
│         388 │ typescript │               151000.0 │
│        4202 │ kubernetes │               150500.0 │
│         179 │ node       │               150000.0 │
│         736 │ ruby       │               150000.0 │
│        9996 │ airflow    │               150000.0 │
│         262 │ css        │               150000.0 │
│         605 │ redis      │               149000.0 │
│         136 │ vmware     │              148798.25 │
│         475 │ ansible    │              148798.25 │
│         400 │ jupyter    │               147500.0 │
└─────────────┴────────────┴────────────────────────┘