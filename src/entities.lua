-- luacheck: ignore i
-- luacheck: globals count
local love = require('love')

local Entities = {}

function Entities.newEntity(x, y, radius, color)
    return {
        x = x or 100,
        y = y or 100,
        radius = radius or 10,
        color = color or {1, 1, 1},

        draw = function (self)
            love.graphics.setColor(self.color)
            love.graphics.circle('fill', self.x, self.y, self.radius)
            love.graphics.setColor(1, 1, 1)
        end
    }
end

Entities.greenEntities = {}
Entities.redEntities = {}

function Entities.createGreenEntity(count)
    local count = 5
    for i = 1, count do
        local greenEntity = Entities.newEntity(
            800 + (i * 50), 200 + (i * 50), 25, {0, 1, 0}
        )
        table.insert(Entities.greenEntities, greenEntity)
    end
end

function Entities.createRedEntity(count)
    local count = 3
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

return Entities