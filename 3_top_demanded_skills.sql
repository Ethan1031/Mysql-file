/* 
find the count of the number of remote job postings per skill, 
- display the tops five skills by their demand in remote jobs
- include skill id, name and count of positng jobs 

CODE:

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

*/

-- Rewrite the code to make it more shorter, and take less time

SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_jobs_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill.id
WHERE
    job_title_short = 'Data Analyst' AND 
    job_work_from_home = TRUE
GROUP BY 
    skills
ORDER BY
    demand_count DESC
LIMIT 5
