ESX                = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand(Config.JailCommand, function(src, args, raw)

	local xPlayer = ESX.GetPlayerFromId(src)

	if xPlayer["job"]["name"] == Config.Job then

		local jailPlayer = args[1]
		local jailTime = tonumber(args[2])
		local jailReason = args[3]
		local prisoner = GetPlayerName(jailPlayer)

		if GetPlayerName(jailPlayer) ~= nil then

			if jailTime ~= nil then
				JailPlayer(jailPlayer, jailTime)
				if Config.NEWNotif then
					TriggerClientEvent("GTA_NUI_ShowNotif_client", src, Config.PlayerTxt..""..prisoner..""..Config.PlayerInf..""..jailTime.. " -m", "success")
				else
					TriggerClientEvent("esx:showNotification", src, Config.PlayerTxt..""..prisoner..""..Config.PlayerInf..""..jailTime.. " -m")
				end
				
				if args[3] ~= nil then
					GetRPName(jailPlayer, function(Firstname, Lastname)
					end)
				end
			else
				if Config.NEWNotif then
					TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'error', text = Config.WorngTime})
				else
					TriggerClientEvent("esx:showNotification", src,  Config.WorngTime)
				end
			end
		else
			if Config.NEWNotif then
				TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'error', text = Config.NotOnline})
			else
				TriggerClientEvent("esx:showNotification", src,  Config.NotOnline)
			end
		end
	else
		if Config.NEWNotif then
			TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'error', text = Config.NotPD})
		else
			TriggerClientEvent("esx:showNotification", src,  Config.NotPD)
		end
	end
	
end)

RegisterCommand(Config.UnjailCommand, function(src, args)

	local xPlayer = ESX.GetPlayerFromId(src)

	if xPlayer["job"]["name"] == Config.Job then

		local jailPlayer = args[1]

		if GetPlayerName(jailPlayer) ~= nil then
			UnJail(jailPlayer)
		else
			if Config.NEWNotif then
				TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'error', text = Config.NotOnline})
			else
				TriggerClientEvent("esx:showNotification", src,  Config.NotOnline)
			end
		end
	else
		if Config.NEWNotif then
			TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'error', text = Config.NotPD})
		else
			TriggerClientEvent("esx:showNotification", src,  Config.NotPD)
		end
	end
end)

RegisterServerEvent("proste-jail:jailPlayer")
AddEventHandler("proste-jail:jailPlayer", function(targetSrc, jailTime, jailReason)
	local src = source
	local targetSrc = tonumber(targetSrc)
	local prisoner = GetPlayerName(targetSrc)

	JailPlayer(targetSrc, jailTime)

	GetRPName(targetSrc, function(Firstname, Lastname)
	-- (chat message)
	end)
	if Config.NEWNotif then
		TriggerClientEvent("GTA_NUI_ShowNotif_client", src, Config.PlayerTxt..""..prisoner..""..Config.PlayerInf..""..jailTime.. " -m", "success")
		print('Tohle jsem upravil já (Ice Cube#4366) ty sračko :) jestli dáš pryč to nolimit, ukradnu ti bagetu.. :)')
	else
		TriggerClientEvent("esx:showNotification", src, Config.PlayerTxt..""..prisoner..""..Config.PlayerInf..""..jailTime.. " -m")
		print('Tohle jsem upravil já (Ice Cube#4366) ty sračko :) jestli dáš pryč to nolimit, ukradnu ti bagetu.. :)')
	end
end)

RegisterServerEvent("proste-jail:unJailPlayer")
AddEventHandler("proste-jail:unJailPlayer", function(targetIdentifier)
	local src = source
	local xPlayer = ESX.GetPlayerFromIdentifier(targetIdentifier)

	if xPlayer ~= nil then
		UnJail(xPlayer.source)
	else
		MySQL.Async.execute(
			"UPDATE users SET jail = @newJailTime WHERE identifier = @identifier",
			{
				['@identifier'] = targetIdentifier,
				['@newJailTime'] = 0
			}
		)
	end
	if Config.NEWNotif then
		TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'success', text = Config.PlayerTxt..''..xPlayer.name..''..Config.WasRelesed})
	else
		TriggerClientEvent("esx:showNotification", src, Config.PlayerTxt..''..xPlayer.name..''..Config.WasRelesed)
	end
end)

RegisterServerEvent("proste-jail:updateJailTime")
AddEventHandler("proste-jail:updateJailTime", function(newJailTime)
	local src = source

	EditJailTime(src, newJailTime)
end)

function JailPlayer(jailPlayer, jailTime)
	TriggerClientEvent("proste-jail:jailPlayer", jailPlayer, jailTime)

	EditJailTime(jailPlayer, jailTime)
end

function UnJail(jailPlayer)
	TriggerClientEvent("proste-jail:unJailPlayer", jailPlayer)

	EditJailTime(jailPlayer, 0)
end

function EditJailTime(source, jailTime)

	local src = source

	local xPlayer = ESX.GetPlayerFromId(src)
	local Identifier = xPlayer.identifier

	MySQL.Async.execute(
       "UPDATE users SET jail = @newJailTime WHERE identifier = @identifier",
        {
			['@identifier'] = Identifier,
			['@newJailTime'] = tonumber(jailTime)
		}
	)
end

function GetRPName(playerId, data)
	local Identifier = ESX.GetPlayerFromId(playerId).identifier

	MySQL.Async.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", { ["@identifier"] = Identifier }, function(result)

		data(result[1].firstname, result[1].lastname)

	end)
end

ESX.RegisterServerCallback("proste-jail:retrieveJailedPlayers", function(source, cb)
	
	local jailedPersons = {}

	MySQL.Async.fetchAll("SELECT firstname, lastname, jail, identifier FROM users WHERE jail > @jail", { ["@jail"] = 0 }, function(result)

		for i = 1, #result, 1 do
			table.insert(jailedPersons, { name = result[i].firstname .. " " .. result[i].lastname, jailTime = result[i].jail, identifier = result[i].identifier })
		end

		cb(jailedPersons)
	end)
end)

ESX.RegisterServerCallback("proste-jail:retrieveJailTime", function(source, cb)

	local src = source

	local xPlayer = ESX.GetPlayerFromId(src)
	local Identifier = xPlayer.identifier


	MySQL.Async.fetchAll("SELECT jail FROM users WHERE identifier = @identifier", { ["@identifier"] = Identifier }, function(result)

		local JailTime = tonumber(result[1].jail)

		if JailTime > 0 then

			cb(true, JailTime)
		else
			cb(false, 0)
		end

	end)
end)