# Surveyor23
 Do not attempt without professional supervision!!
 I have no idea what I am doing.

*Once again this is a prototype that I am not planning to deploy*
I will try to keep a somewhat coherent journal of the development however code snippets and references will be in the code-journal repository until I have edited, implemented and managed to load them into a fork that I merged here.

## index

[Setup](#setup)

# Source Content

#### Modules

    - Game States
    - Buttons
    - Input Handler
    WIP:
    - Entities base methods

 * TODO:
    - *Entities base methods*
    - Console
    - Animate sprites
        + .
    - Collisions
    - Entity Characteristics
    - Entity Modules
    - Scene switches
    - Settings menu

#### Sprites

    - smallGreenButton.png

 * TODO:
    - Entities
        + .

    - Animations sprite sheets
        + .

#### Sound

 * TODO:
    - Structure

#### Story

 * TODO:
    - Structure

# Setup

[back to index](#index)

### 0.01 fork https://github.com/Asporez/Surveyor23/tree/0.01

I find metatables to be quite confusing, in fact I still find regular tables confusing when adding functions in them... but I still wanna OOP so here goes.

The pattern I want to follow is to have an initial class that returns a table with base function, then create subclasses to be assigned to different game states. It's not a good thing to ahead too much but I'd like to establish the same structure with game scenes but I really have to play around with 1 single scene and get comfortable using this method.

#### main.lua


- **_stateButtons_** stores buttons in tables that are called depending on game state. 

```lua
-- initialize state buttons
local stateButtons = {
    menu_state = {},
    running_state = {}
}
```

- **_program_** is a table that acts as a class which defines the "location" of the user within the program.
- **_state_** is a table that stores the different states as bools, the reasoning behind this structure is to be able to store variables and functions that act on game states as a whole.

```lua
-- program table acts as a class with state as it's subclass
local program = {
    state = {
        menu = true,
        running = false,
    }
}
```

- **_enableMenu()_** and **enableRunning** are functions to switch bools within the program.state table
- **_isMenu()_** and **_isRunning()_** are helper functions to call for states globally and avoid returning a nil value on bools

```lua
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
```

- **_love.load()_** is Love2D's main input on program start
- **_stateButtons.menu_state_** initializes the **_createMenuButtons()_** module and stores it in the menu_state table.
- **_inputHandler.setStateButtons(stateButtons)_** initializes the **_inputHandler_** module.

```lua
function love.load()
    stateButtons.menu_state = Buttons.createMenuButton(enableRunning)
    inputHandler.setStateButtons(stateButtons)
end
```

- Both of those functions pass along the registered input to the **_inputHandler_** module.

```lua
function love.mousepressed(x, y, button)
    inputHandler.mousepressed(x, y, button)
end

function love.keypressed(key)
    inputHandler.keypressed(key)
end
```

- Nothing to update for now since everything is managed through the program states and buttons, still going to put it as it is the entry point of Love2D's core loop.

```lua
function love.update(dt)
    -- body
end
```

- **_love.graphics.setDefaultFilter('nearest', 'nearest')_** enables lossless transformation of images.
- We draw the button here for now, it will be refactored later but I think it's important for me to detail the refactoring to some extent until I feel I have established a good set of methods.
- This is where we use **_isMenu()_** and **_isRunning()_** checks first.

```lua
function love.draw()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    if isMenu() then
        stateButtons.menu_state.start_button:draw(windowCentreX, windowCentreY)
    elseif isRunning() then
        love.graphics.print('splash', windowCentreX, windowCentreY)
    end
end
```

#### src/buttons.lua

This is the method I would like to get comfortable with going forward, when I feel comfortable with it I will move on to metatables for things like dynamic inventories and modular systems.

```lua
local love = require('love')

local Buttons = {}

function Buttons.newButton(text, func, func_param, sprite_path, width, height)
-- use graphics.newImage to declare the usage of sprite_path
    local buttonSprite = love.graphics.newImage(sprite_path)
```

```lua
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
```

```lua
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
```

```lua
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
```

```lua

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
```

```lua
-- Function to set stateButtons from main.lua
function inputHandler.setStateButtons(buttons)
    stateButtons = buttons
end
```

```lua
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