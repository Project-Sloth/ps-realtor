--local QBCore = exports['qb-core']:GetCoreObject()
local ESX = exports['es_extended']:getSharedObject()

RegisterNetEvent('QBCore:Server:UpdateObject', function()
	if source ~= '' then return false end
	QBCore = exports['qb-core']:GetCoreObject() 
end)

RegisterNetEvent("bl-realtor:server:updateProperty", function(type, property_id, data)
    -- Job check
    local src = source
    --[[local Player = QBCore.Functions.GetPlayer(src)
    local PlayerData = Player.PlayerData]]--
    local Player = ESX.GetPlayerFromId(src)
    
    if not RealtorJobs[Player.getJob().name] then return false end

    data.realtorSrc = src
    -- Update property
    TriggerEvent("ps-housing:server:updateProperty", type, property_id, data)
end)

RegisterNetEvent("bl-realtor:server:registerProperty", function(data)
    -- Job check
    local src = source
    --[[local Player = QBCore.Functions.GetPlayer(src)
    local PlayerData = Player.PlayerData]]--
    local Player = ESX.GetPlayerFromId(src)
    
    if not RealtorJobs[Player.getJob().name] then return false end

    data.realtorSrc = src
    -- Register property
    TriggerEvent("ps-housing:server:registerProperty", data)
end)

RegisterNetEvent("bl-realtor:server:addTenantToApartment", function(data)
    -- Job check
    local src = source
    --[[local Player = QBCore.Functions.GetPlayer(src)
    local PlayerData = Player.PlayerData]]--
    local Player = ESX.GetPlayerFromId(src)
    
    if not RealtorJobs[Player.getJob().name] then return false end

    data.realtorSrc = src
    -- Add tenant
    TriggerEvent("ps-housing:server:addTenantToApartment", data)
end)

function getESXOfflinePlayer(citizenid)
    return MySQL.single.await("SELECT 'firstname' AS 'firstName', 'lastname' AS 'lastName' FROM `users` WHERE `identifier` = @citizenid", {['@citizenid'] = citizenid})
end

lib.callback.register("bl-realtor:server:getNames", function (source, data)
    local src = source
    --[[local Player = QBCore.Functions.GetPlayer(src)
    local PlayerData = Player.PlayerData]]--
    local Player = ESX.GetPlayerFromId(src)
    
    if not RealtorJobs[Player.getJob().name] then return false end
    
    local names = {}
    for i = 1, #data do
        local target = ESX.GetPlayerFromId(data[i]) or getESXOfflinePlayer(data[i])
        if target then
            names[#names+1] = target.firstName .. " " .. target.lastName
        else
            names[#names+1] = "Unknown"
        end
    end
    
    return names
end)

if Config.UseItem then
    QBCore.Functions.CreateUseableItem(Config.ItemName, function(source, item)
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        if Player.Functions.GetItemByName(item.name) ~= nil then
            TriggerClientEvent("bl-realtor:client:toggleUI", src)
        end
    end)
end
