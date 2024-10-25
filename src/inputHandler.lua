-- local love = require('love')
-- luacheck: globals enableMenu
-- luacheck: globals isRunning
-- luacheck: globals isMenu
local inputHandler = {}
local stateButtons = nil  -- Declare stateButtons as nil initially
local Entities = require('src/entities')


local cursor = {
    radius = 2,
    x = 1,
    y = 1
}

-- Function to set stateButtons from main.lua
function inputHandler.setStateButtons(buttons)
    stateButtons = buttons
end

-- Define the new keypressed function
function inputHandler.keypressed(key)
    -- Handle the 'escape' key to quit the game
    if key == 'escape' then
        enableMenu()
    end
end

function inputHandler.mousepressed(x, y, button)
    -- Ensure stateButtons is not nil before using it
    if stateButtons == nil then
        print("Error: stateButtons not initialized")
        return
    end

    if isMenu() then
        if button == 1 then
            for index in pairs(stateButtons.menu_state) do
                stateButtons.menu_state[index]:checkPressed(x, y, cursor.radius)
            end
        end
    elseif isRunning() then
        if button == 1 then
            Entities.checkSelection(x, y)
            for index in pairs(stateButtons.running_state) do
                stateButtons.running_state[index]:checkPressed(x, y, cursor.radius)
            end
        end
    end
end

return inputHandler