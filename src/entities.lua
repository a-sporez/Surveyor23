local love = require('love')

local Entities = {}

function Entities.newEntity(x, y, width, height, speed)
    return {
        x = x or 100,
        y = y or 100,
        width = width or 32,
        height = height or 32,
        speed = speed or 10,
        selected = false,
        destination = {x = x, y = y},

-- declare the base methods for Entities
    update = function (self, dt)
        if self.x ~= self.destination.x or self.y ~= self.destination.y then
            local dx = self.destination.x - self.x
            local dy = self.destination.y - self.y
            local dist = math.sqrt(dx + dx * dy + dy)

            if dist > 1 then
                local dirX = dx / dist
                local dirY = dy / dist
                self.x = self.x + dirX * self.speed * dt
                self.y = self.y + dirY * self.speed * dt
            end
        end
    end,

    draw = function (self)
        if self.selected then
            love.graphics.setColor(0, 1, 0)
        else
            love.graphics.setColor(1, 1, 1)
        end
        love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    end
    }
end

function Entities.newPlayer(x, y)
    local player = Entities.newEntity(x, y, 24, 24)
-- player specific propertuies
    player.isPlayer = true
    player.speed = 20

-- Override the draw method for the player to show selection state
    player.draw = function(self)
        if self.selected then
            love.graphics.setColor(0, 1, 0)  -- Green if selected
        else
            love.graphics.setColor(1, 1, 1)  -- White otherwise
        end

-- Draw the player's rectangle
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
        love.graphics.setColor(1, 1, 1)  -- Reset color
    end

    return player
end

return Entities