-- 1
CREATE DATABASE `practice`;

USE `practice`;

CREATE TABLE `mountains`(
	`id` INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	`name` VARCHAR(50));
	
CREATE TABLE `peaks`(
	`id` INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	`name` VARCHAR(50),
	`mountain_id` INT UNSIGNED NOT NULL,
	CONSTRAINT fk_peaks_mountains
	FOREIGN KEY (`mountain_id`) REFERENCES `mountains`(`id`));
	
-- 2
CREATE TABLE `authors`(
	`id` INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	`name` VARCHAR(50));
	
CREATE TABLE `books`(
	`id` INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	`name` VARCHAR(50),
	`author_id` INT UNSIGNED NOT NULL,
	CONSTRAINT fk_books_authors
	FOREIGN KEY (`author_id`) REFERENCES `authors`(`id`) ON DELETE CASCADE);
	
-- 3
USE `camp`;

SELECT v.driver_id AS 'driver_id', v.vehicle_type AS 'vehicle_type', CONCAT_WS(" ", c.first_name, c.last_name) AS 'driver_name'
	FROM `campers` AS c 
	JOIN `vehicles` AS v
	ON v.driver_id = c.id;
	
-- 4
SELECT r.starting_point AS 'route_starting_point', r.end_point AS 'route_ending_point', r.leader_id AS 'leader_id', CONCAT(c.first_name, " ", c.last_name) AS 'leader_name'
	FROM `routes` AS r
	JOIN `campers` AS c
	ON r.leader_id = c.id;
	
-- 5
CREATE DATABASE `test`;

USE `test`;

CREATE TABLE `clients`(
	`id` INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	`client_name` VARCHAR(50),
	`project_id` INT UNSIGNED NOT NULL);
	
CREATE TABLE `projects`(
	`id` INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	`client_id` INT UNSIGNED NOT NULL,
	`project_lead_id` INT UNSIGNED NOT NULL);
	
CREATE TABLE `employees`(
	`id` INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	`first_name` VARCHAR(50),
	`last_name` VARCHAR(50),
	`project_id` INT UNSIGNED NOT NULL);
	
ALTER TABLE `clients`
	ADD CONSTRAINT fk_clients_projects
	FOREIGN KEY (`project_id`) REFERENCES `projects`(`id`);
	
ALTER TABLE `projects`
	ADD CONSTRAINT fk_projects_clients
	FOREIGN KEY (`client_id`) REFERENCES `clients`(`id`),
	ADD CONSTRAINT fk_projects_employees
   FOREIGN KEY (`project_lead_id`) REFERENCES `employees`(`id`);
	
ALTER TABLE `employees`
	ADD CONSTRAINT fk_employees_projects
	FOREIGN KEY (`project_id`) REFERENCES `projects`(`id`);
	
-- 6
CREATE DATABASE `test2`;

USE `test2`;

CREATE TABLE `persons`(
	`person_id` INT UNSIGNED,
	`first_name` VARCHAR(50),
	`salary` DECIMAL(10, 2),
	`passport_id` INT UNSIGNED);
	
CREATE TABLE `passports`(
	`passport_id` INT UNSIGNED UNIQUE,
	`passport_number` VARCHAR(50));

INSERT INTO `persons` 
VALUES 
	(1, 'Roberto', 43300.00, 102),
	(2, 'Tom', 56100.00, 103),
	(3, 'Roberto', 60200.00, 101);
	
INSERT INTO `passports`
VALUES
	(101, 'N34FG21B'),
	(102, 'K65LO4R7'),
	(103, 'ZE657QP2');
	
ALTER TABLE `persons`
	MODIFY `person_id` INT UNSIGNED PRIMARY KEY,
	MODIFY `passport_id` INT UNSIGNED UNIQUE,
	ADD CONSTRAINT fk_persons_passports 
	FOREIGN KEY (`passport_id`) REFERENCES `passport`(`passport_id`);
	
-- 7
CREATE TABLE `manufacturers`(
	`manufacturer_id` INT UNSIGNED PRIMARY KEY AUTO_INCREMENT NOT NULL,
	`name` VARCHAR(50),
	`established_on` DATE);
	
CREATE TABLE `models`(
	`model_id` INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	`name` VARCHAR(50),
	`manufacturer_id` INT UNSIGNED NOT NULL,
	CONSTRAINT fk_models_manufacturers FOREIGN KEY (`manufacturer_id`) REFERENCES `manufacturers`(`manufacturer_id`));
		
INSERT INTO `manufacturers`
	VALUES 
		(1, 'BMW', '1916-03-01'),
		(2, 'Tesla', '2003-01-01'),
		(3, 'Lada', '1966-05-01');
		
INSERT INTO `models`
	VALUES 
		(101, 'X1', 1),
		(102, 'i6', 1),
		(103, 'Model S', 2),
		(104, 'Model X', 2),
		(105, 'Model 3', 2),
		(106, 'Nova', 3);
		
-- 8
CREATE TABLE `students`(
	`student_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`name` VARCHAR(50));
	
CREATE TABLE `exams`(
	`exam_id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`name` VARCHAR(50));
	
INSERT INTO `students`
	VALUES 
		(1, 'Mila'),
		(2, 'Toni'),
		(3, 'Ron');
		
INSERT INTO `exams`
	VALUES
		(101, 'Spring MVC'),
		(102, 'Neo4j'),
		(103, 'Oracle 11g');
	
CREATE TABLE `students_exams`(
	`student_id` INT UNSIGNED NOT NULL,
	`exam_id` INT UNSIGNED NOT NULL,
	CONSTRAINT pk_students_exams PRIMARY KEY (`student_id`, `exam_id`),
	CONSTRAINT fk_students_exams_students FOREIGN KEY (`student_id`) REFERENCES `students`(`student_id`),
	CONSTRAINT fk_students_exams_exams FOREIGN KEY (`exam_id`) REFERENCES `exams`(`exam_id`));
		
INSERT INTO `students_exams`
	VALUES
		(1, 101),
		(1, 102),
		(2, 101),
		(3, 103),
		(2, 102),
		(2, 103);
	
-- 9
CREATE TABLE `teachers`(
	`teacher_id` INT UNSIGNED NOT NULL PRIMARY KEY,
	`name` VARCHAR(50),
	`manager_id` INT UNSIGNED);
	
INSERT INTO `teachers`
	VALUES 
		(101, 'John', NULL),
		(102, 'Maya', 106),
		(103, 'Silvia', 106),
		(104, 'Ted', 105),
		(105, 'Mark', 101),
		(106, 'Greta', 101);
		
ALTER TABLE `teachers`
	ADD CONSTRAINT fk_teachers_teachers FOREIGN KEY (`manager_id`) REFERENCES `teachers`(`teacher_id`);

-- 9
CREATE DATABASE `store`;

USE `store`;

CREATE TABLE `item_types`(
	`item_type_id` INT(11) PRIMARY KEY AUTO_INCREMENT NOT NULL,
	`name` VARCHAR(50));
	
CREATE TABLE `cities`(
	`city_id` INT(11) PRIMARY KEY AUTO_INCREMENT NOT NULL,
	`name` VARCHAR(50));
	
CREATE TABLE `customers`(
	`customer_id` INT(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
	`name` VARCHAR(50),
	`birthday` DATE,
	`city_id` INT(11),
	CONSTRAINT fk_customers_cities FOREIGN KEY (`city_id`) REFERENCES `cities`(`city_id`));
	
CREATE TABLE `orders`(
	`order_id` INT(11) PRIMARY KEY NOT NULL AUTO_INCREMENT,
	`customer_id` INT(11),
	CONSTRAINT fk_orders_customers FOREIGN KEY (`customer_id`) REFERENCES `customers`(`customer_id`));
	
CREATE TABLE `items`(
	`item_id` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`name` VARCHAR(50),
	`item_type_id` INT(11),
	CONSTRAINT fk_items_item_types FOREIGN KEY (`item_type_id`) REFERENCES `item_types`(`item_type_id`));
	
CREATE TABLE `order_items`(
	`order_id` INT(11),
	`item_id` INT(11),
	CONSTRAINT pk_order_items PRIMARY KEY (`order_id`, `item_id`),
	CONSTRAINT fk_order_items_orders FOREIGN KEY (`order_id`) REFERENCES `orders`(`order_id`),
	CONSTRAINT fk_order_items_items FOREIGN KEY (`item_id`) REFERENCES `items`(`item_id`));
	
-- 10
CREATE DATABASE `university`;

USE `university`;

CREATE TABLE `subjects`(
	`subject_id` INT(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
	`subject_name` VARCHAR(50));
	
CREATE TABLE `majors`(
	`major_id` INT(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
	`name` VARCHAR(50));
	
CREATE TABLE `students`(
	`student_id` INT(11) PRIMARY KEY AUTO_INCREMENT NOT NULL,
	`student_number` VARCHAR(12),
	`student_name` VARCHAR(50),
	`major_id` INT(11),
	CONSTRAINT fk_students_majors FOREIGN KEY (`major_id`) REFERENCES `majors`(`major_id`));

CREATE TABLE `payments`(
	`payment_id` INT(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
	`payment_date` DATE,
	`payment_amount` DECIMAL(8, 2),
	`student_id` INT(11),
	CONSTRAINT fk_payments_students FOREIGN KEY (`student_id`) REFERENCES `students`(`student_id`));
	
CREATE TABLE `agenda`(
	`student_id` INT(11),
	`subject_id` INT(11),
	CONSTRAINT pk_agenda PRIMARY KEY (`student_id`, `subject_id`),
	CONSTRAINT fk_agenda_students FOREIGN KEY (`student_id`) REFERENCES `students`(`student_id`),
	CONSTRAINT fk_agenda_subjects FOREIGN KEY (`subject_id`) REFERENCES `subjects`(`subject_id`));
	
-- 11
USE `geography`;

SELECT m.mountain_range AS mountain_range, p.peak_name AS peak_name, p.elevation AS peak_elevation
	FROM `mountains` AS m
	JOIN `peaks` AS p
	ON m.id = p.mountain_id
	WHERE m.mountain_range LIKE ("Rila")
	ORDER BY p.elevation DESC;