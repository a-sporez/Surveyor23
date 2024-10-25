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

function Entities.createGreenEntity()
    local greenEntity = Entities.newEntity(800, 200, 25, {0, 1, 0})
    return greenEntity
end

function Entities.createRedEntity()
    local redEntity = Entities.newEntity(200, 800, 20, {1, 0, 0})
    return redEntity
end

return Entities