local Framework = exports['710-lib']:GetFrameworkObject()
local QBCore = {}

if Config.Framework == 'qbcore' then 
    QBCore = exports['qb-core']:GetCoreObject()
end 

AddEventHandler('710-lib:PlayerLoaded', function()
    Wait(3000)
    local Player = Framework.PlayerDataC()
    local Accounts = Framework.TriggerServerCallback('710-Mangement:GetAllAccounts')
    if Accounts then 
        debugPrint('1')
        debugPrint(json.encode(Player))
        debugPrint(Player.Job.name)
        for k,v in pairs(Accounts) do 
            if v.name == Player.Job.name then 
                local dutylocation = v.dutylocation
                debugPrint('Duty Location loaded'..v.name)
                startDutyLocations(Player.Job.name, dutylocation)
                if Player.Job.Grade.level == v.bossgrade then
                    debugPrint('BossMenu loaded'..v.name)
                    local menuLocation = v.menu  
                    startMenuLocation(Player.Job.name, menuLocation)
                end
            end 
        end
        if Config.Framework == 'qbcore' then 
            debugPrint(Player.Gang.name)
            for k, v in pairs(Accounts) do 
                
                if v.name == Player.Gang.name then
                    debugPrint(v.name) 
                    TriggerEvent('710-Management:StartGangMenus', v.name, v.menu)
                end 
            end 
        end 
    end
    local CheckIfFired = Framework.TriggerServerCallback('710-Management:GetMyJobInfo', Player.Pid)
    if CheckIfFired then 
        if CheckIfFired.duty == 3 then 
            TriggerServerEvent('710-Management:OfflinePlayerFired')
        end
    end  
    if Player.Job.name == 'unemployed' then 
        PayWelfareCheck()
    end
    TriggerServerEvent('710-Management:PlayerLoadedS') 
    debugPrint('Player Loaded')
    debugPrint(json.encode(Accounts))

end)

RegisterNetEvent('710-Management:ClientGoOnDuty', function()
    local Player = Framework.PlayerDataC()
    TriggerServerEvent('710-Management:ServerGoOnDuty')
    PayFromManagementFunds()
    debugPrint('Client Go On Duty')
end)

function startDutyLocations(job, location)
    debugPrint(job)
    debugPrint(location)
    local Location = json.decode(location)
    if Config.Important['UsingTarget'] then 
        exports[Config.Important['TargetResource']]:AddBoxZone(job..'Duty', vec3(Location.x, Location.y, Location.z), 2, 2, {
            name=job..'Duty',
            heading=Location.w,
            debugPoly=Config.Debug['PolyZones'],
            minZ=Location.z - 1.2,
            maxZ=Location.z + 1
          }, {
            options = {
                {
                    type = "client",
                    event = "710-Management:ClientGoOnDuty",
                    icon = Locales['DutyIcon'],
                    label = Locales['DutyOnOff'],
                  },
            },
             distance = 2.5 
        })
    else 
        CreateThread(function()
            local Location = json.decode(location)
            local shownMenu = false
            while true do
                local sleep = 5
                local text = Locales['Button-For-Action'].." "..Locales['DutyOnOff'] 
                    local pos = GetEntityCoords(PlayerPedId())
                    local inRange = false
                    local nearMenu = false
                    local menu = vector3(Location.x, Location.y, Location.z)
                        if #(pos - menu) < 5.0 then
                            inRange = true
                            sleep = 5
                                if #(pos - menu) <= 1.5 then
                                    nearMenu = true
                                    if IsControlJustReleased(0, Config.Important['Interact-Drawtext-Key']) then
                                        TriggerEvent("710-Management:ClientGoOnDuty")
                                        shownMenu = true
                                        Framework.DrawText(close, nil)
                                    end
                                end       
                        end
                        if #(pos - menu) > 5.0 then 
                            sleep = 5000      
                        end
    
                    if nearMenu and not shownMenu then
                        Framework.DrawText('open', text)
                        shownMenu = true
                    end
        
                    if not nearMenu and shownMenu then
                        Framework.DrawText('close')
                        shownMenu = false
                    end
                Wait(sleep)
            end
        end)

    end  

end

function startMenuLocation(job, location)
    debugPrint(job)
    debugPrint(location)
    local Location = json.decode(location)
    if Config.Important['UsingTarget'] then 
        exports[Config.Important['TargetResource']]:AddBoxZone(job..'Menu', vec3(Location.x, Location.y, Location.z), 2, 2, {
            name=job..'Menu',
            heading=Location.w,
            debugPoly=Config.Debug['PolyZones'],
            minZ=Location.z - 1.2,
            maxZ=Location.z + 1
          }, {
            options = {
                {
                    type = "client",
                    event = "710-Management:OpenManagementMenu",
                    icon = Locales['ManagementIcon'],
                    label = Locales['OpenMangementMenu'],
                  },
            },
             distance = 2.5 
        })
    else 
        CreateThread(function()
            local Location = json.decode(location)
            local shownMenu = false
            while true do
                local sleep = 5
                local text = Locales['Button-For-Action'].." "..Locales['OpenMangementMenu'] 
                    local pos = GetEntityCoords(PlayerPedId())
                    local inRange = false
                    local nearMenu = false
                    local menu = vector3(Location.x, Location.y, Location.z)
                        if #(pos - menu) < 5.0 then
                            inRange = true
                            sleep = 5
                                if #(pos - menu) <= 1.5 then
                                    nearMenu = true
                                    if IsControlJustReleased(0, Config.Important['Interact-Drawtext-Key']) then
                                        TriggerEvent("710-Management:OpenManagementMenu")
                                        shownMenu = true
                                        Framework.DrawText(close, nil)
                                    end
                                end       
                        end
                        if #(pos - menu) > 5.0 then 
                            sleep = 5000      
                        end
    
                    if nearMenu and not shownMenu then
                        Framework.DrawText('open', text)
                        shownMenu = true
                    end
        
                    if not nearMenu and shownMenu then
                        Framework.DrawText('close')
                        shownMenu = false
                    end
                Wait(sleep)
            end
        end)

    end 


end

RegisterNetEvent('710-Management:OpenBossSafe', function()
    local Player = Framework.PlayerDataC()
    local Pjob = Player.Job.name
    if Config.Framework == 'esx' then 
        Framework.OpenStash(Pjob.."-"..Locales['BossSafe'], {Config.Management['MaxSafeWeight'], Config.Management['MaxSafeSlots']})
    else
        local stashLabel = Pjob.."_"..Locales['BossSafe']
        Framework.OpenStash(stashLabel, {maxweight = Config.Management['MaxSafeWeight'], slots = Config.Management['MaxSafeSlots']})
    end 
end)

RegisterNetEvent('710-Management:createDutyLocationInput', function()
    local playerPed = PlayerPedId()
    local pos = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)
    local location = vec4(pos.x, pos.y, pos.z, heading)
    local dialog = exports[Config.Important['InputResource']]:ShowInput({
		header = Locales['CreateDutyMenu'],
		submitText = Locales['SubmitButton'],
		inputs = {
			{
				text = Locales['BossMenuJobName'], 
				name = "job",
				type = "text", 
				isRequired = true,
				-- default = "cash", -- Default radio option, must match a value from above, this is optional
			},
		},
	})
	if dialog ~= nil then
		debugPrint(json.encode(dialog))
        debugPrint(location)
        TriggerServerEvent('710-Management:CreateNewDutyLocation', dialog.job, location)
	end 
end)

RegisterNetEvent('710-Management:createLocationInput', function()
    local playerPed = PlayerPedId()
    local pos = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)
    local location = vec4(pos.x, pos.y, pos.z, heading)
    local dialog = exports[Config.Important['InputResource']]:ShowInput({
		header = Locales['CreateManagementMenu'],
		submitText = Locales['SubmitButton'],
		inputs = {
			{
				text = Locales['BossGradeInputOption'], 
				name = "bossgrade",
				type = "number", -- type of the input
			    isRequired = true, -- Optional [accepted values: true | false] but will submit the form if no value is inputted
				
			},
			{
				text = Locales['BossMenuJobName'], 
				name = "job",
				type = "text", 
				isRequired = true,
				-- default = "cash", -- Default radio option, must match a value from above, this is optional
			},
		},
	})
	if dialog ~= nil then
		debugPrint(json.encode(dialog))
        debugPrint(location)
        TriggerServerEvent('710-Management:CreateNewManagementMenu', dialog.bossgrade, dialog.job, location)
	end 
end)

RegisterNetEvent('710-Management:OpenManagementMenu', function()
    local managementMenu = {}
	if Config.Important['MenuResource'] == 'nh-context' then
        managementMenu = {
            {
                header = Locales['ManagementMenuTitle'],
            }
        }
        managementMenu[#managementMenu+1] = {
            header = Locales['ManagementAccounts'],
            context  = " ",
            event = '710-Management:AccountsMenu',
        }
        managementMenu[#managementMenu+1] = {
            header = Locales['ManagementRanks'],
            context  = " ",
            event = "710-Management:ManageStaff",
        }
        managementMenu[#managementMenu+1] = {
            header = Locales['ManagementSafe'],
            context  = " ",
            event = '710-Management:OpenBossSafe',
        }
        managementMenu[#managementMenu+1] = {
            header = Locales['ManagementRecruit'],
            context  = " ",
            event = '710-Management:ManagementRecruitNew',
        }
        managementMenu[#managementMenu+1] = {
            header = Locales['ManagementFire'],
            context  = " ",
            event = '710-Management:FireMenu',
        }
		TriggerEvent('nh-context:createMenu', managementMenu)
	else 
        managementMenu = {
            {
                header = Locales['ManagementMenuTitle'],
            }
        }
        managementMenu[#managementMenu+1] = {
            header = Locales['ManagementRanks'],
            txt  = " ",
            params = {
                event = "710-Management:ManageStaff",
            }
        }
        managementMenu[#managementMenu+1] = {
            header = Locales['ManagementSafe'],
            txt  = "",
            params = {
                event = '710-Management:OpenBossSafe',
            }
        }
        managementMenu[#managementMenu+1] = {
            header = Locales['ManagementRecruit'],
            txt  = " ",
            params = {
                event = '710-Management:ManagementRecruitNew',
            }
        }
        managementMenu[#managementMenu+1] = {
            header = Locales['ManagementAccounts'],
            txt  = " ",
            params = {
                event = '710-Management:AccountsMenu',
            }
            
        }
        managementMenu[#managementMenu+1] = {
            header = Locales['ManagementFire'],
            txt  = " ",
            params = {
                event = '710-Management:FireMenu',
            }
            
        }
		exports[Config.Important['MenuResource']]:openMenu(managementMenu)
	end 
end)

RegisterNetEvent('710-Management:ManagementRecruitNew', function()
    local Player = Framework.PlayerDataC()
    local Pjob = Player.Job.name
    local optionTable = {}
    if Config.Framework == 'esx' then 
        local PlayerRanks = Framework.TriggerServerCallback('710-Mangement:GetJobRanks', Pjob)
        debugPrint(PlayerRanks)
		for k,v in pairs(PlayerRanks) do
			optionTable[#optionTable+1] = {value = v.grade, text = v.label}
		end
        debugPrint(json.encode(optionTable))
    else 
        for k,v in pairs(QBCore.Shared.Jobs[Pjob].grades) do
			optionTable[#optionTable+1] = {value = k, text = v.name}
		end
    end 
    local dialog = exports[Config.Important['InputResource']]:ShowInput({
		header = Locales['ManagementRecruit'],
		submitText = Locales['SubmitButton'],
		inputs = {
			{
				text = Locales['PlayerID'], 
				name = "pSource",
				type = "number", -- type of the input
			    isRequired = true, -- Optional [accepted values: true | false] but will submit the form if no value is inputted
				
			},
            {
                text = Locales['ManagementGrades'],
                name = "grade", 
                type = "select", 
                options = optionTable,
            }
		},
	})
	if dialog ~= nil then
		debugPrint(json.encode(dialog))
        debugPrint(Pjob)
        TriggerServerEvent('710-Management:HireNewStaff', dialog.pSource, Pjob, dialog.grade)
	end 
end)

RegisterNetEvent('710-Management:ManageStaff', function()
    local Player = Framework.PlayerDataC()
    local Pjob = Player.Job.name
    local optionTable = {}
    local optionTable2 = {}
    local PlayerRank = {}
    
    local JobStaff = Framework.TriggerServerCallback('710-Mangement:GetJobStaff', Pjob)
    for k,v in pairs(JobStaff) do
        if Config.Framework == 'esx' then 
            local PlayerRanks = Framework.TriggerServerCallback('710-Mangement:GetJobRanks', Pjob)
            for k2,v2 in pairs(PlayerRanks) do 
                if v2.grade == v.grade then 
                    PlayerRank = v2.label
                end 
            end 
        else 
            PlayerRank = QBCore.Shared.Jobs[Pjob].grades[tostring(v.grade)].name
        end 
        optionTable2[#optionTable2+1] = {value = v.pid, text = v.name.." - "..PlayerRank.." - "..Locales['PayAmount']..v.payrate}
    end
    --[[for k,v in pairs(GetActivePlayers()) do 
        local pSource = GetPlayerServerId(v)
        debugPrint(pSource)
        local LPlayer = Framework.PlayerDataC(pSource)
        debugPrint(LPlayer.Name)
        debugPrint('^^^^ ')
        if LPlayer.Job.name == Pjob then
            local PlayerJobPayTbl = Framework.TriggerServerCallback('710-Management:GetMyJobInfo', LPlayer.Pid) 
            local PayRate = PlayerJobPayTbl.payrate
            optionTable2[#optionTable+1] = {value = pSource, text = LPlayer.Name.." - "..LPlayer.Job.Grade.label.." - "..Locales['PayAmount']..PayRate}
        end
    end]]
    if Config.Framework == 'esx' then 
        local PlayerRanks = Framework.TriggerServerCallback('710-Mangement:GetJobRanks', Pjob)
        debugPrint(PlayerRanks)
		for k,v in pairs(PlayerRanks) do
			optionTable[#optionTable+1] = {value = v.grade, text = v.label}
		end
        debugPrint(json.encode(optionTable))
    else 
        for k,v in pairs(QBCore.Shared.Jobs[Pjob].grades) do
			optionTable[#optionTable+1] = {value = tonumber(k), text = v.name}
		end
    end 
    local dialog = exports[Config.Important['InputResource']]:ShowInput({
		header = Locales['ManagementRanks'],
		submitText = Locales['SubmitButton'],
		inputs = {
            {
                text = Locales['ManagementPlayers'],
                name = "pSource", 
                type = "select", 
                options = optionTable2,
            },
            {
                text = Locales['NewSalaryAmount'],
                name = "amount", 
                type = "number", 
            },
            {
                text = Locales['ManagementGrades'],
                name = "grade", 
                type = "select", 
                options = optionTable,
            }
		},
	})
	if dialog ~= nil then
		debugPrint(json.encode(dialog))
        debugPrint(Pjob)
        if dialog.amount ~= '' then 
            TriggerServerEvent('710-Management:SetJobSalary', dialog.pSource, dialog.amount)
        else 
            TriggerServerEvent('710-Management:ChangeStaffRank', dialog.pSource, Pjob, dialog.grade)
        end 
    end
end)

RegisterNetEvent('710-Management:AccountsMenu', function()
    local Player = Framework.PlayerDataC()
    local Pjob = Player.Job.name
    local account = Framework.TriggerServerCallback('710-Mangement:GetAccount', Pjob)
    local dialog = exports[Config.Important['InputResource']]:ShowInput({
		header = "$"..account.balance,
		submitText = Locales['SubmitButton'],
		inputs = {
            {
                text = Locales['Action'], 
                name = "action", 
                type = "radio", 
                options = { 
                    { value = "withdraw", text = Locales['ManagementWithdraw'] }, 
                    { value = "deposit", text = Locales['ManagementDeposit'] }, 
                },
            },
            {
                text = Locales['Amount'],
                name = "amount", 
                type = "number", 
            }
		},
	})
	if dialog ~= nil then
		debugPrint(json.encode(dialog))
        debugPrint(Pjob)
        TriggerServerEvent('710-Management:BankingTransfer', dialog.action, Pjob, dialog.amount)
	end 
end)

RegisterNetEvent('710-Management:FireMenu', function()
    local optionTable = {}
    local Player = Framework.PlayerDataC()
    local Pjob = Player.Job.name
    local JobStaff = Framework.TriggerServerCallback('710-Mangement:GetJobStaff', Pjob)
    for k,v in pairs(JobStaff) do 
        optionTable[#optionTable+1] = {value = v.pid, text = v.name.." - "..Locales['PayAmount']..v.payrate}
    end
    local dialog = exports[Config.Important['InputResource']]:ShowInput({
		header = Locales['ManagementFire'],
		submitText = Locales['SubmitButton'],
		inputs = {
            {
                text = Locales['ManagementPlayers'],
                name = "pid", 
                type = "select", 
                options = optionTable,
            }
		},
	})
	if dialog ~= nil then
		debugPrint(json.encode(dialog))
        TriggerServerEvent('710-Management:FireStaff', dialog.pid)
	end 


end)


local Paidasdfdsafafd = false
function PayFromManagementFunds()
	CreateThread(function()
        Wait(1000)
        local onDuty = Framework.TriggerServerCallback('710-Management:AmIOnDuty')
        debugPrint(onDuty)
		while onDuty do 
			if Paidasdfdsafafd == false then 
				debugPrint('Timer Started - PAYCYCLE')
				Paidasdfdsafafd = true
				Wait(Config.Management['PayCycleTime'] * 60000)
                onDuty = Framework.TriggerServerCallback('710-Management:AmIOnDuty')
				debugPrint('TIMER ENDED - PAYCYCLE ')
				if onDuty then 
					TriggerServerEvent('710-Management:PayStaffFromFunds')
					Paidasdfdsafafd = false
				else
					debugPrint('Player left duty before pay time')
					Paidasdfdsafafd = false
					break
				end
				
			else
				break
			end 
		end
	end)
end

local Paidasdfdsafaf = false
function PayWelfareCheck()
	CreateThread(function()
		while true do 
			if Paidasdfdsafaf == false then 
				debugPrint('Timer Started - PAYCYCLE')
				Paidasdfdsafaf = true
				Wait(Config.Management['PayCycleTime'] * 60000)
				debugPrint('TIMER ENDED - PAYCYCLE ')
                Paidasdfdsafaf = false
                TriggerServerEvent('710-Management:PayWelfareCheck')
				
			else
				break
			end 
		end
	end)
end

function debugPrint(msg)
    if Config.Debug['debugPrint'] then 
        print(msg)
    end 
end


if Config.Framework == 'qbcore' then 
    RegisterNetEvent('710-Management:openGangMenu', function()
        local Player = Framework.PlayerDataC()
        local managementMenu = {
            {
                header = Locales['ManageGang']..Player.Gang.label,
            }
        }
        managementMenu[#managementMenu+1] = {
            header = Locales['CheckGangSafe'],
            txt  = "",
            params = {
                event = '710-Management:OpenGangSafe',
            }
        }
        if Player.Gang.grade.level >= 3 then 
            managementMenu[#managementMenu+1] = {
                header = Locales['CheckGangBossSafe'],
                txt  = "",
                params = {
                    event = '710-Management:OpenGangBossSafe',
                }
            }
            managementMenu[#managementMenu+1] = {
                header = Locales['ManageGangMember'],
                txt  = " ",
                params = {
                    event = "710-Management:ManageGang",
                }
            }
            
            managementMenu[#managementMenu+1] = {
                header = Locales['RecruitNewGangMember'],
                txt  = " ",
                params = {
                    event = '710-Management:RecruitNewGangMember',
                }
            }
            managementMenu[#managementMenu+1] = {
                header = Locales['ManagementAccounts'],
                txt  = " ",
                params = {
                    event = '710-Management:AccountsMenuGang',
                }
                
            }
        end 
        exports[Config.Important['MenuResource']]:openMenu(managementMenu)
    
    end)
    
    RegisterNetEvent('710-Management:AccountsMenuGang', function()
        local Player = Framework.PlayerDataC()
        local Pjob = Player.Gang.name
        local account = Framework.TriggerServerCallback('710-Mangement:GetAccount', Pjob)
        local dialog = exports[Config.Important['InputResource']]:ShowInput({
            header = "$"..account.balance,
            submitText = Locales['SubmitButton'],
            inputs = {
                {
                    text = Locales['Action'], 
                    name = "action", 
                    type = "radio", 
                    options = { 
                        { value = "withdraw", text = Locales['ManagementWithdraw'] }, 
                        { value = "deposit", text = Locales['ManagementDeposit'] }, 
                    },
                },
                {
                    text = Locales['Amount'],
                    name = "amount", 
                    type = "number", 
                }
            },
        })
        if dialog ~= nil then
            debugPrint(json.encode(dialog))
            debugPrint(Pjob)
            TriggerServerEvent('710-Management:BankingTransferGang', dialog.action, Pjob, dialog.amount)
        end 
    end)
    
    RegisterNetEvent('710-Management:RecruitNewGangMember', function()
        local Player = Framework.PlayerDataC()
        local Pgang = Player.Gang.name
        local optionTable = {} 
        for k,v in pairs(QBCore.Shared.Gangs[Pgang].grades) do
            optionTable[#optionTable+1] = {value = tonumber(k), text = v.name}
        end
        local dialog = exports[Config.Important['InputResource']]:ShowInput({
            header = Locales['RecruitNewGangMember'],
            submitText = Locales['SubmitButton'],
            inputs = {
                {
                    text = Locales['PlayerID'], 
                    name = "pSource",
                    type = "number", -- type of the input
                    isRequired = true, -- Optional [accepted values: true | false] but will submit the form if no value is inputted
                    
                },
                {
                    text = Locales['ManagementGrades'],
                    name = "grade", 
                    type = "select", 
                    options = optionTable,
                }
            },
        })
        if dialog ~= nil then
            debugPrint(json.encode(dialog))
            debugPrint(Pgang)
            TriggerServerEvent('710-Management:RecruitNewGangMemberS', dialog.pSource, Pgang, dialog.grade)
        end 
    end)
    
    RegisterNetEvent('710-Management:OpenGangSafe', function()
        local Player = Framework.PlayerDataC()
        local gang = Player.Gang.name
        local stashLabel = gang.."_"..Locales['GangSafe']
        Framework.OpenStash(stashLabel, {maxweight = Config.Management['MaxSafeWeight'], slots = Config.Management['MaxSafeSlots']})
    end)
    
    RegisterNetEvent('710-Management:OpenGangBossSafe', function()
        local Player = Framework.PlayerDataC()
        local gang = Player.Gang.name
        local stashLabel = gang.."_"..Locales['GangBossSafe']
        Framework.OpenStash(stashLabel, {maxweight = Config.Management['MaxSafeWeight'], slots = Config.Management['MaxSafeSlots']})
    end)
    
    RegisterNetEvent('710-Management:ManageGang', function()
        local Player = Framework.PlayerDataC()
        local Pgang = Player.Gang.name
        print(Pgang)
        local optionTable = {}
        local optionTable2 = Framework.TriggerServerCallback('710-Management:GetPlayersInGang', Pgang)
        for k,v in pairs(QBCore.Shared.Gangs[Pgang].grades) do
            optionTable[#optionTable+1] = {value = tonumber(k), text = v.name}
        end
        local dialog = exports[Config.Important['InputResource']]:ShowInput({
            header = Locales['ManagementRanks'],
            submitText = Locales['SubmitButton'],
            inputs = {
                {
                    text = Locales['ManagementPlayers'],
                    name = "pid", 
                    type = "select", 
                    options = optionTable2,
                },
                {
                    text = Locales['ManageGangMember']..Player.Gang.label,
                    name = "action",
                    type = "radio", 
                    options = { 
                        { value = "changerank", text = Locales['ChangeGangRank'] }, 
                        { value = "fire", text = Locales['RemoveFromGang'] },
                    },
                },
                {
                    text = Locales['ManagementGrades'],
                    name = "grade", 
                    type = "select", 
                    options = optionTable,
                }
            },
        })
        if dialog ~= nil then
            debugPrint(json.encode(dialog))
            if dialog.action == 'changerank' then 
                TriggerServerEvent('710-Management:ChangeGangRank', dialog.pid, Pgang, dialog.grade)
            elseif dialog.action == 'fire' then 
                TriggerServerEvent('710-Management:RemoveFromGang', dialog.pid)
            end 
        end
    end)
    
    
    RegisterNetEvent('710-Management:StartGangMenus', function(gang, location)
        debugPrint(gang)
        debugPrint(location)
        local Location = json.decode(location)
        if Config.Important['UsingTarget'] then 
            exports[Config.Important['TargetResource']]:AddBoxZone(gang..'Menu', vec3(Location.x, Location.y, Location.z), 2, 2, {
                name=gang..'Menu',
                heading=Location.w,
                debugPoly=Config.Debug['PolyZones'],
                minZ=Location.z - 1.2,
                maxZ=Location.z + 1
              }, {
                options = {
                    {
                        type = "client",
                        event = "710-Management:openGangMenu",
                        icon = Locales['ManagementIcon'],
                        label = Locales['OpenGangMenu'],
                      },
                },
                 distance = 2.5 
            })
        else 
            CreateThread(function()
                local Location = json.decode(location)
                local shownMenu = false
                while true do
                    local sleep = 5
                    local text = Locales['Button-For-Action'].." "..Locales['OpenGangMenu'] 
                        local pos = GetEntityCoords(PlayerPedId())
                        local inRange = false
                        local nearMenu = false
                        local menu = vector3(Location.x, Location.y, Location.z)
                            if #(pos - menu) < 5.0 then
                                inRange = true
                                sleep = 5
                                    if #(pos - menu) <= 1.5 then
                                        nearMenu = true
                                        if IsControlJustReleased(0, Config.Important['Interact-Drawtext-Key']) then
                                            TriggerEvent("710-Management:openGangMenu")
                                            shownMenu = true
                                            Framework.DrawText(close, nil)
                                        end
                                    end       
                            end
                            if #(pos - menu) > 5.0 then 
                                sleep = 5000      
                            end
        
                        if nearMenu and not shownMenu then
                            Framework.DrawText('open', text)
                            shownMenu = true
                        end
            
                        if not nearMenu and shownMenu then
                            Framework.DrawText('close')
                            shownMenu = false
                        end
                    Wait(sleep)
                end
            end)
    
        end 
    end)
end 