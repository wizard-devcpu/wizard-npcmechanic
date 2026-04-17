local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('wizard-npcmechanic:server:getMechanics', function(source, cb)
    local count = 0
    local players = QBCore.Functions.GetQBPlayers()
    for _, v in pairs(players) do
        if v.PlayerData.job.name == Config.JobName and v.PlayerData.job.onduty then
            count = count + 1
        end
    end
    cb(count)
end)

QBCore.Functions.CreateCallback('wizard-npcmechanic:server:pay', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.money['cash'] >= Config.Price then
        Player.Functions.RemoveMoney('cash', Config.Price)
        cb(true)
    elseif Player.PlayerData.money['bank'] >= Config.Price then
        Player.Functions.RemoveMoney('bank', Config.Price)
        cb(true)
    else
        cb(false)
    end
end)