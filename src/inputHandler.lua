local love = require('love')
-- luacheck: globals isRunning
-- luacheck: globals isMenu
local inputHandler = {}
local stateButtons = nil  -- Declare stateButtons as nil initially
--local Entities = require(src.entities)


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

    -- You can add more key bindings or actions here if needed
    -- Example:
    -- if key == 'space' then
    --     -- Do something when spacebar is pressed
    -- end
end

function inputHandler.mousepressed(x, y, button)
    -- Ensure stateButtons is not nil before using it
    if stateButtons == nil then
        print("Error: stateButtons not initialized")
        return
    end

    if not isRunning() then
        if button == 1 then
            if isMenu() then
                for index in pairs(stateButtons.menu_state) do
                    stateButtons.menu_state[index]:checkPressed(x, y, cursor.radius)
                end
            end
        end
    end
end

return inputHandler