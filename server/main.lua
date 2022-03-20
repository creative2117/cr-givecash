QBCore = exports['qb-core']:GetCoreObject()

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
