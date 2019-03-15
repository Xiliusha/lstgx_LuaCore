local MainScene = class("MainScene", cc.load("mvc").ViewBase)

--local ASSETS_PATH = 'src/mod/demo/assets/'
--local px          = ASSETS_PATH .. 'pixel.png'
--local wqy         = ASSETS_PATH .. 'font/WenQuanYiMicroHeiMono.ttf'

for _, v in ipairs({ 'FocusLoseFunc', 'FocusGainFunc' }) do
    _G[v] = _G[v] or function()
    end
end

local skip_setting-- = true
local skip_selection-- = true

function MainScene.setSkip(skip_set, skip_sel)
    skip_setting, skip_selection = skip_set, skip_sel
end

function MainScene:onCreate()
end

function MainScene:onEnter()
    if not skip_setting then
        --require('editor.main'):create():showWithScene()
        require('platform.launcher_ui')()
    elseif not skip_selection then
        local scene = require('app.views.GameScene'):create(nil, setting.mod)
        lstg.loadMod()
        if lstg._exlauncher then
            SystemLog('use external launcher')
            scene:showWithScene()
        else
            require('platform.launcher2_ui')()
        end
    else
        lstg.loadMod()
        local game_content = require('game.content')
        game_content.setRank(1)
        game_content.setPlayer(1)
        lstg.practice = nil
        local scene = require('app.views.GameScene'):create(nil, setting.mod)
        scene:showWithScene()
    end
end

return MainScene
