Config = {}
Config.Framework = 'qbcore' -- 'qbcore' or 'esx'


Config.Important = {
    ['UsingUpdatedOx'] = true, --- If using oxsql exports set to false. If useing updated version set true
    ['MenuResource'] = 'qb-menu',
    ['UsingTarget'] = true, --- If false then it will use drawtextui (Found in 710-lib options)
    ['TargetResource'] = 'qb-target',
    ['InputResource'] = 'qb-input',
    ['Interact-Drawtext-Key'] = 38, -- (38 is the keynumber for E)
    ['AdminCheckForCommands'] = true, -- IF FALSE ANYONE ON SERVER CAN USE COMMANDS BELOW this should only be used for SETUP if for some reason admin check doesnt work! 
    ['CreateLocationCommand'] = 'managementlocation',
    ['CreateADutyLocationCommand'] = 'managementduty',
    ['CreateAGangLocationCommand'] = 'managementgang',
   --- Multijob Option! 
    ['UsingBuiltInMultiJob'] = true,
    ['UseChangeJobCommand'] = true, -- if false set Job change location below it will use target or drawtext!
    ['ChangeJobCommand'] = 'changejobs', -- works if admin or not. 
    ['ChangeJobLocation'] = vec4(0,0,0,0), --- Location of job change Target/Drawtext Location.
    --- Duty Options 
}

Config.Management = {
    ['PayFromAccount'] = true, --- If true pays from company funds.
    ['PayCycleTime'] = 2, -- Time in Minutes when ON DUTY above option must be true.
    ['MaxSafeWeight'] = 1000000, 
    ['MaxSafeSlots'] = 20, 
    ['WelfarePayAmount'] = 100, 

}


Config.Debug = {
    ['PolyZones'] = true, 
    ['debugPrint'] = true,
}
