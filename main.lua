DEV = true

push = require 'push'
Class = require 'class'
require 'Player'  
require 'RigidBody'
require 'CollisionDetector'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

GROUND_HEIGHT = 20

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

local groundRigidBody = RigidBody(VIRTUAL_WIDTH / 2, GROUND_HEIGHT / 2, VIRTUAL_WIDTH, GROUND_HEIGHT)
groundRigidBody.mass = 1e9
local playerRigidBody = RigidBody(100, groundRigidBody.pos.y + 26, 32, 32, true)
local enemyRigidBody = RigidBody(300,  groundRigidBody.pos.y + 26, 32, 32, true)
local player = Player(playerRigidBody, 'player')
local enemy = Player(enemyRigidBody)
local ground = Player(groundRigidBody)

--local rigidBodies = { playerRigidBody, groundRigidBody }
local rigidBodies = { playerRigidBody, enemyRigidBody, groundRigidBody }
-- local renderedBodies = {player, ground }
local renderedBodies = {player, enemy, ground }
local collisionDetector = CollisionDetector(rigidBodies)

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
    backgroundScroll = (backgroundScroll + playerRigidBody.vel.x * 9.0 * dt) % BACKGROUND_LOOPING_POINT
    groundScroll = (groundScroll + playerRigidBody.vel.x * dt) % GROUND_LOOPING_POINT

    for index, rigidBody in ipairs(rigidBodies) do
      rigidBody:update(dt)
    end

    collisionDetector:run()

    for index, renderedBody in ipairs(renderedBodies) do
      renderedBody:update(dt)
    end

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    --love.graphics.draw(background, -backgroundScroll, 0)
    --love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
    love.graphics.clear(1,1,1)

    for index, renderedBody in ipairs(renderedBodies) do
      renderedBody:render()
    end

    push:finish()
end

