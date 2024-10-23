local love = require('love')

local Buttons = {}

function Buttons.newButton(text, func, func_param, sprite_path, width, height)
-- use graphics.newImage to declare the usage of sprite_path
    local buttonSprite = love.graphics.newImage(sprite_path)

-- return the table that will define the methods for buttons
    return {
        width = width or 20,
        height = height or 20,
        func = func or function() print("no functions attached") end,
        func_param = func_param,
        text = text or "no text",
        button_x = 0,
        button_y = 0,
        text_x = 0,
        text_y = 0,

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


        draw = function (self, button_x, button_y, text_x, text_y)
            self.button_x = button_x or self.button_x
            self.button_y = button_y or self.button_y
            if text_x then
                self.text_x = text_x + self.button_x
            else
                self.text_x = self.button_x
            end

            if text_y then
                self.text_y = text_y + self.button_y
            else
                self.text_y = self.button_y
            end

            -- Draw the button image
            love.graphics.draw(buttonSprite, self.button_x, self.button_y)
            -- Draw the button text
            love.graphics.setColor(0, 0, 0)
            love.graphics.print(self.text, self.text_x, self.text_y)
            -- Reset color
            love.graphics.setColor(1, 1, 1)
        end
    }

end

function Buttons.createMenuButton(enableRunning)
    local MenuButton = {}
    MenuButton.start_button = Buttons.newButton("Start", enableRunning, nil, 'assets/sprites/smallGreenButton.png', 96, 36)

    return MenuButton
end

return Buttons