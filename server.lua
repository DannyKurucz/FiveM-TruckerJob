if cfg.esxLegacy == false then
    ESX = nil
    TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
end

local maxmoney = 1100
RegisterNetEvent("konec:penize")
AddEventHandler("konec:penize", function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local money = 1000
    if xPlayer ~= nil then
        if money >= maxmoney then
            print('esx_truckerjob - money exploit..')
        else
            local randomMoney = math.random(600,800)
            xPlayer.addMoney(randomMoney)
        end
    end
end)


RegisterNetEvent("konec1:penize")
AddEventHandler("konec1:penize", function()
    -- you can also check distance by using player coords and vec3 coords like this:
    --[[
        local src = source
        local srcPed = GetPlayerPed(src)
        local srcCoords = GetEntityCoords(srcPed)
        local dist = #(srcCoords - vec3(1208.2781, -3114.6919, 5.5403))

        if dist > 30 then
            -- ban player
        else
            xPlayer.addAccountMoney('bank', 100)
        end

    ]]

    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local money = 1050

    if money >= maxamount then
        print('esx_truckerjob - account money exploit..')
    else
        xPlayer.addAccountMoney('bank', 1000)
    end
end)

RegisterNetEvent("zacatek:penize")
AddEventHandler("zacatek:penize", function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    xPlayer.removeAccountMoney('bank', 1000)
end)