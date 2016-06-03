local NeverHideApp = class("NeverHideApp", function()
    return display.newScene("NeverHideApp")
end)
require("framework.init")
local scheduler   = cc.Scheduler
local Role        = require("app.scenes.neverhide.Role")
local PosInfo     = require("app.scenes.neverhide.PosInfo")
local BloodEffect = require("app.scenes.neverhide.HeroUpgradeEffect")
local TouchController = import(".TouchController")
local Collision   = require("app.data.Collision")
local BlockData   = require("app.data.BlockData")
local MapView     = require("app.scenes.neverhide.map.MapView")
local CameraView  = require("app.scenes.neverhide.camera.CameraView")
require("app.data.ElementsConfig")


function NeverHideApp:ctor(_o , _chapterIndex)
    math.randomseed(os.time())
    self.safeArea  = {}
    self.speed     = 2
    self.cellGap   = 62
    --存储所有生成的矩形
    self.allPos    = {}
    self.levelWidth = 0
    self.levelHeight = 0
    self.upData = {}
    self.downData = {}
    self.downSpeed = 3;
    self.currentLevel = _chapterIndex;
    self.playerSpeed = cc.p(5,0)
    self.moveSpeed = cc.p(0,0)
    self.wallCloseSpeed = 2
    --天花板下降的距离
    self.ceilOffset = 0;


end

function NeverHideApp:onEnter()
  self.cameraView = CameraView.new()
  self.mapView = MapView.new(self.cameraView)
  self:addChild(self.mapView)

  local bg = display.newSprite("gfx/bg.png")
  self.mapView:addBackground(bg)
  bg:setAnchorPoint(cc.p(0,0))

  local r = Role.new(40,300);
  self.role = r

  self.cameraView:track(self.role)


  self.renderContainer = display.newLayer();
  self.mapView:addMidground(self.renderContainer)
  self.mapView:addMidground(r)
  self:resetMap()
  self:addTouchListener()

end

--读取新的地图
function NeverHideApp:resetMap()
  self.renderContainer:removeAllChildren()
  local MapInfo     = require("app.data.mapdata.colormap"..self.currentLevel)
  --获取tield地图
  local t = MapInfo.layers
  self.upData   = self:deepcopy(t[1].data);
  self.downData = self:deepcopy(t[2].data);
  self.levelWidth = t[1].width;
  self.levelHeight = t[1].height;

  local mapSize = cc.rect(0,0,self.levelWidth * self.cellGap , self.levelHeight * self.cellGap)
  self.cameraView:setCameraSize(mapSize)
  self.role:setBoundarySize(mapSize)
  self:resolvingPro(MapInfo.tilesets)
  self:findGround()
  self:findUpGround();
  -- self:setRoleByPosX(self.role:getPositionX())
  self:resetUpGround();

  local function sortRectByPosX(a,b)
    return a:getRect().x < b:getRect().x
  end

  table.sort(self.upGroundRects , sortRectByPosX)
  table.sort(self.downGroundRects , sortRectByPosX)

  self.role:setPosX(40)
  self.role:setPosY(300)
  self.role:setRoleColor(30003)
  -- scheduleUpdate()
  self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
     self:update(dt)
  end)
  self:scheduleUpdate()
  -- self:scheduleUpdatea(hndler(self, self.update))
  -- self.currentEnterFrame = scheduler.scheduleUpdate(handler(self,self.update))
end

--table深拷贝
function NeverHideApp:deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[self:deepcopy(orig_key)] = self:deepcopy(orig_value)
        end
        setmetatable(copy, self:deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

--根据tiles字段 解析id和对应的属性
function NeverHideApp:resolvingPro(_info)
  local mapTiles = _info[1].tiles
  self.itemInfo = {}
  for i,v in ipairs(mapTiles) do
    self.itemInfo[(v.id+1)..""] = {}
    for k,m in pairs(v.properties) do
      self.itemInfo[(v.id+1)..""][k] = m
    end
  end
end

function NeverHideApp:resetUpGround()
  self.ceilOffset = 0
  for i,v in ipairs(self.upAllGroundRects) do
    local rect = v:getRect()
    rect.y =  rect.y +self.levelHeight * self.cellGap
  end
end


--找到下层的路面
function NeverHideApp:findGround()
    --下层路面每个地形的rect数组
    self.downGroundRects = {}
    self.allGroundRects = {}
    for i,v in ipairs(self.downData) do
        if v ~= 0 then
          local index = i-1;
          local posX = (index % self.levelWidth) * self.cellGap
          local posY = self.levelHeight * self.cellGap -  math.floor(index / self.levelWidth) * self.cellGap - self.cellGap
          local r    = cc.rect(posX,posY,self.cellGap,self.cellGap)
          local tiledId   = v - 1;
          local bd
          local itemInfo = self.itemInfo[v..""]
          if self.downGroundRects[index % self.levelWidth +1 ] == nil and itemInfo.type == "block" then
            bd = BlockData.new(r,BlockData.GROUND,itemInfo,tiledId);
            self.downGroundRects[index % self.levelWidth +1] = bd
          elseif itemInfo.type == "color_change" then
            bd = BlockData.new(r,BlockData.COLORCHANGE,itemInfo,tiledId)
          elseif itemInfo.type == "wall_control" then
            bd = BlockData.new(r,BlockData.WALLCONTROL,itemInfo,tiledId)
          elseif itemInfo.type == "exit" then
            bd = BlockData.new(r,BlockData.EXIT,itemInfo,tiledId)
          else
            bd = BlockData.new(r,BlockData.NORMAL,itemInfo,tiledId);
          end
          table.insert(self.allGroundRects , bd)
          self.renderContainer:addChild(bd)
        end
    end
end

--查找上层路面的最低点
function NeverHideApp:findUpGround()
  self.upGroundRects = {}
  self.upAllGroundRects = {}
  for i,v in ipairs(self.upData) do
      if v ~= 0 then
        local index = i-1;
        local posX = (index % self.levelWidth) * self.cellGap
        local posY = self.levelHeight * self.cellGap -  math.floor(index / self.levelWidth) * self.cellGap - self.cellGap
        local r    = cc.rect(posX,posY,self.cellGap,self.cellGap)
        local tiledId   = v - 1;
        local itemInfo = self.itemInfo[v..""]
        local bd = BlockData.new(r,BlockData.CEIL,itemInfo,tiledId);
        self.upGroundRects[index % self.levelWidth +1] = bd
        table.insert(self.upAllGroundRects , bd)
        self.renderContainer:addChild(bd)
      end
  end
end

function NeverHideApp:closingUpGroud()
    self.ceilOffset = self.ceilOffset - self.wallCloseSpeed;
    for i,v in ipairs(self.upAllGroundRects) do
      local rect = v:getRect();
      rect.y = rect.y - self.wallCloseSpeed
    end
end



--人物与障碍碰撞
function NeverHideApp:onRoleCollisionGround()
  self.role:applyFroce(cc.p(0,-2))
  --上下左右 用于标记那个方向上已经进行过碰撞检测了
  local collisionState = {0,0,0,0}

  for i,v in ipairs(self.allGroundRects) do

    local blockRect = v:getRect();
    local blockType = v:getType();
    local colorID   = v:getColorID();
    local propID    = v:getPropID();

    --只检测颜色与主角不一样的情况
    if colorID ~= self.role.colorID then
      local state = Collision.rectIntersectsRect(cc.rect(self.role:getPositionX() - 20 , self.role:getPositionY() - 5 , 40,30),blockRect)
      --与道具的碰撞检测
      if state ~= "nothing" and self:collisionItem(blockType) then
          if blockType == BlockData.COLORCHANGE then
            self.role:setRoleColor(colorID)
          elseif blockType == BlockData.WALLCONTROL then
            self:onGetWallControl(propID)
          elseif blockType == BlockData.EXIT then
            self:unscheduleUpdate()
            self:destroy()
            return true
          end

          table.remove(self.allGroundRects,i)
          self.renderContainer:removeChild(v)
          local px = blockRect.x / self.cellGap + 1;
          local py = self.levelHeight - blockRect.y / self.cellGap;
          self:setGoundDataByXY(px,py,0)
        return
      end

      local isGround = self:checkGroundState(blockRect)
      if state == "top" and collisionState[1] ~= 1 and self.role:jumpState() == false and isGround then
        -- print("state",state,i);
        collisionState[1] = 1
        self.role.speed.y = 0
        self.role:applyFroce(cc.p(0,2))
        local rX = self.role:getPositionX()
        self.role:setPosY(blockRect.y + blockRect.height)
      elseif state == "left" and collisionState[3] ~= 1 then
        collisionState[3] = 1
        self.role:applyFroce(cc.p(-5,0))
        self.role:setHSpeed(0)
      elseif state == "right" and collisionState[4] ~= 1 then
        collisionState[4] = 1
        self.role:applyFroce(cc.p(5,0))
        self.role:setHSpeed(0)
     end
   end
  end
end

--碰撞到的是不是道具
function NeverHideApp:collisionItem(_blockType)
  return _blockType == BlockData.COLORCHANGE
   or _blockType == BlockData.WALLCONTROL
   or _blockType == BlockData.EXIT
end

function NeverHideApp:onGetWallControl(_propID)
  _propID = tonumber(_propID)
  if _propID == PROP_WALL_DOWN then
      self.wallCloseSpeed = 2
  elseif _propID == PROP_WALL_UP then
      self.wallCloseSpeed = -2
  elseif _propID == PROP_WALL_STOP then
      self.wallCloseSpeed = 0

  end
end

--[[人物进行与地面的碰撞检测时，需要确认：1，这个砖块是不是最上层的。
  2，如果不是最上层的，那么上层是不是颜色id和主角的是一致的。
  3，上层是不是道具
  满足其中一种情况才可以发现『top』方向上的碰撞检测
--]]
function NeverHideApp:checkGroundState(rect)
  local px = rect.x / self.cellGap + 1;
  local py = self.levelHeight - rect.y / self.cellGap;

  -- print("checkGroundState",py)
  -- print("checkGroundState",px)
  local uPx = px ;
  local uPy = py - 1 ;
  local upData = self:getGoundDataByXY(uPx,uPy);
  local itemInfo
  if upData ~= 0 then
    itemInfo = self.itemInfo[upData..""]
  end

  if upData == 0 then
    return true
  elseif tonumber(itemInfo.colorID) == tonumber(self.role.colorID) then
    return true
  elseif itemInfo.type == "color_change" or itemInfo.type == "wall_control" then
    return true
  else
    return false
  end
end

function NeverHideApp:getGoundDataByXY(x,y)
  local index = (y-1) * self.levelWidth  + x
  return self.downData[index]
end

function NeverHideApp:setGoundDataByXY(x,y ,value)
    local index = (y-1) * self.levelWidth  + x
    self.downData[index] = value
end



--检测上方的路面是否和人物碰到
function NeverHideApp:onRoleCollisionCeil()
    local collisionState = {0,0,0,0}

  for i,v in ipairs(self.upAllGroundRects) do
      local blockRect = v:getRect();
      local blockType = v:getType();
      local blockColorId = v:getColorID();
      if blockColorId ~= self.role.colorID then
        local state = Collision.rectIntersectsRect(cc.rect(self.role:getPositionX() - 20 , self.role:getPositionY() - 5 , 40,40),blockRect)
        if state == "bottom" and collisionState[1] ~= 1 then
          collisionState[1] = 1
          self.role.speed.y = 0
          self.role:applyFroce(cc.p(0,-3))
          -- local rX = self.role:getPositionX()
          -- self.role:setPosY(blockRect.y + blockRect.height)
        elseif state == "left" and collisionState[3] ~= 1 then
          collisionState[3] = 1
          self.role:applyFroce(cc.p(-5,0))
          self.role:setHSpeed(0)
        elseif state == "right" and collisionState[4] ~= 1 then
          collisionState[4] = 1
          self.role:applyFroce(cc.p(5,0))
          self.role:setHSpeed(0)
       end
    end
  end
end


function NeverHideApp:getCeilDataByXY(x,y)
  local index = (y-1) * self.levelWidth  + x
  return self.upData[index]
end


--返回是否是地面表层的砖块
function NeverHideApp:findeRectInGround(rect)
  for i,v in ipairs(self.downGroundRects) do
    if v == rect then
      return true
    end
  end
  return false
end

function NeverHideApp:addTouchListener()
    self.touchController = TouchController.new()
    self:addChild(self.touchController)
end




--根据任务的X坐标查找到对应地面的Y坐标 设置位置
function NeverHideApp:setRoleByPosX(posx)

  for i,v in ipairs(self.downGroundRects) do
    if posx <= (v.x + v.width) then
        self.role:setPosY(v.y + v.height)
        -- print("setRoleByPosX" , v.y + v.height)
        break
    end
  end
end

function NeverHideApp:update(dt)
  self.cameraView:onRender()
  self.mapView:onRender()
  self.touchController:onRender()
  local isHit = self:onRoleCollisionCeil(self.role)
  --
  -- if isHit then
  --     self:unscheduleUpdate()
  -- end
  --
  --
  --绘制
  self:tiledRender(self.allGroundRects)
  self:tiledRender(self.upAllGroundRects)

  if self:checkGoundHit() then
      print("checkGoundHit")
      self:unscheduleUpdate()
      self:resetMap()
  end

  if self:onRoleCollisionGround() then
    return
  end
  local mV = self.touchController.moveVec;
  local jV = self.touchController.jumpVec
  self.role:applyFroce(jV)
  self.role:applyFroce(mV:Mult(mV , 5));

  self.role:onUpdate();
  jV:mult(0)

  self:closingUpGroud();
end

--绘制场景
function NeverHideApp:tiledRender(_arr)
  for i,v in ipairs(_arr) do
      v:onRender()
  end
end


--获取结果
function NeverHideApp:getResult(isFailed)
    if isFailed then
      local effect = BloodEffect.new();
      self:addChild(effect)
      effect:setPosition(cc.p(self.role:getPositionX() , self.role:getPositionY() + 100))
      self.role:playAnimation()
      -- self:resetGame()
      local resetTimer =  scheduler.performWithDelayGlobal(handler(self,self.resetGame), 1)
    end
end

function NeverHideApp:resetGame(dt)
    self.role:displayRole()
    self:resetUpGround()
    -- self.currentEnterFrame = scheduler.scheduleUpdateGlobal(handler(self,self.update))
end

--判断垂直方向上，上下矩形是否有碰撞
function NeverHideApp:checkGoundHit()
    for i,v in ipairs(self.upGroundRects) do
      local upRect = v:getRect()
      local downRect = self.downGroundRects[i]:getRect()
      local b = cc.rectIntersectsRect(upRect , downRect)
      if b then return b end
    end
    return false
end


function NeverHideApp:destroy()
    self:removeAllChildren()
    display.replaceScene(require("app.scenes.neverhide.ChapterScene"):new() , "fade" , 0.5 , cc.c3b(0,0,0))
end






return NeverHideApp
