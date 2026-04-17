local QBCore = exports['qb-core']:GetCoreObject()
local isProcessing = false

local function closeUI()
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "hide" })
end

local function spawnMechanic()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local playerVehicle = GetVehiclePedIsIn(playerPed, false)
    
    if not playerVehicle or playerVehicle == 0 then return end

    local spawnDistance = 100.0
    local ret, spawnPos, heading = GetClosestVehicleNodeWithHeading(playerCoords.x + spawnDistance, playerCoords.y + spawnDistance, playerCoords.z, 1, 3.0, 0)
    
    RequestModel(Config.VehicleModel)
    while not HasModelLoaded(Config.VehicleModel) do Wait(0) end
    
    RequestModel(Config.PedModel)
    while not HasModelLoaded(Config.PedModel) do Wait(0) end

    local mechVehicle = CreateVehicle(Config.VehicleModel, spawnPos, heading, true, false)
    local mechPed = CreatePedInsideVehicle(mechVehicle, 4, Config.PedModel, -1, true, false)

    SetEntityAsMissionEntity(mechVehicle, true, true)
    SetEntityAsMissionEntity(mechPed, true, true)
    
    TaskVehicleDriveToCoord(mechPed, mechVehicle, playerCoords.x, playerCoords.y, playerCoords.z, 20.0, 0, Config.VehicleModel, 786603, 5.0, 1)

    while #(GetEntityCoords(mechVehicle) - playerCoords) > 15.0 do
        Wait(500)
    end

    TaskVehicleTempAction(mechPed, mechVehicle, 27, 5000)
    Wait(3000)

    TaskLeaveVehicle(mechPed, mechVehicle, 0)
    
    local offset = GetOffsetFromEntityInWorldCoords(playerVehicle, 0.0, 2.5, 0.0)
    TaskGoToCoordAnyMeans(mechPed, offset.x, offset.y, offset.z, 1.0, 0, 0, 786603, 0xbf800000)

    while #(GetEntityCoords(mechPed) - offset) > 1.5 do
        Wait(500)
    end

    TaskTurnPedToFaceEntity(mechPed, playerVehicle, 1000)
    Wait(1000)
    TaskStartScenarioInPlace(mechPed, "PROP_HUMAN_BUM_BIN", 0, true)

    QBCore.Functions.Progressbar("repairing_veh", "Mechanic is working...", Config.RepairTime, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        ClearPedTasks(mechPed)
        SetVehicleFixed(playerVehicle)
        SetVehicleDeformationFixed(playerVehicle)
        SetVehicleDirtLevel(playerVehicle, 0.0)
        
        TaskEnterVehicle(mechPed, mechVehicle, -1, -1, 1.0, 1, 0)
        Wait(5000)
        
        TaskVehicleDriveWander(mechPed, mechVehicle, 20.0, 786603)
        Wait(10000)
        
        DeleteEntity(mechPed)
        DeleteEntity(mechVehicle)
        isProcessing = false
    end)
end

RegisterCommand('mechanic', function()
    local playerPed = PlayerPedId()
    if IsPedInAnyVehicle(playerPed, false) then
        QBCore.Functions.TriggerCallback('wizard-npcmechanic:server:getMechanics', function(count)
            SetNuiFocus(true, true)
            SendNUIMessage({
                action = "open",
                price = Config.Price,
                available = count > 0
            })
        end)
    else
        QBCore.Functions.Notify("You must be in a vehicle.", "error")
    end
end)

RegisterNUICallback('close', function()
    closeUI()
end)

RegisterNUICallback('callMechanic', function()
    if isProcessing then return end
    
    QBCore.Functions.TriggerCallback('wizard-npcmechanic:server:pay', function(success)
        if success then
            isProcessing = true
            closeUI()
            spawnMechanic()
        else
            QBCore.Functions.Notify("Not enough money.", "error")
        end
    end)
end)

RegisterNUICallback('restartScript', function()
    isProcessing = false
    closeUI()
    QBCore.Functions.Notify("Mechanic variables re-initialized.", "success")
end)