require "Vector"

RigidBody = Class{}

GRAVITY = -1000
FRICTION = 10

function RigidBody:init(x, y, width, height, useGravity)
  self.pos = Vector(x, y)
  self.vel = Vector(0, 0)
  self.acc = Vector(0, 0)
  self.width = width
  self.height = height
  self.restitution = 0.1
  self.mass = 1

  self.maxVel = Vector(500, 2000)
  self.maxAcc = Vector(2000, 2000)

  if useGravity then
    self.acc = Vector(0, GRAVITY)
  end
end

function RigidBody:update(dt)
  self.vel = self.vel:add(self.acc:scale(dt))

  -- self.vel = self.vel:clamp(self.maxVel)
  -- self.vel = self.vel:clamp(self.maxVel:scale(-1))

  if self.vel.x > self.maxVel.x then
    self.vel.x = self.maxVel.x
  end

  if self.vel.x < -self.maxVel.x then
    self.vel.x = -self.maxVel.x
  end

  if self.vel.y > self.maxVel.y then
    self.vel.y = self.maxVel.y
  end

  if self.vel.y < -self.maxVel.y then
    self.vel.y = -self.maxVel.y
  end

  self.pos = self.pos:add(self.vel:scale(dt))
end

function RigidBody:applyForce(force, dt)

  self.vel = self.vel:add(force:scale(dt))

  -- self.vel = self.vel:clamp(self.maxVel)
  -- self.vel = self.vel:clamp(self.maxVel:scale(-1))

  if self.vel.x > self.maxVel.x then
    self.vel.x = self.maxVel.x
  end

  if self.vel.x < -self.maxVel.x then
    self.vel.x = -self.maxVel.x
  end

  if self.vel.y > self.maxVel.y then
    self.vel.y = self.maxVel.y
  end

  if self.vel.y < -self.maxVel.y then
    self.vel.y = -self.maxVel.y
  end

  -- todo: stop the wiggle in a better way, with vectors
  if math.abs(self.vel.x) < 60 and self.vel.x * force.x < 0 then
    self.vel.x = 0
  end
end

function RigidBody:min()
  return Vector(self.pos.x - self.width / 2, self.pos.y - self.height / 2)
end

function RigidBody:max()
  return Vector(self.pos.x + self.width / 2, self.pos.y + self.height / 2)
end

