CREATE TABLE `management_accounts` (
	`name` VARCHAR(255) NOT NULL DEFAULT NULL,
	`balance` INT NOT NULL DEFAULT 0,
	`menu` LONGTEXT NOT NULL,
	PRIMARY KEY (`name`)
)
COLLATE='utf8_general_ci'
;
