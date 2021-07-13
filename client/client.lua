local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil

PlayerData = {}

local jailTime = 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData() == nil do
		Citizen.Wait(10)
	end
	PlayerData = ESX.GetPlayerData()
	LoadTeleporters()
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(newData)
	PlayerData = newData
	Citizen.Wait(25000)
	ESX.TriggerServerCallback("proste-jail:retrieveJailTime", function(inJail, newJailTime)
		if inJail then
			jailTime = newJailTime
			JailLogin()
		end
	end)
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(response)
	PlayerData["job"] = response
end)

RegisterNetEvent("proste-jail:openJailMenu")
AddEventHandler("proste-jail:openJailMenu", function()
	OpenJailMenu()
end)

RegisterNetEvent("proste-jail:jailPlayer")
AddEventHandler("proste-jail:jailPlayer", function(newJailTime)
	jailTime = newJailTime
	Cutscene()
end)

RegisterNetEvent("proste-jail:unJailPlayer")
AddEventHandler("proste-jail:unJailPlayer", function()
	jailTime = 0
	UnJail()
end)

function JailLogin()
	local JailPosition = Config.JailPositions["Cell"]
	SetEntityCoords(PlayerPedId(), JailPosition["x"], JailPosition["y"], JailPosition["z"] - 1)
	if Config.NEWNotif then	
		TriggerEvent('mythic_notify:client:SendAlert', {type = 'inform', text = Config.LeftWhileJailed, length = 2500})
	else
		ESX.ShowNotification(Config.LeftWhileJailed)
	end
	InJail()
end

function UnJail()
	InJail()
	SetEntityCoords(GetPlayerPed(-1), 1848.47, 2585.39, 45.67)
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
		TriggerEvent('skinchanger:loadSkin', skin)
	end)
	if Config.NEWNotif then
		exports.GTA_Notif:GTA_NUI_ShowNotification({ text = Config.JailRelese,  type = 'success' }) 
	else
		ESX.ShowNotification(Config.JailRelese)
	end
end

function InJail()


	Citizen.CreateThread(function()

		while jailTime > 0 do
			jailTime = jailTime - 1
			if Config.NEWNotif then
				exports['swt_notifications']:Success(Config.TimeLeft1..''..jailTime.. ''..Config.TimeLeft2, "Vězení", "left", 2500, true)
			else
				ESX.ShowNotification(Config.TimeLeft1..''..jailTime.. ''..Config.TimeLeft2)
			end
			TriggerServerEvent("proste-jail:updateJailTime", jailTime)
			if jailTime == 0 then
				UnJail()
				TriggerServerEvent("proste-jail:updateJailTime", 0)
			end
			Citizen.Wait(60000)
		end
	end)
end

function LoadTeleporters()
	Citizen.CreateThread(function()
		while true do
			local sleepThread = 500
			local Ped = PlayerPedId()
			local PedCoords = GetEntityCoords(Ped)

			for p, v in pairs(Config.Teleports) do
				local DistanceCheck = GetDistanceBetweenCoords(PedCoords, v["x"], v["y"], v["z"], true)
				if DistanceCheck <= Config.DrawTextDistance then
					sleepThread = 5
					if Config.NLRP_Core == true then
						exports['nlrp_core']:DrawText3D(v.x, v.y, v.z, tostring(Config.DoorMessage))
					elseif Config.NLRP_Core == false then
						ESX.Game.Utils.DrawText3D(v.x, v.y, v.z, Config.DoorMessage)
					end
					if DistanceCheck <= 1.0 then
						if IsControlJustPressed(0, 38) then
							TeleportPlayer(v)
						end
					end
				end
			end
			Citizen.Wait(sleepThread)
		end
	end)
end


function OpenJailMenu()
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'jail_prison_menu',
		{
			title    = Config.MenuLang["title"],
			align    = Config.MenuAlign,
			elements = {
				{ label = Config.MenuLang["unjail"], value = "unjail_player" }
			}
		}, 
	function(data, menu)
		local action = data.current.value

		if action == "jail_closest_player" then

			menu.close()

			ESX.UI.Menu.Open(
          		'dialog', GetCurrentResourceName(), 'jail_choose_time_menu',
          		{
            		title = Config.MenuLang["dialog_title"]
          		},
          	function(data2, menu2)

            	local jailTime = tonumber(data2.value)

            	if jailTime == nil then
					if Config.NEWNotif then
						TriggerEvent('mythic_notify:client:SendAlert', {type = 'error', text = Config.MustMin, length = 2500})
					else
						ESX.ShowNotification(Config.MustMin)
					end
            	else
              		menu2.close()

              		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

              		if closestPlayer == -1 or closestDistance > 3.0 then
						if Config.NEWNotif then
							TriggerEvent('mythic_notify:client:SendAlert', {type = 'error', text = Config.NoNerby, length = 2500})
						else
							ESX.ShowNotification(Config.NoNerby)
						end
					else
						ESX.UI.Menu.Open(
							'dialog', GetCurrentResourceName(), 'jail_choose_reason_menu',
							{
							  title = Config.MenuLang["dialog_reason"]
							},
						function(data3, menu3)
		  
						  	local reason = data3.value
		  
						  	if reason == nil then
								if Config.NEWNotif then
									TriggerEvent('mythic_notify:client:SendAlert', {type = 'inform', text = Config.MustInsert, length = 2500})
								else
									ESX.ShowNotification(Config.MustInsert)
								end
						  	else
								menu3.close()
		  
								local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
		  
								if closestPlayer == -1 or closestDistance > 3.0 then
									if Config.NEWNotif then
										TriggerEvent('mythic_notify:client:SendAlert', {type = 'error', text = Config.NoNerby, length = 2500})
									else
										ESX.ShowNotification(Config.NoNerby)
									end
								else
								  	TriggerServerEvent("proste-jail:jailPlayer", GetPlayerServerId(closestPlayer), jailTime, reason)
								end
		  
						  	end
		  
						end, function(data3, menu3)
							menu3.close()
						end)
              		end

				end

          	end, function(data2, menu2)
				menu2.close()
			end)
		elseif action == "unjail_player" then

			local elements = {}

			ESX.TriggerServerCallback("proste-jail:retrieveJailedPlayers", function(playerArray)

				if #playerArray == 0 then
					if Config.NEWNotif then
						TriggerEvent('mythic_notify:client:SendAlert', {type = 'error', text = Config.NOED, length = 2500})
					else
						ESX.ShowNotification(Config.NOED)
					end
					return
				end

				for i = 1, #playerArray, 1 do
					table.insert(elements, {label = Config.MenuLang["name"].."" .. playerArray[i].name .. " | "..Config.MenuLang["time"].. " " .. playerArray[i].jailTime .. " -m", value = playerArray[i].identifier })
				end

				ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'jail_unjail_menu',
					{
						title = Config.MenuLang["unjail_title"],
						align = Config.MenuAlign,
						elements = elements
					},
				function(data2, menu2)

					local action = data2.current.value

					TriggerServerEvent("proste-jail:unJailPlayer", action)

					menu2.close()

				end, function(data2, menu2)
					menu2.close()
				end)
			end)

		end

	end, function(data, menu)
		menu.close()
	end)	
end
