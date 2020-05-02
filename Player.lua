require 'animation'
require 'Vector'

Player = Class{}

function Player:init(rigidBody)
    self.animation = animation(love.graphics.newImage('player2.png'), 123, 169, 1)
    self.rigidBody = rigidBody

    -- todo add isAirborne to RigidBody class
    self.ground = VIRTUAL_HEIGHT - self.rigidBody.height - 16
    self.canDoubleJump = true
end

function Player:update(dt)
    if self.rigidBody.pos.y < self.ground then
      -- is airborne
    elseif love.keyboard.isDown("right") then
      self.animation.currentTime = self.animation.currentTime + dt
      self.rigidBody:applyForce(Vector(4000, 0), dt)
    elseif love.keyboard.isDown("left") then
      self.animation.currentTime = self.animation.currentTime - dt
      self.rigidBody:applyForce(Vector(-4000, 0), dt)
    else
      if self.rigidBody.pos.y >= self.ground then
        self.rigidBody:applyForce(Vector(-3.5*self.rigidBody.vel.x, 0), dt)
        -- todo apply friction force in rigid body class whenever colliding
      end
    end

    if self.rigidBody.pos.y >= self.ground then
      self.canDoubleJump = true
    end

    if love.keyboard.wasPressed("space") then
      if self.rigidBody.vel.y > 0 and self.canDoubleJump then
        self.rigidBody:applyForce(Vector(0, -2000), dt)
        self.canDoubleJump = false
      elseif self.rigidBody.acc.y == 0 then
        self.rigidBody:applyForce(Vector(0, -2000), dt)
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
      love.graphics.rectangle("fill", self.rigidBody.pos.x, self.rigidBody.pos.y, self.rigidBody.width, self.rigidBody.height)
      love.graphics.print(tostring(self.rigidBody.vel.x),0,0)
      love.graphics.pop()
    else
      local spriteNum = math.floor(self.animation.currentTime / self.animation.duration * #self.animation.quads) + 1
      love.graphics.draw(self.animation.spriteSheet, self.animation.quads[spriteNum], self.rigidBody.pos.x, self.rigidBody.pos.y, 0, 0.5, 0.5)
    end
end

