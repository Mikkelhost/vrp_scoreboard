local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vrp_deathmatch")

local connectedPlayers = {}
local groups = {
    --Standard
    ["Civil"] =            			{title = "Civil"},
    ["Taxa"] =       				{title = "Taxa chauffør"},
    ["Kriminel"] =     				{title = "Kriminel"},
    ["Miner"] = 					{title = "Minearbejder"},
    ["Postnord"] =  				{title = "Postnord medarbejder"},

    -- Police dept
    ["Rigspolitichef"] =   			{title = "Rigspolitichef"},
    ["Vicerigspolitichef"] =    	{title = "Vicerigspolitichef"},
    ["Politiinspektør"] =  			{title = "Politiinspektør"},
    ["Vicepolitiinspektør"] =   	{title = "Vicepolitiinspektør"},
    ["Civilbetjent"] = 				{title = "Civilbetjent"},
    ["AKS"] =  						{title = "Specialenhed"},
    ["Politikommissær"] =   		{title = "Politikommissær"},
    ["Politiassistent"] =       	{title = "Politiassistent"},
    ["Politibetjent"] =         	{title = "Politibetjent"},
    ["Politielev"] =            	{title = "Politielev"},

    --EMS
    ["Regionschef"] =           	{title = "Regionschef"},
    ["Viceregionschef"] =       	{title = "Viceregionschef"},
    ["Overlæge"] =              	{title = "Overlæge"},
    ["Akutlæge"] =              	{title = "Akutlæge"},
    ["Ambulanceredder"] =       	{title = "Ambulanceredder"},
    ["Redderelev"] =            	{title = "Redderelev"},

    --andre whitelist
	["Mekaniker"] =          		{title = "Mekaniker"},
	["Mekanikerchef"] =         	{title = "Mekanikerchef"},
    ["Advokat"] =          			{title = "Advokat"},
    ["Sons of Anarchy"] =       	{title = "Sons of Anarchy"},
    ["Mafia"] =          			{title = "Mafia Medlem"},
    ["Kartel"] =          			{title = "Kartel Medlem"},
    ["Sons of Anarchy Mekaniker"] = {title = "Mekaniker"},
    ["Mafia Mekaniker"] =          	{title = "Mekaniker"},
    ["Kartel Mekaniker"] =          {title = "Mekaniker"},
}

AddEventHandler("vRP:playerJoinGroup", function(user_id, group, gtype)
    local player = vRP.getUserSource({user_id})
    if gtype == "job" then
	    connectedPlayers[player].job = groups[group].title
        TriggerClientEvent('esx_scoreboard:updateConnectedPlayers', -1, connectedPlayers)
    end
end)

AddEventHandler("vRP:playerJoin", function(user_id, user, name, last_login)
		local source = vRP.getUserSource({user_id})
		AddPlayerToScoreboard(source,user_id, true)
		Wait(2000)
		--TriggerClientEvent("vrp_scoreboard:firstjoin",source,connectedPlayers)
end)

AddEventHandler('vRP:playerSpawn', function(user_id,source,first_spawn)
	if first_spawn then
		if not vRP.hasPermission({user_id,"player.list"}) then
			Wait(2000)
			TriggerClientEvent('esx_scoreboard:toggleID', source, false)
			TriggerClientEvent('esx_scoreboard:toggleJob', source, false)
		end
		TriggerClientEvent("vrp_scoreboard:firstjoin",source,connectedPlayers)
	end
end)

AddEventHandler('vRP:playerLeave', function(user_id, source)
	connectedPlayers[source] = nil
	TriggerClientEvent('esx_scoreboard:updateConnectedPlayers', -1, connectedPlayers)
end)

RegisterServerEvent("vrp_scoreboard:askperm")
AddEventHandler("vrp_scoreboard:askperm",function()
	local user_id = vRP.getUserId({source})
    if vRP.hasPermission({user_id,"player.phone"}) then
        TriggerClientEvent("vrp_scoreboard:permgranted",source)
    else
        vRPclient.notify(source, {"Du kan ikke åbne home menuen, hvis du ikke er admin"})
    end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		UpdatePing()
	end
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		Citizen.CreateThread(function()
			Citizen.Wait(2000)
			AddPlayersToScoreboard()
		end)
	end
end)

function AddPlayerToScoreboard(player,id, update)
    connectedPlayers[player] = {}	
	connectedPlayers[player].ping = GetPlayerPing(player)
	connectedPlayers[player].id = id
    connectedPlayers[player].name = GetPlayerName(player)
    for group, data in pairs(groups) do
        if vRP.hasGroup({id, group}) then
            connectedPlayers[player].job = data.title
        end
	end

	if connectedPlayers[player].job == nil then
		connectedPlayers[player].job = "Arbejdsløs"
	end

	if connectedPlayers[player].name == nil then
		connectedPlayers[player]=nil
	end
	
	if update then
		TriggerClientEvent('esx_scoreboard:updateConnectedPlayers', -1, connectedPlayers)
	end	
end

local firstRun = false
function AddPlayersToScoreboard()
	connectedPlayers = {}
	local users = vRP.getUsers()
	for user_id, player in pairs(users) do
        local id = user_id
        local Player = player
		AddPlayerToScoreboard(Player,id, false)
		if not firstRun then
			if not vRP.hasPermission({id,"player.list"}) then
				Wait(10)
				TriggerClientEvent('esx_scoreboard:toggleID', Player, false)
				TriggerClientEvent('esx_scoreboard:toggleJob', Player, false)
			end
		end
	end
	firstRun = true
	TriggerClientEvent('esx_scoreboard:updateConnectedPlayers', -1, connectedPlayers)	
end

function UpdatePing()
	for k,v in pairs(connectedPlayers) do
		v.ping = GetPlayerPing(k)
		if v.ping == 0 then
			connectedPlayers[k]=nil
		end
	end
	AddPlayersToScoreboard()
	TriggerClientEvent('esx_scoreboard:updatePing', -1, connectedPlayers)
	TriggerClientEvent('esx_scoreboard:updateConnectedPlayers', -1, connectedPlayers)
end

function Sanitize(str)
	local replacements = {
		['&' ] = '&amp;',
		['<' ] = '&lt;',
		['>' ] = '&gt;',
		['\n'] = '<br/>'
	}

	return str
		:gsub('[&<>\n]', replacements)
		:gsub(' +', function(s)
			return ' '..('&nbsp;'):rep(#s-1)
		end)
end

--RegisterCommand("scoreboardtoggle",function(source)
	--TriggerClientEvent('esx_scoreboard:toggleID', source, false)
	--TriggerClientEvent('esx_scoreboard:toggleJob', source, false)
--end)
