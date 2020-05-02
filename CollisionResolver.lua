require "Vector"

CollisionResolver = Class{}


function CollisionResolver:run(a, b, normal)
  relativeVelocity = b.vel:subtract(a.vel)
  -- print(relativeVelocity.x .. " : " .. relativeVelocity.y)
  -- print(b.vel.y)
  velocityAlongNormal = relativeVelocity:dot(normal)
  -- print(a.vel.x .. " : " .. a.vel.y .. " : " .. b.vel.x .. " : " .. b.vel.y)
  
  print(normal.y .. " : " .. relativeVelocity.y .. " : " .. velocityAlongNormal)
  -- don't resolve if the objects are separating
  if(velocityAlongNormal > 0) then
    return
  end

  -- print(velocityAlongNormal)
  -- print(velocityAlongNormal .. " - " .. a.vel.x )

  e = math.min(a.restitution, b.restitution)

  -- calculate impulse scalar
  j = -(1 + e)*velocityAlongNormal
  j = j / (1 / a.mass + 1 / b.mass)

  -- apply impulse
  impulse = normal:scale(j)
  a.vel = a.vel:subtract(impulse:scale(1 / a.mass))
  b.vel = b.vel:add(impulse:scale(1 / b.mass))
end

