# Surveyor23
 Do not attempt without professional supervision.
 **_I have no idea what I am doing!!_**

*This is not a tutorial but it is not a prototype either, I guess I could call it a workshop... or what if I call it a surveyor and imagine that it's actually a spaceship?*

I will try to keep a somewhat coherent journal of the development however code snippets and references will be in the code-journal repository until I have edited, implemented and managed to load them into a fork that I merged here.

The snippets I put here are not the same as what is in the main branch, they are to demonstrate the logic behind methods and also it helps me think when I'm stuck to come back here and explain/remember the snippets at that point in time during the process of adding methods.

**_With that said, I will fork the state of development it is at when I do put snippets in this README and they will be numered like this: "0.01a" as I will reserve 0.1 milestone when it becomes somewhat functional enough for me to enjoy playing it, if it isn't enjoyable I wouldn't want to go further than this milestone and I'll refactor until it is_**

## index

[Setup](#setup)

# Source Content

#### Modules

    - Game States
    - Buttons
    - Input Handler
    WIP:
    - Entities base methods
        + Flesh out base entities
        + Create Surveyor base method
    - Console

 * TODO:

    - Animate sprites
        + .
    - Collisions

    - Entity Modules
        + Surveyor
            * Systems
            * Life Support
            * Weapons
        + Drones
            * Systems
            * Weapons
        + Shuttles/Fighters
            * Systems
            * Life Support
            * Weapons
    - Resources
        + Fuel
            * Solid (single use devices and engine)
            * Liquid/Ox standard (reusable tank and engine)
        + Supplies
            * Life Support
            * Weapons Ordnance
            * Tech Supplies
            * Admin Supplies
    - Extraction
    - Transformation
    - Manufacturing
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
local stateButtons = {
    menu_state = {},
    running_state = {}
}
```

- **_program_** is a table that acts as a class which defines the "location" of the user within the program.
- **_state_** is a table that stores the different states as bools, the reasoning behind this structure is to be able to store variables and functions that act on game states as a whole.

```lua
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
function enableRunning()
    program.state['menu'] = false
    program.state['running'] = true
end
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

Let's break down this method because it is a neat one that I intend to use a lot.
First we set a table on top of the file where the Buttons will be stored then we create a constructor function with the parameters that are to be passed when calling the base method.

```lua
local love = require('love')
local Buttons = {}
function Buttons.newButton(text, func, func_param, sprite_path, width, height)
```

Here I am storing the image to be the one provided with sprite_path parameter.

```lua
    local buttonSprite = love.graphics.newImage(sprite_path)
```

This methods is basically Object Oriented Programming for Dummies... or something like that. It returns a table containing the functions that define the base methods.
The first array of values are the static parameters.

```lua
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

once those are declared I make a function to initiate the buttons function when mouse is pressed on it.

```lua
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

Here I define the method to draw the button and place text on it.

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

Finally this is the factory function where I "design" the butonns and assign them the parameters to use the methods I just set up.

```lua
function Buttons.createMenuButton(enableRunning)
    local MenuButton = {}
    MenuButton.start_button = Buttons.newButton("Start", enableRunning, nil, 'assets/sprites/smallGreenButton.png', 96, 36)

    return MenuButton
end
return Buttons
```

*NOTE: It's critical to return the table for any of this stuff to work*

src/inputHandler.lua

This module will govern the logic of keyboard and mouse input.
Because the buttons are initialized depending on their game state, I declare the table where they will be stored to return nil.
Then I create a table to define the area around the mouse that will be the cursor, in this case 1 pixel.

```lua
local inputHandler = {}
local stateButtons = nil  -- Declare stateButtons as nil initially
local cursor = {
    radius = 1,
    x = 1,
    y = 1
}
```

This is a helper function to pass the local scope "buttons" to the global scope "stateButtons" since it will essentially be a coroutine in the main file.

```lua
function inputHandler.setStateButtons(buttons)
    stateButtons = buttons
end
```

This is the function to register mouse clicks, it is pretty straight forward, do an if loop with the helper function that returns game state, button, etc...

```lua
function inputHandler.mousepressed(x, y, button)
    if stateButtons == nil then -- Ensure stateButtons is not nil before using it
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

[back to index](#index)

# Adding Modules

I start by adding buttons, one to exit the game and the other to return to menu.

```lua
function Buttons.drawRunningButtons(runningButtons, windowCentreX, windowCentreY)
    runningButtons.menu_button:draw(windowCentreX - 48, windowCentreY + 36, 20, 10)
end
function Buttons.drawMenuButtons(menuButtons, windowCentreX, windowCentreY)
    menuButtons.start_button:draw(windowCentreX - 48, windowCentreY - 18, 20, 10)
    menuButtons.exit_button:draw(windowCentreX - 48, windowCentreY + 18, 20, 10)
end
```

