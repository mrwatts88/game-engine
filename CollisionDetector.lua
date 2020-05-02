CollisionDetector = Class{}

function CollisionDetector:init(rigidBodies)
   self.rigidBodies = rigidBodies
end

function CollisionDetector:run()
  print("-------------")
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
  d1x = b.pos.x - a.pos.x + a.width
  d1y = b.pos.y - a.pos.y + a.height
  d2x = a.pos.x - b.pos.x + b.width
  d2y = a.pos.y - b.pos.y + b.height

  if b.pos.x > a.pos.x + a.width then
    return false
  end

  if b.pos.x + b.width < a.pos.x then
    return false
  end

  if b.pos.y > a.pos.y + a.height then
    return false
  end

  if b.pos.y + b.height < a.pos.y then
    return false
  end

  return true
end

