CollisionDetector = Class{}

function CollisionDetector:init(rigidBodies)
   self.rigidBodies = rigidBodies
end

function CollisionDetector:run()
  count = #self.rigidBodies

  for i = 1, count do
    for j = i+1, count do
      if self:collides(self.rigidBodies[i], self.rigidBodies[j]) then
        print("collision detected!")
       end
    end
  end
end

function CollisionDetector:collides(a, b)
  d1x = b.x - a.x + a.width
  d1y = b.y - a.y + a.height
  d2x = a.x - b.x + b.width
  d2y = a.y - b.y + b.height

  if b.x > a.x + a.width then
    return false
  end

  if b.x + b.width < a.x then
    return false
  end

  if b.y > a.y + a.height then
    return false
  end

  if b.y + b.height < a.y then
    return false
  end

  return true
end

