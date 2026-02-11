local glm = require 'glm'
local Freecam = exports['fivem-freecam']

local DEBUG_COLOUR = {r = 255, g = 0, b = 0, a = 150}
local DEFAULT_HEIGHT = 5
local CURSOR_COLOUR = {r = 0, g = 255, b = 0, a = 255}
local CURSOR_DELETE_COLOUR = {r = 255, g = 0, b = 0, a = 255}
local MAX_CURSOR_DISTANCE = 10
local POINTS_PADDING = 0.25

local zoneCreator = {
    active = false,
    polygon = {},
    height = DEFAULT_HEIGHT,

    deleteIndex = nil,
    cursor = nil,
    camPosition = nil,
    camRotation = nil,

    highestPoint = nil,
    lowestPoint = nil
}

local polyText = '[C] - +/- point  \n [H] finish  \n [Scroll] change height \n [K] Edit Point'

local function render()
    local points = zoneCreator.polygon

    local DrawLine, IsDisabledControlJustPressed, vec3 = DrawLine, IsDisabledControlJustPressed, vec3

    while zoneCreator.active do
        Wait(0)

        zoneCreator.cursor = zoneCreator.drawCursor()
        local height =  #points > 0 and points[1].z + zoneCreator.height or 0

        if zoneCreator.highestPoint and #points > 0 then
            height = zoneCreator.highestPoint.z + zoneCreator.height
        end

        for i = 1, #points do
            local point = points[i]
            local thickness = vec3(0, 0, zoneCreator.height / 2)
            local a = point + thickness
            local b = point
            local c = (points[i + 1] or points[1]) + thickness
            local d = (points[i + 1] or points[1])
            local isYellow = zoneCreator.editIndex == i
            DrawLine(a.x, a.y, height, b.x, b.y, b.z, DEBUG_COLOUR.r,  isYellow and 255 or DEBUG_COLOUR.g,  DEBUG_COLOUR.b,  255)
            DrawLine(a.x, a.y, height, c.x, c.y, height, DEBUG_COLOUR.r,  isYellow and 255 or DEBUG_COLOUR.g,  DEBUG_COLOUR.b,  255)
            DrawLine(b.x, b.y, b.z, d.x, d.y, d.z, DEBUG_COLOUR.r,  isYellow and 255 or DEBUG_COLOUR.g,  DEBUG_COLOUR.b,  255)
            DrawPoly(a.x, a.y, height, b.x, b.y, b.z, c.x, c.y, height, DEBUG_COLOUR.r,  DEBUG_COLOUR.g,  DEBUG_COLOUR.b,  DEBUG_COLOUR.a)
            DrawPoly(c.x, c.y, height, b.x, b.y, b.z, a.x, a.y, height, DEBUG_COLOUR.r,  DEBUG_COLOUR.g,  DEBUG_COLOUR.b,  DEBUG_COLOUR.a)
            DrawPoly(b.x, b.y, b.z, c.x, c.y, height, d.x, d.y, d.z, DEBUG_COLOUR.r,  DEBUG_COLOUR.g,  DEBUG_COLOUR.b,  DEBUG_COLOUR.a)
            DrawPoly(d.x, d.y, d.z, c.x, c.y, height, b.x, b.y, b.z, DEBUG_COLOUR.r,  DEBUG_COLOUR.g,  DEBUG_COLOUR.b,  DEBUG_COLOUR.a)
        end

        if IsDisabledControlJustPressed(0, 14) then -- H
            zoneCreator.height -= 0.5
        end

        if IsDisabledControlJustPressed(0, 15) then -- H
            zoneCreator.height += 0.5
        end

        if IsDisabledControlJustPressed(0, 104) then -- H
            zoneCreator.destroy()
            SetHide(false)
            return {points = points, thickness = zoneCreator.height}
        end

        if IsDisabledControlJustPressed(0, 306) and zoneCreator.editIndex then -- N
            zoneCreator.editIndex = nil
            lib.hideTextUI()
            lib.showTextUI(polyText)
        end
    end
end

function zoneCreator.destroy()
    zoneCreator.active = false
    zoneCreator.freecamMode(false)
end

function zoneCreator.addPoint(point)
    if zoneCreator.editIndex then
        zoneCreator.polygon[zoneCreator.editIndex] = point
    else
        table.insert(zoneCreator.polygon, point)
    end

    if not zoneCreator.lowestPoint or not zoneCreator.highestPoint then
        zoneCreator.lowestPoint = point
        zoneCreator.highestPoint = point
        return
    end

    zoneCreator.lowestPoint = point.z < zoneCreator.lowestPoint.z and point or zoneCreator.lowestPoint
    zoneCreator.highestPoint = point.z > zoneCreator.highestPoint.z and point or zoneCreator.highestPoint
end

function zoneCreator.editPoint()
    if zoneCreator.editIndex and zoneCreator.cursor then
        zoneCreator.addPoint(zoneCreator.cursor)
        zoneCreator.editIndex = nil
        lib.hideTextUI()
        lib.showTextUI(polyText)
        return
    end

    if zoneCreator.deleteIndex then
        zoneCreator.editIndex = zoneCreator.deleteIndex

        lib.hideTextUI()
        lib.showTextUI('[K] - Set Point \n [N] - Cancel Set')
    else
        lib.notify({ description = 'Need to be close to a point', type = 'error' })
    end
end

function zoneCreator.removePoint()
    if not zoneCreator.deleteIndex then return end

    local deletedPoint = zoneCreator.polygon[zoneCreator.deleteIndex]
    
    local function updateExtremePoint(comparator, currentExtreme)
        if not currentExtreme or deletedPoint.z == currentExtreme.z then
            local newExtreme = nil
            for i = 1, #zoneCreator.polygon do
                if i ~= zoneCreator.deleteIndex then
                    if not newExtreme or comparator(zoneCreator.polygon[i].z, newExtreme.z) then
                        newExtreme = zoneCreator.polygon[i]
                    end
                end
            end
            return newExtreme
        end
        return currentExtreme
    end

    zoneCreator.highestPoint = updateExtremePoint(function(a, b) return a > b end, zoneCreator.highestPoint)
    zoneCreator.lowestPoint = updateExtremePoint(function(a, b) return a < b end, zoneCreator.lowestPoint)

    table.remove(zoneCreator.polygon, zoneCreator.deleteIndex)

    -- If we've removed all points, reset highest and lowest points
    if #zoneCreator.polygon == 0 then
        zoneCreator.highestPoint = nil
        zoneCreator.lowestPoint = nil
    end
end

local function tooCloseToExistingPoint(point)
    local points = zoneCreator.polygon
    for i = 1, #points do
        local checkPoint = points[i]
        if glm.distance(point, checkPoint) < POINTS_PADDING then
            return true, i
        end
    end
    return false, nil
end

local function rayCastGamePlayCamera(distance)
    local cameraRotation = zoneCreator.camRotation
	local cameraCoord = zoneCreator.camPosition
	local direction = RotationToDirection(cameraRotation)
	local destination =
	{
		x = cameraCoord.x + direction.x * distance,
		y = cameraCoord.y + direction.y * distance,
		z = cameraCoord.z + direction.z * distance
	}
	local _, hit, endCoords, _, _ = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1,  0))
	return hit, endCoords
end

function RotationToDirection(rotation)
	local adjustedRotation =
	{
		x = (math.pi / 180) * rotation.x,
		y = (math.pi / 180) * rotation.y,
		z = (math.pi / 180) * rotation.z
	}
	local direction =
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		z = math.sin(adjustedRotation.x)
	}
	return direction
end


function zoneCreator.drawCursor()
    zoneCreator.camPosition = Freecam:GetPosition()
    zoneCreator.camRotation = Freecam:GetRotation()
    local hit, coords = rayCastGamePlayCamera(MAX_CURSOR_DISTANCE)

    if hit then
        local color = CURSOR_COLOUR

        local tooClose, existingIndex = tooCloseToExistingPoint(coords)
        if tooClose then
            zoneCreator.cursor = coords
            zoneCreator.deleteIndex = existingIndex
            color = CURSOR_DELETE_COLOUR
        else
            zoneCreator.deleteIndex = nil
        end

        local position = zoneCreator.camPosition

        DrawLine(position.x, position.y, position.z, coords.x, coords.y, coords.z, color.r, color.g, color.b, color.a)
        DrawMarker(28, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.1, 0.1, 0.1, color.r, color.g, color.b, color.a, false, true, 2, nil, nil, false)
    end

    return hit and coords or nil
end


function zoneCreator.freecamMode(bool)
    if bool then
        Freecam:SetActive(true)
        Freecam:SetKeyboardSetting('BASE_MOVE_MULTIPLIER', 0.1)
        Freecam:SetKeyboardSetting('FAST_MOVE_MULTIPLIER', 2)
        Freecam:SetKeyboardSetting('SLOW_MOVE_MULTIPLIER', 2)
        Freecam:SetFov(45.0)
    else
        Freecam:SetActive(false)
        Freecam:SetKeyboardSetting('BASE_MOVE_MULTIPLIER', 5)
        Freecam:SetKeyboardSetting('FAST_MOVE_MULTIPLIER', 10)
        Freecam:SetKeyboardSetting('SLOW_MOVE_MULTIPLIER', 10)
    end
end

local function usePoint()
    if not zoneCreator.active then return end
    if not zoneCreator.cursor then return end

    if zoneCreator.deleteIndex then
        zoneCreator.removePoint()
    else
        zoneCreator.addPoint(zoneCreator.cursor)
    end
end
RegisterCommand('+usePoint', usePoint, false)
RegisterCommand('-usePoint', usePoint, false)
RegisterKeyMapping('+usePoint', 'Add/Remove Point', 'keyboard', 'c')

local function editPoint()
    if not zoneCreator.active then return end
    if not zoneCreator.cursor then return end

    zoneCreator.editPoint()
end
RegisterCommand('+editPoint', editPoint, false)
RegisterCommand('-editPoint', editPoint, false)
RegisterKeyMapping('+editPoint', 'edit Point', 'keyboard', 'k')

local function polyCreator()
    zoneCreator.freecamMode(false)
    Wait(100)

    lib.showTextUI(polyText)
    zoneCreator.active = true
    zoneCreator.polygon = {}
    zoneCreator.thickness = DEFAULT_HEIGHT
    zoneCreator.freecamMode(true)
    local result = render()
    lib.hideTextUI()
    return #result.points > 2 and result
end

local function mloDoor()
	local lastEntity = 0
    local doubleDoors = false
    local data

    lib.showTextUI('[E] - to add door | [h] cancel')

    while true do
        local hit, entity, coords = lib.raycast.cam(1|16)
        local changedEntity = lastEntity ~= entity

        if lastEntity ~= 0 and changedEntity then
            SetEntityDrawOutline(lastEntity, false)
        end

        lastEntity = entity

        if hit then
            DrawMarker(28, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.2, 255, 42, 24, 100, false, false, 0, true, false, false, false)

            if changedEntity then
				SetEntityDrawOutline(entity, true)
			end

            if IsDisabledControlJustPressed(0, 38) and entity > 0 and GetEntityType(entity) == 3 then
                if GetResourceState('ox_doorlock') == 'started' then
                    if not lib.checkDependency('ox_doorlock', '1.16.0') then
                        lib.notify({ description = 'Need ox_doorlock v1.16.0>', type = 'error' })
                        return
                    end

                    if exports.ox_doorlock:getDoorIdFromEntity(entity) then
                        lib.notify({ description = 'This door already registered in ox_doorlock', type = 'error' })
                    end
                end

                if lastEntity then
                    SetEntityDrawOutline(lastEntity, false)
                end

                local alert = not doubleDoors and lib.alertDialog({
                    header = 'Double Doors?',
                    content = 'Confirm if MLO has 2 doors',
                    centered = true,
                    cancel = true
                })

                local door = {
                    maxDistance = 2.5,
                    model = GetEntityModel(entity),
                    coords = GetEntityCoords(entity),
                    heading = math.floor(GetEntityHeading(entity) + 0.5),
                    name = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z)),
                }

                if doubleDoors and #(door.coords - data.coords) <= 0 then
                    lib.notify({ description = 'Select another door, you already selected this as first door!', type = 'error' })
                else
                    data = doubleDoors and {
                        data,
                        door
                    } or door

                    if not alert or alert == 'cancel' then
                        SetHide(false)
                        break
                    else
                        doubleDoors = true
                    end
                end
			end


			if IsDisabledControlJustPressed(0, 104) then -- H
                if lastEntity then
                    SetEntityDrawOutline(lastEntity, false)
                end
                SetHide(false)
				break
            end
        end
    end
    lib.hideTextUI()
    return data
end


return {
    mloDoor = mloDoor,
    polyCreator = polyCreator
}
