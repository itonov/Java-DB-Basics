CREATE DATABASE `buhtig`;

USE `buhtig`;

-- section 1: data definition

CREATE TABLE `users`(
	`id` INT(11) PRIMARY KEY AUTO_INCREMENT,
	`username` VARCHAR(30) NOT NULL UNIQUE,
	`password` VARCHAR(30) NOT NULL,
	`email` VARCHAR(50) NOT NULL);
	
CREATE TABLE `repositories`(
	`id` INT(11) PRIMARY KEY AUTO_INCREMENT,
	`name` VARCHAR(50) NOT NULL);
	
CREATE TABLE `repositories_contributors`(
	`repository_id` INT(11),
	`contributor_id` INT(11),
	CONSTRAINT fk_repositories_contributors_repositories
	FOREIGN KEY (`repository_id`) REFERENCES `repositories`(`id`),
	CONSTRAINT fk_repositories_contributors_users
	FOREIGN KEY (`contributor_id`) REFERENCES `users`(`id`));
	
CREATE TABLE `issues`(
	`id` INT(11) PRIMARY KEY AUTO_INCREMENT,
	`title` VARCHAR(255) NOT NULL,
	`issue_status` VARCHAR(6) NOT NULL,
	`repository_id` INT(11) NOT NULL,
	`assignee_id` INT(11) NOT NULL,
	CONSTRAINT fk_issues_repositories
	FOREIGN KEY (`repository_id`) REFERENCES `repositories`(`id`),
	CONSTRAINT fk_issues_users
	FOREIGN KEY (`assignee_id`) REFERENCES `users`(`id`));
	
CREATE TABLE `commits`(
	`id` INT(11) PRIMARY KEY AUTO_INCREMENT,
	`message` VARCHAR(255) NOT NULL,
	`issue_id` INT(11),
	`repository_id` INT(11) NOT NULL,
	`contributor_id` INT(11) NOT NULL,
	CONSTRAINT fk_commits_issues
	FOREIGN KEY (`issue_id`) REFERENCES `issues`(`id`),
	CONSTRAINT fk_commits_repositories
	FOREIGN KEY (`repository_id`) REFERENCES `repositories`(`id`),
	CONSTRAINT fk_commits_users
	FOREIGN KEY (`contributor_id`) REFERENCES `users`(`id`));
	
CREATE TABLE `files`(
	`id` INT(11) PRIMARY KEY AUTO_INCREMENT,
	`name` VARCHAR(100) NOT NULL,
	`size` DECIMAL(10, 2) NOT NULL,
	`parent_id` INT(11),
	`commit_id` INT(11) NOT NULL,
	CONSTRAINT fk_files_files
	FOREIGN KEY (`parent_id`) REFERENCES `files`(`id`),
	CONSTRAINT fk_files_commits
	FOREIGN KEY (`commit_id`) REFERENCES `commits`(`id`));
	
-- section 2 data manipulation

INSERT INTO `issues`(`title`, `issue_status`, `repository_id`, `assignee_id`)
	SELECT CONCAT('Critical Problem With ', f.name, '!'), 'open', CEIL((f.id * 2) / 3), c.contributor_id
		FROM `files` AS f
		INNER JOIN `commits` AS c
		ON f.commit_id = c.id
		WHERE f.id BETWEEN 46 AND 50;
											
UPDATE `repositories_contributors` AS rc
	RIGHT JOIN `repositories` AS r
	ON rc.repository_id = r.id
	INNER JOIN `repositories_contributors` AS repo_con
	ON rc.repository_id = repo_con.repository_id AND rc.contributor_id = repo_con.contributor_id
	SET rc.contributor_id = (SELECT repc.contributor_id
											FROM `repositories_contributors` AS repc
											WHERE repc.repository_id = repc.contributor_id)
	WHERE repo_con.contributor_id = (SELECT repc.contributor_id
											FROM `repositories_contributors` AS repc
											WHERE repc.repository_id = repc.contributor_id)
	AND repo_con.contributor_id IS NULL;
	
UPDATE `repositories_contributors` AS rc
	SET rc.contributor_id = rc.contributor_id
	WHERE rc.repository_id = rc.contributor_id AND rc.repository_id = (SELECT min_id.id FROM (SELECT rc.contributor_id, MIN(rc.repository_id) AS 'id'
										FROM `repositories_contributors` AS rc
										RIGHT JOIN `repositories` AS r
										ON rc.repository_id = r.id
										WHERE  rc.contributor_id = rc.repository_id
										GROUP BY rc.contributor_id
										HAVING rc.contributor_id IS NULL) AS min_id);
										
DELETE repositories FROM repositories
	LEFT JOIN `issues` AS i
	ON repositories.id = i.repository_id
	WHERE i.id IS NULL;
	
-- querying

SELECT u.id, u.username
	FROM `users` AS u
	ORDER BY u.id;
	
SELECT rc.repository_id, rc.contributor_id
	FROM `repositories_contributors` AS rc
	WHERE rc.repository_id = rc.contributor_id
	ORDER BY rc.repository_id;
	
SELECT f.id, f.name, f.size
	FROM `files` AS f
	WHERE f.size > 1000 AND f.name LIKE ("%html%")
	ORDER BY f.size DESC;
	
SELECT i.id, CONCAT(u.username, ' : ', i.title) AS 'issue_assignee'
	FROM `issues` AS i
	INNER JOIN `users` AS u
	ON i.assignee_id = u.id
	ORDER BY i.id DESC;
	
SELECT f.id, f.name, CONCAT(f.size, 'KB') AS 'size'
	FROM `files` AS f
	LEFT JOIN `files` AS fi
	ON f.id = fi.parent_id
	WHERE fi.parent_id IS NULL
	ORDER BY f.id;
	
SELECT r.id, r.name, COUNT(i.id) AS 'issues'
	FROM `repositories` AS r
	INNER JOIN `issues` AS i
	ON r.id = i.repository_id
	GROUP BY r.id, r.name
	ORDER BY `issues` DESC, r.id ASC
	LIMIT 5;
	
SELECT first_step.id, first_step.name, COUNT(c.id) AS 'commits',first_step.contributors
	FROM (SELECT r.id, r.name, COUNT(rc.contributor_id) AS 'contributors'
				FROM `repositories` AS r
				INNER JOIN `repositories_contributors` AS rc
				ON r.id = rc.repository_id
				GROUP BY r.id, r.name
				ORDER BY contributors DESC, r.id
				LIMIT 1) AS first_step
	INNER JOIN `commits` AS c 
	ON first_step.id = c.repository_id;
	
-- NOT FINISHED QUERY
SELECT u.id, u.username, COUNT(c.id) AS 'commits'
	FROM `users` AS u
	INNER JOIN `issues` AS i
	ON u.id = i.assignee_id
	INNER JOIN `commits` AS c
	ON i.id = c.issue_id
	GROUP BY u.username
	ORDER BY `commits` DESC, u.id;
	
-- NOT FINISHED YET
SELECT SUBSTRING(f.name, 1, POSITION('.' IN f.name) - 1) AS 'file', COUNT(c.message) AS 'recursive_count'
	FROM `files` AS f
	INNER JOIN `commits` AS c
	ON c.message LIKE (CONCAT('%', f.name, '%'))
	INNER JOIN `files` AS p
	ON f.parent_id = p.id
	WHERE p.id = f.parent_id AND p.parent_id = f.id
	GROUP BY `file`;
	
-- UNFINISHED, AS WELL
SELECT c.repository_id AS 'id', r.name, COUNT(c.contributor_id) AS 'users'
	FROM `commits` AS c
	RIGHT JOIN `repositories` AS r
	ON c.repository_id = r.id
	GROUP BY c.repository_id
	ORDER BY `users` DESC, r.id;
	
-- section 4: programmability

DELIMITER $$
CREATE PROCEDURE udp_commit(username VARCHAR(30), `password` VARCHAR(30), message VARCHAR(255), issue_id INT(11))
BEGIN
	DECLARE exception CONDITION FOR SQLSTATE '45000';
	IF((SELECT u.username
			FROM `users` AS u
			WHERE u.username = username) IS NULL) THEN 
			SIGNAL exception
				SET MESSAGE_TEXT = 'No such user!';
	ELSEIF((SELECT u.`password`
			FROM `users` AS u
			WHERE u.`password` = `password`) IS NULL) THEN
			SIGNAL exception
				SET MESSAGE_TEXT = 'Password is incorrect!';
	ELSEIF((SELECT i.id
			FROM `issues` AS i
			WHERE i.id = issue_id) IS NULL) THEN
			SIGNAL exception
				SET MESSAGE_TEXT = 'The issue does not exist';
	ELSE INSERT INTO `commits`(`message`, `issue_id`, `repository_id`, `contributor_id`) 
			VALUES(message, issue_id, (SELECT i.repository_id
				FROM `issues` AS i
				WHERE i.id = issue_id), (SELECT u.id
				FROM `users` AS u
				INNER JOIN `issues` AS i
				ON u.id = i.assignee_id
				WHERE u.username = username
				LIMIT 1));
				
			UPDATE `issues` AS i
				SET i.issue_status = 'closed'
				WHERE i.id = issue_id;
				
			SELECT c.id, c.message, issue_id, repository_id, contributor_id
				FROM `commits` AS c;
	END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE udp_findbyextension(extension VARCHAR(20))
BEGIN
	SELECT f.id, f.name AS 'caption', CONCAT(f.size, 'KB') AS 'size'
		FROM `files` AS f
		WHERE f.name LIKE CONCAT('%', extension)
		ORDER BY f.id;
END $$
DELIMITER ;
	