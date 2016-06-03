local MapView = class("MapView" ,  function()
    return display.newNode("MapView")
end)

function MapView:ctor(_camera)
  self.cameraView = _camera
  self.foreGround = display.newSprite();
  self.midGround = display.newSprite();
  self.backGround = display.newSprite();

  self:addChild(self.backGround)
  self:addChild(self.midGround)
  self:addChild(self.foreGround)
end

function MapView:addForeground(_view)
    self.foreGround:addChild(_view)
end

function MapView:addMidground(_view)
    self.midGround:addChild(_view)
end

function MapView:addBackground(_view)
    self.backGround:addChild(_view)
end


function MapView:onRender()
  local cx = self.cameraView.location.x
  local cy = self.cameraView.location.y
  self:setPosition(-cx , -cy)

  self.backGround:setPosition(cx,cy)
end

return MapView
