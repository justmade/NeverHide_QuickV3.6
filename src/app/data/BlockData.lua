local BlockData = class("BlockData",function()
    return display.newNode("BlockData")
end)

BlockData.GROUND = "ground"

BlockData.CEIL = "ceil"

BlockData.NORMAL = "normal"

BlockData.COLORCHANGE = "color_change"

BlockData.WALLCONTROL = "wall_control"


function BlockData:ctor (rect , type , dataInfo , tiledID)
    self.blockRect = rect
    self.blockType = type
    if dataInfo.colorID then
        self.colorID = tonumber(dataInfo.colorID)
    else
        self.colorID = 0
    end


    self.propID    = dataInfo.id
    self.tiledID   = tiledID

    local tX   = self.tiledID % 7
    local tY   = math.floor(self.tiledID / 7)

    local grass = display.newSprite("gfx/colorsheet.png")
    grass:setTextureRect(cc.rect(tX * (50) , tY *(50) ,50,50));
    grass:setPosition(self.blockRect.x ,self.blockRect.y)
    grass:setAnchorPoint(cc.p(0,0))
    self:addChild(grass);
    self.grass = grass;

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
