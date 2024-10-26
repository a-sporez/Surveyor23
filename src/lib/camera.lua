local love = require('love')

local Camera = {}

function Camera.new()
    local self = {
        x = 0,
        y = 0,
        scale = 1
    }

    function self:move(dx, dy)
        self.x = self.x + dx
        self.y = self.y + dy
    end

    function self:lookAt(x, y)
        self.x = x
        self.y = y
    end
    function self:zoom(scale)
        self.scale = self.scale * scale
    end
    function self:apply()
        love.graphics.push()
        love.graphics.scale(self.scale)
        love.graphics.translate(-self.x, -self.y)
    end
    function self:release()
        love.graphics.pop()
    end
    return self
end
return Camera