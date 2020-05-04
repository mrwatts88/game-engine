require "Vector"

PlayerInputController = Class{}

function PlayerInputController:init()
  self.canDoubleJump = true
end

function PlayerInputController:registerEntity(entity)
  self.player = entity
end

function PlayerInputController:processInputs(dt)
  if self.player.rigidBody:min().y > GROUND_HEIGHT then
    -- is airborne
  elseif love.keyboard.isDown("right") then
    self.player.renderer.animation.currentTime = self.player.renderer.animation.currentTime + dt
    self.player.rigidBody:applyForce(Vector(2000, 0), dt)
  elseif love.keyboard.isDown("left") then
    self.player.renderer.animation.currentTime = self.player.renderer.animation.currentTime - dt
    self.player.rigidBody:applyForce(Vector(-2000, 0), dt)
  else
    if self.player.rigidBody:min().y <= GROUND_HEIGHT then
      self.player.rigidBody:applyForce(Vector(-3.5*self.player.rigidBody.vel.x, 0), dt)
      -- todo apply friction force in rigid body class whenever colliding
    end
  end

  if self.player.rigidBody:min().y <= GROUND_HEIGHT then
    self.canDoubleJump = true
  end

  if love.keyboard.wasPressed("space") then
    if self.player.rigidBody.vel.y < 0 and self.canDoubleJump then
      self.player.rigidBody:applyForce(Vector(0, 40000), dt)
      self.canDoubleJump = false
    elseif self.player.rigidBody:min().y <= GROUND_HEIGHT then
      self.player.rigidBody:applyForce(Vector(0, 30000), dt)
    end
  end
end

