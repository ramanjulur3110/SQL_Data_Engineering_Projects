SELECT 
    jpf.job_id, 
    jpf.job_title_short,
    cd.company_id,
    cd.name as company_name, 
    jpf.job_location
FROM 
    job_postings_fact jpf
LEFT JOIN company_dim cd
    on jpf.company_id = cd.company_id
LIMIT 10;