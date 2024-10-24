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

-- initialize state buttons
local stateButtons = {
    menu_state = {}
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
    stateButtons.menu_state = Buttons.createMenuButton(enableRunning)
    inputHandler.setStateButtons(stateButtons)
end

function love.update(dt)
    -- change some values based on your actions

end

function love.draw()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    if isMenu() then
        stateButtons.menu_state.start_button:draw(windowCentreX - 48, windowCentreY - 18, 20, 10)
        stateButtons.menu_state.exit_button:draw(windowCentreX - 48, windowCentreY + 18, 20, 10)
    elseif isRunning() then
        love.graphics.print('splash', windowCentreX, windowCentreY)
    end
end

function love.mousepressed(x, y, button)
    inputHandler.mousepressed(x, y, button)
end

function love.keypressed(key)
    inputHandler.keypressed(key)
end