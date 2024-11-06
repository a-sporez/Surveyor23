local love = require('love')
-- luacheck: globals terminalX
-- luacheck: globals terminalY
local colors = require('src.lib.colors')

local Console = {}
-- Declare the dimensions of the console
local terminalWidth, terminalHeight = 426, 240
terminalX = love.graphics.getWidth() - terminalWidth
terminalY = love.graphics.getHeight() - terminalHeight
-- Declaring the base attributes of the console
Console.config = {
    posX = terminalX + 20,
    posY = terminalY + 32,
    width = terminalWidth - 40,
    height = terminalHeight - 64,
    fontSize = 22,
    backColor = colors.darkGrey,
    textColor = colors.oliveGrey
}

-- This table stores the console input and output as well as history when console is active
Console.state = {
    active = false,
    input = "",
    output = "",
    cmdHistory = {}
}

-- This function loads the module assets and initializes it in love.load.
function Console:initialize()
    self.terminal_1 = love.graphics.newImage('assets/sprites/terminal_1.png')
    self.font = love.graphics.newFont('assets/fonts/setbackt.ttf', self.config.fontSize)
    love.graphics.setFont(self.font)
end

-- This function inserts the submittedInput to the command history table and trims older commands
function Console:addToHistory(line)
    table.insert(self.state.cmdHistory, line)
    if #self.state.cmdHistory > math.floor(self.config.height / self.config.fontSize) then
        table.remove(self.state.cmdHistory, 1)
    end
end

-- Helper function passed to inputHandler to toggle console
function Console:toggleActive()
    self.state.active = not self.state.active
end

-- Helper function to delete input on backspace.
function Console:backspace()
    self.state.input = self.state.input:sub(1, -2)
end

-- This function defines where to store the input passed by inputHandler
function Console:receiveInput(key)
    self.state.input = self.state.input..key
end

-- Processing aliases and splitting them into single commands.
function Console:processCommand(command)
    if string.sub(command, 1, 6) == "alias" then
        local aliasName, fullCommand = string.match(command, "^alias (%S+) (.+)$")
        if aliasName and fullCommand then
            self:addAlias(aliasName, fullCommand)
        elseif command == "alias list" then
            self:listAliases()
        else
            self.state.output = "Usage: alias <alias_name> <command>, alias list"
        end
        return
    end

-- Separating multiple command by semi-colon
    local commands = {}
    for singleCommand in string.gmatch(command, "([^;]+)") do
        table.insert(commands, singleCommand:match("^%s*(.-)%s*$"))
    end
-- Processing single commands and adding them to cmdHistory
    for _, cmd in ipairs(commands) do
        self:processSingleCommand(cmd)
-- STart removing cmdHistory entries after 10 have been submitted.
        if #self.state.cmdHistory > 10 then
            table.remove(self.state.cmdHistory, 1)
        end
    end
end

-- This function passes the submitted input to processCommand
function Console:submitInput()
    print("Submitting input: " .. self.state.input)  -- Debugging print statement
    self:addToHistory(self.state.input)
    self:processCommand(self.state.input)
-- Clear input line after submit
    self.state.input = ""
end

function Console:processSingleCommand(command)
    self.state.output = "Processed command: "..command
end

function Console:addAlias(alias, command)
    self.aliases[alias] = command
    self.state.output = "Alias added: " .. alias .. " -> " .. command
end

function Console:listAliases()
    self.state.output = "Aliases:\n"
    for alias, command in pairs(self.aliases) do
        self.state.output = self.state.output .. alias .. " -> " .. command .. "\n"
    end
end

function Console:draw()
-- Draw the terminal frame image at terminalX, terminalY
    love.graphics.draw(self.terminal_1, terminalX, terminalY)

-- Draw the console background rectangle within the terminal frame
    love.graphics.setColor(self.config.backColor)
    love.graphics.rectangle(
        'fill', self.config.posX, self.config.posY, self.config.width, self.config.height
    )

-- Reset color for text
    love.graphics.setColor(self.config.textColor)

-- Print each line of the command history
    local maxLines = math.floor(self.config.height / self.config.fontSize) - 1
    for i = 1, math.min(#self.state.cmdHistory, maxLines) do
        local line = self.state.cmdHistory[i]
        love.graphics.print(
            line, self.config.posX + 4, self.config.posY + (i - 1) * self.config.fontSize
        )
    end
    love.graphics.print(
        self.state.input, self.config.posX + 10, self.config.posY + self.config.height - self.config.fontSize
    )

-- Reset to default color
    love.graphics.setColor(1, 1, 1)
end

return Console