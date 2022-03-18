QBCore = exports['qb-core']:GetCoreObject()

QBCore.Commands.Add("givecash", "Give cash", {{name = "id", help = "Player ID"}, {name = "summa", help = "How much do you wanna give the player?"}}, false, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local otherPlayer = QBCore.Functions.GetPlayer(tonumber(args[1]))
    local summa = tonumber(args[2])
    local cash = Player.Functions.GetMoney("cash")
    if otherPlayer then
        if cash >= summa then
            if summa then
                Player.Functions.RemoveMoney("cash", summa)
                otherPlayer.Functions.AddMoney("cash", summa)
            else
                TriggerClientEvent('QBCore:Notify', src, "You have to add a value", "error")
            end
        else
            TriggerClientEvent('QBCore:Notify', src, "Not enough money", "error")
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "Player not online", "error")
    end
end)