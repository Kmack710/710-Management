local Framework = exports['710-lib']:GetFrameworkObject()
local GConfig = Framework.Config()
local QBCore = {}
local SharedGangData = {}
if GConfig.Framework == 'qbcore' then 
    QBCore = exports['qb-core']:GetCoreObject()
end 

RegisterCommand(Config.Important['CreateLocationCommand'],function(source, args, rawCommand)
    local source = source
    if Config.Important['AdminCheckForCommands'] then 
        if Framework.AdminCheck(source) then 
            TriggerClientEvent('710-Management:createLocationInput', source)
        else 
            local Player = Framework.PlayerDataS(source)
            Player.Notify(Locales['NotAnAdmin'] ,'error')
        end
    else 
        TriggerClientEvent('710-Management:createLocationInput', source)
    end
end, false)

RegisterCommand(Config.Important['HireANewPlayerAdmin'],function(source, args, rawCommand)
    local source = source
    if Config.Important['AdminCheckForCommands'] then 
        if Framework.AdminCheck(source) then 
            TriggerClientEvent('710-Management:manageJobAdmin', source)
        else 
            local Player = Framework.PlayerDataS(source)
            Player.Notify(Locales['NotAnAdmin'] ,'error')
        end
    else 
        TriggerClientEvent('710-Management:manageJobAdmin', source)
    end
end, false)

 -- 710-Management:manageJobAdmin
RegisterCommand(Config.Important['CreateADutyLocationCommand'],function(source, args, rawCommand)
    local source = source
    if Config.Important['AdminCheckForCommands'] then 
        if Framework.AdminCheck(source) then 
            TriggerClientEvent('710-Management:createDutyLocationInput', source)
        else 
            local Player = Framework.PlayerDataS(source)
            Player.Notify(Locales['NotAnAdmin'] ,'error')
        end
    else 
        TriggerClientEvent('710-Management:createLocationInput', source)
    end
end, false)


RegisterNetEvent('710-Manaagement:changeJobs', function()
    local source = source
    local Player = Framework.PlayerDataS(source)
    local pid = Player.Pid 
    local Job = JobCheck(pid) 
    local Cjob = Player.Job.name 
    local CGrade = Player.Job.Grade.level
    local CPay = Job.payrate
    local Sjob = Job.job2
    local SGrade = Job.grade2
    local SPay = Job.payrate2

    if GConfig.OxSQL == 'new' then 
        MySQL.update('UPDATE management_staff SET job = @job, grade = @grade, payrate = @payrate, job2 = @job2, grade2 = @grade2, payrate2 = @payrate2  WHERE pid = @pid', {
            ['@job'] = Sjob, 
            ['@grade'] = SGrade,
            ['@payrate'] = SPay,
            ['@job2'] = Cjob, 
            ['@grade2'] = CGrade,
            ['@payrate2'] = CPay,
            ['@pid'] = pid, 

        })
    else 
        exports.oxmysql:execute('UPDATE management_staff SET job = @job, grade = @grade, payrate = @payrate, job2 = @job2, grade2 = @grade2, payrate2 = @payrate2  WHERE pid = @pid', {
            ['@job'] = Sjob, 
            ['@grade'] = SGrade,
            ['@payrate'] = SPay,
            ['@job2'] = Cjob, 
            ['@grade2'] = CGrade,
            ['@payrate2'] = CPay,
            ['@pid'] = pid, 

        })
    end
    Player.SetJob(Sjob, SGrade)
    local Player = Framework.PlayerDataS(source)
    
    Player.Notify(Locales['ChangedJobNoti']..Player.Job.label..' - '..Player.Job.Grade.label)
end)

---- CreateNewDutyLocation
RegisterNetEvent('710-Management:CreateNewManagementMenu', function(bossgrade, name, location)
    local source = source 
    local Player = Framework.PlayerDataS(source)
    local accountCheck = GetManagementAccount(name)
    if accountCheck == false then 
        if GConfig.OxSQL == 'new' then
            if GConfig.Framework == 'qbcore' then 
                if Config.Important['TransferDataFromQbManagement'] then 
                    local oldManagementAccount = MySQL.query.await('SELECT * FROM management_funds WHERE job_name = ?', {name})
                    if oldManagementAccount then 
                        local balance = oldManagementAccount[1].amount 
                        MySQL.query('INSERT INTO management_accounts (name, bossgrade, menu, balance) VALUES (@name, @bossgrade, @menu, @balance)', {['@name'] = name, ['@bossgrade'] = bossgrade, ['@menu'] = json.encode(location), ['@balance'] = balance})
                        MySQL.query('DELETE FROM management_funds WHERE job_name = @name', {['@name'] = name})
                    else 
                        MySQL.query('INSERT INTO management_accounts (name, bossgrade, menu) VALUES (@name, @bossgrade, @menu)', {['@name'] = name, ['@bossgrade'] = bossgrade, ['@menu'] = json.encode(location)}) 
                    end
                else
                    MySQL.query('INSERT INTO management_accounts (name, bossgrade, menu) VALUES (@name, @bossgrade, @menu)', {['@name'] = name, ['@bossgrade'] = bossgrade, ['@menu'] = json.encode(location)}) 
                end  
            else 
                MySQL.query('INSERT INTO management_accounts (name, bossgrade, menu) VALUES (@name, @bossgrade, @menu)', {['@name'] = name, ['@bossgrade'] = bossgrade, ['@menu'] = json.encode(location)}) 
            end 
        else
            if GConfig.Framework == 'qbcore' then
                if Config.Important['TransferDataFromQbManagement'] then  
                    local oldManagementAccount = exports.oxmysql:executeSync('SELECT * FROM management_funds WHERE job_name = ?', {name})
                    if oldManagementAccount then 
                        local balance = oldManagementAccount[1].amount 
                        exports.oxmysql:execute('INSERT INTO management_accounts (name, bossgrade, menu, balance) VALUES (@name, @bossgrade, @menu, @balance)', {['@name'] = name, ['@bossgrade'] = bossgrade, ['@menu'] = json.encode(location), ['@balance'] = balance})
                        exports.oxmysql:execute('DELETE FROM management_funds WHERE job_name = @name', {['@name'] = name})
                    else 
                        exports.oxmysql:execute('INSERT INTO management_accounts (name, bossgrade, menu) VALUES (@name, @bossgrade, @menu)', {['@name'] = name, ['@bossgrade'] = bossgrade, ['@menu'] = json.encode(location)}) 
                    end
                else 
                    exports.oxmysql:execute('INSERT INTO management_accounts (name, bossgrade, menu) VALUES (@name, @bossgrade, @menu)', {['@name'] = name, ['@bossgrade'] = bossgrade, ['@menu'] = json.encode(location)})
                end  
            else 
                exports.oxmysql:execute('INSERT INTO management_accounts (name, bossgrade, menu) VALUES (@name, @bossgrade, @menu)', {['@name'] = name, ['@bossgrade'] = bossgrade, ['@menu'] = json.encode(location)}) 
            end
        end
        Player.Notify(Locales['ManagementAccountCreated'], 'success')  
        registerStashes()
    else 
        Player.Notify(Locales['ManagementAccountExists'], 'error')
    end 
end)



RegisterNetEvent('710-Management:CreateNewDutyLocation', function(name, location)
    local source = source 
    local Player = Framework.PlayerDataS(source)
    local accountCheck = GetManagementAccount(name)
    local dutylocation = location 
    if accountCheck ~= false then 
        if GConfig.OxSQL == 'new' then 
            MySQL.query.await('UPDATE management_accounts SET dutylocation = @dutylocation WHERE name = @name', {['@name'] = name, ['@dutylocation'] = json.encode(dutylocation)})
            --MySQL.query('UPDATE management_accounts SET menu = @menu WHERE name = @name', {['@name'] = name, ['@menu'] = location})
        else 
            exports.oxmysql:executeSync('UPDATE management_accounts SET dutylocation = @dutylocation WHERE name = @name', {['@name'] = name, ['@dutylocation'] = json.encode(dutylocation)})
        end
    else 
        Player.Notify(Locales['ManagementAccountNotExists'], 'error')
    end

end)

function JobCheck(pid)
    if GConfig.OxSQL == 'new' then
        local job = MySQL.query.await('SELECT * FROM management_staff WHERE pid = @pid', {['@pid'] = pid})
        return job[1]
    else 
        local job = exports.oxmysql:executeSync('SELECT * FROM management_staff WHERE pid = @pid', {['@pid'] = pid})
        return job[1]
    end
end 


function registerStashes()  --- Only used for ox_inventory but can be used for other ones that need to register stashes on server side on resource start. QB only does this on client.
    local dbinfo = GetManagementAccounts()
    for k,v in pairs(dbinfo) do
        local stash = {
            id = v.name.."-"..Locales['BossSafe'],
            label = v.name..Locales['BossSafe'],
            slots = 50,
            weight = 100000
        }
        Framework.RegisterStash(stash.id, stash.label, stash.slots, stash.weight)
    end
end 

if Config.Important['Using710-GangSystem'] then 
    function Get710GangData()
        local Gangs = {}
        if Config.Important['updatedOxMySQL'] then 
            Gangs = MySQL.query.await("SELECT * FROM 710_gangs")
            local gangshit = {}
            for k, v in pairs(Gangs) do 
                gangshit[v.gang] = json.decode(v.gangdata)
            end 
            return gangshit
        else 
            Gangs = exports.oxmysql:executeSync("SELECT * FROM 710_gangs")
            local gangshit = {}
            for k, v in pairs(Gangs) do 
                gangshit[v.gang] = json.decode(v.gangdata)
            end 
            return gangshit
        end
    end
end  


AddEventHandler('onServerResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then 
        Wait(3000)
        registerStashes()
        Wait(6000)

        print("^2▀▀█ ▄█ █▀█ ▄▄ █▀▄▀█ ▄▀█ █▄░█ ▄▀█ █▀▀ █▀▀ █▀▄▀█ █▀▀ █▄░█ ▀█▀\n░░█ ░█ █▄█ ░░ █░▀░█ █▀█ █░▀█ █▀█ █▄█ ██▄ █░▀░█ ██▄ █░▀█ ░█░")
        print('^3Support available at guilded.gg/710')
        if GConfig.Framework == 'qbcore' then 
            if Config.Important['Using710-GangSystem'] then 
                SharedGangData = Get710GangData()
                print('^1 710 Gang System is loaded be sure to REMOVE all gangs from qb-core/shared/Gangs besides NONE and create them from 710-GangSystem.')
            else
                SharedGangData = QBCore.Shared.Gangs
            end
        end

        CreateThread( function()
            updatePath = "/Kmack710/710-Management" -- your git user/repo path
            resourceName = GetCurrentResourceName() -- the resource name
            function checkVersion(err,responseText, headers)
                local curVersion = tonumber(1.1) -- make sure the "version" file actually exists in your resource root!
                local rresponseText = tonumber(responseText)
                if curVersion ~= rresponseText and curVersion < rresponseText then
                    print("^1################# RESOURCE OUT OF DATE ###############################")
                    print("^1"..resourceName.." is outdated, New Version: "..responseText.."Your Version: "..curVersion.." please update from https://github.com/Kmack710/710-Management")
                    print("############### Please Download the newest version ######################")
                elseif curVersion > rresponseText then
                    print("^2"..resourceName.." is up to date, have fun!")
                else
                    print("^2"..resourceName.." is up to date, have fun!")
                end
            end
            
            PerformHttpRequest("https://raw.githubusercontent.com"..updatePath.."/master/version", checkVersion, "GET")
        end)
    end
end)

RegisterNetEvent('710-Management:HireNewStaff', function(pSource, Pjob, grade)
    if pSource ~= nil then 
        local Player = Framework.PlayerDataS(pSource)
        local pid = Player.Pid
        Player.SetJob(Pjob, grade)
        local Player = Framework.PlayerDataS(pSource) -- refresh Player data 
        Player.Notify(Locales['YouHaveBeenHired']..Player.Job.label, 'success')
        local payrate = {}
        if GConfig.Framework == 'esx' then 
            payrate = Player.Job.grade_salary
        else 
            payrate = Player.Job.payment
        end
        if GConfig.OxSQL == 'new' then 
            MySQL.query('UPDATE `management_staff` SET `payrate` = @payrate, `job` = @job, grade = @grade WHERE `pid` = @pid', {['@pid'] = pid, ['@payrate'] = payrate, ['@job'] = Pjob, ['@grade'] = grade})
        else
            exports.oxmysql:execute('UPDATE `management_staff` SET `payrate` = @payrate, `job` = @job, grade = @grade WHERE `pid` = @pid', {['@pid'] = pid, ['@payrate'] = payrate, ['@job'] = Pjob, ['@grade'] = grade})
        end

    end
end)

RegisterNetEvent('710-Management:HireNewAdmin', function(pSource, Pjob, grade, payrate)
    local source = source
    if Framework.AdminCheck(source) then  
        if pSource ~= nil then 
            local Player = Framework.PlayerDataS(pSource)
            local pid = Player.Pid
            Player.SetJob(Pjob, grade)
            local Player = Framework.PlayerDataS(pSource) -- refresh Player data 
            Player.Notify(Locales['YouHaveBeenHired']..Player.Job.label, 'success')
            if GConfig.OxSQL == 'new' then 
                MySQL.query('UPDATE `management_staff` SET `payrate` = @payrate, `job` = @job, grade = @grade WHERE `pid` = @pid', {['@pid'] = pid, ['@payrate'] = payrate, ['@job'] = Pjob, ['@grade'] = grade})
            else
                exports.oxmysql:execute('UPDATE `management_staff` SET `payrate` = @payrate, `job` = @job, grade = @grade WHERE `pid` = @pid', {['@pid'] = pid, ['@payrate'] = payrate, ['@job'] = Pjob, ['@grade'] = grade})
            end

        end
    else 
        Player.Notify(Locales['NotAnAdmin'], 'error')
    end
end)


RegisterNetEvent('710-Management:ChangeStaffRank', function(pid, Pjob, grade)
    local employee = Framework.GetPlayerFromPidS(pid)
    local source = source 
    if employee then 
        pSource = employee.Source
        local Player = Framework.PlayerDataS(pSource)
        Player.SetJob(Pjob, grade)
        local Player = Framework.PlayerDataS(pSource)
        Player.Notify(Locales['RankHasBeenChanged']..Player.Job.Grade.label, 'success')
        if GConfig.OxSQL == 'new' then 
            MySQL.query('UPDATE `management_staff` SET grade = @grade WHERE `pid` = @pid', {['@pid'] = pid, ['@grade'] = grade})
        else
            exports.oxmysql:execute('UPDATE `management_staff` SET grade = @grade WHERE `pid` = @pid', {['@pid'] = pid,  ['@grade'] = grade})
        end
    else 
        local Player = Framework.PlayerDataS(source)
        Player.Notify(Locales['PlayerNotOnline'], 'error')
    end
end) 


function GetManagementAccounts()
    if GConfig.OxSQL == 'new' then 
        local Accounts = MySQL.query.await('SELECT * FROM `management_accounts`')
        if Accounts ~= nil then
            return Accounts
        else 
            print('No Management accounts have been made please create them ingame!')
        end
    else
        local Accounts = exports.oxmysql:executeSync('SELECT * FROM `management_accounts`')
        if Accounts ~= nil then
            return Accounts
        else 
            print('No Management accounts have been made please create them ingame!')
        end 
    end 
end 

Framework.RegisterServerCallback('710-Mangement:GetAllAccounts', function(source, cb)
    local source = source 
    if source ~= nil then 
        local Accounts = GetManagementAccounts()
        if Accounts ~= nil then 
            cb(Accounts)
        else 
            cb(false)
        end 
    else 
        cb(false)
    end
end)  

Framework.RegisterServerCallback('710-Management:CheckIfBoss', function(source, cb, job)
    local source = source 
    if source ~= nil then 
        local isBoss = CheckIfBossS(source, job)
        cb(isBoss)
    else 
        cb(false)
    end
end) 

Framework.RegisterServerCallback('710-Mangement:GetJobRanks', function(source, cb, job)
    local source = source 
    if source ~= nil then 
        local ranks = GetJobRanks(job)
        if ranks ~= nil then 
            cb(ranks)
        else 
            cb(false)
        end 
    else 
        cb(false)
    end
end)

Framework.RegisterServerCallback('710-Mangement:GetJobStaff', function(source, cb, job)
    if GConfig.OxSQL == 'new' then 
        local staff = MySQL.query.await('SELECT * FROM `management_staff` WHERE `job` = @job', {['@job'] = job})
        if staff ~= nil then 
            cb(staff)
        else 
            cb(false)
        end
    else 
        local staff = exports.oxmysql:executeSync('SELECT * FROM `management_staff` WHERE `job` = @job', {['@job'] = job})
        if staff ~= nil then 
            cb(staff)
        else 
            cb(false)
        end
    end 
end)



function GetJobRanks(job)
    if GConfig.OxSQL == 'new' then 
        local data = MySQL.query.await('SELECT * FROM job_grades WHERE job_name = @job', {['@job'] = job})
        return data 
    else
        local data = exports.oxmysql:executeSync('SELECT * FROM job_grades WHERE job_name = @job', {['@job'] = job})
        return data
    end
end 

Framework.RegisterServerCallback('710-Mangement:GetAccount', function(source, cb, job)
    local source = source 
    if source ~= nil then 
        local Account = GetManagementAccount(job)
        if Account ~= nil then 
            cb(Account)
        else 
            cb(false)
        end 
    else 
        cb(false)
    end
end)

function GetManagementAccount(name)
    if GConfig.OxSQL == 'new' then 
        local Account = MySQL.query.await('SELECT * FROM `management_accounts` WHERE `name` = @name', {['@name'] = name})
        if Account[1] then 
            return Account[1]
        else 
            return false
        end
    else
        local Account = exports.oxmysql:executeSync('SELECT * FROM `management_accounts` WHERE `name` = @name', {['@name'] = name})
        if Account[1] then 
            return Account[1]
        else 
            return false
        end
    end 
end

function AddAccountMoney(name, amount)
    if GConfig.OxSQL == 'new' then 
        MySQL.query.await('UPDATE `management_accounts` SET `balance` = `balance` + @amount WHERE `name` = @name', {['@name'] = name, ['@amount'] = amount})
    else
        exports.oxmysql:executeSync('UPDATE `management_accounts` SET `balance` = `balance` + @amount WHERE `name` = @name', {['@name'] = name, ['@amount'] = amount})
    end 
end

RegisterNetEvent('710-Management:BankingTransfer', function(action, Pjob, amount)
    local source = source 
    local amount = tonumber(amount)
    local Player = Framework.PlayerDataS(source)
    local account = GetManagementAccount(Pjob)
    if Player.Job.name == Pjob then 
        if action == 'deposit' then
            if Player.Cash >= amount then 
                Player.RemoveCash(amount)
                Player.Notify(Locales['DepositSuccess']..' $'..amount, 'success')
                AddAccountMoney(Pjob, amount)
            else
                Player.Notify(Locales['NotEnoughMoney'], 'error')
            end 
        elseif action == 'withdraw' then 
            if account.balance >= amount then 
                Player.AddCash(amount)
                Player.Notify(Locales['WithdrawSuccess']..' $'..amount, 'success')
                RemoveAccountMoney(Player.Job.name, amount)
            else 
                Player.Notify(Locales['NotEnoughMoney'], 'error')
            end 
        end 
    else 
        Player.Notify(Locales['YouAreNotInThisJob'], 'error')
    end

end)

function RemoveAccountMoney(name, amount)
    local currentAccount = GetManagementAccount(name)
    if tonumber(currentAccount.balance) >= amount then 
        if GConfig.OxSQL == 'new' then 
            MySQL.query.await('UPDATE `management_accounts` SET `balance` = `balance` - @amount WHERE `name` = @name', {['@name'] = name, ['@amount'] = amount})
            return true
        else
            exports.oxmysql:executeSync('UPDATE `management_accounts` SET `balance` = `balance` - @amount WHERE `name` = @name', {['@name'] = name, ['@amount'] = amount})
            return true
        end
    else 
        return false
    end 
end

function CheckEmployeesTable(pid)
    if GConfig.OxSQL == 'new' then 
        local data = MySQL.query.await('SELECT * FROM `management_staff` WHERE `pid` = @pid', {['@pid'] = pid})
        if data[1] then 
            return data[1]
        else 
            return false
        end
    else
        local data = exports.oxmysql:executeSync('SELECT * FROM `management_staff` WHERE `pid` = @pid', {['@pid'] = pid})
        if data[1] then 
            return data[1]
        else 
            return false
        end
    end 
end

Framework.RegisterServerCallback('710-Management:GetMyJobInfo', function(source, cb, pid)
    local source = source 
    if source ~= "" then 
        cb(CheckEmployeesTable(pid)) 
    end
end)

RegisterNetEvent('710-Management:SetJobSalary', function(pid, payrate)
    local Player = Framework.GetPlayerFromPidS(pid)
    if GConfig.OxSQL == 'new' then 
        MySQL.query('UPDATE `management_staff` SET `payrate` = @payrate WHERE `pid` = @pid', {['@pid'] = pid, ['@payrate'] = payrate})
    else
        exports.oxmysql:execute('UPDATE `management_staff` SET `payrate` = @payrate WHERE `pid` = @pid', {['@pid'] = pid, ['@payrate'] = payrate})
    end
    if Player then 
        Framework.NotiS(Player.Source, Locales['PayRateChanged']..payrate, 'success')
    end 

end)

RegisterServerEvent('710-Management:PlayerLoadedS', function()
    local source = source 
    local Player = Framework.PlayerDataS(source)
    local Payrate = {}
    if GConfig.Framework == 'esx' then 
        Payrate = Player.Job.grade_salary
    else 
        Payrate = Player.Job.payment
    end 
    if CheckEmployeesTable(Player.Pid) == false then 
        if GConfig.OxSQL == 'new' then 
            MySQL.query.await('INSERT INTO `management_staff` (`pid`, `job`, `grade`, `payrate`, `name`) VALUES (@pid, @job, @grade, @payrate, @name)', {
                ['@pid'] = Player.Pid, 
                ['@job'] = Player.Job.name, 
                ['@grade'] = Player.Job.Grade.level,
                ['@payrate'] = Payrate,
                ['@name'] = Player.Name,
            })
        else
            exports.oxmysql:executeSync('INSERT INTO `management_staff` (`pid`, `job`, `grade`, `payrate`, `name`) VALUES (@pid, @job, @grade, @payrate, @name)', {
                ['@pid'] = Player.Pid, 
                ['@job'] = Player.Job.name, 
                ['@grade'] = Player.Job.Grade.level,
                ['@payrate'] = Payrate,
                ['@name'] = Player.Name,
            })
        end
        print('New Player Loaded in they are now added to employees table')
    end
    

end)

RegisterNetEvent('710-Management:PayStaffFromFunds', function()
    local source = source 
    local Player = Framework.PlayerDataS(source)
    local pid = Player.Pid
    local Jobinfo = JobCheck(pid)  
    local PayRate = Jobinfo.payrate
    local Jobname = Jobinfo.job
    if Config.Management['PayFromAccount'] then 
        if RemoveAccountMoney(Jobname, PayRate) then 
            Player.AddBankMoney(PayRate)
            Player.Notify(Locales['SalaryPaid']..' $'..PayRate, 'success')
        else 
            Player.Notify(Locales['SalaryFailed'], 'error')
        end 
    else 
        Player.AddBankMoney(PayRate)
        Player.Notify(Locales['SalaryPaid']..' $'..PayRate, 'success')
    end 
end)

RegisterNetEvent('710-Management:PayWelfareCheck', function()
    local source = source 
    local Player = Framework.PlayerDataS(source)
    Player.AddBankMoney(Config.Management['WelfarePayAmount'])
    Player.Notify(Locales['WelfarePaid'])
end)

function CheckIfBossS(source, job)
    local source = source 
    local Player = Framework.PlayerDataS(source)
    local PJob = Player.Job.name
    local Jobgrade = Player.Job.Grade.level
    if PJob == job then
        if GConfig.OxSQL == 'new' then 
            local data = MySQL.query.await('SELECT * FROM `management_accounts` WHERE `name` = @name', {['@name'] = job})
            if data[1].bossgrade == Jobgrade then 
                return true
            else 
                return false
            end
        else
            local data = exports.oxmysql:executeSync('SELECT * FROM `management_accounts` WHERE `name` = @name', {['@name'] = job})
            if data[1].bossgrade == Jobgrade then 
                return true
            else 
                return false
            end
        end
    else 
        return false
    end 
end


function CheckIfPlayerOnDuty(source)
    local source = source 
    local Player = Framework.PlayerDataS(source)
    local pid = Player.Pid 
    if GConfig.OxSQL == 'new' then 
        local data = MySQL.query.await('SELECT * FROM `management_staff` WHERE `pid` = @pid', {['@pid'] = pid})
        if data[1].duty == 1 then 
            return true
        else 
            return false
        end
    else
        local data = exports.oxmysql:executeSync('SELECT * FROM `management_staff` WHERE `pid` = @pid', {['@pid'] = pid})
        if data[1].duty == 1 then 
            return true
        else 
            return false
        end
    end 
end 

function CheckHowManyStaffOnDuty(job)
    if GConfig.OxSQL == 'new' then 
        local data = MySQL.query.await('SELECT * FROM `management_staff` WHERE `job` = @job AND `duty` = 1', {['@job'] = job})
        if data[1] then 
            return #data
        else 
            return 0
        end
    else
        local data = exports.oxmysql:executeSync('SELECT * FROM `management_staff` WHERE `job` = @job AND `duty` = 1', {['@job'] = job})
        if data[1] then 
            return #data
        else 
            return 0
        end
    end
end

function GoOnDuty(pid, onDuty)
    local setDuty = 0
    if onDuty then setDuty = 1 end 
    if GConfig.OxSQL == 'new' then 
        MySQL.query('UPDATE `management_staff` SET `duty` = @duty WHERE `pid` = @pid', {['@pid'] = pid, ['@duty'] = setDuty})
    else
        exports.oxmysql:execute('UPDATE `management_staff` SET `duty` = @duty WHERE `pid` = @pid', {['@pid'] = pid, ['@duty'] = setDuty})
    end
end

Framework.RegisterServerCallback('710-Management:AmIOnDuty', function(source, cb)
    local source = source 
    local Player = Framework.PlayerDataS(source)
    local pid = Player.Pid 
    if CheckIfPlayerOnDuty(source) then 
        cb(true)
    else 
        cb(false)
    end
end)

RegisterNetEvent('710-Management:ServerGoOnDuty', function()
    local source = source 
    local Player = Framework.PlayerDataS(source)
    local dutyCheck = CheckIfPlayerOnDuty(source)
    if dutyCheck == true then 
        GoOnDuty(Player.Pid, false)
        if GConfig.Framework == 'qbcore' then 
            if Player.QBDuty then 
                Player.SetDuty(false)
            end
        end  
        Player.Notify(Locales['YouAreOffDuty']..Player.Job.label, 'info')
    else 
        GoOnDuty(Player.Pid, true)
        if GConfig.Framework == 'qbcore' then 
            if not Player.QBDuty then 
                Player.SetDuty(true)
            end
        end  
        Player.Notify(Locales['YouAreOnDuty']..Player.Job.label, 'info')
    end
end)


AddEventHandler('playerDropped', function()
	local source = source
	if source ~= "" then
		local Player = Framework.PlayerDataS(source)
        local Pid = Player.Pid
        local dutyCheck = CheckIfPlayerOnDuty(source)
		if dutyCheck then
            GoOnDuty(Pid, false)
            if GConfig.Framework == 'qbcore' then
                if Player.QBDuty then 
                    Player.SetDuty(false)
                end 
            end 
		end
	end
end)

RegisterNetEvent('710-Management:FireStaff', function(pid)
    local source = source 
    local Player = Framework.GetPlayerFromPidS(pid)
    if Player then 
        Player.SetJob('unemployed', 0)
        Framework.NotiS(Player.Source, Locales['YouWereFiredFool'], 'info')
        if GConfig.OxSQL == 'new' then 
            MySQL.query('UPDATE `management_staff` SET `duty` = 0, `job` = @job, grade = @grade, payrate = @payrate WHERE `pid` = @pid', {['@pid'] = pid, ['@job'] = 'unemployed', ['@grade'] = 0, ['@payrate'] = 0})
        else 
            exports.oxmysql:execute('UPDATE `management_staff` SET `duty` = 0, `job` = @job, grade = @grade, payrate = @payrate WHERE `pid` = @pid', {['@pid'] = pid, ['@job'] = 'unemployed', ['@grade'] = 0, ['@payrate'] = 0})
        end
        local bossPerson = Framework.PlayerDataS(source)
        bossPerson.Notify(Locales['YouFired']..Player.Name, 'info')
    else 
        if GConfig.OxSQL == 'new' then 
            MySQL.query('UPDATE `management_staff` SET `duty` = 3, `job` = @job, grade = @grade, payrate = @payrate WHERE `pid` = @pid', {['@pid'] = pid, ['@job'] = 'unemployed', ['@grade'] = 0, ['@payrate'] = 0})
        else 
            exports.oxmysql:execute('UPDATE `management_staff` SET `duty` = 3, `job` = @job, grade = @grade, payrate = @payrate WHERE `pid` = @pid', {['@pid'] = pid, ['@job'] = 'unemployed', ['@grade'] = 0, ['@payrate'] = 0})
        end
    end
    local bossPerson = Framework.PlayerDataS(source)
    bossPerson.Notify(Locales['YouFired'].."Someone.", 'info') 
    
end) 

RegisterNetEvent('710-Management:OfflinePlayerFired', function()
    local source = source 
    local Player = Framework.PlayerDataS(source)
    Player.SetJob('unemployed', 0)
    Player.Notify(Locales['YouWereFiredFool'], 'info')
    if GConfig.OxSQL == 'new' then 
        MySQL.query('UPDATE `management_staff` SET `duty` = 0 WHERE `pid` = @pid', {['@pid'] = Player.Pid})
    else 
        exports.oxmysql:execute('UPDATE `management_staff` SET `duty` = 0 WHERE `pid` = @pid', {['@pid'] = Player.Pid})
    end
end)

--- Exports ---
exports('GetManagementAccounts', GetManagementAccounts)
exports('GetManagementAccount', GetManagementAccount)
exports('AddAccountMoney', AddAccountMoney)
exports('RemoveAccountMoney', RemoveAccountMoney)
exports('CheckIfPlayerOnDuty', CheckIfPlayerOnDuty)
exports('CheckHowManyStaffOnDuty', CheckHowManyStaffOnDuty)
exports('CheckIfBossS', CheckIfBossS)


if GConfig.Framework == 'qbcore' then 
    RegisterNetEvent('710-Management:ChangeGangRank', function(pid, Pgang, grade)
        local IsGangMemberActive = Framework.GetPlayerFromPidS(pid)
    
        if IsGangMemberActive then 
            local Player = Framework.PlayerDataS(IsGangMemberActive.Source)
            Player.SetGang(Pgang, tonumber(grade))
            local Player = Framework.PlayerDataS(IsGangMemberActive.Source)
            Player.Notify(Locales['GangRankChanged']..Player.Gang.grade.name)
    
        else 
            if GConfig.OxSQL == 'new' then 
                local data = MySQL.query.await("SELECT * FROM `players` WHERE `citizenid` = @citizenid", {['@citizenid'] = pid })
                local gang = json.decode(data[1].gang)
                gang.grade.level = tonumber(grade)
                gang.grade.name = SharedGangData[Pgang].grades[grade].name
                MySQL.query("UPDATE `players` SET `gang` = @gang WHERE `citizenid` = @citizenid", {['@gang'] = json.encode(gang), ['@citizenid'] = pid })
            else 
                local data = exports.oxmysql:executeSync("SELECT * FROM `players` WHERE `citizenid` = @citizenid", {['@citizenid'] = pid })
                local gang = json.decode(data[1].gang)
                gang.grade.level = tonumber(grade)
                gang.grade.name = SharedGangData[Pgang].grades[grade].name
                exports.oxmysql:execute("UPDATE `players` SET `gang` = @gang WHERE `citizenid` = @citizenid", {['@gang'] = json.encode(gang), ['@citizenid'] = pid })
            end 
        end 
    
    end)
    
    Framework.RegisterServerCallback('710-Management:Get710Gangs', function(source, cb)
        local Gangs = Get710GangData()
        if Gangs then 
            cb(Gangs)
        end
    end)

    RegisterNetEvent('710-Management:RecruitNewGangMemberS', function(pSource, Pgang, grade)
        local NewGangMember = Framework.PlayerDataS(pSource)
        NewGangMember.SetGang(Pgang, tonumber(grade))
        local Player = Framework.PlayerDataS(pSource)
        Player.Notify(Locales['YouHaveBeenRecruitedGang']..Player.Gang.label, 'info')
    end)
    
    RegisterNetEvent('710-Management:RemoveFromGang', function(pid)
        local IsGangMemberActive = Framework.GetPlayerFromPidS(pid)
    
        if IsGangMemberActive then 
            local Player = Framework.PlayerDataS(IsGangMemberActive.Source)
            Player.SetGang('none', 0)
            local Player = Framework.PlayerDataS(IsGangMemberActive.Source)
            Player.Notify(Locales['GangRankChanged']..Player.Gang.grade.name)
        else 
            if GConfig.OxSQL == 'new' then 
                local gang = 'none'
                gang.grade.level = 0
                gang.grade.name = 'Unaffiliated'
                gang.isboss = false
                gang.label = 'No Affiliation'
                gang.payment = 0
    
                MySQL.query("UPDATE `players` SET `gang` = @gang WHERE `citizenid` = @citizenid", {['@gang'] = json.encode(gang), ['@citizenid'] = pid })
            else 
                local gang = 'none'
                gang.grade.level = 0
                gang.grade.name = 'Unaffiliated'
                gang.isboss = false
                gang.label = 'No Affiliation'
                gang.payment = 0
                exports.oxmysql:execute("UPDATE `players` SET `gang` = @gang WHERE `citizenid` = @citizenid", {['@gang'] = json.encode(gang), ['@citizenid'] = pid })
            end 
        end 
    
    end)
    
    RegisterNetEvent('710-Management:BankingTransferGang', function(action, Pjob, amount)
        local source = source 
        local amount = tonumber(amount)
        local Player = Framework.PlayerDataS(source)
        local account = GetManagementAccount(Pjob)
        if Player.Gang.name == Pjob then 
            if action == 'deposit' then
                if Player.Cash >= amount then 
                    Player.RemoveCash(amount)
                    Player.Notify(Locales['DepositSuccess']..' $'..amount, 'success')
                    AddAccountMoney(Pjob, amount)
                else
                    Player.Notify(Locales['NotEnoughMoney'], 'error')
                end 
            elseif action == 'withdraw' then 
                if account.balance >= amount then 
                    Player.AddCash(amount)
                    Player.Notify(Locales['WithdrawSuccess']..' $'..amount, 'success')
                    RemoveAccountMoney(Player.Job.name, amount)
                else 
                    Player.Notify(Locales['NotEnoughMoney'], 'error')
                end 
            end 
        else 
            Player.Notify(Locales['YouAreNotInThisJob'], 'error')
        end
    
    end)
    
    Framework.RegisterServerCallback('710-Management:GetPlayersInGang', function(source, cb, gang)
        local Player = Framework.PlayerDataS(source)
        local GangMembers = MySQL.query.await("SELECT * FROM `players` WHERE `gang` LIKE '%".. gang .."%'", {})
        
        local GangMemberTable = {}
        if GangMembers[1] ~= nil then 
            for k, v in pairs(GangMembers) do   
                local GangPlayerActive = Framework.GetPlayerFromPidS(v.citizenid)
                if GangPlayerActive then 
                    GangMemberTable[#GangMemberTable+1] = {value = GangPlayerActive.Pid, text = GangPlayerActive.Name.." - "..GangPlayerActive.Gang.grade.name}
                else 
                    GangMemberTable[#GangMemberTable+1] = {value = v.citizenid, text = json.decode(v.charinfo).firstname .. ' ' .. json.decode(v.charinfo).lastname.." - "..json.decode(v.gang).grade.name}
                end
            end 
            cb(GangMemberTable)
        else 
            
            cb(false)
        end 
    end)
end