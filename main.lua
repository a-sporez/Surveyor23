--[[
Comments are on top of body.
Manual luacheck on top of file.
 VS Code color schemes:
Alu Dark - Pycharm High Contrast
Ayu Darkvenom
--]]
-- luacheck: ignore dt
-- luacheck: globals isMenu
-- luacheck: globals enableRunning
-- luacheck: globals isRunning
-- luacheck: globals enableMenu
local love = require "love"
-- imports
local Console = require('src.console')
local Buttons = require('src.buttons')
local inputHandler = require('src.inputHandler')
local Entities = require('src.entities')

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
    stateButtons.menu_state = Buttons.createMenuButton(enableRunning)
    stateButtons.running_state = Buttons.createRunningButton(enableMenu)
    inputHandler.setStateButtons(stateButtons)
    Console:initialize()
    Entities.createGreenEntity()
    Entities.createRedEntity()
end

function love.update(dt)
    for _, entity in ipairs(Entities.greenEntities) do
        entity:moveToTarget(dt)
    end
    for _, entity in ipairs(Entities.redEntities) do
        entity:moveToTarget(dt)
    end
end

function love.draw()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    if isMenu() then
        Buttons.drawMenuButtons(stateButtons.menu_state, windowCentreX, windowCentreY)
    elseif isRunning() then
        Console:draw()
        Buttons.drawRunningButtons(stateButtons.running_state, windowCentreX, windowCentreY)
        Entities.drawGreenEntities()  -- Draw all green entities
        Entities.drawRedEntities()    -- Draw all red entities
    end
end

function love.mousepressed(x, y, button)
    inputHandler.mousepressed(x, y, button)
end

function love.keypressed(key)
    inputHandler.keypressed(key)
end