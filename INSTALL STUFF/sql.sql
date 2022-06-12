CREATE TABLE `management_staff` (
	`pid` VARCHAR(255) NOT NULL COLLATE 'utf8_general_ci',
	`name` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`job` VARCHAR(255) NULL DEFAULT 'unemployed' COLLATE 'utf8_general_ci',
	`grade` INT(11) NULL DEFAULT '0',
	`payrate` INT(11) NULL DEFAULT '0',
	`job2` VARCHAR(255) NULL DEFAULT 'unemployed' COLLATE 'utf8_general_ci',
	`grade2` INT(11) NULL DEFAULT '0',
	`payrate2` INT(11) NULL DEFAULT '0',
	`duty` INT(11) NULL DEFAULT '0',
	PRIMARY KEY (`pid`) USING BTREE
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

CREATE TABLE `management_accounts` (
	`name` VARCHAR(255) NOT NULL COLLATE 'utf8_general_ci',
	`balance` INT(11) NOT NULL DEFAULT '0',
	`menu` LONGTEXT NOT NULL COLLATE 'utf8_general_ci',
	`bossgrade` INT(11) NULL DEFAULT NULL,
	`dutylocation` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	PRIMARY KEY (`name`) USING BTREE
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;