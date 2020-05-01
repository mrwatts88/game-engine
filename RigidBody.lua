RigidBody = Class{}

GRAVITY = 1000
FRICTION = 10

function RigidBody:init(x, y, width, height)
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  self.AABB = { min=self.x, max=self.y + self.height }
  self.xv = 0
  self.yv = 0
  self.xa = 0
  self.ya = 0

  self.max_xv = 500
  self.max_yv = 2000
  self.max_xa = 2000
  self.max_ya = 2000

  self.useGravity = false
   
  if self.useGravity then
    self.ya = GRAVITY
  end
end

function RigidBody:update(dt)
  self.xv = self.xv + self.xa * dt
  self.yv = self.yv + self.ya * dt

  if self.xv > self.max_xv then
    self.xv = self.max_xv
  end

  if self.xv < -self.max_xv then
    self.xv = -self.max_xv
  end

  if self.yv > self.max_yv then
    self.yv = self.max_yv
  end

  if self.yv < -self.max_yv then
    self.yv = -self.max_yv
  end

  self.x = self.x + self.xv * dt
  self.y = self.y + self.yv * dt

  self.AABB = { min=self.x, max=self.y + self.height }
end

function RigidBody:applyForce(x, y, dt)
  -- self.xa = self.xa + x
  -- self.ya = self.ya + y

  self.xv = self.xv + x * dt
  self.yv = self.yv + y * dt

  if self.xv > self.max_xv then
    self.xv = self.max_xv
  end

  if self.xv < -self.max_xv then
    self.xv = -self.max_xv
  end

  if self.yv > self.max_yv then
    self.yv = self.max_yv
  end

  if self.yv < -self.max_yv then
    self.yv = -self.max_yv
  end

  if math.abs(self.xv) < 60 and self.xv * x < 0 then
    self.xv = 0
  end

end

