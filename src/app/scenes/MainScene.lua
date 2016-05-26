
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

local GameScene = import(".GameScene")
local NeverHideApp = import(".neverhide.NeverHideApp")

function MainScene:ctor()
  print("main")
  local gameScene = require("app.scenes.neverhide.ChapterScene"):new()
  display.replaceScene(gameScene , "fade" , 0.5 , cc.c3b(0,0,0))
end

return MainScene
