Config = {}

Config.Important = {
    ['UsingTarget'] = true, --- If false then it will use drawtextui (Found in 710-lib options)
    ['Interact-Drawtext-Key'] = 38, -- (38 is the keynumber for E)
    ['AdminCheckForCommands'] = true, -- IF FALSE ANYONE ON SERVER CAN USE COMMANDS BELOW this should only be used for SETUP if for some reason admin check doesnt work! 
    ['CreateLocationCommand'] = 'managementlocation',
    ['CreateADutyLocationCommand'] = 'managementduty',
    ['HireANewPlayerAdmin'] = 'managementsetjob',
    ['TransferDataFromQbManagement'] = false, --- set true if you want old accounts to transfer over from qb-management table. 
    --- Gang Stuff -- 
    ['CreateAGangLocationCommand'] = 'managementgang',
    ['Using710-GangSystem'] = true, --- If using 710-GangSystem set true (QBCORE ONLY SINCE ESX HAS DIFFERENT STUFF)
   --- Multijob Option! 
    ['UsingBuiltInMultiJob'] = true,
    ['ChangeJobLocation'] = vec4(-543.9165, -196.8859, 38.2269, 252.0851), --- Location of job change Target/Drawtext Location.
    --- Duty Options 
}

Config.Management = {
    ['PayFromAccount'] = true, --- If true pays from company funds.
    ['PayCycleTime'] = 60, -- Time in Minutes when ON DUTY above option must be true.
    ['MaxSafeWeight'] = 1000000, 
    ['MaxSafeSlots'] = 20, 
    ['WelfarePayAmount'] = 100, 

}


Config.Debug = {
    ['PolyZones'] = false, 
}
