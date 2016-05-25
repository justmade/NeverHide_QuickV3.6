
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

local GameScene = import(".GameScene")
local NeverHideApp = import(".neverhide.NeverHideApp")

function MainScene:ctor()
    -- -- add background image
    -- display.newSprite("MainSceneBg.jpg")
    --     :move(display.center)
    --     :addTo(self)
    --
    -- -- add play button


    -- local playButton = cc.MenuItemImage:create("PlayButton.png", "PlayButton.png")
    --     :onClicked(function()
    --         self:getApp():enterScene("PlayScene")
    --     end)
    -- cc.Menu:create(playButton)
    --     :move(display.cx, display.cy - 200)
    --     :addTo(self)

    -- local sp = display.newSprite()
    -- self:addChild(sp)
    -- self:setTouchEnabled(true)
    -- self:setTouchMode(cc.TOUCH_MODE_ALL_AT_ONCE)
    -- self:addNodeEventListener(cc.NODE_TOUCH_EVENT,function(event) dump(event) return  end)

  -- display.runScene(GameScene:new())
  --  local n = require("app.scenes.neverhide.NeverHideApp"):new();
  print("main")
  -- display.replaceScene()
  -- self:addChild(NeverHideApp:new())
  local gameScene = require("app.scenes.neverhide.ChapterScene"):new()
  display.replaceScene(gameScene , "fade" , 0.5 , cc.c3b(0,0,0))
end

return MainScene
