QBCore = exports['qb-core']:GetCoreObject()
local discordWebhook = "PASTE_DISCORD_WEBHOOK_HERE"

QBCore.Commands.Add('givecash', 'Give cash', {{name = 'id', help = 'ID'}, {name = 'amount', help = 'Amount cash'}}, true, function(source, args)
    local src = source
	local id = tonumber(args[1])
	local amount = math.ceil(tonumber(args[2]))
    
	if id and amount then
		local xPlayer = QBCore.Functions.GetPlayer(src)
		local xReciv = QBCore.Functions.GetPlayer(id)
		
		if xReciv and xPlayer then
			if not xPlayer.PlayerData.metadata["isdead"] then
				local distance = xPlayer.PlayerData.metadata["inlaststand"] and 3.0 or 10.0
				if #(GetEntityCoords(GetPlayerPed(src)) - GetEntityCoords(GetPlayerPed(id))) < distance then
					if xPlayer.Functions.RemoveMoney('cash', amount) then
						if xReciv.Functions.AddMoney('cash', amount) then
							TriggerClientEvent('QBCore:Notify', src, "you gave money to " .. tostring(id) .. ' ' .. tostring(amount) .. '$.', "success")
							TriggerClientEvent('QBCore:Notify', id, "you received money: $ " .. tostring(amount) .. ' from ' .. tostring(src), "success")
                            TriggerClientEvent("payanimation", src)
                            TriggerEvent('cr-givecash:server:log', source, id, amount)
						else
							TriggerClientEvent('QBCore:Notify', src, "could not give the money", "error")
						end
					else
						TriggerClientEvent('QBCore:Notify', src, "you don't have that amount", "error")
					end
				else
					TriggerClientEvent('QBCore:Notify', src, "You are too far away", "error")
				end
			else
				TriggerClientEvent('QBCore:Notify', src, "You are dead", "error")
			end
		else
			TriggerClientEvent('QBCore:Notify', src, "wrong ID", "error")
		end
	else
		TriggerClientEvent('QBCore:Notify', src, "Use /givecash [ID] [AMOUNT]", "error")
	end
end)

RegisterNetEvent('cr-givecash:server:log', function(source, reciver, amount)
	if discordWebhook == "PASTE_DISCORD_WEBHOOK_HERE" then return end
    local discord
    local reciverDiscord
    for i = 0, GetNumPlayerIdentifiers(source) - 1 do
        local identifier = GetPlayerIdentifier(source, i)

        if identifier:find('discord') then
            discord = string.sub(identifier, 9)
        end
    end
    for i = 0, GetNumPlayerIdentifiers(reciver) - 1 do
        local identifier = GetPlayerIdentifier(reciver, i)

        if identifier:find('discord') then
            reciverDiscord = string.sub(identifier, 9)
        end
    end
    local embedData = {
        {
            ['title'] = "user gave cash",
            ['color'] = 65280,
            ['footer'] = {
                ['text'] = os.date('%c'),
            },
            ['description'] = 'Sender CitizenID: ' .. QBCore.Functions.GetPlayer(source).PlayerData.citizenid .. '\nSender Discord: <@'.. discord .. '>\nReciver CitizenID: ' .. QBCore.Functions.GetPlayer(reciver).PlayerData.citizenid .. '\nReciver Discored: <@'.. reciverDiscord .. '>\nSent amount: ' .. amount,
            ['author'] = {
                ['name'] = 'Creative Development',
                ['icon_url'] = 'https://media.discordapp.net/attachments/957021435652620298/1100495355755376640/Creative_development.png?width=449&height=449',
            },
        }
    }
    PerformHttpRequest(discordWebhook, function() end, 'POST', json.encode({ username = 'cr-givecash', embeds = embedData}), { ['Content-Type'] = 'application/json' })
    Wait(100)
end)