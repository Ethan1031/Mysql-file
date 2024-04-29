CREATE TABLE job_applied(
    job_id INT,
    application_sent_date date,
    custom_resume boolean,
    resume_file_name varchar(255),
    cover_letter_sent boolean,
    cover_letter_file_name varchar(255),
    status varchar(50)
);

/* 
Full Order to write commands:
SELECT column1, column2, …
FROM/JOIN table_name
WHERE condition
GROUP BY column
HAVING condition
SELECT 
DISTINCT 
ORDER BY column1 [ASC|DESC] …
LIMIT/OFFSET number;
*/

/* 
INSERT INTO table_name (column_name, column_name2, ...)
VALUES (value1, value2);

ALTER TABLE table_name
    ADD column_name datatypes;
    RENAME COLUMN column_name TO new_name;
    ALTER COLUMN column_name TYPE datatype;
    DROP COLUMN column_name;

UPDATE table_name
SET column_name = 'new value'
WHERE condition;

ALTER TABLE table_name
RENAME COLUMN column_name TO new_name;

ALTER TABLE table_name
ALTER COLUMN column_name TYPE new_data_type;
ALTER COLUMN column_name SET DEFAULT default_value;
ALTER COLUMN column_name DROP DEFAULT; (remove default value from the column if one exists)

ALTER TABLE table_name
DROP COLUMN column_name;

DROP TABLE table_name

*/

-- altering table function
UPDATE job_applied
SET contact = 'Erlich Bachman'
WHERE job_id = 1;

ALTER TABLE job_applied
RENAME COLUMN contact TO contact_name;

SELECT *
FROM job_applied;
LIMIT  10;

-- SQL join, left right join and inner outer join
SELECT 
	job_postings.job_id,
	job_postings.job_title_short AS title
	job_postings.company_id AS company
FROM job_postings_fact AS job_postings

LEFT JOIN company_dim AS companies(join company_dim table with job_postings_fact table tgt)
	ON job_postings.company_id = companies.company_id (connecting the same columns name(company_id) of two table)

INNER JOIN skills_job_dim AS skills_to_job ON job_postings.job_id = skills_to_job.job_id
INNER JOIN skills_dim AS skills ON skills_to_job.skill_id = skills.skill_id


-- January
CREATE TABLE january_jobs AS 
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
    LIMIT 10;

-- February
CREATE TABLE february_jobs AS 
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2
    LIMIT 10;

-- March
CREATE TABLE march_jobs AS 
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3
    LIMIT 10;

SELECT job_posted_date
from march_jobs;

/* CASE EXPRESSION:
CASE, WHEN, THEN, ELSE, END
*/ 

SELECT 
	COUNT(job_id) AS number_of_jobs,
	CASE
	    WHEN job_location = ‘Anywhere’  THEN ‘Remote‘
        WHEN job_location = ‘NEW york’ THEN ‘Local ‘
        ELSE ‘O	nsite’
	END AS location_category
FROM 
	Job_postings_fact
WHERE 
    job_title_short = 'data analyst'
GROUP BY
    location_category;

/* CTEs - common table expression
select, insert, update, and delete statement
WITH - used to define cte at the beginning of a quary
*/

SELECT name AS company_name
FROM company_dim
WHERE company_id IN (
    SELECT 
        company_id
    from 
        Job_postings_fact
    WHERE 
        job_no_degree_mention = true
)

WITH january_jobs AS ( 
    SELECT * 
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
) -- cte definition ends here

SELECT *
FROM january_jobs;

/* find the companies which have the most job count, 
get the total number of job posting, 
and return the number of the jobs with the company name.
*/

WITH company_job_count AS (
    select 
        company_id,
        COUNT(*) AS total_jobs
    FROM
        job_postings_fact
    GROUP BY   
        company_id
)

SELECT *
from company_job_count

-- use left join to connect job posting fact table (B) with company dim (A)

select 
    company_dim.name AS company_name,
    company_job_count.total_jobs
from 
    company_dim
left join company_job_count ON company_job_count.company_id = company_dim.company_id
ORDER BY
    total_jobs desc

/* 
find the count of the number of remote job postings per skill, 
- display the tops five skills by their demand in remote jobs
- include skill id, name and count of positng jobs 
*/

WITH remote_job_skills AS (
select
    skills_id,
    count(*) AS skill_count
from 
    skills_job_dim AS skills_to_job
INNER JOIN
    job_postings_fact AS job_postings 
ON
    job_postings.job_id = skills_to_job.job_id
WHERE
    job_postings.job_work_from_home = true
GROUP BY
    skill_id
)

select 
    skills.skill_id,
    skills AS skill_name,
    skill_count
from remote_job_skills
INNER join 
    skills_dim AS skills on skills.skill_id = remote_job_skills.skill_id
ORDER BY 
    skill_count desc
LIMIT 5;

/* UNION Operators
UNION – remove duplicate rows
UNION ALL – includes all duplicate rows
*/
 
SELECT 
    job_title_short,
    company_id,
    job_location
from 
    january_jobs

UNION / UNION ALL

SELECT 
    job_title_short,
    company_id,
    job_location
from 
    february_jobs


/*
find the job postings from the first quarter(jan-march) that have a salary greater than 70k per year
*/

SELECT*
FROM(
    select *
    from january_jobs
    union all
    select *
    from february_jobs
    UNION all
    select *
    from march_jobs
) AS quarter_job_postings
WHERE
    salary_year_avg > 70000 and
    job_title_short = 'data analsyt'
ORDER BY 
    salary_year_avg DESC