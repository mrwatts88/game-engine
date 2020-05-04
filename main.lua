DEV = true

push = require 'push'
Class = require 'class'

require 'PlayerInputController'  
require 'PlayerRenderer'
require 'Entity'
require 'RigidBody'
require 'CollisionDetector'
require 'CollisionResolver'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

GROUND_HEIGHT = 20

local background = love.graphics.newImage('background.png')
local ground = love.graphics.newImage('ground.png')

local groundScroll = 0
local backgroundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413
local GROUND_LOOPING_POINT = 514


local ground = Entity()
local groundRigidBody = RigidBody(VIRTUAL_WIDTH / 2, GROUND_HEIGHT / 2, VIRTUAL_WIDTH, GROUND_HEIGHT)
groundRigidBody.mass = 1e9
ground:attachRigidBody(groundRigidBody)
ground:attachRenderer(PlayerRenderer())

local player = Entity()
local playerRigidBody = RigidBody(100, groundRigidBody.pos.y + 26, 32, 32, true)
local playerInputController = PlayerInputController()

player:attachRigidBody(playerRigidBody)
player:attachInputController(playerInputController)
player:attachRenderer(PlayerRenderer())

local enemy = Entity()
local enemyRigidBody = RigidBody(300,  groundRigidBody.pos.y + 26, 32, 32, true)
enemy:attachRigidBody(enemyRigidBody)
enemy:attachRenderer(PlayerRenderer())

local entities = { player, enemy, ground }

local collisionDetector = CollisionDetector(entities)
local collisionResolver = CollisionResolver()

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
    -- backgroundScroll = (backgroundScroll + playerRigidBody.vel.x * 9.0 * dt) % BACKGROUND_LOOPING_POINT
    -- groundScroll = (groundScroll + playerRigidBody.vel.x * dt) % GROUND_LOOPING_POINT
    for index, entity in ipairs(entities) do
      if entity.inputController then
        entity.inputController:processInputs(dt)
      end
    end

    for index, entity in ipairs(entities) do
      entity.rigidBody:update(dt)
    end

    local manifolds = collisionDetector:run()
    collisionResolver:run(manifolds)
    
    for index, entity in ipairs(entities) do
      entity.renderer:update(dt)
    end
   
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()
    --love.graphics.draw(background, -backgroundScroll, 0)
    --love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
    love.graphics.clear(1,1,1)

    for index, entity in ipairs(entities) do
      entity.renderer:render()
    end

    push:finish()
end

