require 'animation'
require 'Vector'

PlayerRenderer = Class{}

function PlayerRenderer:init()
    self.animation = animation(love.graphics.newImage('player2.png'), 123, 169, 1)
end

function PlayerRenderer:update(dt)
  if self.animation.currentTime >= self.animation.duration then
      self.animation.currentTime = self.animation.currentTime - self.animation.duration
  end

  if self.animation.currentTime < 0 then
      self.animation.currentTime = self.animation.currentTime + self.animation.duration
  end
end

function PlayerRenderer:registerEntity(entity)
  self.player = entity
end

function PlayerRenderer:render()
    if DEV == true then
      love.graphics.push()
      love.graphics.setColor(1,0,0)

      love.graphics.rectangle(
        "fill",
        self.player.rigidBody:min().x,
        VIRTUAL_HEIGHT - self.player.rigidBody:max().y,
        self.player.rigidBody.width,
        self.player.rigidBody.height
      )

      love.graphics.pop()
    else
      local spriteNum = math.floor(self.animation.currentTime / self.animation.duration * #self.animation.quads) + 1

      love.graphics.draw(
        self.animation.spriteSheet,
        self.animation.quads[spriteNum],
        self.player.rigidBody.pos.x,
        self.player.rigidBody.pos.y,
        0,
        0.5,
        0.5
      )
    end
end
