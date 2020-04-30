require 'animation'
Player = Class{}

function Player:init(rigidBody)
    self.animation = animation(love.graphics.newImage('player2.png'), 123, 169, 1)
    self.rigidBody = rigidBody

    -- todo add isAirborne to RigidBody class
    self.ground = VIRTUAL_HEIGHT - self.rigidBody.height - 16
    self.canDoubleJump = true
end

function Player:update(dt)
    if self.rigidBody.y < self.ground then
      -- is airborne
    elseif love.keyboard.isDown("right") then
      self.animation.currentTime = self.animation.currentTime + dt
      self.rigidBody:applyForce(4000, 0, dt)
      -- todo apply right force
    elseif love.keyboard.isDown("left") then
      self.animation.currentTime = self.animation.currentTime - dt
      self.rigidBody:applyForce(-4000, 0, dt)
      -- todo apply left force
    else
      if self.rigidBody.y >= self.ground then
        self.rigidBody:applyForce(-3.5*self.rigidBody.xv, 0, dt)
        -- todo apply friction force in rigid body class when colliding
      end
    end

    if self.rigidBody.y >= self.ground then
      self.canDoubleJump = true
    end

    if love.keyboard.wasPressed("space") then
      if self.rigidBody.yv > 0 and self.canDoubleJump then
        self.rigidBody:applyForce(0, -2000, dt)
        -- todo apply force
        self.canDoubleJump = false
      elseif self.rigidBody.ya == 0 then
        self.rigidBody:applyForce(0, -2000, dt)
        -- todo apply force
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
      love.graphics.rectangle("fill", self.rigidBody.x, self.rigidBody.y, self.rigidBody.width, self.rigidBody.height)
      -- love.graphics.rectangle("fill", VIRTUAL_WIDTH / 2 - (self.rigidBody.width / 2), self.rigidBody.y, self.rigidBody.width, self.rigidBody.height)
      love.graphics.print(tostring(self.rigidBody.xv),0,0)
      -- love.graphics.print(tostring(self.rigidBody.yv),30,0)
      love.graphics.pop()
    else
      local spriteNum = math.floor(self.animation.currentTime / self.animation.duration * #self.animation.quads) + 1
      love.graphics.draw(self.animation.spriteSheet, self.animation.quads[spriteNum], self.rigidBody.x, self.rigidBody.y, 0, 0.5, 0.5)
    end
end


