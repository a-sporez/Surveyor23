--[[
Comments are on top of body.
Manual luacheck on top of file.
Ayu Darkvenom VS Code color scheme.
--]]
-- luacheck: globals isMenu
-- luacheck: ignore dt
-- luacheck: globals enableRunning
-- luacheck: globals isRunning
-- luacheck: globals enableMenu
local love = require "love"
-- imports
local Buttons = require('src/buttons')
local inputHandler = require('src/inputHandler')
--local Entities = require('src/entities')

-- stored values
local windowCentreX = love.graphics.getWidth() / 2
local windowCentreY = love.graphics.getHeight() / 2

-- initialize and store state buttons
local stateButtons = {
    menu_state = {},
    running_state = {}
}

-- program table acts as a class with state as it's subclass
local program = {
    state = {
        menu = true,
        running = false,
    }
}

function enableMenu()
    program.state['menu'] = true
    program.state['running'] = false
end

function isMenu()
    return program.state['menu']
end

-- helper function to switch to running program state
function enableRunning()
    program.state['menu'] = false
    program.state['running'] = true
end

-- helper function for state checks
function isRunning()
    return program.state['running']
end

function love.load()
-- The following lines assign "classes" to tables to act as objects.
    stateButtons.menu_state = Buttons.createMenuButton(enableRunning)
    stateButtons.running_state = Buttons.createRunningButton(enableMenu)
    inputHandler.setStateButtons(stateButtons)
end

function love.update(dt)
    -- change some values based on your actions

end

function love.draw()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    if isMenu() then
        Buttons.drawMenuButtons(stateButtons.menu_state, windowCentreX, windowCentreY)
    elseif isRunning() then
        Buttons.drawRunningButtons(stateButtons.running_state, windowCentreX, windowCentreY)
    end
end

function love.mousepressed(x, y, button)
    inputHandler.mousepressed(x, y, button)
end

function love.keypressed(key)
    inputHandler.keypressed(key)
end