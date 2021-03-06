local base = require('xe.ui.Property')
---@class xe.NodeProperty:xe.ui.Property
local M = class('xe.NodeProperty', base)
local im = imgui
local wi = require('imgui.Widget')

function M:ctor()
    base.ctor(self)
    ---@type xe.NodePropertySetter[]
    self._setters = {}
end

function M:collectValues()
    local ret = {}
    for _, c in ipairs(self._setters) do
        table.insert(ret, c:getValue())
    end
    return ret
end

function M:getValue(idx)
    local c = self._setters[idx]
    --assert(c and c.getValue)
    return c:getValue()
end

function M:setValue(idx, v)
    local c = self._setters[idx]
    --assert(c and c.setValue)
    return c:setValue(v)
end

---@return xe.NodePropertySetter
function M:getSetter(idx)
    return self._setters[idx]
end

---@param node xe.SceneNode
function M:showNode(node)
    if self._node == node then
        return
    end
    self._node = node
    self._setters = {}
    self:removeAllChildren()
    if not node then
        return
    end
    self:addChild(function()
        im.text(('Info: %s'):format(node:getDisplayType()))
        im.separator()
        im.columns(2, 'xe.NodeProperty.input')
    end)

    if not node:isRoot() then
        for i = 1, node:getAttrCount() do
            local setter = require('xe.ui.NodePropertySetter')(node, i)
            self:addChild(setter)
            table.insert(self._setters, setter)
        end
    else
        local proj = require('xe.Project')
        self:addChildren(wi.Text('Path'), im.nextColumn, function()
            im.textWrapped(proj.getFile() or 'N/A')
        end)
        --TODO: show more info
    end
    self:addChild(function()
        im.columns(1)
    end)
    self:addChild(function()
        for i, v in ipairs(node.attr) do
            local s = stringify(v)
            im.text(s:sub(1, -3))
        end
        im.separator()
        im.text(node:toHead() or 'N/A')
        im.separator()
        im.text(node:toFoot() or 'N/A')
    end)
end

return M
