SELECT 
    count(jpf.job_id) as job_count,
    cd.name as company_name
FROM 
    job_postings_fact jpf
LEFT JOIN company_dim cd
    on jpf.company_id = cd.company_id
WHERE jpf.job_country = 'United States'
GROUP BY cd.name
HAVING job_count > 3000
ORDER BY job_count desc 
LIMIT 10;

select * from job_postings_fact jpf
limit 10;

select * from company_dim cd
limit 10;

select distinct(job_country) from job_postings_fact jpf
    where job_country like ('U%');
