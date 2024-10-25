# Surveyor23
 Do not attempt without professional supervision!!
 I have no idea what I am doing.

*Once again this is a prototype that I am not planning to deploy*
I will try to keep a somewhat coherent journal of the development however code snippets and references will be in the code-journal repository until I have edited, implemented and managed to load them into a fork that I merged here.

## index

[Setup](#setup)

# Source Content

#### Modules

 * DONE:
    - Game States
    - Buttons
    - Input Handler

 * TODO:
    - Entities
    - Console
    - Animate sprites
    - Collisions
    - Entity Characteristics
    - Entity Modules
    - Scene switches
    - Settings menu

#### Sprites

 * TODO:
    - Structure

#### Sound

 * TODO:
    - Structure

#### Story

 * TODO:
    - Structure

# Setup

I find metatables to be quite confusing, in fact I still find regular tables confusing when adding functions in them... but I still wanna OOP so here goes.

The pattern I want to follow is to have an initial class that returns a table with base function, then create subclasses to be assigned to different game states. It's not a good thing to ahead too much but I'd like to establish the same structure with game scenes but I really have to play around with 1 single scene and get comfortable using this method.

The initial setup already implements one of the constructor functions inside of the Buttons class.

main.lua

```lua
local love = require('love')
-- imports
local Buttons = require('src.buttons')
local inputHandler = require('src.inputHandler')
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

function love.mousepressed(x, y, button, istouch, presses)
    inputHandler.mousepressed(x, y, button, istouch, presses)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)
    -- change some values based on your actions

end

function love.draw()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    if isMenu() then
        stateButtons.menu_state.start_button:draw(windowCentreX, windowCentreY)
    elseif isRunning() then
        love.graphics.print('splash', windowCentreX, windowCentreY)
    end
end
```

src/buttons.lua

```lua
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
```

src/inputHandler.lua

```lua
local inputHandler = {}
local stateButtons = nil  -- Declare stateButtons as nil initially

local cursor = {
    radius = 2,
    x = 1,
    y = 1
}

-- Function to set stateButtons from main.lua
function inputHandler.setStateButtons(buttons)
    stateButtons = buttons
end

function inputHandler.mousepressed(x, y, button, istouch, presses)
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
```

It probably takes a seasoned programmer a few minutes to cook this code up, it took me about two weeks. xD