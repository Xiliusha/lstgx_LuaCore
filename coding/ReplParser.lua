---@class x.ReplParser
local M = class('x.ReplParser', {})

---@class x.ReplParser.Segment
local _seg = {
    is_local       = false,
    is_global      = false,
    is_field       = false,
    is_func        = false,
    is_member_var  = false,
    is_member_func = false,
    is_static_func = false,
    is_global_func = false,
    is_bool        = false,
    is_nil         = false,
    is_self        = false,
}

function M:ctor(code)
    self.code = code
    self.lexer = require('coding.lexers.lua_')
    local tokens = self.lexer:lex(code)
    self.tokens = tokens
    local segments = {}
    self.segments = segments
    local segments_without_space = {}
    local num = #self.tokens / 2
    local cur = 1
    for i = 1, num do
        local type = tokens[(i - 1) * 2 + 1]
        local idx = tokens[i * 2]
        local s = code:sub(cur, idx - 1)
        -- shared in 2 tables
        local seg = { type, s }
        table.insert(segments, seg)
        if type ~= 'whitespace' then
            table.insert(segments_without_space, seg)
        end
        cur = idx
    end

    for i, seg in ipairs(segments_without_space) do
        local type, str = seg[1], seg[2]
        if type == 'identifier' then
            local last = segments_without_space[i - 1]
            local next = segments_without_space[i + 1]
            local is_local
            local is_field
            local is_func
            local is_member_func
            if last then
                is_local = last[2] == 'local'
                is_field = last[2] == '.' or last[2] == ':'
                is_member_func = last[2] == ':'
            end
            if next then
                is_func = next[2] == '(' or next[2] == '{' or next[1] == 'string'
            end
            seg.is_local = is_local
            seg.is_global = not is_local and not is_field
            seg.is_field = is_field
            seg.is_func = is_func
            seg.is_member_var = is_field and (not is_func)
            seg.is_member_func = is_member_func
            seg.is_static_func = is_field and is_func and (not is_member_func)
            seg.is_global_func = seg.is_global and is_func
            seg.is_global_var = seg.is_global and (not is_func)
            seg.is_self = str == 'self'
        elseif type == 'keyword' then
            seg.is_nil = str == 'nil'
            seg.is_bool = str == 'true' or str == 'false'
        end
    end
end

---@return x.ReplParser.Segment[]
function M:getSegments()
    return self.segments
end

return M