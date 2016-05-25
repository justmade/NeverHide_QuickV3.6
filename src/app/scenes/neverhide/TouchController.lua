local TouchController = class("TouchController", function()
    return display.newLayer()
end)

local Vector2D = import(".Vector2D")

function TouchController:ctor()
    self.moveVec = Vector2D.new(0,0)
    self.jumpVec = Vector2D.new(0,0)
    self.moveState = 0;

    self.btnJump = display.newSprite("gfx/controller_jump.png")
    self.btnLeft = display.newSprite("gfx/controller_left.png")
    self.btnRight = display.newSprite("gfx/controller_right.png")

    self:addChild(self.btnJump)
    self:addChild(self.btnLeft)
    self:addChild(self.btnRight)

    self.btnLeft:setAnchorPoint(cc.p(0,0))
    self.btnRight:setAnchorPoint(cc.p(0,0))
    self.btnJump:setAnchorPoint(cc.p(0,0))

    self.btnJump:setOpacity(120)
    self.btnLeft:setOpacity(120)
    self.btnRight:setOpacity(120)

    self.btnJump:setPositionX(self.btnJump:getBoundingBox().width/2 + 50)
    self.btnRight:setPositionX(display.width - self.btnRight:getBoundingBox().width - 50)
    self.btnLeft:setPositionX(self.btnRight:getPositionX() - self.btnLeft:getBoundingBox().width - 50)

    self.btnJump:setPositionY(50)
    self.btnRight:setPositionY(50)
    self.btnLeft:setPositionY(50)

    self.jumpID = -1
    self.moveID = -1


    self:setTouchEnabled(true)
    self:setTouchMode(cc.TOUCH_MODE_ALL_AT_ONCE)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event) return self:onTouchHandler(event) end)

    local btn
    btn = cc.ui.UIPushButton.new() :setButtonLabel(cc.ui.UILabel.new({text = " ", size = 64}))
    self:addChild(btn)
    btn:setKeypadEnabled(true)
    btn:addNodeEventListener(cc.KEYPAD_EVENT,function(e)
      print("keyboard")
          if e.code == 59 then
              self.jumpVec.y = 20
          end

          if e.code == 26 then
            self.state = "left"
          elseif e.code == 27 then
            self.state = "right"
          end
    end)
end

function TouchController:onRender()
  if self.state == "right" then
    self.moveVec.x = 1
  elseif self.state == "left" then
     self.moveVec.x = -1
  elseif self.state == "jump" then

  end
end

function TouchController:onTouchHandler(event)
  local point
  local touchID
  for k,v in pairs(event.points) do
      point = v
      touchID = v.id
  end

  -- print("touchID::",touchID)
  local rightRect = self.btnRight:getBoundingBox();
  local leftRect = self.btnLeft:getBoundingBox();
  local jumpRect = self.btnJump:getBoundingBox();
  if cc.rectContainsPoint(rightRect , cc.p(point.x , point.y)) then
      self.moveState = 1
      self.moveVec.x = 1
      self.moveID = touchID
  end

  if cc.rectContainsPoint(leftRect , cc.p(point.x , point.y)) then

      self.moveState = -1
      self.moveVec.x = -1
      self.moveID = touchID
  end

  if cc.rectContainsPoint(jumpRect , cc.p(point.x , point.y)) then
    self.jumpID = touchID
  end
  if event.name == "began" or event.name == "added" then
    if self.jumpID == touchID then
      self.jumpID = -1
      self.jumpVec.y = 20
    end
  elseif event.name == "moved" then

  elseif event.name == "ended" then
    if touchID == self.moveID then
      self.moveID = -1
      self.moveState = 0
      self.moveVec.x = 0
    end
      self.jumpID = -1
  end
  return true
end


return TouchController
