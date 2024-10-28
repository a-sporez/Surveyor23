local love = require('love')
local Entities = require('src.entities')
local Buttons = {}

function Buttons.newButton(text, func, func_param, sprite_path, x, y)
-- Initialize newImage and attach it to sprite_path
    local buttonSprite = love.graphics.newImage(sprite_path)
-- return the table that will define the base methods for buttons
    return {
        width = buttonSprite:getWidth(),
        height = buttonSprite:getHeight(),
        func = func or function() print("no functions attached") end,
        func_param = func_param,
        text = text or "no text",
        button_x = x or 0,
        button_y = y or 0,

-- Function to execute paramereters if mouse is pressed over a button.
        checkPressed = function(self, mouse_x, mouse_y, cursor_radius)
            if (mouse_x + cursor_radius >= self.button_x and
                mouse_x - cursor_radius <= self.button_x + self.width) and
               (mouse_y + cursor_radius >= self.button_y and
                mouse_y - cursor_radius <= self.button_y + self.height) then
                if self.func_param then
                    self.func(self.func_param)
                else
                    self.func()
                end
            end
        end,


        draw = function (self, button_x, button_y)
            self.button_x = button_x or self.button_x
            self.button_y = button_y or self.button_y
-- Draw the background image of the button
            love.graphics.draw(buttonSprite, self.button_x, self.button_y)
-- Calculating text position to print in the centre
            local text_x = self.button_x + (
                self.width - love.graphics.getFont():getWidth(self.text)) / 2
            local text_y = self.button_y + (
                self.height - love.graphics.getFont():getHeight()) / 2
-- Draw the button by first setting color to white and then the text.
            love.graphics.setColor(0, 0, 0)
            love.graphics.print(self.text, text_x, text_y)
-- Reset color to black to draw other stuff
            love.graphics.setColor(1, 1, 1)
        end
    }
end
--[[
TO ADD NEW BUTTONS
Add an entry to the button type you want to create and
multiply the height by the row you want the button to be at in the node
--]]
-- Buttons in the menu phase are created and stored here.
function Buttons.createMenuButton(enableRunning, windowCentreX, windowCentreY)
    local MenuButton = {}
    MenuButton.start_button = Buttons.newButton(
        "PLAY", enableRunning, nil, 'assets/sprites/smallGreenButton.png',
        windowCentreX - 48, windowCentreY - 18
    )
    MenuButton.exit_button = Buttons.newButton(
        "EXIT", love.event.quit, nil, 'assets/sprites/smallGreenButton.png',
        windowCentreX - 48, windowCentreY + 18
    )
    return MenuButton
end

-- Buttons in the running phase are created and stored here.
function Buttons.createRunningButton(enableMenu, ui_node1_x, ui_node1_y)
    local RunningButton = {}
    RunningButton.menu_button = Buttons.newButton(
        "MENU", enableMenu, nil, 'assets/sprites/smallGreenButton.png',
            ui_node1_x, ui_node1_y
        )
    RunningButton.new_red = Buttons.newButton(
        "RED1", function()
            Entities.createRedEntity(1)
        end, nil, 'assets/sprites/smallGreenButton.png',
            ui_node1_x, ui_node1_y + RunningButton.menu_button.height * 2
        )
    RunningButton.new_green = Buttons.newButton(
        "GRN1", function()
            Entities.createGreenEntity(1)
        end, nil, 'assets/sprites/smallGreenButton.png',
            ui_node1_x, ui_node1_y + RunningButton.menu_button.height
        )
    return RunningButton
end

-- Function to draw buttons used in the running interface.
function Buttons.drawRunningButtons(runningButtons)
    runningButtons.menu_button:draw()
    runningButtons.new_green:draw()
    runningButtons.new_red:draw()
end

-- Function to draw all menu buttons
function Buttons.drawMenuButtons(menuButtons, windowCentreX, windowCentreY)
    menuButtons.start_button:draw(windowCentreX - 48, windowCentreY - 18)
    menuButtons.exit_button:draw(windowCentreX - 48, windowCentreY + 18)
end

return Buttons