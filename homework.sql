--과제 join 실습8~13)

--실습 join8
SELECT r.region_id, r.region_name, c.country_name
FROM regions r, countries c
WHERE r.region_id = 1
AND r.region_id = c.region_id;

--실습 join9
SELECT r.region_id, r.region_name, c.country_name, city
FROM countries c, regions r, locations l
WHERE r.region_id = 1
AND c.region_id = r.region_id AND c.country_id = l.country_id;

--실습 join10
SELECT r.region_id, r.region_name, c.country_name, city, department_name
FROM countries c, regions r, locations l, departments d
WHERE r.region_id = 1
AND c.region_id = r.region_id AND c.country_id = l.country_id
AND l.location_id = d.location_id;

--실습 join11
SELECT r.region_id, r.region_name, c.country_name, city, department_name, 
       e.first_name || e.last_name name
FROM countries c, regions r, locations l, departments d, employees e
WHERE r.region_id = 1
AND c.region_id = r.region_id AND c.country_id = l.country_id
AND l.location_id = d.location_id AND d.department_id = e.department_id;

--실습 join12
SELECT employee_id, first_name || last_name name, j.job_id, job_title
FROM employees e, jobs j
WHERE e.job_id = j.job_id
ORDER BY j.job_id;

--실습 join13
SELECT e1.manager_id mng_id, e2.first_name || e2.last_name mgr_name,
       e1.employee_id, e1.first_name || e1.last_name name,
       j.job_id, job_title        
FROM employees e1, employees e2, jobs j
WHERE e1.manager_id = e2.employee_id
AND j.job_id = e1.job_id;

