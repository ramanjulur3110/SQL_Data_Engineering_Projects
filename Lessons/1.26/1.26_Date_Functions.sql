SELECT 
    job_posted_date, 
    job_posted_date::DATE AS date,
    job_posted_date::TIME as time, 
    job_posted_date::TIMESTAMP as timestamp, 
    job_posted_date::TIMESTAMPTZ as timestamptz,
    EXTRACT(YEAR FROM job_posted_date) as job_posted_year,
    YEAR(job_posted_date) as job_posted_year2
from job_postings_fact
limit 10;

SELECT 
    EXTRACT (YEAR FROM job_posted_date) as job_posted_year, 
    EXTRACT (MONTH FROM job_posted_date) as job_posted_month, 
    COUNT(job_id) as job_count
FROM job_postings_fact
WHERE job_title_short = 'Data Engineer'
GROUP BY 
    EXTRACT (YEAR FROM job_posted_date),
    EXTRACT (MONTH FROM job_posted_date)
ORDER BY job_posted_year, job_posted_month;

SELECT 
    job_posted_date, 
    DATE_TRUNC('month', job_posted_date) as job_posted_month
FROM job_postings_fact
ORDER BY RANDOM()
LIMIT 10;

select count(job_id) as job_count, strftime(job_posted_date, '%Y-%m') as Year_Month
from job_postings_fact
where job_title_short = 'Data Engineer'
group by strftime(job_posted_date, '%Y-%m')
order by Year_Month DESC;


select '2026-01-01 12:00:00+00'::TIMESTAMPTZ AT TIME ZONE 'PST';