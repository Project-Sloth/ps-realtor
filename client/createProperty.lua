function MathFloor(val)
    return math.floor(val * 100) / 100
end

local createProperty = {
    creating = false,
    street = "",
    region = "",
    description = "",
    for_sale = 1,
    price = 0,
    shell = "",
    door_data = nil,
    garage_data = nil,
    zone_data = nil,

    startCreating = function(self)
        self.creating = true
    end,

    cancelCreating = function(self)
        self.creating = false
        self.description = ""
        self.for_sale = false
        self.price = 0
        self.shell = ""
        self.door_data = nil
        self.garage_data = nil
        self.creating = false
    end,

    setTextFields = function(self, data)
        self.description = data.description
        self.for_sale = data.for_sale
        self.price = data.price
        self.shell = data.shell
    end,

    placingZone = function(self, type, propertyType)
        local ped = cache.ped
        local function createZone()
            local zoneDataPromise = promise.new()
            lib.showTextUI('[E] - to confirm | [h] to cancel')
            ZoneThread(type, zoneDataPromise)

            local success = Citizen.Await(zoneDataPromise)
            if not success then return false end

            lib.hideTextUI()
            local coords = GetEntityCoords(ped)
            return {
                x = MathFloor(coords.x),
                y = MathFloor(coords.y),
                z = MathFloor(coords.z),
                h = MathFloor(GetEntityHeading(ped))
            }
        end

        local function setZoneData(zoneData, length, width, notifyMessage)
            zoneData.length = length
            zoneData.width = width
            if notifyMessage then
                lib.notify({ description = notifyMessage, type = 'success' })
            end
        end

        if propertyType == 'mlo' then
            if type == 'zone' then
                local zoneData = require 'client.zoneCreator'.polyCreator()
                if not zoneData then return false end

                self.zone_data = zoneData
            elseif type == "door" then
                local data = require 'client.zoneCreator'.mloDoor()
                if not data then return false end

                self.door_data = self.door_data or {}
                self.door_data[#self.door_data+1] = data
            elseif type == "garage" then
                local zoneData = createZone()
                if not zoneData then return false end
                setZoneData(zoneData, 3.0, 5.0, 'Garage was set!')
                self.garage_data = zoneData
            end
        else
            if type == "garden" then
                self.zone_data = require 'client.zoneCreator'.polyCreator()
                goto skip
            end

            local zoneData = createZone()
            if not zoneData then return false end

            if type == "door" then
                zoneData.locked = false
                setZoneData(zoneData, 1.5, 2.2, 'Door was set!')
                self.door_data = zoneData
            elseif type == "garage" then
                setZoneData(zoneData, 3.0, 5.0, 'Garage was set!')
                self.garage_data = zoneData
            end
        end

        ::skip::
        local coords = GetEntityCoords(ped)
        self.street = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z))
        self.region = GetLabelText(GetNameOfZone(coords.x, coords.y, coords.z))
        self.propertyType = propertyType
        return true
    end,

    removeDoor = function(self, index)
        if not self.door_data then return end
        self.door_data[index] = nil
        lib.notify({ description = 'Door was removed!', type = 'error'})
    end,

    removeGarage = function(self)
        self.garage_data = nil
        lib.notify({ description = 'Garage was removed!', type = 'error'})
        return true
    end,

    removeGarden = function(self)
        self.zone_data = nil
        lib.notify({ description = 'Garden was removed!', type = 'error'})
        return true
    end,

    createProperty = function(self)
        self.shell = self.propertyType == 'mlo' and 'mlo' or self.shell
        local data = {
            street = self.street,
            region = self.region,
            description = self.description,
            for_sale = self.for_sale,
            price = self.price,
            shell = self.shell,
            door_data = self.door_data,
            garage_data = self.garage_data,
            zone_data = self.zone_data,
            propertyType = self.propertyType
        }

        TriggerServerEvent('bl-realtor:server:registerProperty', data)

        lib.notify({ description = 'Property was created!', type = 'success'})
        self:cancelCreating()
    end,
}

RegisterNUICallback("create:startCreating", function(data, cb)
    createProperty:startCreating()
    cb("ok")
end)

RegisterNUICallback("create:cancelCreating", function(data, cb)
    createProperty:cancelCreating()
    cb("ok")
end)

RegisterNUICallback("create:setTextFields", function(data, cb)
    createProperty:setTextFields(data)
    cb("ok")
end)

RegisterNUICallback("create:confirmListing", function(data, cb)
    createProperty:createProperty()
    cb("ok")
end)

RegisterNUICallback("create:createZone", function(data, cb)
    SetNuiFocus(false, false)
    local type, propertyType in data
    local result = createProperty:placingZone(type, propertyType)
    cb(result)
end)

RegisterNUICallback("create:removeGarage", function(data, cb)
    cb(createProperty:removeGarage())
end)

RegisterNUICallback("create:removeGarden", function(data, cb)
    cb(createProperty:removeGarden())
end)

RegisterNUICallback("create:removeDoor", function(index, cb)
    createProperty:removeDoor(index+1)
    cb("ok")
end)
