---------------------Priyo's query----------------------------

--Extract bd data for data science jobs.
SELECT 
    job_postings_fact.job_title_short,
    company_dim.name,
    job_postings_fact.job_location,
    job_postings_fact.salary_year_avg,
    job_postings_fact.job_posted_date,
    STRING_AGG(skills_dim.skills, ', ') as skills
FROM 
    job_postings_fact
JOIN 
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
JOIN 
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
JOIN
    company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_postings_fact.job_location ilike '%Bangladesh%'
    
GROUP BY
    skills_dim.skills,
    company_dim.name,
    job_postings_fact.job_location,
    job_postings_fact.job_posted_date,
    job_postings_fact.job_title_short,
    job_postings_fact.salary_year_avg
;
--comments= total bd data 987


--Arranging skills based on job title.
SELECT 
    job_postings_fact.job_title_short,
    company_dim.name,
    job_postings_fact.job_location,
    job_postings_fact.salary_year_avg,
    job_postings_fact.salary_hour_avg,
    job_postings_fact.job_posted_date,
    STRING_AGG(skills_dim.skills, ', ') as skills
FROM 
    job_postings_fact
JOIN 
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
JOIN 
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
JOIN
    company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_postings_fact.job_location ilike '%Bangladesh%'
GROUP BY
    company_dim.name,
    job_postings_fact.job_location,
    job_postings_fact.job_posted_date,
    job_postings_fact.job_title_short,
    job_postings_fact.salary_year_avg,
    job_postings_fact.salary_hour_avg
;
--comments= After properly arranged skills vs job_title = 180 data.


--creating the bangladesh data table.
CREATE TABLE bangladesh_jobs AS
SELECT 
    job_postings_fact.job_title_short,
    company_dim.name,
    job_postings_fact.job_location,
    job_postings_fact.salary_year_avg,
    job_postings_fact.salary_hour_avg,
    job_postings_fact.job_posted_date,
    STRING_AGG(skills_dim.skills, ', ') as skills
FROM 
    job_postings_fact
JOIN 
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
JOIN 
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
JOIN
    company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_postings_fact.job_location ilike '%Bangladesh%'
GROUP BY
    company_dim.name,
    job_postings_fact.job_location,
    job_postings_fact.job_posted_date,
    job_postings_fact.job_title_short,
    job_postings_fact.salary_year_avg,
    job_postings_fact.salary_hour_avg
;

--Most job roles based on company in bangladesh_jobs table
SELECT 
    company_name,
    job_title_short,
    COUNT(*) as count
FROM 
    bangladesh_jobs
GROUP BY 
    company_name,
    job_title_short
ORDER BY 
    company_name DESC
;

---- Most job posted by company based on job_role in bd.
SELECT 
    company_name,
    COUNT(*) as job_title_short_count
FROM 
    bangladesh_jobs
GROUP BY 
    company_name
ORDER BY 
    job_title_short_count DESC
    limit 10
;

-- Most job posted based on role in bd.
SELECT 
    job_title_short,
    COUNT(*) as count
FROM 
    bangladesh_jobs
GROUP BY 
    job_title_short
ORDER BY 
    count DESC
LIMIT 5
;

---------------lukes Youtube tutorial query-------------------------------
--Globally top paying jobs in the data science field.
SELECT 
    job_title_short,
    salary_year_avg,
    job_location,
    job_posted_date,
    company_dim.name
FROM 
    job_postings_fact
JOIN
    company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    salary_year_avg IS NOT NULL
    AND job_location = 'Anywhere'
ORDER BY 
    salary_year_avg DESC
LIMIT 5
;

--Indemand jobs in the data science field.
SELECT 
    job_title_short,
    COUNT(*) as job_count
FROM 
    job_postings_fact
WHERE
    job_location = 'Anywhere'
GROUP BY
    job_title_short
ORDER BY
    job_count DESC
LIMIT 5
;

--Top skills for data analyst Globally.
SELECT 
    skills_dim.skills,
    COUNT(*) as skill_count
FROM 
    job_postings_fact
JOIN 
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
JOIN 
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_fact.job_location = 'Anywhere'
    AND job_postings_fact.job_title_short = 'Data Scientist'
GROUP BY
    skills_dim.skills
ORDER BY
    skill_count DESC
LIMIT 5
;
--comments= For Data analyst top skills are: SQL, Python, Excel, Tableau, powerbi.
   --For Business analyst top skills are: SQL, Excel, Power BI, Tableau, Python.
   --For Data scientist top skills are: Python, SQL, aws,azure,tableau.

--Demanding skills w.r.t high paying skills Globally.
SELECT 
    skills_dim.skills,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary,
    COUNT(*) AS skill_count
FROM 
    job_postings_fact
JOIN 
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
JOIN 
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_fact.job_location = 'Anywhere' AND
    job_postings_fact.salary_year_avg IS NOT NULL AND
    job_postings_fact.salary_year_avg > 100000
GROUP BY
    skills_dim.skills
HAVING
    COUNT(*) > 500
ORDER BY
    avg_salary DESC,
    skill_count DESC;
--comments= sql,python,spark,r,azure,aws.


SELECT 
    job_postings_fact.job_title_short,
    company_dim.name,
    job_postings_fact.job_location,
    job_postings_fact.salary_year_avg,
    job_postings_fact.job_posted_date,
    STRING_AGG(skills_dim.skills, ', ') as skills
FROM 
    job_postings_fact
JOIN 
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
JOIN 
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
JOIN
    company_dim ON job_postings_fact.company_id = company_dim.company_id
GROUP BY
    skills_dim.skills,
    company_dim.name,
    job_postings_fact.job_location,
    job_postings_fact.job_posted_date,
    job_postings_fact.job_title_short,
    job_postings_fact.salary_year_avg
;
