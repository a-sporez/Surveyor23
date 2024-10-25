local love = require('love')

local colors = require('src.lib.colors')

local Console = {}

Console.config = {
    width = 638,
    height = 254,
    fontSize = 22,
    backColor = colors.oliveGrey,
    textColor = colors.brown,
    lines = {}
}

function Console:initialize(custom_config)
    if custom_config then
        for key, value in pairs(custom_config) do
            self.config[key] = value
        end
        self.font = love.graphics.newFont('assets/fonts/setbackt.ttf', self.font)
        love.graphics.setFont(self.font)
    end
end

function Console:print(line)
    table.insert(self.config.lines, line)
    if #self.config.lines > (self.config.height / self.config.fontSize) then
        table.remove(self.config.lines, 1)
    end
end

function Console:draw()
    love.graphics.setColor(self.config.backColor)
    love.graphics.rectangle('fill', 0, 0, self.config.width, self.config.height)
    love.graphics.setColor(self.config.textColor)
    for i, line in ipairs(self.config.lines) do
        love.graphics.print(line, 10, (i - 1) * self.config.fontSize)
    end
end

return Console