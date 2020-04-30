DEV = true

push = require 'push'
Class = require 'class'
require 'Player'  
require 'RigidBody'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- background image and starting scroll location (X axis)
local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

-- ground image and starting scroll location (X axis)
local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

-- speed at which we should scroll our images, scaled by dt
local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

-- point at which we should loop our background back to X 0
local BACKGROUND_LOOPING_POINT = 413

-- point at which we should loop our ground back to X 0
local GROUND_LOOPING_POINT = 514

local playerRigidBody = RigidBody(100, VIRTUAL_HEIGHT - 32, 32, 32)
local player = Player(playerRigidBody)

function love.load()
    -- love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Running Man')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
    
    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    -- scroll background by preset speed * dt, looping back to 0 after the looping point
    backgroundScroll = (backgroundScroll + playerRigidBody.xv * 9.0 * dt) 
        % BACKGROUND_LOOPING_POINT

    -- scroll ground by preset speed * dt, looping back to 0 after the screen width passes
    groundScroll = (groundScroll + playerRigidBody.xv * dt) 
        % GROUND_LOOPING_POINT

    playerRigidBody:update(dt)
    player:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    --love.graphics.draw(background, -backgroundScroll, 0)
    --love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
    love.graphics.clear(1,1,1)
    player:render()
    push:finish()
end
