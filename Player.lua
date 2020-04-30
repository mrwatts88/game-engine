require 'animation'
Player = Class{}

local GRAVITY = 10
local FRICTION = 10

function Player:init()
    self.animation = animation(love.graphics.newImage('player2.png'), 123, 169, 1)

    self.width = 32
    self.height = 32

    self.initialY = VIRTUAL_HEIGHT - self.height - 16

    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = self.initialY

    self.dx = 0
    self.dy = 0
    self.canDoubleJump = true
end

function Player:update(dt)
    if self.y < self.initialY then
    elseif love.keyboard.isDown("right") then
      self.animation.currentTime = self.animation.currentTime + dt
      self.dx = 50
    elseif love.keyboard.isDown("left") then
      self.animation.currentTime = self.animation.currentTime - dt
      self.dx = -50
    else
      if self.y == self.initialY then
        self.dx = self.dx * .9
        if math.abs(self.dx) < 1 then
          self.dx = 0
        end
      end
    end

    self.x = self.x + self.dx
    
    self.dy = self.dy + GRAVITY * dt

    self.y = self.y + self.dy

    if self.y > self.initialY then
      self.y = self.initialY
      self.dy = 0
      self.canDoubleJump = true
    end

    if love.keyboard.wasPressed("space") then
      if self.dy > 0 and self.canDoubleJump then
        self.dy = self.dy - 8
        self.canDoubleJump = false
      elseif self.dy == 0 then
        self.dy = self.dy - 5
      end
    end

    if self.animation.currentTime >= self.animation.duration then
        self.animation.currentTime = self.animation.currentTime - self.animation.duration
    end

    if self.animation.currentTime < 0 then
        self.animation.currentTime = self.animation.currentTime + self.animation.duration
    end
end

function Player:render()
    if DEV == true then
      love.graphics.push()
      love.graphics.setColor(1,0,0)
      love.graphics.rectangle("fill", VIRTUAL_WIDTH / 2 - (self.width / 2), self.y, self.width, self.height)
      love.graphics.print(tostring(self.dx),0,0)
      love.graphics.pop()
    else
      local spriteNum = math.floor(self.animation.currentTime / self.animation.duration * #self.animation.quads) + 1
      love.graphics.draw(self.animation.spriteSheet, self.animation.quads[spriteNum], self.x, self.y, 0, 0.5, 0.5)
    end
end

function clamp(min, val, max)
    return math.max(min, math.min(val, max));
end
