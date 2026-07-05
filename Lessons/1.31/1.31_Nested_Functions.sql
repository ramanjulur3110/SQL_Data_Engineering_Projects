select [1,2,3];

select ['python', 'sql', 'r'] as skills_array;

WITH skills as (
    select 'python' as skill
    UNION ALL
    select 'sql'
    UNION ALL 
    select 'r'
),
skills_array as (
    SELECT ARRAY_AGG(skill ORDER BY SKILL) as skills
    from skills
)

select 
    skills[1] as first_skill,
    skills[2] as second_skill,
    skills[3] as third_skill,
from skills_array;

--STRUCT
SELECT {skill: 'python', type: 'programming'} as skill_struct;

with skill_struct as (
    SELECT 
        STRUCT_PACK(
            skill := 'python', 
            type := 'programming'
        ) as s
)

select 
    s.skill,
    s.type
from skill_struct;

WITH skill_table as(
    select 'python' as skills, 'programming' as types
    UNION ALL
    select 'sql', 'query_language'
    UNION ALL 
    select 'r', 'programming'
)

SELECT
    STRUCT_PACK(
        skill := skills,
        type := types
    )
FROM skill_table;

--Array of Structs
SELECT[
    {skill:'python', type:'programming'},
    {skill: 'sql', tyep:'query_language'}
] as skills_array_of_structs;

WITH skill_table as(
    select 'python' as skills, 'programming' as types
    UNION ALL
    select 'sql', 'query_language'
    UNION ALL 
    select 'r', 'programming'
),
skills_array_struct as (
    SELECT
        ARRAY_AGG(
            STRUCT_PACK(
                skill := skills,
                type := types
            )
        ) array_struct
    FROM skill_table
)

select array_struct[1] from skills_array_struct;

--MAP
WITH skill_map as (
    select MAP{'skill':'python', 'type':'programming'} as skill_type
)

select 
    skill_type['skill'], 
    skill_type['type'] 
from skill_map;

--JSON
WITH raw_skill_json as (
    SELECT 
        --TO_JSON('{"skill":"python", "type":"programming"}') as skill_json; --Not Ideal
        '{"skill":"python", "type":"programming"}'::JSON as skill_json
)

SELECT
    STRUCT_PACK(
        skill := json_extract_string(skill_json, '$.skill'),
        type := json_extract_string(skill_json, '$.type')
    )
FROM raw_skill_json;

-- Arrays - Final Example
-- Build a flat skill table for co-workers to access job titles, salary info, and skills in one table. 

CREATE OR REPLACE TEMP TABLE job_skills_array as 
    select 
        jpf.job_id, 
        jpf.job_title_short, 
        jpf.salary_year_avg, 
        ARRAY_AGG(sd.skills) as skills_array
    from job_postings_fact jpf
    left join skills_job_dim sjd
        on sjd.job_id = jpf.job_id
    left join skills_dim sd
        on sd.skill_id = sjd.skill_id
    group by jpf.job_id, jpf.job_title_short, jpf.salary_year_avg
    order by job_id;

-- From the perspective of a Data Analyst, analyze the median salary per skill.

with flat_skills as (
    select
        job_id, 
        job_title_short, 
        salary_year_avg, 
        UNNEST(skills_array) as skill
    from job_skills_array
)

select 
    skill,
    MEDIAN(salary_year_avg) as median_salary
FROM flat_skills
GROUP BY skill
ORDER BY median_salary DESC;

-- Array of Structs - Final Example
-- Build a flat skill & type table for co-workers to access job titles, salary info, skills, and type in one table

CREATE OR REPLACE TEMP TABLE job_skills_array_struct as 
select 
    jpf.job_id, 
    jpf.job_title_short, 
    jpf.salary_year_avg, 
    ARRAY_AGG(
        STRUCT_PACK(
            skill_type := sd.type,
            skill_name := sd.skills
        )
    ) as skills_type
from job_postings_fact jpf
left join skills_job_dim sjd
    on sjd.job_id = jpf.job_id
left join skills_dim sd
    on sd.skill_id = sjd.skill_id
group by jpf.job_id, jpf.job_title_short, jpf.salary_year_avg
order by job_id;

-- From the perspective of a Data Analyst, analyst the median salary per type of skill

with flat_skills as (
    SELECT 
        job_id, job_title_short, salary_year_avg, 
        UNNEST(skills_type).skill_type as skill_type,
        UNNEST(skills_type).skill_name as skill_name
    FROM 
        job_skills_array_struct
)

select 
    skill_type,
    MEDIAN(salary_year_avg) as median_salary
FROM flat_skills
GROUP BY skill_type
ORDER BY median_salary DESC;