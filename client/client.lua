vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP", "vrp_scoreboard")


local idVisable = true
local jobVisable = true

RegisterNetEvent("vrp_scoreboard:firstjoin")
AddEventHandler("vrp_scoreboard:firstjoin",function(connectedPlayers)
	UpdatePlayerTable(connectedPlayers)
end)



Citizen.CreateThread(function()
	Citizen.Wait(500)
	SendNUIMessage({
		action = 'updateServerInfo',

		maxPlayers = GetConvarInt('sv_maxclients', 64),
		uptime = 'unknown',
		playTime = '00h 00m'
	})
end)

RegisterNetEvent('esx_scoreboard:updateConnectedPlayers')
AddEventHandler('esx_scoreboard:updateConnectedPlayers', function(connectedPlayers)
	UpdatePlayerTable(connectedPlayers)
end)

RegisterNetEvent('esx_scoreboard:updatePing')
AddEventHandler('esx_scoreboard:updatePing', function(connectedPlayers)
	SendNUIMessage({
		action  = 'updatePing',
		players = connectedPlayers
	})
end)

RegisterNetEvent('esx_scoreboard:toggleID')
AddEventHandler('esx_scoreboard:toggleID', function(state)
	if state then
		idVisable = state
	else
		idVisable = not idVisable
	end

	SendNUIMessage({
		action = 'toggleID',
		state = idVisable
	})
end)

RegisterNetEvent('esx_scoreboard:toggleJob')
AddEventHandler('esx_scoreboard:toggleJob', function(state)
	if state then
		jobVisable = state
	else
		jobVisable = not jobVisable
	end

	SendNUIMessage({
		action = 'toggleJob',
		state = jobVisable
	})
end)

RegisterNetEvent('uptime:tick')
AddEventHandler('uptime:tick', function(uptime)
	SendNUIMessage({
		action = 'updateServerInfo',
		uptime = uptime
	})
end)

function UpdatePlayerTable(connectedPlayers)
	local formattedPlayerList, num = {}, 1
	local ems, police, taxi, mechanic, advokat, players = 0, 0, 0, 0, 0, 0, 0

	for k,v in pairs(connectedPlayers) do

		if num == 1 then
			table.insert(formattedPlayerList, ('<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td>'):format(v.name, v.id, v.job, v.ping))
			num = 2
		elseif num == 2 then
			table.insert(formattedPlayerList, ('<td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>'):format(v.name, v.id, v.job, v.ping))
			num = 1
		end

		players = players + 1

		if v.job == 'Regionschef' or v.job == 'Viceregionschef' or v.job == 'Overlæge' or v.job == 'Akutlæge' or v.job == 'Ambulanceredder' or v.job == 'Redderelev' then
			ems = ems + 1
		elseif v.job == 'Rigspolitichef' or v.job == 'Vicerigspolitichef' or v.job == 'Politiinspektør' or v.job == 'Vicepolitiinspektør' or v.job == 'Civilbetjent' or v.job == 'Specialenhed' or v.job == 'Politikommissær' or v.job == 'Politiassistent' or v.job == 'Politibetjent' or v.job == 'Politielev' then
			police = police + 1
		elseif v.job == 'Taxa chauffør' then
			taxi = taxi + 1
		elseif v.job == 'Mekaniker' then
			mechanic = mechanic + 1
		elseif v.job == 'Advokat' then
			advokat = advokat + 1
		elseif v.job == 'realestateagent' then
			estate = estate + 1
		end
	end

	if num == 1 then
		table.insert(formattedPlayerList, '</tr>')
	end

	SendNUIMessage({
		action  = 'updatePlayerList',
		players = table.concat(formattedPlayerList)
	})

	SendNUIMessage({
		action = 'updatePlayerJobs',
		jobs   = {ems = ems, police = police, taxi = taxi, mechanic = mechanic, advokat = advokat, player_count = players}
	})
	SendNUIMessage({
		action = 'toggleJob',
		state = jobVisable
	})
	SendNUIMessage({
		action = 'toggleID',
		state = idVisable
	})
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if IsControlJustReleased(0, 212) then
			TriggerServerEvent("vrp_scoreboard:askperm")
			Citizen.Wait(200)

		-- D-pad up on controllers works, too!
		elseif IsControlJustReleased(0, 172) and not IsInputDisabled(0) then
			TriggerServerEvent("vrp_scoreboard:askperm")
			Citizen.Wait(200)
		end
	end
end)

RegisterNetEvent("vrp_scoreboard:permgranted")
AddEventHandler("vrp_scoreboard:permgranted",function()
	ToggleScoreBoard()
end)

-- Close scoreboard when game is paused
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(300)
		if IsPauseMenuActive() and not IsPaused then
			IsPaused = true
			SendNUIMessage({
				action  = 'close'
			})
		elseif not IsPauseMenuActive() and IsPaused then
			IsPaused = false
		end
	end
end)

function ToggleScoreBoard()
	SendNUIMessage({
		action = 'toggle'
	})
end

Citizen.CreateThread(function()
	local playMinute, playHour = 0, 0

	while true do
		Citizen.Wait(1000 * 60) -- every minute
		playMinute = playMinute + 1
	
		if playMinute == 60 then
			playMinute = 0
			playHour = playHour + 1
		end

		SendNUIMessage({
			action = 'updateServerInfo',
			playTime = string.format("%02dh %02dm", playHour, playMinute)
		})
	end
end)
