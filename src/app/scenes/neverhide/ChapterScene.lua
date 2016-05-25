local ChapterScene = class("ChapterScene", function()
    return display.newScene("ChapterScene")
end)

function ChapterScene:ctor()
  self.chapterContainer = display.newSprite()
  for i=1,10 do
    local btn = cc.ui.UIPushButton.new({
    normal = "gfx/circle_blue.png",
    pressed = "gfx/circle_green.png",
    disabled = "gfx/circle_blue.png",
    } ,{scale9 = true})
    self.chapterContainer:addChild(btn)
    local px = ((i-1) % 5) * (60 + 30)
    local py = math.floor((i-1)/5) * (60 + 30)
    btn:pos(px,py)
    btn:onButtonClicked(function (event)
        self:onSelectChapter(event,i)
    end)
    btn:setButtonLabel(cc.ui.UILabel.new({text = i.."", size = 22, color = display.COLOR_WHITE}))
  end
  self.chapterContainer:pos(display.cx - 90 * 5/2 ,
        display.cy -  90 * 2/2 + 30)

  self:addChild(self.chapterContainer)


end

function ChapterScene:onSelectChapter(event,_index)
  local gameScene = require("app.scenes.neverhide.NeverHideApp"):new(_index)
  display.replaceScene(gameScene , "fade" , 0.5 , cc.c3b(0,0,0))
end


return ChapterScene
