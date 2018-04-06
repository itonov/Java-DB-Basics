-- 1
SELECT `id`, `first_name`, `last_name`, `job_title` FROM `employees`
	ORDER BY `id`;
	
-- 2
SELECT `id`, CONCAT(`first_name`, ' ', `last_name`) AS `full_name`, `job_title`, `salary` FROM `employees`
	WHERE `salary` > 1000.00
	ORDER BY `id`;
	
-- 3
UPDATE `employees`
	SET `salary` = `salary` + (`salary` * 0.1)
	WHERE `job_title` = 'Therapist';
	
SELECT `salary` FROM `employees`
	ORDER BY `salary`;
	
-- 4
SELECT `id`, `first_name`, `last_name`, `job_title`, `department_id`, `salary` FROM `employees`
	ORDER BY `salary` DESC
	LIMIT 1;
	
-- 5
SELECT `id`, `first_name`, `last_name`, `job_title`, `department_id`, `salary` FROM `employees`
	WHERE `department_id` = 4 AND `salary` >= 1600;
	
-- 6
DELETE FROM `employees`
	WHERE `department_id` IN (1, 2);
	
SELECT `id`, `first_name`, `last_name`, `job_title`, `department_id`, `salary` FROM `employees`
	ORDER BY `id`;
	
-- 7
USE `soft_uni`;

SELECT `department_id`, `name`, `manager_id` FROM `departments`
	ORDER BY `department_id`;
	
-- 8 
SELECT `name` FROM `departments`
	ORDER BY `department_id`;
	
-- 9 
SELECT `first_name`, `last_name`, `salary` FROM `employees`
	ORDER BY `employee_id`;
	
-- 10 
SELECT `first_name`, `middle_name`, `last_name` FROM `employees`
	ORDER BY `employee_id`;
	
-- 11
SELECT CONCAT(`first_name`, '.', `last_name`, '@softuni.bg') AS `full_email_adress` FROM `employees`;

-- 12
SELECT DISTINCT `salary` FROM `employees`
	ORDER BY `employee_id`;
	
-- 13
SELECT `employee_id` AS `id`, `first_name` AS `First Name`, `last_name` AS `Last Name`, `middle_name` AS `Middle Name`, `job_title` AS `Job Title`, `department_id` AS `Dept ID`, `manager_id` AS `Mngr ID`, `hire_date` AS `Hire Date`, `salary`, `address_id` FROM `employees`
	WHERE `job_title` = 'Sales Representative'
	ORDER BY `employee_id`;
	
-- 14
SELECT `first_name`, `last_name`, `job_title` AS `JobTitle` FROM `employees`
	WHERE `salary` BETWEEN 20000 AND 30000
	ORDER BY `employee_id`;
	
-- 15
SELECT CONCAT(`first_name`, ' ', `middle_name`, ' ', `last_name`) AS `full_name` FROM `employees`
	WHERE `salary` IN (25000, 14000, 12500, 23600);
	
-- 16
SELECT `first_name`, `last_name` FROM `employees`
	WHERE `manager_id` IS NULL;
	
-- 17
SELECT `first_name`, `last_name`, `salary` FROM `employees`
	WHERE `salary` > 50000
	ORDER BY `salary` DESC;
	
-- 18
SELECT `first_name`, `last_name` FROM `employees`
	ORDER BY `salary` DESC
	LIMIT 5;
	
-- 19
SELECT `first_name`, `last_name` FROM `employees`
	WHERE NOT `department_id` = 4;
	
-- 20
SELECT `employee_id` AS `id`, `first_name` AS `First Name`, `last_name` AS `Last Name`, `middle_name` AS `Middle Name`, `job_title`, `department_id` AS `Dept ID`, `manager_id` AS `Mngr ID`,`hire_date` AS `Hire Date`, `salary`, `address_id` FROM `employees`
	ORDER BY `salary` DESC, `first_name` ASC, `last_name` DESC, `middle_name` ASC, `employee_id`;
	
-- 21
CREATE VIEW `v_employees_salaries`
	AS SELECT `first_name`, `last_name`, `salary` FROM `employees`;
	
-- 22 
CREATE VIEW `v_employees_job_titles` 
	AS SELECT CONCAT(`first_name`, ' ', IF(`middle_name` IS NULL, '', `middle_name`), ' ', `last_name`) AS `full_name`, `job_title` FROM `employees`;
	
-- 23
SELECT DISTINCT `job_title` FROM `employees`;

-- 24
SELECT `project_id` AS `id`, `name` AS `Name`, `description` AS `Description`, `start_date`, `end_date` FROM `projects`
	ORDER BY `start_date`, `name`, `project_id`
	LIMIT 10;
	
-- 25
SELECT `first_name`, `last_name`, `hire_date` FROM `employees`
	ORDER BY `hire_date` DESC
	LIMIT 7;
	
-- 26
UPDATE `employees`
	SET `salary` = `salary` + (`salary` * 0.12)
	WHERE `department_id` IN (1,2,4,11);
	
SELECT `salary` FROM `employees`;

-- 27
USE `geography`;

SELECT `peak_name` FROM `peaks`
	ORDER BY `peak_name` ASC;
	
-- 28
SELECT `country_name`, `population` FROM `countries`
	WHERE `continent_code` = 'EU'
	ORDER BY `population` DESC, `country_name` ASC
	LIMIT 30;
	
-- 29
SELECT `country_name`, `country_code`, IF(`currency_code` = 'EUR', 'Euro', 'Not Euro') AS `currency` FROM `countries`
	ORDER BY `country_name`;
	
-- 30
USE `diablo`;

SELECT `name` FROM `characters`
	ORDER BY `name`;