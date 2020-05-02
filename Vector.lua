Vector = Class{}

function Vector:init(x, y)
  self.x = x
  self.y = y
end

function Vector:add(other)
  return Vector(self.x + other.x, self.y + other.y)
end

function Vector:subtract(other)
  return Vector(self.x - other.x, self.y - other.y)
end

function Vector:dot(other)
  return self.x * other.x + self.y * other.y
end

function Vector:scale(scale)
  return Vector(scale*self.x, scale*self.y)
end

function Vector:magnitude()
  return math.sqrt(math.pow(self.x, 2) + math.pow(self.y, 2))
end

function Vector:unit()
  magnitude = self:magnitude()
  if magnitude == 0 then
    return Vector(0, 0)
  end

  return Vector(self.x / magnitude, self.y / magnitude)
end

-- radians
function Vector:angle()
  if self.x == 0 then
    return 0
  end

  return math.atan(self.y / self.x)
end

-- smallest positive angle, this is sketchy I don't know if it's right
function Vector:angleBetween(other)
  dotProduct = self:dot(other)
  magSelf = self:magnitude()
  magOther = other:magnitude()

  if magOther * magSelf == 0 then
    return 1e309
  end

  cosineAngle = dotProduct / magSelf * magOther

  return math.cos(cosineAngle)
end

-- returns magnitude only
function Vector:cross(other)
  return self:magnitude()*other:magnitude()*math.sin(self.angleBetween(other))
end

function Vector:rotate(angle)
  x = self.x*math.cos(angle) - self.y*math.sin(angle)
  y = self.y*math.cos(angle) - self.x*math.sin(angle)
  
  return Vector(x, y)
end

