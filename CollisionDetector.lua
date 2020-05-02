require "CollisionResolver"
require "Vector"

CollisionDetector = Class{}

function CollisionDetector:init(rigidBodies)
   self.rigidBodies = rigidBodies
   self.collisionResolver = CollisionResolver()
end

function CollisionDetector:run()
  count = #self.rigidBodies

  for i = 1, count do
    for j = i + 1, count do
      a = self.rigidBodies[i]
      b = self.rigidBodies[j]
      
      normal = self:collides(a, b)
      if normal then
        if DEV == true then
          -- print("collision detected!")
          love.graphics.push()
          love.graphics.setColor(1,0,0)
          love.graphics.print("collision",100,0)
          love.graphics.pop()
        end

        self.collisionResolver:run(a, b, normal)
       end
    end
  end
end

function CollisionDetector:collides(a, b)

  -- vector from a to b
  n = b.pos:subtract(a.pos)

  -- calculate the half extents along the x axis for each object
  a_extent = (a:max().x - a:min().x) / 2
  b_extent = (b:max().x - b:min().x) / 2
    
  -- calculate the overlap on the x axis
  x_overlap = a_extent + b_extent - math.abs(n.x)

  -- SAT test on x axis
  if x_overlap > 0 then
    -- calculate the half extents along the y axis for each object
    a_extent = (a:max().y - a:min().y) / 2
    b_extent = (b:max().y - b:min().y) / 2

    -- calculate the overlap on the x axis
    y_overlap = a_extent + b_extent - math.abs(n.y)
  
    -- print(a_extent .. " : " .. b_extent .. " : " .. y_overlap)
    if y_overlap > 0 then
      -- find out which axis is the axis of least penetration
      if y_overlap > x_overlap then
        if n.x < 0 then
          return Vector(-1, 0)
        else
          return Vector(1, 0)
        end
      else
        if n.y < 0 then
          return Vector(0, -1)
        else
          return Vector(0, 1)
        end
      end
    end

    return false
  end

  return false
end

