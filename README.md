# 710-Management 
## A management system for company and gang funds that works with all frameworks! 

# Docs 
http://kmack710.info/docs
# Support 
https://Guilded.gg/710 

## IMPORTANT 
If using QBCore then turn all jobs default duty to false so they will always log in as false. This resource automatically puts them off duty when they log out! 



## Exports 
```lua 
exports['710-Management']:GetManagementAccounts()
exports['710-Management']:GetManagementAccount(name)
exports['710-Management']:AddAccountMoney(name, amount)
exports['710-Management']:RemoveAccountMoney(name, amount)

exports['710-Management']:CheckIfPlayerOnDuty(source)
exports['710-Management']:CheckHowManyStaffOnDuty(job)

```
```sql 
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
```
