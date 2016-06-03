local BlockData = class("BlockData",function()
    return display.newNode("BlockData")
end)

BlockData.GROUND = "ground"

BlockData.CEIL = "ceil"

BlockData.NORMAL = "normal"

BlockData.COLORCHANGE = "color_change"

BlockData.WALLCONTROL = "wall_control"

BlockData.EXIT  = "exit"


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

    local grass = display.newSprite("gfx/sheet-2.png")
    grass:setTextureRect(cc.rect(tX * (self.cellGap + 2) , tY *(self.cellGap + 2) ,self.cellGap,self.cellGap));
    grass:setPosition(self.blockRect.x ,self.blockRect.y)
    grass:setAnchorPoint(cc.p(0,0))
    self:addChild(grass);
    self.grass = grass;

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
  self.grass:setPosition(self.blockRect.x ,self.blockRect.y)
end

return BlockData
