require 'animation'
Player = Class{}

local GRAVITY = 20

function Player:init()
    -- self.image = love.graphics.newImage('player.png')
    self.animation = animation(love.graphics.newImage('player.png'), 123, 169, 1)

    self.width = 123
    self.height = 169

    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    self.dx = 0
    self.ddx = 0
end

function Player:update(dt)
    self.dx = self.dx + self.ddx * dt
    self.x = self.x + self.dx

    if love.keyboard.isDown("right") then
      self.animation.currentTime = self.animation.currentTime + dt
    end
    if love.keyboard.isDown("left") then
      self.animation.currentTime = self.animation.currentTime - dt
    end


    if self.animation.currentTime >= self.animation.duration then
        self.animation.currentTime = self.animation.currentTime - self.animation.duration
    end

    if self.animation.currentTime < 0 then
        self.animation.currentTime = self.animation.currentTime + self.animation.duration
    end
end

function Player:render()
    local spriteNum = math.floor(self.animation.currentTime / self.animation.duration * #self.animation.quads) + 1
    love.graphics.draw(self.animation.spriteSheet, self.animation.quads[spriteNum], self.x, self.y)
end
