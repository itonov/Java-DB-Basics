-- 1
SELECT * FROM minions AS m

-- 2
SELECT m.name 
	FROM minions AS m
	ORDER BY m.name ASC;

-- 3
UPDATE minions
	SET minions.age = minions.age + 1;
	
-- 4
UPDATE minions
	SET minions.age = minions.age + 1;
	
-- 5
CREATE DATABASE `gamebar`;

USE `gamebar`;

CREATE TABLE `employees`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`first_name` VARCHAR(50) NOT NULL,
	`last_name` VARCHAR(50) NOT NULL);
	
CREATE TABLE `categories`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`name` VARCHAR(50) NOT NULL);
	
CREATE TABLE `products`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`name` VARCHAR(50) NOT NULL,
	`category_id` INT NOT NULL);
	
-- 6
INSERT INTO `employees`(`first_name`,`last_name`)
VALUES ('petur','petrov');

INSERT INTO `employees`(`first_name`,`last_name`)
VALUES ('petur','petrov');

INSERT INTO `employees`(`first_name`,`last_name`)
VALUES ('petur','petrov');

-- 7
ALTER TABLE `employees`
	ADD `middle_name` VARCHAR(50);
	
-- 8
ALTER TABLE `products`
	ADD FOREIGN KEY (`category_id`) REFERENCES `categories`(`id`);
	
-- 9
ALTER TABLE `employees`
	MODIFY COLUMN `middle_name` VARCHAR(100);
	
-- 10
DROP DATABASE `gamebar`;

-- 11
USE `minions;

CREATE TABLE `minions`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`name` VARCHAR(50),
	`age` INT);
	
CREATE TABLE `towns`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`name` VARCHAR(50));
	
-- 12
USE `minions`;

ALTER TABLE `minions`
	ADD COLUMN `town_id` INT,
	ADD FOREIGN KEY (`town_id`) REFERENCES `towns`(`id`);
	
-- 13
TRUNCATE TABLE `minions`;

-- 14
DROP TABLES `minions`;

DROP DATABASE `minions`;

-- 15
CREATE DATABASE `minions`;

USE `minions`;

CREATE TABLE `minions`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`name` VARCHAR(50),
	`age` INT);
	
CREATE TABLE `towns`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`name` VARCHAR(50));
	
-- 16
ALTER TABLE `minions`
	ADD COLUMN `town_id` INT,
	ADD FOREIGN KEY (`town_id`) REFERENCES `towns`(`id`);
	
-- 17
CREATE TABLE `minions`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
	`name` VARCHAR(50) NOT NULL,
	`age` INT);
	
-- 18
CREATE TABLE `towns`(
	`id` INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	`name` VARCHAR(50));
	
-- 19
DROP TABLE `minions`,`towns`;

-- 20
CREATE TABLE `people`(
	`id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	`name` VARCHAR(200) NOT NULL,
	`picture` TINYBLOB,
	`height` DOUBLE(3,2),
	`weight` DOUBLE(3,2),
	`gender` ENUM('f','m') NOT NULL,
	`birthdate` DATE NOT NULL,
	`biography` TEXT);
	
-- 21
CREATE TABLE `users`(
	`id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	`username` VARCHAR(30) UNIQUE NOT NULL,
	`password` VARCHAR(36) NOT NULL,
	`profile_picture` MEDIUMBLOB,
	`last_login_time` DATETIME,
	`is_deleted` TINYINT(1));
	
INSERT INTO `users`(`username`,`password`,`profile_picture`,`last_login_time`,`is_deleted`)
VALUES ('minko123','123minko','C:\Users\Dell\Desktop\gpu1','2018-01-23',1);

INSERT INTO `users`(`username`,`password`,`profile_picture`,`last_login_time`,`is_deleted`)
VALUES ('minko1234','123minko','C:\Users\Dell\Desktop\gpu1','2018-01-23',1);

INSERT INTO `users`(`username`,`password`,`profile_picture`,`last_login_time`,`is_deleted`)
VALUES ('minko12345','123minko','C:\Users\Dell\Desktop\gpu1','2018-01-23',1);

ALTER TABLE `users`
	CHANGE `id` `id` INT;
	
ALTER TABLE `users`
	MODIFY `id` INT NOT NULL;
	
ALTER TABLE `users`
	MODIFY `id` INT;
	
ALTER TABLE `users`
	DROP PRIMARY KEY;
	
ALTER TABLE `users`
	ADD PRIMARY KEY (`id`,`username`);
	
ALTER TABLE `users`
	DROP PRIMARY KEY,
	ADD PRIMARY KEY (`id`,`username`);
	
ALTER TABLE `users`
	MODIFY COLUMN `last_login_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE `users`
	DROP PRIMARY KEY,
	ADD PRIMARY KEY (`id`,`username`);
	
ALTER TABLE `users`
	DROP PRIMARY KEY,
	ADD PRIMARY KEY (`id`);

ALTER TABLE `users`
	ADD UNIQUE (`username`);

-- 22
INSERT INTO `cars`(`plate_number`,`make`,`model`,`car_year`,`category_id`,`doors`,`picture`,`car_condition`,`available`)
	VALUES ('PB 1234 AC','random','random',1980,2,4,'C:\Users\Dell\Desktop\gpu1','bad','y');
	
INSERT INTO `cars`(`plate_number`,`make`,`model`,`car_year`,`category_id`,`doors`,`picture`,`car_condition`,`available`)
	VALUES ('PB 5678 AC','random2','random2',2015,2,4,'C:\Users\Dell\Desktop\gpu1','bad',0);
	
INSERT INTO `cars`(`plate_number`,`make`,`model`,`car_year`,`category_id`,`doors`,`picture`,`car_condition`,`available`)
	VALUES ('PB 9012 AC','random1','random1',2010,2,4,'C:\Users\Dell\Desktop\gpu1','bad',0);
	
INSERT INTO `employees`(`first_name`,`last_name`,`title`,`notes`)
	VALUES ('gosho','petrov','seller','the best one');
	
INSERT INTO `employees`(`first_name`,`last_name`,`title`,`notes`)
	VALUES ('ivan','petrov','mechanic','the worst one');
	
INSERT INTO `employees`(`first_name`,`last_name`,`title`,`notes`)
	VALUES ('gosho','petrov','seller','the best one');

-- 23
CREATE TABLE `rental_orders`(
	`id` INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	`employee_id` INT UNSIGNED NOT NULL,
	`customer_id` INT UNSIGNED NOT NULL,
	`car_id` INT UNSIGNED NOT NULL,
	`car_condition` TEXT,
	`tank_level` INT UNSIGNED,
	`kilometrage_start` INT UNSIGNED,
	`kilometrage_end` INT UNSIGNED,
	`total_kilometrage` INT UNSIGNED,
	`start_date` DATE,
	`end_date` DATE,
	`total_days` INT UNSIGNED,
	`rate_applied` DOUBLE(4,2),
	`tax_rate` DOUBLE(4,2),
	`order_status` VARCHAR(50),
	`notes` TEXT);
	
INSERT INTO `rental_orders`(`employee_id`,`customer_id`,`car_id`,`car_condition`,`tank_level`,`kilometrage_start`,`kilometrage_end`,`total_kilometrage`,`start_date`,`end_date`,`total_days`,`rate_applied`,`tax_rate`,`order_status`,`notes`)
	VALUES (2,1,3,'bad',15,120000,125000,5000,1980-02-20,2000-02-20,50,25.34,20.2,'finished','not the best deal');
	
INSERT INTO `rental_orders`(`employee_id`,`customer_id`,`car_id`,`car_condition`,`tank_level`,`kilometrage_start`,`kilometrage_end`,`total_kilometrage`,`start_date`,`end_date`,`total_days`,`rate_applied`,`tax_rate`,`order_status`,`notes`)
	VALUES (2,1,3,'bad',15,120000,125000,5000,1980-02-20,2000-02-20,50,25.34,20.2,'finished','not the best deal');
	
INSERT INTO `rental_orders`(`employee_id`,`customer_id`,`car_id`,`car_condition`,`tank_level`,`kilometrage_start`,`kilometrage_end`,`total_kilometrage`,`start_date`,`end_date`,`total_days`,`rate_applied`,`tax_rate`,`order_status`,`notes`)
	VALUES (2,1,3,'bad',15,120000,125000,5000,1980-02-20,2000-02-20,50,25.34,20.2,'finished','not the best deal');

-- 24
INSERT INTO `payments`(`employee_id`, `payment_date`, `account_number`, `first_date_occupied`, `last_date_occupied`, `total_days`, `amount_charged`, `tax_rate`, `tax_amount`, `payment_total`, `notes`)
	VALUES (1, 1986, 12345, 1999, 2018, 1234, 236.13, 1.32, 36.13, 270.23, 'not the best deal');
	
INSERT INTO `payments`(`employee_id`, `payment_date`, `account_number`, `first_date_occupied`, `last_date_occupied`, `total_days`, `amount_charged`, `tax_rate`, `tax_amount`, `payment_total`, `notes`)
	VALUES (1, 1986, 12345, 1999-03-15, 2018-01-13, 1234, 236.13, 1.32, 36.13, 270.23, 'not the best deal');
	
INSERT INTO `payments`(`employee_id`, `payment_date`, `account_number`, `first_date_occupied`, `last_date_occupied`, `total_days`, `amount_charged`, `tax_rate`, `tax_amount`, `payment_total`, `notes`)
	VALUES (1, 1999, 12345, '1999-08-12', '2018-04-11', 1234, 236.13, 1.32, 36.13, 270.23, 'not the best deal');
	
INSERT INTO `payments`(`employee_id`, `payment_date`, `account_number`, `first_date_occupied`, `last_date_occupied`, `total_days`, `amount_charged`, `tax_rate`, `tax_amount`, `payment_total`, `notes`)
	VALUES (1, 1999, 12345, 1999-08-12, '2018-04-11', 1234, 236.13, 1.32, 36.13, 270.23, 'not the best deal');
	
-- 24
SELECT * FROM `towns`;

SELECT * FROM `departments`;

SELECT * FROM `employees`;

-- 25
SELECT * FROM `towns`
	ORDER BY `name`;
	
SELECT * FROM `departments`
	ORDER BY `name`;
	
SELECT * FROM `employees`
	ORDER BY `salary`;
	
-- 26
SELECT `name` FROM `towns`
	ORDER BY `name`;
	
SELECT `name` FROM `departments`
	ORDER BY `name`;
	
SELECT `first_name`, `last_name`, `job_title`, `salary` FROM `employees`
	ORDER BY `salary` DESC;
	
-- 27
UPDATE `employees`
	SET  `salary` = `salary` + (`salary` * 0.1);
	
-- 28
USE `hotel`;

UPDATE `payments`
	SET `tax_rate` = `tax_rate` - (`tax_rate` * 0.03);
	
SELECT `tax_rate` FROM `payments`;

-- 29
TRUNCATE TABLE `occupancies`;