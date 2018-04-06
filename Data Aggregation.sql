-- 1
USE `restaurant`;

SELECT `department_id`, COUNT(`id`) AS 'Number of employees'
	FROM `employees`
	GROUP BY `department_id`;
	
-- 2
SELECT `department_id`, ROUND(AVG(`salary`), 2) AS 'Average Salary'
	FROM `employees`
	GROUP BY `department_id`;
	
-- 3
SELECT `department_id`, ROUND(MIN(`salary`), 2) AS 'Min Salary'
	FROM `employees`
	GROUP BY `department_id`
	HAVING `Min Salary` > 800;
	
-- 4
SELECT COUNT(`name`) AS 'Appetizers Count'
	FROM `products`
	WHERE `category_id` = 2 AND `price` > 8
	GROUP BY `category_id`;
	
-- 5
SELECT `category_id`, ROUND(AVG(`price`), 2) AS 'Average Price', ROUND(MIN(`price`), 2) AS 'Cheapest Product', ROUND(MAX(`price`), 2) AS 'Most Expensive Product' 
	FROM `products`
	GROUP BY `category_id`;
	
-- 6
USE `gringotts`;

SELECT COUNT(*) AS 'count'
	FROM `wizzard_deposits`;
	
-- 7 
SELECT MAX(`magic_wand_size`) AS 'longest_magic_wand' 
	FROM `wizzard_deposits`;
	
-- 8
SELECT `deposit_group`, MAX(`magic_wand_size`) AS 'longest_magic_wand'
	FROM `wizzard_deposits`
	GROUP BY `deposit_group`
	ORDER BY `longest_magic_wand`, `deposit_group`;
	
-- 9 
SELECT mw.dp
	FROM (SELECT wd.deposit_group AS dp, AVG(wd.magic_wand_size) AS avg_size
	FROM `wizzard_deposits` AS wd
	GROUP BY wd.deposit_group
	ORDER BY avg_size ASC
	LIMIT 1) AS mw;
	
-- 10
SELECT `deposit_group`, SUM(`deposit_amount`) AS 'total_sum'
	FROM `wizzard_deposits`
	GROUP BY `deposit_group`
	ORDER BY `total_sum`;
	
-- 11
SELECT `deposit_group`, SUM(`deposit_amount`) AS 'total_sum'
	FROM `wizzard_deposits`
	WHERE `magic_wand_creator` LIKE ("Ollivander family")
	GROUP BY `deposit_group`
	ORDER BY `deposit_group`;
	
-- 12
SELECT `deposit_group`, SUM(`deposit_amount`) AS 'total_sum'
	FROM `wizzard_deposits`
	WHERE `magic_wand_creator` LIKE ("Ollivander family")
	GROUP BY `deposit_group`
	HAVING `total_sum` < 150000
	ORDER BY `total_sum` DESC;
	
-- 13
SELECT `deposit_group`, `magic_wand_creator`, MIN(`deposit_charge`) AS 'min_deposit_charge'
	FROM `wizzard_deposits`
	GROUP BY `deposit_group`, `magic_wand_creator`
	ORDER BY `magic_wand_creator`, `deposit_group`;
	
-- 14
SELECT IF(`age` < 11, '[0-10]', IF(`age` < 21, '[11-20]', IF(`age` < 31, '[21-30]', IF(`age` < 41, '[31-40]', IF(`age` < 51, '[41-50]', IF(`age` < 61, '[51-60]', '[61+]')))))) AS 'age_group', COUNT(`id`) AS 'wizard_count' 
	FROM `wizzard_deposits`
	GROUP BY `age_group`
	ORDER BY `age_group`;
	
-- 15
SELECT LEFT(`first_name`, 1) AS 'first_letter'
	FROM `wizzard_deposits`
	WHERE `deposit_group` LIKE ("Troll Chest")
	GROUP BY `first_letter`
	ORDER BY `first_letter`;
	
-- 16
SELECT `deposit_group`, `is_deposit_expired`, AVG(`deposit_interest`) AS 'average_interest'
	FROM `wizzard_deposits`
	WHERE `deposit_start_date` > '1985-01-01'
	GROUP BY `deposit_group`, `is_deposit_expired`
	ORDER BY `deposit_group` DESC, `is_deposit_expired` ASC;
	
-- 17
SELECT SUM(diff.difference)
	FROM (SELECT wd1.deposit_amount - wd2.deposit_amount AS 'difference'
		FROM `wizzard_deposits` AS wd1, `wizzard_deposits` AS wd2
		WHERE wd2.id - wd1.id = 1) AS diff;
		
-- 18
USE `soft_uni`;

SELECT `department_id`, MIN(`salary`) AS 'minimum_salary' 
	FROM `employees`
	WHERE `hire_date` > '2000-01-01'
	GROUP BY `department_id`
	HAVING `department_id` IN (2, 5, 7)
	ORDER BY `department_id`;
	
-- 19
CREATE TABLE `salaries`
	AS (SELECT `department_id`, `salary`
		FROM `employees`
		WHERE `salary` > 30000 AND `manager_id` NOT IN (42));
		
UPDATE `salaries`
	SET `salary` = `salary` + 5000
	WHERE `department_id` = 1;
	
SELECT `department_id`, AVG(`salary`) AS 'avg_salary'
	FROM `salaries`
	GROUP BY `department_id`
	ORDER BY `department_id`; 
	
-- 20
SELECT `department_id`, MAX(`salary`) AS 'max_salary'
	FROM `employees`
	GROUP BY `department_id`
	HAVING `max_salary` NOT BETWEEN 30000 AND 70000;
	
-- 21
SELECT COUNT(`salary`) 
	FROM `employees`
	WHERE `manager_id` IS NULL;
	
-- 22
SELECT e3.department_id, MAX(e3.salary) 
	FROM `employees` AS e3
	JOIN
		(SELECT e.department_id AS department_id, MAX(e.salary) AS second_max_salary
			FROM `employees` AS e
			JOIN
				(SELECT `department_id`, MAX(`salary`) AS max_salary
				FROM `employees`
				GROUP BY `department_id`) AS first_salary
			ON e.department_id = first_salary.department_id AND e.salary < first_salary.max_salary
			GROUP BY department_id) AS second_max_salary
	ON e3.department_id = second_max_salary.department_id AND e3.salary < second_max_salary.second_max_salary
	GROUP BY e3.department_id;

-- 23
SELECT e1.first_name, e1.last_name, e1.department_id
	FROM `employees` AS e1
	JOIN
		(SELECT e2.department_id AS department_id, AVG(e2.salary) AS avg_salary
			FROM `employees` AS e2
			GROUP BY department_id) AS avg_salary
	ON e1.department_id = avg_salary.department_id AND e1.salary > avg_salary.avg_salary
	ORDER BY e1.department_id
	LIMIT 10;
	
-- 24
SELECT `department_id`, SUM(`salary`) AS 'total_salary'
	FROM `employees`
	GROUP BY `department_id`;