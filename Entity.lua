Entity = Class {}

function Entity:attachRigidBody(rigidBody)
  self.rigidBody = rigidBody
end

function Entity:attachInputController(inputController)
  inputController:registerEntity(self)
  self.inputController = inputController
end

function Entity:attachRenderer(renderer)
  renderer:registerEntity(self)
  self.renderer = renderer
end

