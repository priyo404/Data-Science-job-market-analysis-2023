# 👉 Introduction : 
📊A Simple Analysis of the 2023 Job Market in the Field of Data Science Using SQL
This project explores trends and insights from the 2023 data science job market using real-world data (700k+ records). Through structured SQL queries and analysis, it investigates job demand, top companies, in-demand skills, and salary patterns — both in Bangladesh and globally.

Full SQL Code: [Priyo_Project](Priyo's_Project.sql) 
# 🎯 Objective :
I aimed to understand the data science job market both in Bangladesh and globally, focusing on:

- Job demand

- In-demand skills

- Number of job postings

- Identifying relevant companies hiring 
# 🛠️ Tools used : 
- PostgreSQL – for writing and executing SQL queries

- Excel – for data cleaning or visualization

- VS Code – as the code editor

- GitHub – for version control and project showcase
# 🔍 Project Analysis :
Each query aimed to find answers to a problem and how I approached solving it.

### 1. Creating a Bangladesh-Specific Table by Extracting and Filtering Data
I started by querying the original database containing over 700,000+ records spread across 4 separate tables. I joined these tables and selected relevant columns. 
```sql
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
```
Then, by filtering for Bangladesh-related data and applying additional queries, I created a new table with 987 records.Finally, I aggregated and sorted this data to produce a refined table of 180 records for analysis.
 ```sql
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
```
Output- Bd_jobs table has been created.

![Demanding job roles](https://raw.githubusercontent.com/priyo404/Data-Science-job-market-analysis-2023/main/5.png)


### 2. Top companies recruting in BD
Selected company names and associated job posting data, then aggregated the results to identify the top companies hiring for data-related roles.
```sql
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
```
Output- Top companies need data people (counting job post roles)

![Companies recruting](https://raw.githubusercontent.com/priyo404/Data-Science-job-market-analysis-2023/main/1.png)

### 3. Most Job postings in BD
counted total job postings based on job roles.
```sql
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
```
Output- Top demanding data job roles in bd

![Demanding job roles](https://raw.githubusercontent.com/priyo404/Data-Science-job-market-analysis-2023/main/2.png)

### 4. Globally top paying jobs in the data science field
Joined the company and job_postings tables, then selected relevant columns such as salary and location to identify high-paying data science roles globally. 
```sql
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
```
Output- Globaly approx pay scale of top data roles

![Demanding job roles](https://raw.githubusercontent.com/priyo404/Data-Science-job-market-analysis-2023/main/3.png)

### 5. Globally Demanding skills with respect to high paying skills 
I had to analyze which skills were top demanding and had good pay in upwards of 100k and skill_count of 500+. 

```sql
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
```
Output- These skills are relatively high paying in the job market.

![Demanding job roles](https://raw.githubusercontent.com/priyo404/Data-Science-job-market-analysis-2023/main/4.png)

# 💡 Insights :
- When comparing Bangladesh and the global job market, there are noticeable differences in popular job roles and salary levels.

- However, the in-demand skills remain largely similar across both markets.

- This similarity also extends to remote vs. onsite job postings, where the required skill sets show little variation. 
# 📘 What I learned :
- How to develop an analytical mindset when approaching real-world data problems

- Improved my SQL coding skills through hands-on query writing and optimization

- Gained experience in manipulating and managing databases


# 📌 Conclusion :
This project helped me strengthen my data analysis skills and develop a more structured, problem-solving approach using real-world data.


