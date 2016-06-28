local BlockData = class("BlockData",function()
    return display.newSprite("gfx/sheet-2.png")
end)

BlockData.GROUND        = "ground"
BlockData.CEIL          = "ceil"
BlockData.NORMAL        = "normal"
BlockData.COLORCHANGE   = "color_change"
BlockData.WALLCONTROL   = "wall_control"
BlockData.EXIT          = "exit"
BlockData.PIN           = "pin"
BlockData.HALFPIN       = "half_pin"


function BlockData:ctor (rect , type , dataInfo , tiledID)
    self.blockRect = rect
    self.blockType = type
    self.cellGap = 64
    if dataInfo.colorID then
        self.colorID = tonumber(dataInfo.colorID)
    else
        self.colorID = 0
    end



    self.propID    = dataInfo.id
    self.tiledID   = tiledID

    local tX   = self.tiledID % 7
    local tY   = math.floor(self.tiledID / 7)


    -- local grass = display.newSprite("gfx/sheet-2.png")
    self:setTextureRect(cc.rect(tX * (self.cellGap + 2) , tY *(self.cellGap + 2) ,self.cellGap,self.cellGap));
    self:setPosition(self.blockRect.x ,self.blockRect.y)
    -- self:setAnchorPoint(cc.p(0,0))
    -- self:addChild(grass);
    -- self.grass = grass;

    local body = cc.PhysicsBody:createBox(self:getContentSize() , cc.PhysicsMaterial(0, 0, 0))
    body:setMass(0)
    body:setDynamic(false);
    body:setContactTestBitmask(0xFFFFFFFF)
    self:setPhysicsBody(body)
    self:setTag(self.propID)

end

function BlockData:pinBody()

end

function BlockData:hPinBody()
    
end


function BlockData:getPropID ()
    return self.propID
end

function BlockData:getRect()
    return self.blockRect
end

function BlockData:getType()
    return self.blockType
end

function BlockData:getColorID()
    return self.colorID
end

function BlockData:getTiledID()
    return self.tiledID
end

function BlockData:onRender()
  self:setPosition(self.blockRect.x + self.blockRect.width/2 ,self.blockRect.y + self.blockRect.height/2)
end

return BlockData
