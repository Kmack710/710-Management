Config = {}
Config.Framework = 'esx' -- 'qbcore' or 'esx'


Config.Important = {
    ['UsingUpdatedOx'] = true, --- If using oxsql exports set to false. If useing updated version set true
    ['MenuResource'] = 'nh-context', --- nh-context (New only) or qb-menu or any of the forks of it. 
    ['UsingTarget'] = true, --- If false then it will use drawtextui (Found in 710-lib options)
    ['TargetResource'] = 'qtarget',
    ['InputResource'] = '710-input',
    ['Interact-Drawtext-Key'] = 38, -- (38 is the keynumber for E)
    ['AdminCheckForCommands'] = true, -- IF FALSE ANYONE ON SERVER CAN USE COMMANDS BELOW this should only be used for SETUP if for some reason admin check doesnt work! 
    ['CreateLocationCommand'] = 'managementlocation',
    ['CreateADutyLocationCommand'] = 'managementduty',
    ['CreateAGangLocationCommand'] = 'managementgang',
   --- Multijob Option! 
    ['UsingBuiltInMultiJob'] = true,
    ['ChangeJobLocation'] = vec4(-543.9165, -196.8859, 38.2269, 252.0851), --- Location of job change Target/Drawtext Location.
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
    ['PolyZones'] = false, 
}
