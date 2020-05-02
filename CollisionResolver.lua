require "Vector"

CollisionResolver = Class{}


function CollisionResolver:run(a, b, manifold)
  normal = manifold.normal
  penetration = manifold.penetration

  relativeVelocity = b.vel:subtract(a.vel)
  velocityAlongNormal = relativeVelocity:dot(normal)
  
  -- don't resolve if the objects are separating
  if(velocityAlongNormal > 0) then
    return
  end

  e = math.min(a.restitution, b.restitution)

  -- calculate impulse scalar
  j = -(1 + e)*velocityAlongNormal
  j = j / (1 / a.mass + 1 / b.mass)

  -- apply impulse
  impulse = normal:scale(j)
  a.vel = a.vel:subtract(impulse:scale(1 / a.mass))
  b.vel = b.vel:add(impulse:scale(1 / b.mass))

  -- correct position to account for floating point errors (prevents sinking)
  percent = 1
  slop = 0.01

  correctionMagnitude = math.max(penetration - slop,  0) / (1 / a.mass + 1 / b.mass) * percent
  correction = normal:scale(correctionMagnitude)

  a.pos = a.pos:subtract(correction:scale(1 / a.mass))
  b.pos = b.pos:add(correction:scale(1 / b.mass))
end

