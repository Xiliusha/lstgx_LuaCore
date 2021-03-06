---按键状态
KeyState = {}
---上一帧按键状态
KeyStatePre = {}

local _GetKeyState = lstg.GetKeyState
local _GetLastKey = lstg.GetLastKey
local ch = require('platform.ControllerHelper')

--- 给出虚拟键代码检测是否按下
---> code的具体含义请查阅keycode.lua
function GetKeyState(code)
    return _GetKeyState(code) or ch.getStatus(code)
end

---返回最后一次输入的按键的虚拟键代码
---@return number
function GetLastKey()
    local ret = _GetLastKey()
    if ret == 0 then
        return ch.getLastKey()
    else
        return ret
    end
end

---获取输入并保存
function GetInput()
    lstg.eventDispatcher:dispatchEvent('onGetInput')
end

---key是否被按下
---@param key string
---@return boolean
function KeyIsDown(key)
    return KeyState[key]
end

---key是否刚刚被按下
---@param key string
---@return boolean
function KeyIsPressed(key)
    return KeyState[key] and (not KeyStatePre[key])
end

---key是否被按下
KeyPress = KeyIsDown

---key是否刚刚被按下
KeyTrigger = KeyIsPressed

---key是否刚刚松开
---@param key string
---@return boolean
function KeyIsReleased(key)
    return KeyStatePre[key] and (not KeyState[key])
end

--

MouseState = {}
MouseStatePre = {}

---MouseIsDown
---@param button number
---@return boolean
function MouseIsDown(button)
    return MouseState[button]
end

---MouseIsPressed
---@param button number
---@return boolean
function MouseIsPressed(button)
    return MouseState[button] and (not MouseStatePre[button])
end

---MouseIsReleased
---@param button number
---@return boolean
function MouseIsReleased(button)
    return MouseStatePre[button] and (not MouseState[button])
end

---@return number,number
function MousePosition()
    return MouseState[4], MouseState[5]
end

---@return number,number
function MousePositionPre()
    return MouseStatePre[4], MouseStatePre[5]
end

local _GetMousePosition = lstg.GetMousePosition
local glv = cc.Director:getInstance():getOpenGLView()

---获取鼠标的位置，以窗口左下角为原点，使用screen坐标系
---@return number,number
function GetMousePosition()
    local res = glv:getDesignResolutionSize()
    local rect = glv:getViewPortRect()
    local x, y = _GetMousePosition()
    y = res.height - y
    x = x + rect.x / glv:getScaleX()
    y = y + rect.y / glv:getScaleY()
    local scale = screen.scale
    x = x / scale
    y = y / scale
    return x, y
end

lstg.eventDispatcher:addListener('onGetInput', function()
    for i = 1, 5 do
        MouseStatePre[i] = MouseState[i]
    end
    for i = 1, 3 do
        MouseState[i] = GetMouseState(i)
    end
    MouseState[4], MouseState[5] = GetMousePosition()
end, 1, 'mouse')

