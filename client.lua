

if cfg.esxLegacy == false then
    ESX = nil -- ESX 
    CreateThread(function()
	    while ESX == nil do
	    	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		    Wait(0)
	    end
    end)
end

RegisterNetEvent('esx:playerLoaded') -- toto načte postavu prostě základ
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

local start = true
local start1 = true
local start2 = true
local truckspawned = false
local blip4 = nil
local randomak = {
    vector3(41.2160, 6291.3403, 31.2445),
    vector3(2672.5979, 1670.1613, 24.4886),
    vector3(2734.4402, 2782.9216, 35.8469),
    vector3(3504.1655, 3678.3823, 33.8705),
    vector3(812.0580, 2361.1912, 51.0148),
    vector3(1708.8717, 4803.0303, 41.7924),
    vector3(1377.0773, 3597.6069, 34.8902),
    vector3(-2345.8738, 3245.0051, 32.8276),
    vector3(-145.2133, -1012.3617, 27.2751),


}

CreateThread(function()
	while true do
        Citizen.Wait(0)
        if ESX.PlayerData.job and ESX.PlayerData.job.name == cfg.job['job'] then
            if blip4 == nil then
                blip4 = AddBlipForCoord(cfg.blip['blip'])
                AddTextEntry('MYBLIP', cfg.translation['jobblip'])
                SetBlipSprite(blip4, 67)
                SetBlipColour(blip4, 38)
                SetBlipDisplay(blip4, 4)
                SetBlipScale(blip4, 1.0)
                SetBlipAsShortRange(blip4, true)
                BeginTextCommandSetBlipName('MYBLIP')
                EndTextCommandSetBlipName(blip4)
            end
        else
            if blip4 ~= nil then
                RemoveBlip(blip4)
                blip4 = nil
            end

        end
    
    
    end
end)


CreateThread(function()
	while true do
        cas = 1000
        local Coords = GetEntityCoords(PlayerPedId())
        local pos = (cfg.startroute1['route'])
		local dist = #(Coords - pos)
        if dist < 3 then
            if ESX.PlayerData.job and ESX.PlayerData.job.name == cfg.job['job'] then
                if start then
                    start = true
                    if start == true then
                        cas = 5
                        ShowFloatingHelpNotification(cfg.translation['startRoute'], pos)
                        if IsControlJustPressed(0, 38) then
                            start = true
                            if not truckspawned then
                                TriggerServerEvent("zacatek:penize")
                                truckspawned = true
                                SpawnTruck()
                                Notify(cfg.translation['gpsRoute'])
                                Notify(cfg.translation['takeMoney'])
                                start2 = false
                                
                                cesta()
                            else
                                Notify(cfg.translation['alreadyOut'])
                            end
                                
                        end
                    end
                end
            end
        end
        Wait(cas)
	end
end)


CreateThread(function()
	while true do
        Citizen.Wait(0)
        local Coords = GetEntityCoords(PlayerPedId())
        local random = math.random(1, #randomak)
        local posr = vec3(randomak[random])
		local dist = #(Coords - posr)
        if truckspawned then
            if dist < 10 then
                if start1 then
                    start1 = true
                    if start1 == true then
                        Citizen.Wait(0)
                        ShowFloatingHelpNotification(cfg.translation['unhookTrailer'], posr)
                        if IsControlJustPressed(0, 38) then
                            start1 = false
                            konec()
                            start2 = true
                        end
                    end
                end
            end
        end
        
    end
end)

CreateThread(function()
	while true do
        cas = 1000
        local Coords = GetEntityCoords(PlayerPedId())
        local pos = (cfg.returntruck['return'])
		local dist = #(Coords - pos)
        if truckspawned then
            if dist < 10 then
                if start2 then
                    start2 = true
                    if start2 == true then
                        cas = 5
                        ShowFloatingHelpNotification(cfg.translation['returnVeh'], pos)
                        if IsControlJustPressed(0, 38) then
                            start2 = false
                            RemoveBlip(blip3)
                            uplnekonec()
                            truckspawned = true
                            truckspawned = false
                        end
                    end
                end
            end
        end
        Wait(cas)
    end
end)

konec = function()
    if IsVehicleAttachedToTrailer(truck) and (GetVehiclePedIsIn(PlayerPedId(), false) == truck) then
        DeleteVehicle(trailer)
        RemoveBlip(blip2)
        Notify(cfg.translation['buyCargo'])
        Wait(1000)
        TriggerServerEvent("konec:penize")
        Notify(cfg.translation['goBack'])
        depo()
    else
        Notify(cfg.translation['mustTrailer'])
    end
end

uplnekonec = function()
    if (GetVehiclePedIsIn(PlayerPedId(), false) == truck) then
        DeleteVehicle(truck)
        TriggerServerEvent("konec1:penize")
        Notify(cfg.translation['returnMoney'])
    else
        Notify(cfg.translation['returnTruck'])
    end
end

ShowFloatingHelpNotification = function(msg, pos)
    AddTextEntry('hs', msg)
    SetFloatingHelpTextWorldPosition(1, pos.x, pos.y, pos.z)
    SetFloatingHelpTextStyle(2, 1, 25, -1, 3, 0)
    BeginTextCommandDisplayHelp('hs')
    EndTextCommandDisplayHelp(2, false, false, -1)
end


SpawnTruck = function()
    ClearAreaOfVehicles(1204.5099, -3089.9766, 5.8921, 50.0, false, false, false, false, false)
    SetEntityAsNoLongerNeeded(trailer)
    DeleteVehicle(trailer)
    SetEntityAsNoLongerNeeded(truck)
    DeleteVehicle(truck)
    RemoveBlip(deliveryblip)
    local vehiclehash = GetHashKey("phantom")
    RequestModel(vehiclehash)
    while not HasModelLoaded(vehiclehash) do
        RequestModel(vehiclehash)
        Wait(0)
    end
    truck = CreateVehicle(vehiclehash, 1204.5099, -3089.9766, 5.8921, 0.0, true, false)
    SetEntityAsMissionEntity(truck, true, true) 
    local trailerhash = GetHashKey("trailers")
    RequestModel(trailerhash)
    while not HasModelLoaded(trailerhash) do
        RequestModel(trailerhash)
        Wait(0)
    end
    trailer = CreateVehicle(trailerhash, 1204.3513, -3103.0732, 5.8137, 0.0, true, false)
    SetEntityAsMissionEntity(trailer, true, true) 
    AttachVehicleToTrailer(truck, trailer, 1.1) 
    TaskWarpPedIntoVehicle(PlayerPedId(), truck, -1) 
end

cesta = function()
    local random = math.random(1, #randomak)
	blip2 = AddBlipForCoord(randomak[random])
    SetBlipRoute(blip2, true)
	AddTextEntry('MYBLIP', 'Place of delivery')
	BeginTextCommandSetBlipName('MYBLIP')
	EndTextCommandSetBlipName(blip2)
end

depo = function()
	blip3 = AddBlipForCoord(1203.5892, -3103.6331, 5.8028)
    SetBlipRoute(blip3, true)
	AddTextEntry('MYBLIP', cfg.translation['blipName'])
	BeginTextCommandSetBlipName('MYBLIP')
	EndTextCommandSetBlipName(blip3)
end

