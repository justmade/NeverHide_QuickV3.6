local Role = class("Role", function()
    return display.newSprite()
end)


function Role:ctor(x,y,mass)
  self.position = cc.p(x,y)
  self.mass     = 1

  self.speed    = cc.p(0,0);
  self.acceleration = cc.p(0,0);
  self.boundary = cc.rect(0,0,display.width , display.height)


  -- local drawSp = display.newDrawNode()
  self.height = 30
  -- drawSp:drawLine(cc.p(10,10) , cc.p(20,20) , 2 , cc.c4f(1.0,1.0,1.0,1.0))
  -- drawSp:drawRect({0,0,self.height,self.height},{fillColor = cc.c4f(1.0,0,0,1.0)})
  -- self.sp = display.newSprite("gfx/blood.png")
  -- self:addChild(self.sp)
  -- self.sp:setScale(30/20);
  -- self.sp:setAnchorPoint(cc.p(0.5,0))
  self.roleContainer = display.newSprite();
  self.sp = cc.DrawNode:create()
  self.sp:drawSolidRect(cc.p(0,0),cc.p(30,30) ,cc.c4f(185/255,70/255,70/255,1))
  self.roleContainer:addChild(self.sp)
  self.sp:setPositionX(-15)

  local eye = cc.DrawNode:create()
  eye:drawSolidCircle(cc.p(0,15),10,math.pi,20,cc.c4f(1,1,1,1))
  self.roleContainer:addChild(eye)
  self:addChild(self.roleContainer)

  local body = cc.PhysicsBody:createBox(self:getContentSize() , cc.PhysicsMaterial(0, 0, 0))
  body:setMass(0)
  body:setDynamic(true);
  body:setContactTestBitmask(0xFFFFFFFF)
  self:setPhysicsBody(body)
  self:setTag(1990)

  self.colorID = 30003;
end

function Role:setRoleColor(_colorID)
  self.colorID = tonumber(_colorID)
  self.sp:clear()
  if self.colorID == 30001 then
    self.sp:drawSolidRect(cc.p(0,0),cc.p(30,30) ,cc.c4f(70/255,70/255,185/255,1))
  elseif self.colorID == 30002 then
    self.sp:drawSolidRect(cc.p(0,0),cc.p(30,30) ,cc.c4f(70/255,185/255,159/255,1))
  elseif self.colorID == 30003 then
    self.sp:drawSolidRect(cc.p(0,0),cc.p(30,30) ,cc.c4f(185/255,70/255,70/255,1))
  end
end

function Role:onUpdate()
  self.speed.y = self.speed.y + self.acceleration.y
  -- print("onUpdate" , self.speed.y )
  self.speed.x = self.acceleration.x
  -- self.speed:add(self.acceleration)
  if self.speed.x >=5 then
    self.speed.x = 5;
  end

  if self.speed.x <=-5 then
    self.speed.x = -5;
  end

  self.position = cc.pAdd(self.position , self.speed)
  self:setPositionX(self.position.x)
  self:setPositionY(self.position.y)
  -- print("pos",self.position.y)
  self.acceleration = cc.pMul(self.acceleration , 0)
  self:checkBoundary()
end

function Role:setPosY(value)
  self.position.y = value
end


function Role:jumpState()
  -- print('speed',self.speed.y)
  if self.speed.y > 0 then
    return true
  else
    return false
  end
end

function Role:setPosX(value)
  self.position.x = value
end

--给外力
function Role:applyFroce(v)
  -- print("applyFroce",v.y)
  self.acceleration = cc.pAdd(self.acceleration , v)
end

--设置水平方向的速度
function Role:setHSpeed(v)
  self.speed.x = v
end

function Role:playAnimation()
  local ac = cc.FadeOut:create(1)
  self.sp:runAction(ac)
end

function Role:displayRole()
  self.sp:setOpacity(255)
end

function Role:getHeight()
    return self.height
end

function Role:getLocation()
  return self.position
end

function Role:setBoundarySize(size)
    self.boundary = size
end

--移动的边界
function Role:checkBoundary()
  if self.position.x  < 0 then
      self.position.x = 0
  elseif self.position.x > self.boundary.width - 50 then
    self.position.x = self.boundary.width - 50
  end
end



return Role
