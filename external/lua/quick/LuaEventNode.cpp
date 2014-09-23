/****************************************************************************
Copyright (c) 2013-2014 Chukong Technologies Inc.

 http://www.cocos2d-x.org

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/

#include "LuaEventNode.h"
#include "LuaTouchEventManager.h"
#include "LuaNodeManager.h"


NS_CC_BEGIN

LuaEventNode *LuaEventNode::create(Node *node)
{
    LuaEventNode *lnode = new LuaEventNode(node);
    lnode->autorelease();
    return lnode;
}

LuaEventNode::LuaEventNode(Node *node)
: _bTouchCaptureEnabled(true)
, _bTouchSwallowEnabled(true)
, _bTouchEnabled(false)
, _eTouchMode(modeTouchesOneByOne)
{
    _node = node;
    _luaEventDispatcher = new LuaEventDispatcher();
}

LuaEventNode::~LuaEventNode()
{
    CC_SAFE_DELETE(_luaEventDispatcher);
}

Node *LuaEventNode::getNode()
{
    return  _node;
}

LuaEventNode* LuaEventNode::getParent()
{
    Node *node = _node->getParent();
    if (node)
    {
        return LuaNodeManager::getInstance()->getLuaNodeByNode(node);
    }
    return nullptr;
}

bool LuaEventNode::isVisible() const
{
    return _node->isVisible();
}

bool LuaEventNode::isRunning() const
{
    return _node->isRunning();
}

// ----------------------------------------

void LuaEventNode::registerWithTouchDispatcher()
{
    //    CCLOG("CCNODE: REGISTER WITH TOUCH DISPATHCER <%p>", this);
    LuaTouchEventManager *mng = LuaTouchEventManager::getInstance();
    if (mng)
    {
        mng->addTouchableNode(this);
    }
}

void LuaEventNode::unregisterWithTouchDispatcher()
{
    //    CCLOG("CCNODE: UNREGISTER WITH TOUCH DISPATHCER <%p>", this);
    LuaTouchEventManager *mng = LuaTouchEventManager::getInstance();
    if (mng)
    {
        mng->removeTouchableNode(this);
    }
}

bool LuaEventNode::isTouchCaptureEnabled()
{
    return _bTouchCaptureEnabled;
}

void LuaEventNode::setTouchCaptureEnabled(bool value)
{
    _bTouchCaptureEnabled = value;
}

bool LuaEventNode::isTouchSwallowEnabled()
{
    return _bTouchSwallowEnabled;
}

void LuaEventNode::setTouchSwallowEnabled(bool value)
{
    _bTouchSwallowEnabled = value;
}

bool LuaEventNode::ccTouchCaptureBegan(Touch *pTouch, LuaEventNode *pTarget)
{
    CC_UNUSED_PARAM(pTouch);
    CC_UNUSED_PARAM(pTarget);
    if (_luaEventDispatcher->hasScriptEventListener(NODE_TOUCH_CAPTURE_EVENT))
    {
        return executeScriptTouchHandler(CCTOUCHBEGAN, pTouch, NODE_TOUCH_CAPTURING_PHASE);
    }
    else
    {
        return true;
    }
}

bool LuaEventNode::ccTouchCaptureMoved(Touch *pTouch, LuaEventNode *pTarget)
{
    CC_UNUSED_PARAM(pTouch);
    CC_UNUSED_PARAM(pTarget);
    if (_luaEventDispatcher->hasScriptEventListener(NODE_TOUCH_CAPTURE_EVENT))
    {
        return executeScriptTouchHandler(CCTOUCHMOVED, pTouch, NODE_TOUCH_CAPTURING_PHASE);
    }
    else
    {
        return true;
    }
}

void LuaEventNode::ccTouchCaptureEnded(Touch *pTouch, LuaEventNode *pTarget)
{
    CC_UNUSED_PARAM(pTouch);
    CC_UNUSED_PARAM(pTarget);
    if (_luaEventDispatcher->hasScriptEventListener(NODE_TOUCH_CAPTURE_EVENT))
    {
        executeScriptTouchHandler(CCTOUCHENDED, pTouch, NODE_TOUCH_CAPTURING_PHASE);
    }
}

void LuaEventNode::ccTouchCaptureCancelled(Touch *pTouch, LuaEventNode *pTarget)
{
    CC_UNUSED_PARAM(pTouch);
    CC_UNUSED_PARAM(pTarget);
    if (_luaEventDispatcher->hasScriptEventListener(NODE_TOUCH_CAPTURE_EVENT))
    {
        executeScriptTouchHandler(CCTOUCHCANCELLED, pTouch, NODE_TOUCH_CAPTURING_PHASE);
    }
}

void LuaEventNode::ccTouchesCaptureBegan(const std::vector<Touch*>& touches, LuaEventNode *pTarget)
{
    CC_UNUSED_PARAM(touches);
    CC_UNUSED_PARAM(pTarget);
    if (_luaEventDispatcher->hasScriptEventListener(NODE_TOUCH_CAPTURE_EVENT))
    {
        executeScriptTouchHandler(CCTOUCHBEGAN, touches, NODE_TOUCH_CAPTURING_PHASE);
    }
}

void LuaEventNode::ccTouchesCaptureMoved(const std::vector<Touch*>& touches, LuaEventNode *pTarget)
{
    CC_UNUSED_PARAM(touches);
    CC_UNUSED_PARAM(pTarget);
    if (_luaEventDispatcher->hasScriptEventListener(NODE_TOUCH_CAPTURE_EVENT))
    {
        executeScriptTouchHandler(CCTOUCHMOVED, touches, NODE_TOUCH_CAPTURING_PHASE);
    }
}

void LuaEventNode::ccTouchesCaptureEnded(const std::vector<Touch*>& touches, LuaEventNode *pTarget)
{
    CC_UNUSED_PARAM(touches);
    CC_UNUSED_PARAM(pTarget);
    if (_luaEventDispatcher->hasScriptEventListener(NODE_TOUCH_CAPTURE_EVENT))
    {
        executeScriptTouchHandler(CCTOUCHENDED, touches, NODE_TOUCH_CAPTURING_PHASE);
    }
}

void LuaEventNode::ccTouchesCaptureCancelled(const std::vector<Touch*>& touches, LuaEventNode *pTarget)
{
    CC_UNUSED_PARAM(touches);
    CC_UNUSED_PARAM(pTarget);
    if (_luaEventDispatcher->hasScriptEventListener(NODE_TOUCH_CAPTURE_EVENT))
    {
        executeScriptTouchHandler(CCTOUCHCANCELLED, touches, NODE_TOUCH_CAPTURING_PHASE);
    }
}

void LuaEventNode::ccTouchesCaptureAdded(const std::vector<Touch*>& touches, LuaEventNode *pTarget)
{
    CC_UNUSED_PARAM(touches);
    CC_UNUSED_PARAM(pTarget);
    if (_luaEventDispatcher->hasScriptEventListener(NODE_TOUCH_CAPTURE_EVENT))
    {
        executeScriptTouchHandler(CCTOUCHADDED, touches, NODE_TOUCH_CAPTURING_PHASE);
    }
}

void LuaEventNode::ccTouchesCaptureRemoved(const std::vector<Touch*>& touches, LuaEventNode *pTarget)
{
    CC_UNUSED_PARAM(touches);
    CC_UNUSED_PARAM(pTarget);
    if (_luaEventDispatcher->hasScriptEventListener(NODE_TOUCH_CAPTURE_EVENT))
    {
        executeScriptTouchHandler(CCTOUCHREMOVED, touches, NODE_TOUCH_CAPTURING_PHASE);
    }
}

bool LuaEventNode::isTouchEnabled()
{
    return _bTouchEnabled;
}

void LuaEventNode::setTouchEnabled(bool enabled)
{
    if (_bTouchEnabled != enabled)
    {
        _bTouchEnabled = enabled;
        //if (_running)
        {
            if (enabled)
            {
                registerWithTouchDispatcher();
            }
            else
            {
                unregisterWithTouchDispatcher();
            }
        }
    }
}

void LuaEventNode::setTouchMode(int mode)
{
    if(_eTouchMode != mode)
    {
        _eTouchMode = mode;
        
		if( _bTouchEnabled)
        {
			setTouchEnabled(false);
			setTouchEnabled(true);
		}
    }
}

int LuaEventNode::getTouchMode()
{
    return _eTouchMode;
}

bool LuaEventNode::ccTouchBegan(Touch *pTouch, Event *pEvent)
{
    CC_UNUSED_PARAM(pTouch);
    CC_UNUSED_PARAM(pEvent);
    if (_luaEventDispatcher->hasScriptEventListener(NODE_TOUCH_EVENT))
    {
        executeScriptTouchHandler(CCTOUCHBEGAN, pTouch);
    }
    return true;
}

void LuaEventNode::ccTouchMoved(Touch *pTouch, Event *pEvent)
{
    CC_UNUSED_PARAM(pTouch);
    CC_UNUSED_PARAM(pEvent);
    if (_luaEventDispatcher->hasScriptEventListener(NODE_TOUCH_EVENT))
    {
        executeScriptTouchHandler(CCTOUCHMOVED, pTouch);
    }
}

void LuaEventNode::ccTouchEnded(Touch *pTouch, Event *pEvent)
{
    CC_UNUSED_PARAM(pTouch);
    CC_UNUSED_PARAM(pEvent);
    if (_luaEventDispatcher->hasScriptEventListener(NODE_TOUCH_EVENT))
    {
        executeScriptTouchHandler(CCTOUCHENDED, pTouch);
    }
}

void LuaEventNode::ccTouchCancelled(Touch *pTouch, Event *pEvent)
{
    CC_UNUSED_PARAM(pTouch);
    CC_UNUSED_PARAM(pEvent);
    if (_luaEventDispatcher->hasScriptEventListener(NODE_TOUCH_EVENT))
    {
        executeScriptTouchHandler(CCTOUCHCANCELLED, pTouch);
    }
}

void LuaEventNode::ccTouchesBegan(const std::vector<Touch*>& touches, Event *pEvent)
{
    CC_UNUSED_PARAM(touches);
    CC_UNUSED_PARAM(pEvent);
    if (_luaEventDispatcher->hasScriptEventListener(NODE_TOUCH_EVENT))
    {
        executeScriptTouchHandler(CCTOUCHBEGAN, touches);
    }
}

void LuaEventNode::ccTouchesMoved(const std::vector<Touch*>& touches, Event *pEvent)
{
    CC_UNUSED_PARAM(touches);
    CC_UNUSED_PARAM(pEvent);
    if (_luaEventDispatcher->hasScriptEventListener(NODE_TOUCH_EVENT))
    {
        executeScriptTouchHandler(CCTOUCHMOVED, touches);
    }
}

void LuaEventNode::ccTouchesEnded(const std::vector<Touch*>& touches, Event *pEvent)
{
    CC_UNUSED_PARAM(touches);
    CC_UNUSED_PARAM(pEvent);
    if (_luaEventDispatcher->hasScriptEventListener(NODE_TOUCH_EVENT))
    {
        executeScriptTouchHandler(CCTOUCHENDED, touches);
    }
}

void LuaEventNode::ccTouchesCancelled(const std::vector<Touch*>& touches, Event *pEvent)
{
    CC_UNUSED_PARAM(touches);
    CC_UNUSED_PARAM(pEvent);
    if (_luaEventDispatcher->hasScriptEventListener(NODE_TOUCH_EVENT))
    {
        executeScriptTouchHandler(CCTOUCHCANCELLED, touches);
    }
}

void LuaEventNode::ccTouchesAdded(const std::vector<Touch*>& touches, Event *pEvent)
{
    CC_UNUSED_PARAM(touches);
    CC_UNUSED_PARAM(pEvent);
    if (_luaEventDispatcher->hasScriptEventListener(NODE_TOUCH_EVENT))
    {
        executeScriptTouchHandler(CCTOUCHADDED, touches);
    }
}

void LuaEventNode::ccTouchesRemoved(const std::vector<Touch*>& touches, Event *pEvent)
{
    CC_UNUSED_PARAM(touches);
    CC_UNUSED_PARAM(pEvent);
    if (_luaEventDispatcher->hasScriptEventListener(NODE_TOUCH_EVENT))
    {
        executeScriptTouchHandler(CCTOUCHREMOVED, touches);
    }
}

int LuaEventNode::executeScriptTouchHandler(int nEventType, Touch *pTouch, int phase /* = NODE_TOUCH_TARGETING_PHASE */)
{
//    return ScriptEngineManager::getInstance()->getScriptEngine()->executeNodeTouchEvent(this, nEventType, pTouch, phase);
}

int LuaEventNode::executeScriptTouchHandler(int nEventType, const std::vector<Touch*>& touches, int phase /* = NODE_TOUCH_TARGETING_PHASE */)
{
//    return ScriptEngineManager::getInstance()->getScriptEngine()->executeNodeTouchesEvent(this, nEventType, touches, phase);
}

NS_CC_END
