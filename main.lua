--[[
luacheck: globals isMenu
luacheck: globals enableRunning
luacheck: globals isRunning
luacheck: globals enableMenu
luacheck: globals ui_node1_x
luacheck: globals ui_node1_y
luacheck: globals windowCentreX
luacheck: globals windowCentreY
--]]
local love = require "love"

-- imports
local Console = require('src.console')
local Buttons = require('src.buttons')
local inputHandler = require('src.inputHandler')
local Entities = require('src.entities')
local Collision = require('src.lib.collision')

-- globals
windowCentreX = love.graphics.getWidth() / 2
windowCentreY = love.graphics.getHeight() / 2
ui_node1_x = 1078
ui_node1_y = 660

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
    Collision:init(0, 0)
    Console:initialize()
    stateButtons.menu_state = Buttons.createMenuButton(enableRunning, windowCentreX, windowCentreY)
    stateButtons.running_state = Buttons.createRunningButton(enableMenu, ui_node1_x, ui_node1_y)
    inputHandler.setStateButtons(stateButtons)
end

function love.update(dt)
    Collision:update(dt)
    Entities.movement(dt)
    Entities.update(dt)
end

function love.draw()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    if isMenu() then
        Buttons.drawMenuButtons(stateButtons.menu_state, windowCentreX, windowCentreY)
    elseif isRunning() then
        Entities.drawGreenEntities()  -- Draw all green entities
        Entities.drawRedEntities()    -- Draw all red entities
        Collision:draw()
        Console:draw()
        Buttons.drawRunningButtons(stateButtons.running_state)
    end
end

function love.mousepressed(x, y, button)
    inputHandler.mousepressed(x, y, button)
end

function love.keypressed(key)
    inputHandler.keypressed(key)
end