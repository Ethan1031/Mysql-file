/* 
what are the top skills based on salary?
-- look at the average salary for each skill for data analyst position
*/

SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS average_salary
FROM job_postings_fact
INNER JOIN skills_jobs_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill.id
WHERE
    job_title_short = 'Data Analyst' AND --(you can put any job position)
    salary_year_avg IS NOT NULL
    -- job_work_from_home = true (you can put any job location )
GROUP BY 
    skills
ORDER BY
    average_salary DESC
LIMIT 25
