select UNNEST([1,1,1,2])
UNION ALL
select UNNEST([1,1,3]);

select UNNEST([1,1,1,2])
INTERSECT
select UNNEST([1,1,3]);

select UNNEST([1,1,1,2])
INTERSECT ALL
select UNNEST([1,1,3]);



WITH jobs_2023 as(
    select * EXCLUDE (job_id, job_posted_date)
    from job_postings_fact
    where YEAR(job_posted_date) = '2023'
),
jobs_2024 as (
    select * EXCLUDE (job_id, job_posted_date)
    from job_postings_fact
    where YEAR(job_posted_date) = '2024'
)

--select * from jobs_2024;

--Which unique job postings appeared in either 2023 or 2024

-- select * from jobs_2023
-- UNION
-- select * from jobs_2024;

--Which job postings appeared across both years, counting duplicates?

-- select * from jobs_2023
-- UNION ALL
-- select * from jobs_2024;

--Which job postings appeared in 2023 but not in 2024?

-- select * from jobs_2023
-- EXCEPT
-- select * from jobs_2024;

--Which job postings from 2023 remain after subtracting mathching 2024 postings, one-for-one?

-- select * from jobs_2023
-- EXCEPT ALL
-- select * from jobs_2024;

--Which job postings appeared in both 2023 and 2024?

-- select * from jobs_2023
-- INTERSECT
-- select * from jobs_2024;

--Which job postings appeared in both 2023 and 2024, preserving duplicates?
select * from jobs_2023
INTERSECT ALL
select * from jobs_2024;
