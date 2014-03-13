require "src/CocoStudioTest/CocoStudioSceneTest/TriggerCode/acts"
require "src/CocoStudioTest/CocoStudioSceneTest/TriggerCode/cons"
require "src/CocoStudioTest/CocoStudioSceneTest/TriggerCode/eventDef"

local itemTagBasic = 1000

local sceneEditorTestIdx = 1

local SceneEditorTestLayer = class("SceneEditorTestLayer")
SceneEditorTestLayer.__index = SceneEditorTestLayer
SceneEditorTestLayer._backItem = nil
SceneEditorTestLayer._restarItem = nil
SceneEditorTestLayer._nextItem   = nil
SceneEditorTestLayer.title       =
{
    "loadSceneEdtiorFile Test",
    "Sprite Component Test",
    "Armature Component Test",
    "UI Component Test",
    "TmxMap Component Test",
    "Particle Component Test",
    "Effect Component Test",
    "Background Component Test",
    "Attribute Component Test",
    "Trigger Test",
}

function SceneEditorTestLayer.extend(target)
    local t = tolua.getpeer(target)
    if not t then
        t = {}
        tolua.setpeer(target, t)
    end
    setmetatable(t, SceneEditorTestLayer)
    return target
end


function SceneEditorTestLayer:onEnter() 
    
end

function SceneEditorTestLayer:onExit()
    ccs.TriggerMng.destroyInstance()
    ccs.ArmatureDataManager:destroyInstance()
    ccs.SceneReader:destroyInstance()
    ccs.ActionManagerEx:destroyInstance()
    ccs.GUIReader:destroyInstance()
end

function SceneEditorTestLayer.create()
    local layer = SceneEditorTestLayer.extend(cc.Layer:create())
    if nil ~= layer then
        layer:createTitle()
        layer:createMenu()
        local function onNodeEvent(event)
            if "enter" == event then
                layer:onEnter()
            end
        end
        layer:registerScriptHandler(onNodeEvent)
    end
end

function SceneEditorTestLayer:createTitle()
    local title = cc.Label:create(self.title[sceneEditorTestIdx], s_arialPath, 18)
    title:setAnchorPoint(cc.p(0.5, 0.5))
    title:setColor(cc.c3b(255, 255, 255))
    self:addChild(title, 1, 10000)
    title:setPosition( cc.p(VisibleRect:center().x, VisibleRect:top().y - 30))
end

function SceneEditorTestLayer:createMenu()
    local menu = cc.Menu:create()

    local function pre()
        local scene = cc.Scene:create()
        scene:addChild(backSceneEditorTest())
        cc.Director:getInstance():replaceScene(scene)
    end

    local function restart()
        local scene = cc.Scene:create()
        scene:addChild(restartSceneEditorTest())
        cc.Director:getInstance():replaceScene(scene)
    end

    local function next()
        local scene = cc.Scene:create()
        scene:addChild(nextSceneEditorTest())
        cc.Director:getInstance():replaceScene(scene)
    end

    self._backItem = cc.MenuItemImage:create(s_pPathB1, s_pPathB2)
    self._backItem:registerScriptTapHandler(pre)
    self._restarItem = cc.MenuItemImage:create(s_pPathR1, s_pPathR2)
    self._restarItem:registerScriptTapHandler(restart)
    self._nextItem = cc.MenuItemImage:create(s_pPathF1, s_pPathF2)
    self._nextItem:registerScriptTapHandler(next)



    local size = cc.Director:getInstance():getWinSize()
    self._backItem:setPosition(cc.p(size.width / 2 - self._restarItem:getContentSize().width * 2, self._restarItem:getContentSize().height / 2))
    self._restarItem:setPosition(cc.p(size.width / 2, self._restarItem:getContentSize().height / 2))
    self._nextItem:setPosition(cc.p(size.width / 2 + self._restarItem:getContentSize().width * 2, self._restarItem:getContentSize().height / 2))

    menu:addChild(self._backItem,itemTagBasic)
    menu:addChild(self._restarItem,itemTagBasic)
    menu:addChild(self._nextItem,itemTagBasic)
    menu:setPosition(cc.p(0,0))
    self:addChild(menu, 100)

    local function back()
        local scene = CocoStudioTestMain()
        if nil ~= scene then
            cc.Director:getInstance():replaceScene(scene)
        end
    end

    local backMenu = cc.Menu:create()
    cc.MenuItemFont:setFontName("Arial")
    cc.MenuItemFont:setFontSize(24)
    local menuItemFont = cc.MenuItemFont:create("Back")
    menuItemFont:setPosition(cc.p(VisibleRect:rightBottom().x - 50, VisibleRect:rightBottom().y + 25))
    menuItemFont:registerScriptTapHandler(back)

    backMenu:addChild(menuItemFont)
    backMenu:setPosition(cc.p(0, 0))
    self:addChild(backMenu,10)
end

local LoadSceneEdtiorFileTest = class("LoadSceneEdtiorFileTest",SceneEditorTestLayer)
LoadSceneEdtiorFileTest.__index = LoadSceneEdtiorFileTest

function LoadSceneEdtiorFileTest.extend(target)
    local t = tolua.getpeer(target)
    if not t then
        t = {}
        tolua.setpeer(target, t)
    end
    setmetatable(t, LoadSceneEdtiorFileTest)
    return target
end

function LoadSceneEdtiorFileTest:createGameScene()
    local node = ccs.SceneReader:getInstance():createNodeWithSceneFile("scenetest/LoadSceneEdtiorFileTest/FishJoy2.json")
    return node
end

function LoadSceneEdtiorFileTest:onEnter()
    self:createMenu()
    self:createTitle()
    local root = self:createGameScene()
    if nil ~= root then
        self:addChild(root, 0, 1)
    end
    
end

function LoadSceneEdtiorFileTest.create()
    local layer = LoadSceneEdtiorFileTest.extend(cc.Layer:create())

    if nil ~= layer then
        local function onNodeEvent(event)
            if "enter" == event then
                layer:onEnter()
            elseif "exit" == event then
                layer:onExit()
            end
        end
        layer:registerScriptHandler(onNodeEvent)
    end

    return layer
end

local SpriteComponentTest = class("SpriteComponentTest",SceneEditorTestLayer)
SpriteComponentTest.__index = SpriteComponentTest

function SpriteComponentTest.extend(target)
    local t = tolua.getpeer(target)
    if not t then
        t = {}
        tolua.setpeer(target, t)
    end
    setmetatable(t, SpriteComponentTest)
    return target
end

function SpriteComponentTest:createGameScene()
    local node = ccs.SceneReader:getInstance():createNodeWithSceneFile("scenetest/SpriteComponentTest/SpriteComponentTest.json")
    if nil ~= node then
        local action1 = cc.Blink:create(2, 10)
        local action2 = cc.Blink:create(2, 5)

        local sister1 = node:getChildByTag(10003):getComponent("CCSprite")
        sister1:getNode():runAction(action1)
        local sister2 = node:getChildByTag(10004):getComponent("CCSprite")
        sister2:getNode():runAction(action2)
    end

    return node
end

function SpriteComponentTest:onEnter()
    self:createMenu()
    self:createTitle()
    local root = self:createGameScene()
    if nil ~= root then
        self:addChild(root, 0, 1)
    end
    
end

function SpriteComponentTest.create()
    local layer = SpriteComponentTest.extend(cc.Layer:create())

    if nil ~= layer then
        local function onNodeEvent(event)
            if "enter" == event then
                layer:onEnter()
            elseif "exit" == event then
                layer:onExit()
            end
        end
        layer:registerScriptHandler(onNodeEvent)
    end

    return layer
end

local ArmatureComponentTest = class("ArmatureComponentTest",SceneEditorTestLayer)
ArmatureComponentTest.__index = ArmatureComponentTest

function ArmatureComponentTest.extend(target)
    local t = tolua.getpeer(target)
    if not t then
        t = {}
        tolua.setpeer(target, t)
    end
    setmetatable(t, ArmatureComponentTest)
    return target
end

function ArmatureComponentTest:createGameScene()
    local node = ccs.SceneReader:getInstance():createNodeWithSceneFile("scenetest/ArmatureComponentTest/ArmatureComponentTest.json")
    if nil ~= node then
        local blowFish = node:getChildByTag(10007):getComponent("CCArmature")
        blowFish:getNode():runAction(cc.MoveBy:create(10.0, cc.p(-1000.0, 0)))

        local butterflyfish = node:getChildByTag(10008):getComponent("CCArmature")
        butterflyfish:getNode():runAction(CCMoveBy:create(10.0, cc.p(-1000.0, 0)))
    end

    return node
end

function ArmatureComponentTest:onEnter()
    self:createMenu()
    self:createTitle()
    local root = self:createGameScene()
    if nil ~= root then
        self:addChild(root, 0, 1)
    end
    
end

function ArmatureComponentTest.create()
    local layer = ArmatureComponentTest.extend(cc.Layer:create())

    if nil ~= layer then
        local function onNodeEvent(event)
            if "enter" == event then
                layer:onEnter()
            elseif "exit" == event then
                layer:onExit()
            end
        end
        layer:registerScriptHandler(onNodeEvent)
    end

    return layer
end

local UIComponentTest = class("UIComponentTest",SceneEditorTestLayer)
UIComponentTest.__index = UIComponentTest

function UIComponentTest.extend(target)
    local t = tolua.getpeer(target)
    if not t then
        t = {}
        tolua.setpeer(target, t)
    end
    setmetatable(t, UIComponentTest)
    return target
end

function UIComponentTest:createGameScene()
    local node = ccs.SceneReader:getInstance():createNodeWithSceneFile("scenetest/UIComponentTest/UIComponentTest.json")
    if nil ~= node then
        local render = node:getChildByTag(10025):getComponent("GUIComponent")
        local widget = render:getNode()
        local button = widget:getChildByName("Button_156")
        local function onTouch(sender, eventType)
            if eventType == ccui.TouchEventType.began then
                local blowFish = node:getChildByTag(10010):getComponent("CCArmature")
                blowFish:getNode():runAction(cc.MoveBy:create(10.0, cc.p(-1000.0, 0)))

                local butterflyfish = node:getChildByTag(10011):getComponent("CCArmature")
                butterflyfish:getNode():runAction(cc.MoveBy:create(10.0, cc.p(-1000.0, 0)))
            end
        end

        button:addTouchEventListener(onTouch)
    end

    return node
end

function UIComponentTest:onEnter()
    self:createMenu()
    self:createTitle()
    local root = self:createGameScene()
    if nil ~= root then
        self:addChild(root, 0, 1)
    end
    
end

function UIComponentTest.create()
    local layer = UIComponentTest.extend(cc.Layer:create())

    if nil ~= layer then
        local function onNodeEvent(event)
            if "enter" == event then
                layer:onEnter()
            elseif "exit" == event then
                layer:onExit()
            end
        end
        layer:registerScriptHandler(onNodeEvent)
    end

    return layer
end

local TmxMapComponentTest = class("TmxMapComponentTest",SceneEditorTestLayer)
TmxMapComponentTest.__index = TmxMapComponentTest

function TmxMapComponentTest.extend(target)
    local t = tolua.getpeer(target)
    if not t then
        t = {}
        tolua.setpeer(target, t)
    end
    setmetatable(t, TmxMapComponentTest)
    return target
end

function TmxMapComponentTest:createGameScene()
    local node = ccs.SceneReader:getInstance():createNodeWithSceneFile("scenetest/TmxMapComponentTest/TmxMapComponentTest.json")
    if nil ~= node then
        local tmxMap = node:getChildByTag(10015):getComponent("CCTMXTiledMap")
        local actionTo = cc.SkewTo:create(2, 0.0, 2.0)
        local rotateTo = cc.RotateTo:create(2, 61.0)
        local actionScaleTo = cc.ScaleTo:create(2, -0.44, 0.47)

        local actionScaleToBack = cc.ScaleTo:create(2, 1.0, 1.0)
        local rotateToBack = cc.RotateTo:create(2, 0)
        local actionToBack = cc.SkewTo:create(2, 0, 0)

        tmxMap:getNode():runAction(cc.Sequence:create(actionTo, actionToBack))
        tmxMap:getNode():runAction(cc.Sequence:create(rotateTo, rotateToBack))
        tmxMap:getNode():runAction(cc.Sequence:create(actionScaleTo, actionScaleToBack))
    end

    return node
end

function TmxMapComponentTest:onEnter()
    self:createMenu()
    self:createTitle()
    local root = self:createGameScene()
    if nil ~= root then
        self:addChild(root, 0, 1)
    end
    
end

function TmxMapComponentTest.create()
    local layer = TmxMapComponentTest.extend(cc.Layer:create())

    if nil ~= layer then
        local function onNodeEvent(event)
            if "enter" == event then
                layer:onEnter()
            elseif "exit" == event then
                layer:onExit()
            end
        end
        layer:registerScriptHandler(onNodeEvent)
    end

    return layer
end

local ParticleComponentTest = class("ParticleComponentTest",SceneEditorTestLayer)
ParticleComponentTest.__index = ParticleComponentTest

function ParticleComponentTest.extend(target)
    local t = tolua.getpeer(target)
    if not t then
        t = {}
        tolua.setpeer(target, t)
    end
    setmetatable(t, ParticleComponentTest)
    return target
end

function ParticleComponentTest:createGameScene()
    local node = ccs.SceneReader:getInstance():createNodeWithSceneFile("scenetest/ParticleComponentTest/ParticleComponentTest.json")
    if nil ~= node then
        local particle = node:getChildByTag(10020):getComponent("CCParticleSystemQuad")
        local jump = cc.JumpBy:create(5, cc.p(-500,0), 50, 4)
        local action = cc.Sequence:create( jump, jump:reverse())
        particle:getNode():runAction(action)
    end

    return node
end

function ParticleComponentTest:onEnter()
    self:createMenu()
    self:createTitle()
    local root = self:createGameScene()
    if nil ~= root then
        self:addChild(root, 0, 1)
    end
    
end

function ParticleComponentTest.create()
    local layer = ParticleComponentTest.extend(cc.Layer:create())

    if nil ~= layer then
        local function onNodeEvent(event)
            if "enter" == event then
                layer:onEnter()
            elseif "exit" == event then
                layer:onExit()
            end
        end
        layer:registerScriptHandler(onNodeEvent)
    end

    return layer
end

local EffectComponentTest = class("EffectComponentTest",SceneEditorTestLayer)
EffectComponentTest.__index = EffectComponentTest

function EffectComponentTest.extend(target)
    local t = tolua.getpeer(target)
    if not t then
        t = {}
        tolua.setpeer(target, t)
    end
    setmetatable(t, EffectComponentTest)
    return target
end

function EffectComponentTest:createGameScene()
    local node = ccs.SceneReader:getInstance():createNodeWithSceneFile("scenetest/EffectComponentTest/EffectComponentTest.json")
    if nil ~= node then
        local render = node:getChildByTag(10015):getComponent("CCArmature")
        local armature = render:getNode()
        local function animationEvent(armatureBack,movementType,movementID)
            local id = movementID
            if movementType == ccs.MovementEventType.loopComplete then
                if id == "Fire" then
                    local audio = node:getChildByTag(10015):getComponent("CCComAudio")
                    audio:playEffect()
                end
            end
        end

        armature:getAnimation():setMovementEventCallFunc(animationEvent)
    end

    return node
end

function EffectComponentTest:onEnter()
    self:createMenu()
    self:createTitle()
    local root = self:createGameScene()
    if nil ~= root then
        self:addChild(root, 0, 1)
    end
    
end

function EffectComponentTest.create()
    local layer = EffectComponentTest.extend(cc.Layer:create())

    if nil ~= layer then
        local function onNodeEvent(event)
            if "enter" == event then
                layer:onEnter()
            elseif "exit" == event then
                layer:onExit()
            end
        end
        layer:registerScriptHandler(onNodeEvent)
    end

    return layer
end

local BackgroundComponentTest = class("BackgroundComponentTest",SceneEditorTestLayer)
BackgroundComponentTest.__index = BackgroundComponentTest

function BackgroundComponentTest.extend(target)
    local t = tolua.getpeer(target)
    if not t then
        t = {}
        tolua.setpeer(target, t)
    end
    setmetatable(t, BackgroundComponentTest)
    return target
end

function BackgroundComponentTest:createGameScene()
    local node = ccs.SceneReader:getInstance():createNodeWithSceneFile("scenetest/BackgroundComponentTest/BackgroundComponentTest.json")
    if nil ~= node then
        local audio = node:getComponent("CCBackgroundAudio")
        audio:playBackgroundMusic()
    end

    return node
end

function BackgroundComponentTest:onEnter()
    self:createMenu()
    self:createTitle()
    local root = self:createGameScene()
    if nil ~= root then
        self:addChild(root, 0, 1)
    end
    
end

function BackgroundComponentTest.create()
    local layer = BackgroundComponentTest.extend(cc.Layer:create())

    if nil ~= layer then
        local function onNodeEvent(event)
            if "enter" == event then
                layer:onEnter()
            elseif "exit" == event then
                layer:onExit()
            end
        end
        layer:registerScriptHandler(onNodeEvent)
    end

    return layer
end

local AttributeComponentTest = class("AttributeComponentTest",SceneEditorTestLayer)
AttributeComponentTest.__index = AttributeComponentTest

function AttributeComponentTest.extend(target)
    local t = tolua.getpeer(target)
    if not t then
        t = {}
        tolua.setpeer(target, t)
    end
    setmetatable(t, AttributeComponentTest)
    return target
end

function AttributeComponentTest:createGameScene()
    local node = ccs.SceneReader:getInstance():createNodeWithSceneFile("scenetest/AttributeComponentTest/AttributeComponentTest.json")
    local attribute = node:getChildByTag(10015):getComponent("CCComAttribute")
    print(string.format("Name: %s, HP: %f, MP: %f", attribute:getString("name"), attribute:getFloat("maxHP"), attribute:getFloat("maxMP")))
    return node
end

function AttributeComponentTest:onEnter()
    self:createMenu()
    self:createTitle()
    local root = self:createGameScene()
    if nil ~= root then
        self:addChild(root, 0, 1)
    end
    
end

function AttributeComponentTest.create()
    local layer = AttributeComponentTest.extend(cc.Layer:create())

    if nil ~= layer then
        local function onNodeEvent(event)
            if "enter" == event then
                layer:onEnter()
            elseif "exit" == event then
                layer:onExit()
            end
        end
        layer:registerScriptHandler(onNodeEvent)
    end

    return layer
end

local TriggerTest = class("TriggerTest",SceneEditorTestLayer)
TriggerTest.__index = TriggerTest
TriggerTest._touchListener = nil

function TriggerTest.extend(target)
    local t = tolua.getpeer(target)
    if not t then
        t = {}
        tolua.setpeer(target, t)
    end
    setmetatable(t, TriggerTest)
    return target
end

function TriggerTest:createGameScene()
    local node = ccs.SceneReader:getInstance():createNodeWithSceneFile("scenetest/TriggerTest/TriggerTest.json")

    return node
end

function TriggerTest:onTouchBegan(touch,event)
    ccs.sendTriggerEvent(triggerEventDef.TRIGGEREVENT_TOUCHBEGAN)
    return true
end

function TriggerTest:onTouchMoved(touch,event)
    ccs.sendTriggerEvent(triggerEventDef.TRIGGEREVENT_TOUCHMOVED)
end

function TriggerTest:onTouchEnded(touch,event)
    ccs.sendTriggerEvent(triggerEventDef.TRIGGEREVENT_TOUCHENDED)
end

function TriggerTest:onTouchCancelled(touch,event)
    ccs.sendTriggerEvent(triggerEventDef.TRIGGEREVENT_TOUCHCANCELLED)
end

function TriggerTest:onEnter()
    self:createMenu()
    self:createTitle()
    local root = self:createGameScene()
    if nil ~= root then
        self:addChild(root, 0, 1)
        self._touchListener = nil
        local listener = cc.EventListenerTouchOneByOne:create()
        listener:setSwallowTouches(true)
        listener:registerScriptHandler(self.onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
        listener:registerScriptHandler(self.onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
        listener:registerScriptHandler(self.onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
        listener:registerScriptHandler(self.onTouchCancelled,cc.Handler.EVENT_TOUCH_CANCELLED )
        local eventDispatcher = self:getEventDispatcher()
        eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
        self._touchListener = listener
        local function update(dt)
            ccs.sendTriggerEvent(triggerEventDef.TRIGGEREVENT_UPDATESCENE)
        end
        self:scheduleUpdateWithPriorityLua(update,0)
        ccs.sendTriggerEvent(triggerEventDef.TRIGGEREVENT_ENTERSCENE)
    end
    
end

function TriggerTest:onExit()
    ccs.sendTriggerEvent(triggerEventDef.TRIGGEREVENT_LEAVESCENE)
    self:unscheduleUpdate()
    local dispatcher = self:getEventDispatcher()
    dispatcher:removeEventListener(self._touchListener)
    ccs.TriggerMng.destroyInstance()
    ccs.ArmatureDataManager:destroyInstance()
    ccs.SceneReader:destroyInstance()
    ccs.ActionManagerEx:destroyInstance()
    ccs.GUIReader:destroyInstance()
end

function TriggerTest.create()
    local layer = TriggerTest.extend(cc.Layer:create())

    if nil ~= layer then
        local function onNodeEvent(event)
            if "enter" == event then
                layer:onEnter()
            elseif "exit" == event then
                layer:onExit()
            end
        end
        layer:registerScriptHandler(onNodeEvent)
    end

    return layer
end

local createSceneEditorTest = 
{
    LoadSceneEdtiorFileTest.create,
    SpriteComponentTest.create,
    ArmatureComponentTest.create,
    UIComponentTest.create,
    TmxMapComponentTest.create,
    ParticleComponentTest.create,
    EffectComponentTest.create,
    BackgroundComponentTest.create,
    AttributeComponentTest.create,
    TriggerTest.create,
}

function nextSceneEditorTest( )
    sceneEditorTestIdx = sceneEditorTestIdx + 1
    sceneEditorTestIdx = sceneEditorTestIdx % table.getn(createSceneEditorTest)

    if 0 == sceneEditorTestIdx  then
        sceneEditorTestIdx = table.getn(createSceneEditorTest)
    end

    return createSceneEditorTest[sceneEditorTestIdx]()
end

function backSceneEditorTest()
    sceneEditorTestIdx = sceneEditorTestIdx - 1
    if sceneEditorTestIdx <= 0 then
        sceneEditorTestIdx = sceneEditorTestIdx + table.getn(createSceneEditorTest)
    end

    return createSceneEditorTest[sceneEditorTestIdx]()
end

function restartSceneEditorTest()
    return createSceneEditorTest[sceneEditorTestIdx]()
end

function runCocosSceneTestScene()
   local scene = cc.Scene:create()
   sceneEditorTestIdx = 1
   scene:addChild(restartSceneEditorTest())
   cc.Director:getInstance():replaceScene(scene)
end
