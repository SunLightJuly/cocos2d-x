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

#ifndef __LUA_EVENT_NODE_H_
#define __LUA_EVENT_NODE_H_

#include "2d/CCNode.h"
#include "LuaEventDispatcher.h"

NS_CC_BEGIN

/**
 * @addtogroup scene
 * @{
 */

class CC_DLL LuaEventNode : public Ref
{
public:
    static const int modeTouchesOneByOne = (int)Touch::DispatchMode::ONE_BY_ONE;
    static const int modeTouchesAllAtOnce = (int)Touch::DispatchMode::ALL_AT_ONCE;
    
    static LuaEventNode *create(Node *node);

    ~LuaEventNode();

    Node *getNode();

    virtual LuaEventNode* getParent();
    
    virtual bool isVisible() const;
    virtual bool isRunning() const;
    
    virtual void registerWithTouchDispatcher(void);
    virtual void unregisterWithTouchDispatcher(void);
    
    virtual bool isTouchCaptureEnabled();
    virtual void setTouchCaptureEnabled(bool value);
    virtual bool isTouchSwallowEnabled();
    virtual void setTouchSwallowEnabled(bool value);
    
    virtual bool ccTouchCaptureBegan(Touch *pTouch, LuaEventNode *pTarget);
    virtual bool ccTouchCaptureMoved(Touch *pTouch, LuaEventNode *pTarget);
    virtual void ccTouchCaptureEnded(Touch *pTouch, LuaEventNode *pTarget);
    virtual void ccTouchCaptureCancelled(Touch *pTouch, LuaEventNode *pTarget);
    
    virtual void ccTouchesCaptureBegan(const std::vector<Touch*>& touches, LuaEventNode *pTarget);
    virtual void ccTouchesCaptureMoved(const std::vector<Touch*>& touches, LuaEventNode *pTarget);
    virtual void ccTouchesCaptureEnded(const std::vector<Touch*>& touches, LuaEventNode *pTarget);
    virtual void ccTouchesCaptureCancelled(const std::vector<Touch*>& touches, LuaEventNode *pTarget);
    virtual void ccTouchesCaptureAdded(const std::vector<Touch*>& touches, LuaEventNode *pTarget);
    virtual void ccTouchesCaptureRemoved(const std::vector<Touch*>& touches, LuaEventNode *pTarget);
    
    virtual bool isTouchEnabled();
    virtual void setTouchEnabled(bool value);
    
    virtual void setTouchMode(int mode);
    virtual int getTouchMode();
    
    virtual bool ccTouchBegan(Touch *pTouch, Event *pEvent);
    virtual void ccTouchMoved(Touch *pTouch, Event *pEvent);
    virtual void ccTouchEnded(Touch *pTouch, Event *pEvent);
    virtual void ccTouchCancelled(Touch *pTouch, Event *pEvent);
    
    virtual void ccTouchesBegan(const std::vector<Touch*>& touches, Event *pEvent);
    virtual void ccTouchesMoved(const std::vector<Touch*>& touches, Event *pEvent);
    virtual void ccTouchesEnded(const std::vector<Touch*>& touches, Event *pEvent);
    virtual void ccTouchesCancelled(const std::vector<Touch*>& touches, Event *pEvent);
    virtual void ccTouchesAdded(const std::vector<Touch*>& touches, Event *pEvent);
    virtual void ccTouchesRemoved(const std::vector<Touch*>& touches, Event *pEvent);

private:
    LuaEventNode(Node *node);

    Node *_node;
    
    LuaEventDispatcher *_luaEventDispatcher;
    // touch events
    bool _bTouchCaptureEnabled;
    bool _bTouchSwallowEnabled;
    bool _bTouchEnabled;
//    int _nTouchPriority;
    int _eTouchMode;

    virtual int executeScriptTouchHandler(int nEventType, Touch *pTouch, int phase = 1);
    virtual int executeScriptTouchHandler(int nEventType, const std::vector<Touch*>& touches, int phase = 1);
    
};

NS_CC_END

#endif // __LUA_EVENT_NODE_H_
