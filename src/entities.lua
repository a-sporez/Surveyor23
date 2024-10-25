-- luacheck: ignore i count
local love = require('love')

local Entities = {}

function Entities.newEntity(x, y, radius, color)
    return {
        x = x or 100,
        y = y or 100,
        radius = radius or 10,
        color = color or {1, 1, 1},
        selected = false,

-- toggle selection using a not statement
        toggleSelected = function (self)
            self.selected = not self.selected
        end,

        checkPressed = function (self, mouse_x, mouse_y)
            local dx = mouse_x - self.x
            local dy = mouse_y - self.y
            return (dx * dx + dy * dy) <= (self.radius * self.radius)
        end,

        draw = function (self)
            if self.selected then
                love.graphics.setColor(1, 1, 0)
            else
                love.graphics.setColor(self.color)
            end
            love.graphics.circle('fill', self.x, self.y, self.radius)
            love.graphics.setColor(1, 1, 1)
        end
    }
end

Entities.greenEntities = {}
Entities.redEntities = {}

function Entities.createGreenEntity(count)
    local count = count or 5
    for i = 1, count do
        local greenEntity = Entities.newEntity(
            800 + (i * 50), 200 + (i * 50), 25, {0, 1, 0}
        )
        table.insert(Entities.greenEntities, greenEntity)
    end
end

function Entities.createRedEntity(count)
    local count = count or 3
    for i = 1, count do
        local redEntity = Entities.newEntity(
            200 + (i * 50), 600 + (i * 50), 20, {1, 0, 0}
        )
        table.insert(Entities.redEntities, redEntity)
    end
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

function Entities.checkSelection(x, y)
    for _, entity in ipairs(Entities.greenEntities) do
        if entity:checkPressed(x, y) then
            entity:toggleSelected()
        end
    end

    for _, entity in ipairs(Entities.redEntities) do
        if entity:checkPressed(x, y) then
            entity:toggleSelected()
        end
    end

end

return Entities