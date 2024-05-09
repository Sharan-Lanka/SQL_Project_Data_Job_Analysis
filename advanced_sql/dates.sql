    CREATE table january_jobs as
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(month from job_posted_date) = 1;

    CREATE table febraury_jobs as
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(month from job_posted_date) = 2;

    CREATE table march_jobs as
    SELECT *
    FROM job_postings_fact
    WHERE EXTRACT(month from job_posted_date) = 3;

    select job_posted_date
    from march_jobs;

    SELECT
        job_title_short,
        job_location,
        case
            when job_location = 'Anywhere' then 'Remote'
            when job_location = 'New York, NY' then 'local'
            else 'Onsite'
        end as location_category
    FROM job_postings_fact;


    SELECT
        count(job_id) as number_of_jobs,
        case
            when job_location = 'Anywhere' then 'Remote'
            when job_location = 'New York, NY' then 'local'
            else 'Onsite'
        end as location_category
    FROM job_postings_fact
    where job_title_short = 'Data Analyst'
    GROUP BY
        location_category;


with remote_job_skills as (
        select
            skill_id,
            count(*) as skill_count
        from 
            skills_job_dim as skills_to_job
        inner join job_postings_fact as job_postings on job_postings.job_id = skills_to_job.job_id
        where
            job_postings.job_work_from_home = true and 
            job_postings.job_title_short = 'Data Analyst'
        group by skill_id
)

select 
    skills.skill_id,
    skills as skill_name,
    skill_count
from remote_job_skills
inner join skills_dim as skills on skills.skill_id = remote_job_skills.skill_id
order BY
    skill_count desc
Limit 5