ESX = nil
TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)


RegisterNetEvent("konec:penize")
AddEventHandler("konec:penize", function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer ~= nil then
        local randomMoney = math.random(600,800)
        xPlayer.addMoney(randomMoney)
    end

end)

RegisterNetEvent("konec1:penize")
AddEventHandler("konec1:penize", function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
        xPlayer.addAccountMoney('bank', 1000)

end)

RegisterNetEvent("zacatek:penize")
AddEventHandler("zacatek:penize", function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.removeAccountMoney('bank', 1000)

end)