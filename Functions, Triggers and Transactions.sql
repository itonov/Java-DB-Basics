-- 1
USE `soft_uni`;

DELIMITER $$
CREATE FUNCTION ufn_count_employees_by_town(town_name VARCHAR(20))
RETURNS INT
BEGIN
	DECLARE e_count INT;
	SET e_count := (SELECT COUNT(e.employee_id)
	FROM `employees` AS e
	INNER JOIN `addresses` AS a
	ON e.address_id = a.address_id
	INNER JOIN `towns` AS t
	ON a.town_id = t.town_id
	WHERE t.name = town_name);
	RETURN e_count;
END $$
DELIMITER ; 

-- 2
DELIMITER $$
CREATE PROCEDURE usp_raise_salaries(department_name VARCHAR(20))
BEGIN
	UPDATE `employees` AS e
		INNER JOIN `departments` AS d
		ON e.department_id = d.department_id
		SET e.salary = e.salary * 1.05
		WHERE d.name = department_name;
END $$
DELIMITER ;

-- 3
DELIMITER $$
CREATE PROCEDURE usp_raise_salary_by_id(id INT)
BEGIN
	START TRANSACTION;
	IF((SELECT COUNT(e.employee_id)
			FROM `employees` AS e
			WHERE e.employee_id LIKE id) <> 1) THEN
	ROLLBACK;
	ELSE
		UPDATE `employees` AS e SET e.salary = e.salary * 1.05
		WHERE e.employee_id = id;
	END IF;
END $$
DELIMITER ;

-- 4
CREATE TABLE `deleted_employees`(
	`employee_id` INT PRIMARY KEY AUTO_INCREMENT,
	`first_name` VARCHAR(50),
	`last_name` VARCHAR(50),
	`middle_name` VARCHAR(50),
	`job_title` VARCHAR(50),
	`department_id` INT,
	`salary` DECIMAL(19,4));

CREATE TRIGGER tr_deleted_employees
AFTER DELETE
ON employees
FOR EACH ROW 
BEGIN
	INSERT INTO deleted_employees(`first_name`, `last_name`, `middle_name`, `job_title`, `department_id`, `salary`)
		VALUES(OLD.first_name, OLD.last_name, OLD.middle_name, OLD.job_title, OLD.department_id, OLD.salary);
END; $$
DELIMITER ; 	

-- 5
DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above_35000()
BEGIN
	SELECT e.first_name, e.last_name
		FROM `employees` AS e
		WHERE e.salary > 35000
		ORDER BY e.first_name, e.last_name, e.employee_id;
END $$
DELIMITER ;

-- 6
DELIMITER $$
CREATE PROCEDURE usp_get_employees_salary_above(salary DECIMAL(19,4))
BEGIN
	SELECT e.first_name, e.last_name
		FROM `employees` AS e
		WHERE e.salary >= salary
		ORDER BY e.first_name, e.last_name, e.employee_id;
END $$
DELIMITER ;

-- 7
DELIMITER $$
CREATE PROCEDURE usp_get_towns_starting_with(town_name VARCHAR(50))
BEGIN
	SELECT t.name AS 'town_name'
		FROM `towns` AS t
		WHERE t.name LIKE CONCAT(town_name, '%')
		ORDER BY t.name;
END $$
DELIMITER ;

-- 8
DELIMITER $$
CREATE PROCEDURE usp_get_employees_from_town(town_name VARCHAR(50))
BEGIN
	SELECT e.first_name, e.last_name
		FROM `employees` AS e
		INNER JOIN `addresses` AS a
		ON e.address_id = a.address_id
		INNER JOIN `towns` AS t
		ON a.town_id = t.town_id
		WHERE t.name = town_name
		ORDER BY e.first_name, e.last_name, e.employee_id;
END $$
DELIMITER ;

-- 9
DELIMITER $$
CREATE FUNCTION ufn_get_salary_level(salary DECIMAL(19,4))
RETURNS VARCHAR(20)
BEGIN
	DECLARE e_result VARCHAR(20);
	IF (salary < 30000)
	THEN SET e_result = 'Low';
	ELSEIF (salary <= 50000)
	THEN SET e_result = 'Average';
	ELSEIF (salary > 50000)
	THEN SET e_result = 'High';
	END IF;
	RETURN e_result;
END $$
DELIMITER ;

-- 10
DELIMITER $$
CREATE PROCEDURE usp_get_employees_by_salary_level(salary_level VARCHAR(20))
BEGIN
	SELECT e.first_name, e.last_name
		FROM `employees` AS e
		WHERE CASE salary_level 
			WHEN 'Low' THEN e.salary < 30000
			WHEN 'Average' THEN e.salary <= 50000
			WHEN 'High' THEN e.salary > 50000
		END
		ORDER BY e.first_name DESC, e.last_name DESC;
END $$
DELIMITER ;

-- 11
DELIMITER $$
CREATE FUNCTION ufn_is_word_comprised(set_of_letters VARCHAR(50), word VARCHAR(50))
RETURNS BIT
BEGIN
	RETURN word REGEXP CONCAT('^[', set_of_letters, ']+$');
END $$
DELIMITER ;

-- 12
USE `bank`;

DELIMITER $$
CREATE PROCEDURE usp_get_holders_full_name()
BEGIN
	SELECT CONCAT(ac.first_name, ' ', ac.last_name) AS 'full_name'
		FROM `account_holders` AS ac
		ORDER BY `full_name`, ac.id;
END $$
DELIMITER ;

-- 13
DELIMITER $$
CREATE PROCEDURE usp_get_holders_with_balance_higher_than(number DOUBLE)
BEGIN
	SELECT emp.first_name, emp.last_name
		FROM (SELECT a.id, ah.first_name, ah.last_name, SUM(a.balance)
		FROM `account_holders` AS ah
		INNER JOIN `accounts` AS a
		ON ah.id = a.account_holder_id
		GROUP BY a.id, ah.first_name, ah.last_name
		HAVING SUM(a.balance) > number
		ORDER BY ah.first_name, ah.last_name, a.id) AS emp;
END $$
DELIMITER ;

-- 14
DELIMITER $$
CREATE FUNCTION ufn_calculate_future_value(initial_sum DECIMAL(19,4), rate DOUBLE(19,4), years INT)
RETURNS DECIMAL(19,4)
BEGIN	
	RETURN initial_sum * POW((1 + rate), years);
END $$
DELIMITER ;

-- 15
DELIMITER $$
CREATE PROCEDURE usp_calculate_future_value_for_account(account_id INT, interest_rate DOUBLE(19,4))
BEGIN
	SELECT a.id, ah.first_name, ah.last_name, a.balance AS 'current_balance', ufn_calculate_future_value(a.balance, interest_rate, 5) AS 'balance_in_5_years'
		FROM `account_holders` AS ah
		INNER JOIN `accounts` AS a
		ON ah.id = a.account_holder_id
		WHERE a.id = account_id;
END $$
DELIMITER ; 

-- 16
DELIMITER $$
CREATE PROCEDURE usp_deposit_money(account_id INT, money_amount DECIMAL(19,4))
BEGIN
	START TRANSACTION;
		IF(money_amount <= 0) 
		THEN ROLLBACK;
		ELSE UPDATE `accounts` AS a
					SET a.balance = a.balance + money_amount;					
		END IF;
END $$
DELIMITER ;

-- 17
DELIMITER $$
CREATE PROCEDURE usp_withdraw_money(account_id INT, money_amount DECIMAL(19,4))
BEGIN
	START TRANSACTION;
	IF(money_amount <= 0)
	THEN ROLLBACK;
	ELSEIF((SELECT a.balance
				FROM `accounts` AS a
				WHERE a.id = account_id) < money_amount) 
	THEN ROLLBACK;
	ELSE UPDATE `accounts` AS a
				SET a.balance = a.balance - money_amount;
	END IF;
END $$
DELIMITER ;

-- 18
DELIMITER $$
CREATE PROCEDURE usp_transfer_money(from_account_id INT, to_account_id INT, amount DECIMAL(19,4))
BEGIN
	START TRANSACTION;
	IF((SELECT a.account_holder_id
			FROM `accounts` AS a
			WHERE a.id = from_account_id) IS NULL)
	THEN ROLLBACK;
	ELSEIF((SELECT a.account_holder_id
			FROM `accounts` AS a
			WHERE a.id = to_account_id) IS NULL)
	THEN ROLLBACK;
	ELSEIF amount <= 0
	THEN ROLLBACK;
	ELSEIF from_account_id = to_account_id
	THEN ROLLBACK;
	ELSEIF((SELECT a.balance
				FROM `accounts` AS a
				WHERE a.id = from_account_id) < amount)
	THEN ROLLBACK;
	ELSE UPDATE `accounts` AS a
		SET a.balance = a.balance - amount
		WHERE a.id = from_account_id;
		UPDATE `accounts` AS a
		SET a.balance = a.balance + amount
		WHERE a.id = to_account_id;
	END IF;
END $$
DELIMITER ;

-- 19
CREATE TABLE `logs`(
	`log_id` INT PRIMARY KEY AUTO_INCREMENT,
	`account_id` INT,
	`old_sum` DECIMAL(19,4),
	`new_sum` DECIMAL(19,4));
	
DELIMITER $$
CREATE TRIGGER tr_accounts_logs
AFTER UPDATE
ON `accounts`
FOR EACH ROW
BEGIN
	INSERT INTO `logs`(`account_id`, `old_sum`, `new_sum`)
		VALUES(OLD.id, OLD.balance, NEW.balance);
END $$
DELIMITER ;

-- 20
CREATE TABLE `notification_emails`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`recipient` INT,
	`subject` TEXT,
	`body` TEXT);
	
DELIMITER $$
CREATE TRIGGER tr_logs_message
AFTER INSERT
ON `logs`
FOR EACH ROW
BEGIN
	INSERT INTO `notification_emails`(`recipient`, `subject`, `body`)
		VALUES(NEW.account_id, CONCAT('Balance change for account: ', NEW.account_id), CONCAT('On ', NOW(), ' your balance was changed from ', NEW.old_sum, ' to ', NEW.new_sum));
END $$
DELIMITER ;