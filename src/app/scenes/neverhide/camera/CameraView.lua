local CameraView = class("CameraView")

function CameraView:ctor()
  self.location = cc.p(0,0)
  self.cameraSize = cc.rect(0,0,display.width , display.height)
end


function CameraView:setCameraSize(_size)
  self.cameraSize = _size
end


function CameraView:track(_role)
  self.role = _role
  self:onRender()
end

function CameraView:move(_vel)
  self.location = cc.pAdd(self.location , _vel);
end

function CameraView:onRender()
  local p = self.role:getLocation()
  self.location.x = p.x - self.cameraSize.width/2;
  self.location.y = p.y - self.cameraSize.height/2;
  if self.location.x < 0 then
    self.location.x = 0
    elseif  self.location.x > self.cameraSize.width - display.width then
    self.location.x =  self.cameraSize.width - display.width
  end

  if self.location.y < 0 then
    self.location.y = 0
  elseif self.location.y > self.cameraSize.height then
      self.location.y = self.cameraSize.height
  end
end

return CameraView
