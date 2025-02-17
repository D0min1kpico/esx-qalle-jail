RegisterCommand(Config.MenuCommand, function(source, args)
	if PlayerData.job.name == Config.Job and PlayerData.job.grade_name == Config.JobGrade then
		OpenJailMenu()
	else
		if Config.NEWNotif then
			TriggerEvent('mythic_notify:client:SendAlert', {type = 'inform', text = Config.NoPerms, length = 2500})
		else
			ESX.ShowNotification(Config.NoPerms)
		end
	end
end)

function LoadAnim(animDict)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		Citizen.Wait(10)
	end
end

function LoadModel(model)
	RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(10)
	end
end

function HideHUDThisFrame()
	HideHelpTextThisFrame()
	HideHudAndRadarThisFrame()
	HideHudComponentThisFrame(1)
	HideHudComponentThisFrame(2)
	HideHudComponentThisFrame(3)
	HideHudComponentThisFrame(4)
	HideHudComponentThisFrame(6)
	HideHudComponentThisFrame(7)
	HideHudComponentThisFrame(8)
	HideHudComponentThisFrame(9)
	HideHudComponentThisFrame(13)
	HideHudComponentThisFrame(11)
	HideHudComponentThisFrame(12)
	HideHudComponentThisFrame(15)
	HideHudComponentThisFrame(18)
	HideHudComponentThisFrame(19)
end

function Cutscene()
	DoScreenFadeOut(100)
	Citizen.Wait(250)
	local Male = GetHashKey("mp_m_freemode_01")

	TriggerEvent('skinchanger:getSkin', function(skin)
		if GetHashKey(GetEntityModel(PlayerPedId())) == Male then
			local clothesSkin = {
				['tshirt_1'] = Config.MaleSkin["tshirt_1"], ['tshirt_2'] = Config.MaleSkin["tshirt_2"],
				['torso_1'] = Config.MaleSkin["torso_1"], ['torso_2'] = Config.MaleSkin["torso_2"],
				['arms'] = Config.MaleSkin["arms"],
				['pants_1'] = Config.MaleSkin["pants_1"], ['pants_2'] = Config.MaleSkin["pants_2"],
				['shoes_1'] = Config.MaleSkin["shoes_1"], ['shoes_2'] = Config.MaleSkin["shoes_2"],
			}
			TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
		else
			local clothesSkin = {
				['tshirt_1'] = Config.FemaleSkin["tshirt_1"], ['tshirt_2'] = Config.FemaleSkin["tshirt_2"],
				['torso_1'] = Config.FemaleSkin["torso_1"], ['torso_2'] = Config.FemaleSkin["torso_2"],
				['arms'] = Config.FemaleSkin["arms"],
				['pants_1'] = Config.FemaleSkin["pants_1"], ['pants_2'] = Config.FemaleSkin["pants_2"],
				['shoes_1'] = Config.FemaleSkin["shoes_1"], ['shoes_2'] = Config.FemaleSkin["shoes_2"],
			}
			TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
		end
	end)
	LoadModel(-1320879687)
	local PolicePosition = Config.Cutscene["PolicePosition"]
	local Police = CreatePed(5, -1320879687, PolicePosition["x"], PolicePosition["y"], PolicePosition["z"], PolicePosition["h"], false)

	TaskStartScenarioInPlace(Police, "WORLD_HUMAN_PAPARAZZI", 0, false)
	local PlayerPosition = Config.Cutscene["PhotoPosition"]
	local PlayerPed = PlayerPedId()

	SetEntityCoords(PlayerPed, PlayerPosition["x"], PlayerPosition["y"], PlayerPosition["z"] - 1)
	SetEntityHeading(PlayerPed, PlayerPosition["h"])
	FreezeEntityPosition(PlayerPed, true)
	Cam()
	Citizen.Wait(1000)
	DoScreenFadeIn(100)
	Citizen.Wait(10000)
	DoScreenFadeOut(250)
	local JailPosition = Config.JailPositions["Cell"]
	SetEntityCoords(PlayerPed, JailPosition["x"], JailPosition["y"], JailPosition["z"])
	DeleteEntity(Police)
	SetModelAsNoLongerNeeded(-1320879687)
	Citizen.Wait(1000)
	DoScreenFadeIn(250)
	TriggerServerEvent("InteractSound_SV:PlayOnSource", "cell", 0.3)
	RenderScriptCams(false,  false,  0,  true,  true)
	FreezeEntityPosition(PlayerPed, false)
	DestroyCam(Config.Cutscene["CameraPos"]["cameraId"])
	InJail()
end

function Cam()
	local CamOptions = Config.Cutscene["CameraPos"]

	CamOptions["cameraId"] = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(CamOptions["cameraId"], CamOptions["x"], CamOptions["y"], CamOptions["z"])
	SetCamRot(CamOptions["cameraId"], CamOptions["rotationX"], CamOptions["rotationY"], CamOptions["rotationZ"])
	RenderScriptCams(true, false, 0, true, true)
end

function TeleportPlayer(pos)
	local Values = pos

	if #Values["goal"] > 1 then
		local elements = {}

		for i, v in pairs(Values["goal"]) do
			table.insert(elements, { label = v, value = v })
		end

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'teleport_jail',
			{
				title    = Config.MenuLang["tp_title"],
				align    = Config.MenuAlign,
				elements = elements
			},
		function(data, menu)
			local action = data.current.value
			local position = Config.Teleports[action]

			if action == "Boiling Broke" or action == "Security" then

				if PlayerData.job.name ~= Config.Job then
					if Config.NEWNotif then
						TriggerEvent('mythic_notify:client:SendAlert', {type = 'error', text = Config.NoKeys, length = 2500})
					else
						ESX.ShowNotification(Config.NoKeys)
					end
					return
				end
			end
			menu.close()
			DoScreenFadeOut(100)
			Citizen.Wait(250)
			SetEntityCoords(PlayerPedId(), position["x"], position["y"], position["z"])
			Citizen.Wait(250)
			DoScreenFadeIn(100)
		end,
		function(data, menu)
			menu.close()
		end)
	else
		local position = Config.Teleports[Values["goal"][1]]
		DoScreenFadeOut(100)
		Citizen.Wait(250)
		SetEntityCoords(PlayerPedId(), position["x"], position["y"], position["z"])
		Citizen.Wait(250)
		DoScreenFadeIn(100)
	end
end