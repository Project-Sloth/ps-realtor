CreateProperty = {
    creating = false,
    street = "",
    region = "",
    description = "",
    for_sale = 1,
    price = 0,
    shell = "",
    door_data = nil,
    garage_data = nil,

    StartCreating = function(self)
        self.creating = true
    end,

    CancelCreating = function(self)
        self.creating = false
        self.description = ""
        self.for_sale = false
        self.price = 0
        self.shell = ""
        self.door_data = nil
        self.garage_data = nil
        self.creating = false
    end,

    SetTextFields = function(self, data)
        self.description = data.description
        self.for_sale = data.for_sale
        self.price = data.price
        self.shell = data.shell
    end,

    PlacingZone = function(self, type)
        local zoneDataPromise = promise.new()
        ZoneThread(type, zoneDataPromise)
        local zoneData = Citizen.Await(zoneDataPromise)
        if not zoneData then return end
        zoneData.x = math.floor(zoneData.x* 100) / 100
        zoneData.y = math.floor(zoneData.y* 100) / 100
        zoneData.z = math.floor(zoneData.z* 100) / 100
        zoneData.h = math.floor(zoneData.h* 100) / 100
        if type == "door" then
            self.door_data = zoneData
            self.door_data.locked = false
            self.door_data.length = 1.5
            self.door_data.width = 2.2
            SendNUIMessage({
                action = "createdDoor",
                data = true
            })
            lib.notify({ description = 'Door was set!', type = 'success'})
        elseif type == "garage" then
            self.garage_data = zoneData

            self.garage_data.length = 3.0
            self.garage_data.width = 5.0

            SendNUIMessage({
                action = "createdGarage",
                data = true
            })
            lib.notify({ description = 'Garage was set!', type = 'success'})
        end

        
        local streetHash = GetStreetNameAtCoord(zoneData.x, zoneData.y, zoneData.z)
        self.street = GetStreetNameFromHashKey(streetHash)

        local regionHash = GetNameOfZone(zoneData.x, zoneData.y, zoneData.z)
        self.region = GetLabelText(regionHash)

    end,

    RemoveGarage = function(self)
        self.garage_data = nil
        SendNUIMessage({
            action = "createdGarage",
            data = nil
        })
        lib.notify({ description = 'Garage was removed!', type = 'error'})
    end,

    CreateProperty = function(self)
        local data = {
            street = self.street,
            region = self.region,
            description = self.description,
            for_sale = self.for_sale,
            price = self.price,
            shell = self.shell,
            door_data = self.door_data,
            garage_data = self.garage_data,
        }
        
        TriggerServerEvent("bl-realtor:server:registerProperty", data)
        lib.notify({ description = 'Property was created!', type = 'success'})
        self:CancelCreating()
    end,
}

RegisterNUICallback("create:startCreating", function(data, cb)
    CreateProperty:StartCreating()
    cb("ok")
end)

RegisterNUICallback("create:cancelCreating", function(data, cb)
    CreateProperty:CancelCreating()
    cb("ok")
end)

RegisterNUICallback("create:setTextFields", function(data, cb)
    CreateProperty:SetTextFields(data)
    cb("ok")
end)

RegisterNUICallback("create:confirmListing", function(data, cb)
    CreateProperty:CreateProperty()
    cb("ok")
end)

RegisterNUICallback("create:createZone", function(data, cb)
    local type = data.type
    SetNuiFocus(false, false)
    CreateProperty:PlacingZone(type)
    cb("ok")
end)

RegisterNUICallback("create:removeGarage", function(data, cb)
    CreateProperty:RemoveGarage()
    cb("ok")
end)
