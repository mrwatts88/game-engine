require "CollisionResolver"
require "Vector"

CollisionDetector = Class{}

function CollisionDetector:init(entities)
  self.entities = entities
end

function CollisionDetector:run()
  local count = #self.entities
  local manifolds = {}

  for i = 1, count do
    for j = i + 1, count do
      local a = self.entities[i].rigidBody
      local b = self.entities[j].rigidBody
      
      local manifold = self:collides(a, b)

      if manifold then
        manifolds[#manifolds+1]  = manifold
      end
    end
  end

  return manifolds
end

function CollisionDetector:collides(a, b)
  -- vector from a to b
  local n = b.pos:subtract(a.pos)

  -- calculate the half extents along the x axis for each object
  local a_extent = (a:max().x - a:min().x) / 2
  local b_extent = (b:max().x - b:min().x) / 2
    
  -- calculate the overlap on the x axis
  local x_overlap = a_extent + b_extent - math.abs(n.x)

  -- SAT test on x axis
  if x_overlap > 0 then
    -- calculate the half extents along the y axis for each object
    a_extent = (a:max().y - a:min().y) / 2
    b_extent = (b:max().y - b:min().y) / 2

    -- calculate the overlap on the x axis
    local y_overlap = a_extent + b_extent - math.abs(n.y)
  
    -- print(a_extent .. " : " .. b_extent .. " : " .. y_overlap)
    if y_overlap > 0 then
      -- find out which axis is the axis of least penetration
      if y_overlap > x_overlap then
        if n.x < 0 then
          return { a=a, b=b, normal=Vector(-1, 0), penetration=x_overlap }
        else
          return { a=a, b=b, normal=Vector(1, 0), penetration=x_overlap }
        end
      else
        if n.y < 0 then
          return { a=a, b=b, normal=Vector(0, -1), penetration=y_overlap }
        else
          return { a=a, b=b, normal=Vector(0, 1), penetration=y_overlap }
        end
      end
    end
  end

  return false
end

