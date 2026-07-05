-- .read 'Lessons\1.21\1.21_DDL_DML_Pt1.sql'

USE data_jobs;
DROP DATABASE IF EXISTS jobs_mart;
CREATE DATABASE IF NOT EXISTS jobs_mart;

SHOW DATABASES;

--select * from information_schema.schemata;

USE jobs_mart;
CREATE SCHEMA IF NOT EXISTS jobs_mart.staging;

CREATE TABLE IF NOT EXISTS staging.preferred_roles(
    role_id INT PRIMARY KEY, 
    role_name VARCHAR(255)
);

--SELECT * FROM information_schema.tables WHERE table_catalog = 'jobs_mart';

INSERT INTO staging.preferred_roles(role_id, role_name)
VALUES
    (1, 'Data Engineer'), 
    (2, 'Senior Data Engineer'),
    (3, 'Software Engineer');

SELECT * FROM staging.preferred_roles;

ALTER TABLE staging.preferred_roles ADD COLUMN preferred_role BOOLEAN;

--ALTER TABLE staging.preferred_roles DROP COLUMN preferred_role;

UPDATE staging.preferred_roles
set preferred_role = TRUE
where role_id IN (1, 2);

UPDATE staging.preferred_roles
set preferred_role = FALSE
where role_id IN (3);

ALTER TABLE IF EXISTS staging.preferred_roles RENAME TO priority_roles;

ALTER TABLE IF EXISTS staging.priority_roles RENAME COLUMN preferred_role TO priority_lvl;

alter table if exists staging.priority_roles alter column priority_lvl type INT;

UPDATE staging.priority_roles set priority_lvl = 3 where role_id IN (3);

select * from staging.priority_roles;