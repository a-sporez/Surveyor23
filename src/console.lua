local love = require('love')

local colors = require('src.lib.colors')

local Console = {}

local terminalWidth, terminalHeight = 680, 320
local terminalX = love.graphics.getWidth() - terminalWidth
local terminalY = love.graphics.getHeight() - terminalHeight
Console.config = {
    posX = terminalX + 20,
    posY = terminalY + 32,
    width = terminalWidth - 40,
    height = terminalHeight - 64,
    fontSize = 22,
    backColor = colors.oliveGrey,
    textColor = colors.brown
}

Console.state = {
    active = false,
    input = "",
    output = "",
    cmdHistory = {}
}

function Console:initialize()
    self.terminal_1 = love.graphics.newImage('assets/sprites/terminal_1.png')
    self.font = love.graphics.newFont('assets/fonts/setbackt.ttf', self.config.fontSize)
    love.graphics.setFont(self.font)
end

function Console:addToHistory(line)
    table.insert(self.state.cmdHistory, line)
    if #self.state.cmdHistory > (self.config.height / self.config.fontSize) then
        table.remove(self.state.cmdHistory, 1)
    end
end

function Console:receiveInput(key)
    self.state.input = self.state.input..key
end

function Console:submitInput()
    self:addToHistory(self.state.input)
    self.state.input = ""
end

function Console:draw()
    -- Draw the terminal frame image at terminalX, terminalY
    love.graphics.draw(self.terminal_1, terminalX, terminalY)

    -- Draw the console background rectangle within the terminal frame
    love.graphics.setColor(self.config.backColor)
    love.graphics.rectangle('fill', self.config.posX, self.config.posY, self.config.width, self.config.height)

    -- Reset color for text
    love.graphics.setColor(self.config.textColor)

    -- Print each line of the command history
    for i, line in ipairs(self.state.cmdHistory) do
        -- Adjust starting x and y positions if needed to better align text inside the console rectangle
        love.graphics.print(line, self.config.posX + 10, self.config.posY + (i - 1) * self.config.fontSize)
    end
    love.graphics.print(
        self.state.input, self.config.posX + 10, self.config.posY + self.config.height - self.config.fontSize
    )

    -- Reset to default color
    love.graphics.setColor(1, 1, 1)
end

return Console