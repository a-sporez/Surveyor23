-- local love = require('love')
-- luacheck: globals enableMenu
-- luacheck: globals isRunning
-- luacheck: globals isMenu
local inputHandler = {}
-- Declare stateButtons as nil initially
local stateButtons = nil
local Entities = require('src.entities')
local Console = require('src.console')

-- Table to store the mouse cursor position.
local cursor = {
    radius = 1,
    x = 1,
    y = 1
}

-- Function to initialize stateButtons from main.lua
function inputHandler.setStateButtons(buttons)
    stateButtons = buttons
end

-- Define the keypressed functions
function inputHandler.keypressed(key)
-- Verifying program state from main.lua
    if isRunning() then
        if key == 'tab' then
-- Initializing the console
            Console:toggleActive()
-- Escape key while the game is running exits to menu
        elseif key == 'escape' then
            enableMenu()
-- Passing the input to process command to console with debug print statement
        elseif Console.state.active and key == 'return' then
            print("Enter pressed")
            Console:submitInput()
        elseif Console.state.active then
-- Passing the backspace input to remove characters to console
            if key == 'backspace' then
                Console:backspace()
--[[ Only process printable characters.
TODO: this is a workaround to avoid registering the key functions "shift, ctrl..."
I have to find out how to register fn keys without printing.
--]]
            elseif #key == 1 then
                Console:receiveInput(key)
            end
        end
    end
end

function inputHandler.mousepressed(x, y, button)
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
            local clickedEntity = Entities.checkSelection(x, y)

            if not clickedEntity then
-- Deselect all entities if no entity was clicked
                Entities:deselectAll()
            end

            for index in pairs(stateButtons.running_state) do
                stateButtons.running_state[index]:checkPressed(x, y, cursor.radius)
            end
        elseif button == 2 then
            for _, entity in ipairs(Entities.greenEntities) do
                if entity.selected then
                    entity.target = {x = x, y = y}
                end
            end
            for _, entity in ipairs(Entities.redEntities) do
                if entity.selected then
                    entity.target = {x = x, y = y}
                end
            end
        end
    end
end

return inputHandler