-- luacheck: ignore i count
local love = require('love')

local colors = require('src.lib.colors')
local vector = require('lib.vector')

local Entities = {}
Entities.greenEntities = {}
Entities.redEntities = {}

local function toggleSelected(self)
    self.selected = not self.selected
end

local function checkPressed(self, mouse_x, mouse_y)

    -- Transform the vertices of the polygon to the entity's position and angle
    local transformedVertices = {}
    for _, vertex in ipairs(self.shape) do
        local transformedX = self.pos.x + (vertex[1] * math.cos(self.angle) - vertex[2] * math.sin(self.angle))
        local transformedY = self.pos.y + (vertex[1] * math.sin(self.angle) + vertex[2] * math.cos(self.angle))
        table.insert(transformedVertices, {transformedX, transformedY})
    end

    -- Ray-Casting Algorithm
    local inside = false
    local numVertices = #transformedVertices

    for i = 1, numVertices do
        local v1 = transformedVertices[i]
        local v2 = transformedVertices[i % numVertices + 1]  -- Wrap around to the first vertex

        if ((v1[2] > mouse_y) ~= (v2[2] > mouse_y)) and
           (mouse_x < (v2[1] - v1[1]) * (mouse_y - v1[2]) / (v2[2] - v1[2]) + v1[1]) then
            inside = not inside
        end
    end

    return inside
end

local function moveToTarget(self, dt)
    if self.target then
        -- Check if angle is not nil
        if self.angle == nil then
            print("Error: self.angle is nil!")
            self.angle = 0  -- Assign a default value if necessary
        end

        -- Calculate the distance between self and target
        local direction = (self.target - self.pos):normalized()
        local distance = (self.target - self.pos):len()
        local targetAngle = direction:angleTo(vector(math.cos(self.angle), math.sin(self.angle)))

        -- Rotating smoothly towards the target
        if math.abs(targetAngle) < self.turnSpeed * dt then
            self.angle = self.angle + targetAngle
        else
            self.angle = self.angle + (targetAngle > 0 and 1 or -1) * self.turnSpeed * dt
        end

        -- Adjusting speed based on distance to target
        if distance > 1 then
            self.velocity = math.min(self.velocity + self.fwdThrust * dt, self.maxVelocity)
        else
            self.velocity = math.max(self.velocity - self.rwdThrust * dt, 0)
        end

        -- Moving the entity towards the forward facing direction
        local moveDir = vector(math.cos(self.angle), math.sin(self.angle))
        self.pos = self.pos + moveDir * self.velocity * dt

        -- Stopping if the destination has been reached
        if distance < 1 then
            self.target = nil
            self.velocity = 0
        end
    end
end

function Entities.newEntity(x, y, vertices, color)
    return {
        pos = vector(x or 100, y or 100),
        target = nil,
        color = color or colors.white,
        selected = false,
        velocity = 0,
        fwdThrust = 50,
        rwdThrust = 25,
        maxVelocity = 100,
        turnSpeed = math.rad(90),
        angle = 0,
        targetAngle = 0,
        shape = vertices or {
            {0, -5},
            {5, 5},
            {-5, 5}
        },

        toggleSelected = toggleSelected,
        checkPressed = checkPressed,
        moveToTarget = moveToTarget,

        draw = function(self)
-- Set color based on selection state
            if self.selected then
                love.graphics.setColor(colors.yellow)
            else
                love.graphics.setColor(self.color)
            end

-- Transforming and drawing the polygon
            love.graphics.push()
            love.graphics.translate(self.pos.x, self.pos.y)
            love.graphics.rotate(self.angle)

-- Drawing the polygon using vertices
            local transformedVertices = {}
            for _, vertex in ipairs(self.shape) do
                table.insert(transformedVertices, vertex[1])
                table.insert(transformedVertices, vertex[2])
            end

            love.graphics.polygon("fill", transformedVertices)
            love.graphics.pop()  -- Reset transformations

-- Resetting color after drawing
            love.graphics.setColor(colors.white)
        end
    }
end

function Entities.createGreenEntity(count)
    local count = count or 5
    for i = 1, count do
        local greenEntity = Entities.newEntity(
            800 + (i * 50), 200 + (i * 50),  -- Position
            {{0, 5}, {5, -5}, {-5, -5}},  -- Define the shape here
            colors.green
        )
        greenEntity.name = "greenEntity" .. i
        table.insert(Entities.greenEntities, greenEntity)
    end
end

function Entities.createRedEntity(count)
    local count = count or 3
    for i = 1, count do
        local redEntity = Entities.newEntity(
            800 + (i * 50), 200 + (i * 50),  -- Position
            {{0, 5}, {5, -5}, {-5, -5}},  -- Define the shape here
            colors.red
        )
        redEntity.name = "redEntity" .. i
        table.insert(Entities.redEntities, redEntity)
    end
end

function Entities.movement(dt)
    for _, entity in ipairs(Entities.greenEntities) do
        entity:moveToTarget(dt)
    end
    for _, entity in ipairs(Entities.redEntities) do
        entity:moveToTarget(dt)
    end
end

function Entities.checkSelection(x, y)
    local selected = false
    for _, entity in ipairs(Entities.greenEntities) do
        if entity:checkPressed(x, y) then
            entity:toggleSelected()
            selected = true
        end
    end

    for _, entity in ipairs(Entities.redEntities) do
        if entity:checkPressed(x, y) then
            entity:toggleSelected()
            selected = true
        end
    end

    return selected  -- Returns true if any entity was selected
end

-- Function to draw all green entities
function Entities.drawGreenEntities()
    for _, entity in ipairs(Entities.greenEntities) do
        entity:draw()
    end
end

-- Function to draw all red entities
function Entities.drawRedEntities()
    for _, entity in ipairs(Entities.redEntities) do
        entity:draw()
    end
end

function Entities:deselectAll()
    for _, entity in pairs(self.greenEntities) do
        entity.selected = false
    end
    for _, entity in pairs(self.redEntities) do
        entity.selected = false
    end
end

return Entities