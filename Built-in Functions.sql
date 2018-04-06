-- 1
USE `book_library`;

SELECT `title` 
	FROM `books`
	WHERE SUBSTRING(`title`, 1, 3) = 'The';
	
-- 2
SELECT REPLACE(`title`, 'The', '***') 
	FROM `books`
	WHERE LEFT(`title`, 3) = 'The';
	
-- 3
SELECT ROUND(SUM(`cost`), 2) 
	FROM `books`;

-- 4
SELECT CONCAT(`first_name`, ' ', `last_name`) AS 'Full Name', TIMESTAMPDIFF(DAY, `born`, `died`) AS 'Days Lived'
	FROM `authors`;
	
-- 5
SELECT `title`
	FROM `books`
	WHERE LEFT(`title`, 12) = 'Harry Potter';
	
-- 6
USE `soft_uni`;

SELECT `first_name`, `last_name`
	FROM `employees`
	WHERE LEFT(LOWER(`first_name`), 2) = 'sa'
	ORDER BY `employee_id`;
	
-- 7
SELECT `first_name`, `last_name`
	FROM `employees`
	WHERE LOWER(`last_name`) LIKE ('%ei%')
	ORDER BY `employee_id`;
	
-- 8 
SELECT `first_name`
	FROM `employees`
	WHERE `department_id` IN (3, 10) AND YEAR(`hire_date`) BETWEEN 1995 AND 2005
	ORDER BY `employee_id`;
	
-- 9
SELECT `first_name`, `last_name` 
	FROM `employees`
	WHERE NOT LOWER(`job_title`) LIKE ("%engineer%");
	
-- 10
SELECT `name`
	FROM `towns`
	WHERE CHAR_LENGTH(`name`) IN (5, 6)
	ORDER BY `name` ASC;
	
-- 11
SELECT `town_id`, `name`
	FROM `towns`
	WHERE LOWER(LEFT(`name`, 1)) IN ('m', 'k', 'b', 'e')
	ORDER BY `name` ASC;
	
-- 12
SELECT `town_id`, `name`
	FROM `towns`
	WHERE NOT LOWER(LEFT(`name`,1)) IN ('r', 'b', 'd')
	ORDER BY `name` ASC;
	
-- 13
CREATE VIEW `v_employees_hired_after_2000` AS SELECT `first_name`, `last_name` 
	FROM `employees`
	WHERE YEAR(`hire_date`) > 2000;
	
-- 14
SELECT `first_name`, `last_name` 
	FROM `employees`
	WHERE CHAR_LENGTH(`last_name`) IN (5);
	
-- 15
USE `geography`;

SELECT `country_name`, `iso_code`
	FROM `countries`
	WHERE LOWER(`country_name`) LIKE ("%a%a%a%")
	ORDER BY `iso_code`;
	
-- 16
SELECT p.peak_name, r.river_name, LOWER(CONCAT(LEFT(p.peak_name, CHAR_LENGTH(p.peak_name) - 1), r.river_name)) AS 'mix'
	FROM `peaks` AS p, `rivers` AS r
	WHERE RIGHT(p.peak_name, 1) LIKE LEFT(r.river_name, 1)
	ORDER BY `mix`;
	
-- 17
USE `diablo`;

SELECT `name`, DATE_FORMAT(`start`, '%Y-%m-%d') 
	FROM `games`
	WHERE YEAR(`start`) IN (2011, 2012)
	ORDER BY `start`, `name`
	LIMIT 50;
	
-- 18
SELECT `user_name`, SUBSTRING(`email`, LOCATE('@', `email`) + 1) AS 'Email Provider'
	FROM `users`
	ORDER BY `Email Provider`, `user_name`;
	
-- 19
SELECT `user_name`, `ip_address`
	FROM `users`
	WHERE `ip_address` LIKE ("___.1%.%.___")
	ORDER BY `user_name`;
	
-- 20
SELECT `name` AS 'game', 
	IF(HOUR(`start`) >= 0 AND HOUR(`start`) < 12, 'Morning', IF(HOUR(`start`) < 18, 'Afternoon', 'Evening')) AS 'Part of the Day',
	IF(`duration` <= 3, 'Extra Short', IF(`duration` <= 6, 'Short', IF(`duration` <= 10, 'Long', 'Extra Long'))) AS 'Duration'
	FROM `games`
	ORDER BY `name`;
	
-- 21
USE `orders`;

SELECT `product_name`, `order_date`, DATE_ADD(`order_date`, INTERVAL 3 DAY) AS 'pay_due', DATE_ADD(`order_date`, INTERVAL 1 MONTH) AS 'deliver_due'
	FROM `orders`;