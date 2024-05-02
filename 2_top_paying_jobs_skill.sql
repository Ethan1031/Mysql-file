/*
what skills are required for the top-paying data analyst job?
-- use the top 10 highest-paying data analyst job from the first query
-- add the specific skills required for these jobs
-- WHY? it provided a detailed look at whichh high-aying jobs demand certain skill
*/

WITH top_paying_jobs AS (
    SELECT
        job_id, 
        job_title,
        job_location, 
        job_schedule_type, 
        salary_year_avg, 
        job_posted_date
        name as comapany_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_posting_fact.company_id = company_dim.company_id
    WHERE 
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT *
FROM top_paying_jobs
INNER JOIN skills_jobs_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill.id
ORDER BY
    salary_year_avg DESC

