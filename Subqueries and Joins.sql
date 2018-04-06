-- 1
USE `soft_uni`;

SELECT e.employee_id, CONCAT_WS(' ', e.first_name, e.last_name) AS 'full_name', d.department_id, d.name AS 'department_name'
	FROM `employees` AS e
	JOIN `departments` AS d
	ON e.employee_id = d.manager_id
	ORDER BY e.employee_id
	LIMIT 5;
	
-- 2
SELECT t.town_id, t.name AS 'town_name', a.address_text
 FROM `towns` AS t
 JOIN `addresses` AS a
 ON t.town_id = a.town_id
 WHERE t.name IN ('San Francisco', 'Sofia', 'Carnation')
 ORDER BY t.town_id, a.address_id;
 
-- 3
SELECT e.employee_id, e.first_name, e.last_name, e.department_id, e.salary
	FROM `employees` AS e
	JOIN `salaries` AS s
	ON e.department_id = s.department_id
	WHERE ISNULL(e.manager_id)
	ORDER BY e.employee_id;
	
-- 4
SELECT COUNT(emp.employee_id)
	FROM `employees` AS emp
	WHERE emp.salary > (SELECT AVG(e.salary)
		FROM `employees` AS e);
		
-- 5
SELECT e.employee_id, e.job_title, e.address_id, a.address_text
	FROM `employees` AS e
	INNER JOIN `addresses` AS a
	ON e.address_id = a.address_id
	ORDER BY e.address_id ASC
	LIMIT 5;
	
-- 6
SELECT e.first_name, e.last_name, t.name AS 'town', a.address_text
	FROM `employees` AS e
	INNER JOIN `addresses` AS a
	ON e.address_id = a.address_id
	INNER JOIN `towns` AS t
	ON a.town_id = t.town_id
	ORDER BY e.first_name, e.last_name
	LIMIT  5;
	
-- 7
SELECT e.employee_id, e.first_name, e.last_name, d.name AS 'department_name' 
	FROM `employees` AS e
	LEFT JOIN `departments` AS d
	ON e.department_id = d.department_id
	WHERE d.name LIKE ('Sales')
	ORDER BY e.employee_id DESC;
	
-- 8
SELECT e.employee_id, e.first_name, e.salary, d.name AS 'department_name'
	FROM `employees` AS e
	INNER JOIN `departments` AS d
	ON e.department_id = d.department_id
	WHERE e.salary > 15000
	ORDER BY e.department_id DESC
	LIMIT 5;
	
-- 9
SELECT e.employee_id, e.first_name
	FROM `employees` AS e
	LEFT JOIN `employees_projects` AS ep
	ON e.employee_id = ep.employee_id
	WHERE ep.project_id IS NULL
	ORDER BY e.employee_id DESC
	LIMIT 3;
	
-- 10
SELECT e.first_name, e.last_name, e.hire_date, d.name AS 'dept_name'
	FROM `employees` AS e
	INNER JOIN `departments` AS d
	ON e.department_id = d.department_id
	WHERE DATE(e.hire_date) > '1999-01-01'
	AND d.name IN ('Sales', 'Finance')
	ORDER BY e.hire_date ASC;
	
-- 11
SELECT e.employee_id, e.first_name, p.name AS 'project_name'
	FROM `employees` AS e
	INNER JOIN `employees_projects` AS ep
	ON e.employee_id = ep.employee_id
	INNER JOIN `projects` AS p
	ON ep.project_id = p.project_id
	WHERE DATE(p.start_date) > '2002.08.13' 
	AND p.end_date IS NULL
	ORDER BY e.first_name, p.name
	LIMIT 5; 
	
-- 12
SELECT e.employee_id, e.first_name, IF(YEAR(p.start_date) >= 2005, NULL, p.name) AS 'project_name' 
	FROM `employees` AS e
	INNER JOIN `employees_projects` AS ep
	ON e.employee_id = ep.employee_id
	INNER JOIN `projects` AS p
	ON ep.project_id = p.project_id
	WHERE e.employee_id = 24
	ORDER BY p.name;
	
-- 13
SELECT e.employee_id, e.first_name, e.manager_id, emp.first_name AS 'manager_name'
	FROM `employees` AS e
	INNER JOIN `employees` AS emp
	ON e.manager_id = emp.employee_id
	WHERE e.manager_id IN (3, 7)
	ORDER BY e.first_name;
	
-- 14
SELECT e.employee_id, CONCAT_WS(' ', e.first_name, e.last_name) AS 'employee_name', CONCAT(emp.first_name, ' ', emp.last_name) AS 'manager_name', d.name AS 'department_name' 
	FROM `employees` AS e
	INNER JOIN `employees` AS emp
	ON e.manager_id = emp.employee_id
	INNER JOIN `departments` AS d
	ON e.department_id = d.department_id
	ORDER BY e.employee_id
	LIMIT 5;
	
-- 15
SELECT avg_salary.avg_salary
	FROM (SELECT e.department_id, AVG(e.salary) AS 'avg_salary'
		FROM `employees` AS e
		GROUP BY e.department_id
		ORDER BY avg_salary) AS avg_salary
	LIMIT 1;
	
-- 16
USE `geography`;

SELECT c.country_code, m.mountain_range, p.peak_name, p.elevation
	FROM `countries` AS c
	INNER JOIN `mountains_countries` AS mc
	ON c.country_code = mc.country_code
	INNER JOIN `peaks` AS p
	ON mc.mountain_id = p.mountain_id
	INNER JOIN `mountains` AS m
	ON mc.mountain_id = m.id
	WHERE c.country_code LIKE ('BG')
	AND p.elevation > 2835
	ORDER BY p.elevation DESC;
	
-- 17
SELECT c.country_code, COUNT(m.mountain_range) AS 'mountain_range'
	FROM `countries` AS c
	INNER JOIN `mountains_countries` AS mc
	ON c.country_code = mc.country_code
	INNER JOIN `mountains` AS m
	ON mc.mountain_id = m.id
	WHERE c.country_name IN ('United States', 'Russia', 'Bulgaria')
	GROUP BY c.country_code
	ORDER BY `mountain_range` DESC;
	
-- 18
SELECT c.country_name, r.river_name
	FROM `countries` AS c
	LEFT JOIN `countries_rivers` AS cr
	ON c.country_code = cr.country_code
	LEFT JOIN `rivers` AS r
	ON cr.river_id = r.id
	INNER JOIN `continents` AS cn
	ON c.continent_code = cn.continent_code
	WHERE cn.continent_name LIKE ('Africa')
	ORDER BY c.country_name
	LIMIT 5;
	
-- 19
SELECT COUNT(c.country_code)
	FROM `countries` AS c
	LEFT JOIN `mountains_countries` AS mc
	ON c.country_code = mc.country_code
	WHERE mc.country_code IS NULL;
	
-- 20
SELECT c.country_name, MAX(p.elevation) AS 'highest_peak_elevation', MAX(r.`length`) AS 'longest_river_length'
	FROM `countries` AS c
	LEFT JOIN `mountains_countries` AS mc
	ON c.country_code = mc.country_code
	LEFT JOIN `peaks` AS p
	ON mc.mountain_id = p.mountain_id
	LEFT JOIN `countries_rivers` AS cr
	ON c.country_code = cr.country_code
	LEFT JOIN `rivers` AS r
	ON cr.river_id = r.id
	GROUP BY c.country_name
	ORDER BY highest_peak_elevation DESC, longest_river_length DESC, c.country_name ASC
	LIMIT 5;