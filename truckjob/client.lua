
local ESX = nil -- ESX 
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)
RegisterNetEvent('esx:playerLoaded') -- toto načte postavu prostě základ
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

local start = true
local start1 = true
local start2 = true
local truckspawned = false
local truckznova = true
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

Citizen.CreateThread(function()
	while true do
        cas = 1000
        local Coords = GetEntityCoords(PlayerPedId())
        local pos = (vector3(1208.2781, -3114.6919, 5.5403))
		local dist = #(Coords - pos)
        if dist < 3 then
            if ESX.PlayerData.job and ESX.PlayerData.job.name == "truck" then
                if start then
                    start = true
                    if start == true then
                        cas = 5
                        ShowFloatingHelpNotification("Start the route with [E]", pos)
                        if IsControlJustPressed(0, 38) then
                            start = true
                            if not truckspawned then
                                TriggerServerEvent("zacatek:penize")
                                truckspawned = true
                                SpawnTruck()
                                ESX.ShowNotification('You have your route on GPS. deliver the shipment in order.')
                                ESX.ShowNotification('As a deposit for renting a truck, we took $ 1,000 from you.')
                                start2 = false
                                cesta()
                            else
                                ESX.ShowNotification('You ve already pulled out your truck')

                            end
                                
                        end
                    end
                end
            end
        end
        Citizen.Wait(cas)
	end
end)


function SpawnTruck()
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
      Citizen.Wait(0)
    end
    truck = CreateVehicle(vehiclehash, 1204.5099, -3089.9766, 5.8921, 0.0, true, false)
    SetEntityAsMissionEntity(truck, true, true) 
    
    local trailerhash = GetHashKey("trailers")
    RequestModel(trailerhash)
    while not HasModelLoaded(trailerhash) do
      RequestModel(trailerhash)
      Citizen.Wait(0)
    end
    trailer = CreateVehicle(trailerhash, 1204.3513, -3103.0732, 5.8137, 0.0, true, false)
    SetEntityAsMissionEntity(trailer, true, true) 
    
    AttachVehicleToTrailer(truck, trailer, 1.1) 
    
    TaskWarpPedIntoVehicle(GetPlayerPed(-1), truck, -1) 
end

function cesta()
    local random = math.random(1, #randomak)
	blip2 = AddBlipForCoord(randomak[random])
    SetBlipRoute(blip2, true)
	AddTextEntry('MYBLIP', 'Place of delivery')
	BeginTextCommandSetBlipName('MYBLIP')
	EndTextCommandSetBlipName(blip2)
end
function depo()
	blip3 = AddBlipForCoord(1203.5892, -3103.6331, 5.8028)
    SetBlipRoute(blip3, true)
	AddTextEntry('MYBLIP', 'Depot')
	BeginTextCommandSetBlipName('MYBLIP')
	EndTextCommandSetBlipName(blip3)
end


CreateThread(function()
	while true do
        Wait(0)
        local Coords = GetEntityCoords(PlayerPedId())
        local random = math.random(1, #randomak)
        local posr = vector3(randomak[random])
		local dist = #(Coords - posr)
        if truckspawned then
            if dist < 10 then
                if start1 then
                    start1 = true
                    if start1 == true then
                        ShowFloatingHelpNotification("Unhook the semi-trailer with [E] ", posr)
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
        local pos = (vector3(1204.0476, -3100.9810, 5.8822))
		local dist = #(Coords - pos)
        if truckspawned then
            if dist < 10 then
                if start2 then
                    start2 = true
                    if start2 == true then
                        cas = 5
                        ShowFloatingHelpNotification("Return vehicle with [E]", pos)
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
        Citizen.Wait(cas)
    end
end)

function konec()
    if IsVehicleAttachedToTrailer(truck) and (GetVehiclePedIsIn(GetPlayerPed(-1), false) == truck) then
      DeleteVehicle(trailer)
      RemoveBlip(blip2)
      ESX.ShowNotification('You brought the cargo')
        Wait(1000)
      TriggerServerEvent("konec:penize")
      ESX.ShowNotification('Go back to the depot to drop off the truck')
        depo()
    else
        ESX.ShowNotification('You must also have a trailer')
    end
end

function uplnekonec()
    if (GetVehiclePedIsIn(GetPlayerPed(-1), false) == truck) then
      DeleteVehicle(truck)
      TriggerServerEvent("konec1:penize")
      ESX.ShowNotification('Thank you, your deposit has been returned')

    else
        ESX.ShowNotification('You have to bring us the car we lent you')

    end
end

function ShowFloatingHelpNotification(msg, pos)
    AddTextEntry('hs', msg)
    SetFloatingHelpTextWorldPosition(1, pos.x, pos.y, pos.z)
    SetFloatingHelpTextStyle(2, 1, 25, -1, 3, 0)
    BeginTextCommandDisplayHelp('hs')
    EndTextCommandDisplayHelp(2, false, false, -1)
end