require "Vector"

CollisionResolver = Class{}

function CollisionResolver:run(manifolds)
  for index, manifold in ipairs(manifolds) do
    if DEV == true then
      print("collision detected!")
      love.graphics.push()
      love.graphics.setColor(1,0,0)
      love.graphics.print("collision",100,0)
      love.graphics.pop()
    end

    local normal = manifold.normal
    local penetration = manifold.penetration
    local a = manifold.a
    local b = manifold.b

    local relativeVelocity = b.vel:subtract(a.vel)
    local velocityAlongNormal = relativeVelocity:dot(normal)
    
    -- don't resolve if the objects are separating
    if(velocityAlongNormal <= 0) then
      local e = math.min(a.restitution, b.restitution)

      -- calculate impulse scalar
      local j = -(1 + e)*velocityAlongNormal
      j = j / (1 / a.mass + 1 / b.mass)

      -- apply impulse
      local impulse = normal:scale(j)
      a.vel = a.vel:subtract(impulse:scale(1 / a.mass))
      b.vel = b.vel:add(impulse:scale(1 / b.mass))

      -- correct position to account for floating point errors (prevents sinking)
      local percent = 1
      local slop = 0.01

      local correctionMagnitude = math.max(penetration - slop,  0) / (1 / a.mass + 1 / b.mass) * percent
      local correction = normal:scale(correctionMagnitude)

      a.pos = a.pos:subtract(correction:scale(1 / a.mass))
      b.pos = b.pos:add(correction:scale(1 / b.mass))
    end
  end
end

