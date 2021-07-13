Config = {}

Config.Job = 'police'
Config.JobGrade = 'boss'

Config.NEWNotif = true

Config.JailCommand = "jail"
Config.UnjailCommand = "unjail"
Config.MenuCommand = "jailmenu"
Config.NLRP_Core = false

Config.DrawTextDistance = 5.0

---config.cs

Config.DoorMessage = 'Zmáčkni ~g~[E]~s~ pro otevření dveří'
Config.JailRelese = 'Tvůj trest byl odpikán!\nNyní jsi na svobodě.'
Config.LeftWhileJailed = 'Než jsi opustil město, byl jsi uvězněn. V důsledku jsi byl navrácen zpět do cely!'
Config.NotOnline = 'Hráč s tímto ID není online!'
Config.NotPD = 'Nejsi Policista!'
Config.WrongTime = 'Neplatný čas!'
Config.WorkReward = 'Zde máš nějaké peníze na jídlo a pití.'
Config.PackageTaken = 'Již jsi vzal tento balíček'
Config.MustMin = 'Čas musí být v minutách'
Config.NoNerby = 'Žádný hráč poblíž!'
Config.MustInsert = 'Musíš zde něco vložit!'
Config.NOED = 'Vězení je prázdné Sedge'
Config.NoKeys = 'Nemáš klíče!'
Config.TimeLeft1 = 'Zbýva ti: '
Config.TimeLeft2 = ' minut v cele!'
Config.NoPerms = 'Nejsi dostatečně velká pozice, aby jsi mohl použít tuto funkci!'
-----
Config.PlayerTxt = 'Hráč: '
Config.PlayerInf = '\n Byl poslán do vězení!\nČas: '
Config.WasRelesed = ' Byl pro puštěn z vězení!'

Config.MenuAlign = 'center'
Config.MenuLang = {
	["title"] = 'Vězeňské menu',
	["unjail_title"] = 'Propustit z vězení',
	["unjail"] = 'Propustit z vězení',
	["dialog_title"] = 'Čas ve vězení (minuty)',
	["dialog_reason"] = 'Důvod',
	["name"] = 'Vězen: ',
	["time"] = 'Čas: ',
	["tp_title"] = 'Zvol místo'
}


---config.en

--[[Config.DoorMessage = 'Press [E] to open the door'
Config.JailRelese = 'Your punishment has been served!\nYou are now free.'
Config.LeftWhileJailed = 'Before you left town, you were imprisoned. As a result, you have been returned to the cell!'
Config.NotOnline = 'The player with this ID is not online!'
Config.NotPD = 'You re not a cop!'
Config.WrongTime = 'Invalid time!'
Config.WorkReward = 'Here s some money for food and drink.'
Config.PackageTaken = 'You have already taken this package'
Config.MustMin = 'Time must be in minutes'
Config.NoNerby = 'No player nearby!'
Config.MustInsert = 'You have to insert something here!'
Config.NOED = 'The prison is an empty sedge'
Config.NoKeys = 'You don t have the keys!'
Config.TimeLeft1 = 'You have left: '
Config.TimeLeft2 = ' minutes in the cell!'
Config.NoPerms = 'You are not large enough to use this feature!'
-----
Config.PlayerTxt = 'Player: '
Config.PlayerInf = '\n He was sent to prison!\nTime: '
Config.WasRelesed = ' He was released from prison!'

Config.MenuAlign = 'center'
Config.MenuLang = {
	["title"] = 'Prison menu',
	["unjail_title"] = 'Release from prison',
	["unjail"] = 'Release from prison',
	["dialog_title"] = 'Prison time (minutes)',
	["dialog_reason"] = 'Reason',
	["name"] = 'Prisoner: ',
	["time"] = 'Time: ',
	["tp_title"] = 'Choose a place'
}]]--

Config.JailPositions = {["Cell"] = { ["x"] = 1799.8345947266, ["y"] = 2489.1350097656, ["z"] = -119.02998352051, ["h"] = 179.03021240234 }}
Config.Cutscene = {
	["PhotoPosition"] = { ["x"] = 402.91567993164, ["y"] = -996.75970458984, ["z"] = -99.000259399414, ["h"] = 186.22499084473 },
	["CameraPos"] = { ["x"] = 402.88830566406, ["y"] = -1003.8851318359, ["z"] = -97.419647216797, ["rotationX"] = -15.433070763946, ["rotationY"] = 0.0, ["rotationZ"] = -0.31496068835258, ["cameraId"] = 0 },
	["PolicePosition"] = { ["x"] = 402.91702270508, ["y"] = -1000.6376953125, ["z"] = -99.004028320313, ["h"] = 356.88052368164 }
}

-- You can use it for ever you want.. :D
Config.Teleports = {
	["Jail"] = { ["x"] = 1800.6979980469, ["y"] = 2483.0979003906, ["z"] = -122.68814849854, ["h"] = 271.75274658203, ["goal"] = { "Visitor" }},
	["Visitor"] = { ["x"] = 1691.61, ["y"] = 2566.2, ["z"] = 45.56, ["h"] = 179.94, ["goal"] = { "Jail" }}
}

-- Idk if it male or female :D it works one like that and one like.. you know what i mean
Config.FemaleSkin = {
	['tshirt_1'] = 15,
	['tshirt_2'] = 0,
	["torso_1"] = 2,
	["torso_2"] = 6,
	["arms"] = 2,
	["pants_1"] = 2,
	["pants_2"] = 0,
	["shoes_1"] = 35,
	["shoes_2"] = 0,
	["helmet_1"] = -1
}

-- Idk if it male or female :D it works one like that and one like.. you know what i mean
Config.MaleSkin = {
	['tshirt_1'] = 20,
	['tshirt_2'] = 15,
	['torso_1'] = 33,
	['torso_2'] = 0,
	['arms'] = 0,
	['pants_1'] = 7,
	['pants_2'] = 0,
	['shoes_1'] = 34,
	['shoes_2'] = 0,
	["helmet_1"] = -1
}