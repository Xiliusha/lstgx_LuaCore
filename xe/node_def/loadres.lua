local M = require('xe.node_def._checker')
local CalcParamNum = M.CalcParamNum
local CheckName = M.CheckName
local CheckVName = M.CheckVName
local CheckExpr = M.CheckExpr
local CheckPos = M.CheckPos
local CheckExprOmit = M.CheckExprOmit
local CheckCode = M.CheckCode
local CheckParam = M.CheckParam
local CheckNonBlank = M.CheckNonBlank
local CheckClassName = M.CheckClassName
local IsBlank = M.IsBlank
local CheckResFileInPack = M.CheckResFileInPack
local CheckAnonymous = M.CheckAnonymous
local MakeFullPath = M.MakeFullPath

local loadbgm = {
    { 'File path', 'resfile', CheckNonBlank },
    { 'Resource name', 'string', CheckNonBlank },
    { 'Loop end (seconds)', 'number', CheckExpr },
    { 'Loop length (seconds)', 'number', CheckExpr },
    disptype    = 'load background music',
    editfirst   = true,
    watch       = 'bgm',
    allowchild  = {},
    allowparent = { 'root', 'folder', 'codeblock' },
    totext      = function(nodedata)
        --return string.format("load background music %s from %s", nodedata.attr[2], nodedata.attr[1])
        return string.format("load BGM %s", nodedata.attr[2])
    end,
    tohead      = function(nodedata)
        --local fname = wx.wxFileName(nodedata.attr[1]):GetFullName()
        local fname = string.filename(nodedata.attr[1], true)
        return string.format("MusicRecord(%s,%q,%s,%s)\n", nodedata.attr[2], fname, nodedata.attr[3], nodedata.attr[4])
    end,
    check       = function(nodedata)
        return M.AddPackBgm(nodedata.attr[1], nodedata.attr[2], 'loadbgm')
    end
}
local loadimage = {
    { 'File path', 'resfile', CheckNonBlank },
    { 'Resource name', 'string', CheckNonBlank },
    { 'Mipmap', 'bool', CheckExpr },
    { 'Collision size', 'vec2', CheckExpr },
    { 'Rectangle collision', 'bool', CheckExpr },
    { 'Cut edge', 'any', CheckExpr, '0' },
    disptype    = 'load image',
    editfirst   = true,
    default     = { ["type"] = 'loadimage', attr = { '', '', 'true', '0,0', 'false', '0' } },
    watch       = 'image',
    allowchild  = {},
    allowparent = { 'root', 'folder' },
    totext      = function(nodedata)
        return string.format("load image %q from %q", nodedata.attr[2], nodedata.attr[1])
    end,
    tohead      = function(nodedata)
        --local fname = wx.wxFileName(nodedata.attr[1]):GetFullName()
        local fname = string.filename(nodedata.attr[1], true)
        return string.format("_LoadImageFromFile('image:'..%s,%q,%s,%s,%s,%s)\n",
                             nodedata.attr[2], fname, nodedata.attr[3], nodedata.attr[4], nodedata.attr[5], nodedata.attr[6])
    end,
    check       = function(nodedata)
        return M.AddPackRes(nodedata.attr[1], nodedata.attr[2], M.checkImageName, 'loadimage')
    end
}
local loadtexture = {
    { 'File path', 'resfile', CheckNonBlank },
    { 'Resource name', 'any', CheckNonBlank },
    { 'Mipmap', 'bool', CheckExpr },
    disptype    = 'load texture',
    editfirst   = true,
    default     = { ["type"] = 'loadtexture', attr = { '', '', 'true' } },
    watch       = 'image',
    allowchild  = {},
    allowparent = { 'root', 'folder' },
    totext      = function(nodedata)
        return string.format("load texture %q from %q", nodedata.attr[2], nodedata.attr[1])
    end,
    tohead      = function(nodedata)
        --local fname = wx.wxFileName(nodedata.attr[1]):GetFullName()
        local fname = string.filename(nodedata.attr[1], true)
        return string.format("LoadTexture('texture:'..%q,%q,%s)\n", nodedata.attr[2], fname, nodedata.attr[3])
    end,
    check       = function(nodedata)
        return M.AddPackRes(nodedata.attr[1], nodedata.attr[2], M.checkImageName, 'loadtexture')
    end
}
local loadimagegroup = {
    { 'File path', 'resfile', CheckNonBlank },
    { 'Resource name', 'any', CheckNonBlank },
    { 'Mipmap', 'bool', CheckExpr },
    { 'cols and rows', 'any', CheckExpr },
    { 'Collision size', 'vec2', CheckExpr },
    { 'Rectangle collision', 'bool', CheckExpr },
    disptype    = 'load image group',
    editfirst   = true,
    default     = { ["type"] = 'loadimagegroup', attr = { '', '', 'true', '4,1', '0,0', '0' } },
    watch       = 'image',
    allowchild  = {},
    allowparent = { 'root', 'folder' },
    totext      = function(nodedata)
        return string.format("load image group %q from %q", nodedata.attr[2], nodedata.attr[1])
    end,
    tohead      = function(nodedata)
        --local fname = wx.wxFileName(nodedata.attr[1]):GetFullName()
        local fname = string.filename(nodedata.attr[1], true)
        return string.format("_LoadImageGroupFromFile('image:'..%q,%q,%s,%s,%s,%s)\n", nodedata.attr[2], fname, nodedata.attr[3], nodedata.attr[4], nodedata.attr[5], nodedata.attr[6])
    end,
    check       = function(nodedata)
        return M.AddPackRes(nodedata.attr[1], nodedata.attr[2], M.checkImageName, 'loadimagegroup')
    end
}
local loadani = {
    { 'File path', 'resfile', CheckNonBlank },
    { 'Resource name', 'any', CheckNonBlank },
    { 'Mipmap', 'bool', CheckExpr },
    { 'nCol', 'any', CheckExpr },
    { 'nRow', 'any', CheckExpr },
    { 'Interval', 'any', CheckExpr },
    { 'Collision size', 'vec2', CheckExpr },
    { 'Rectangle collision', 'bool', CheckExpr },
    disptype    = 'load animation',
    editfirst   = true,
    default     = { ["type"] = 'loadani', attr = { '', '', 'true', '1', '1', '4', '0,0', 'false' } },
    watch       = 'image',
    allowchild  = {},
    allowparent = { 'root', 'folder' },
    totext      = function(nodedata)
        return string.format("load animation %q from %q", nodedata.attr[2], nodedata.attr[1])
    end,
    tohead      = function(nodedata)
        --local fname = wx.wxFileName(nodedata.attr[1]):GetFullName()
        local fname = string.filename(nodedata.attr[1], true)
        return string.format("LoadAniFromFile('ani:'..%q,%q,%s,%s,%s,%s,%s,%s)\n", nodedata.attr[2], fname, nodedata.attr[3], nodedata.attr[4], nodedata.attr[5], nodedata.attr[6], nodedata.attr[7], nodedata.attr[8])
    end,
    check       = function(nodedata)
        return M.AddPackRes(nodedata.attr[1], nodedata.attr[2], M.checkAniName, 'loadani')
    end
}
local loadparticle = {
    { 'File path', 'resfile', CheckNonBlank },
    { 'Resource name', 'any', CheckNonBlank },
    { 'Image', 'image'--[[, CheckParImage]] },
    { 'Collision size', 'vec2', CheckExpr },
    { 'Rectangle collision', 'bool', CheckExpr },
    disptype    = 'load particle effect',
    editfirst   = true,
    default     = { ["type"] = 'loadparticle', attr = { '', '', '', '0,0', 'false' } },
    watch       = 'image',
    allowchild  = {},
    allowparent = { 'root', 'folder' },
    totext      = function(nodedata)
        return string.format("load particle system %q from %q", nodedata.attr[2], nodedata.attr[1])
    end,
    tohead      = function(nodedata)
        --local fname = wx.wxFileName(nodedata.attr[1]):GetFullName()
        local fname = string.filename(nodedata.attr[1], true)
        return string.format("LoadPS('particle:'..%q,%q,%q,%s,%s)\n", nodedata.attr[2], fname, nodedata.attr[3], nodedata.attr[4], nodedata.attr[5])
    end,
    check       = function(nodedata)
        local msg = M.AddPackRes(nodedata.attr[1], nodedata.attr[2], M.checkParName, 'loadparticle')
        if msg then
            return msg
        end
        if not (M.watchDict.imageonly[nodedata.attr[3]] or M.parimg[nodedata.attr[3]]) then
            return string.format('image %q does not exist', nodedata.attr[3])
        end
    end
}
local loadFX = {
    { 'File path', 'resfile', CheckNonBlank },
    { 'Resource name', 'any', CheckNonBlank },
    disptype    = 'loadFX',
    editfirst   = true,
    default     = { ["type"] = 'loadFX', attr = { '', '', } },
    watch       = 'image',
    allowchild  = {},
    allowparent = { 'root', 'folder' },
    totext      = function(nodedata)
        return string.format("load FX %q from %q", nodedata.attr[2], nodedata.attr[1])
    end,
    tohead      = function(nodedata)
        --local fname = wx.wxFileName(nodedata.attr[1]):GetFullName()
        local fname = string.filename(nodedata.attr[1], true)
        return string.format("LoadFX(%q,%q)\n", nodedata.attr[2], fname)
    end,
    check       = function(nodedata)
        return M.AddPackRes(nodedata.attr[1], nodedata.attr[2], M.checkImageName, 'loadFX')
    end
}

local _def = {
    loadbgm        = loadbgm,
    loadimage      = loadimage,
    loadtexture    = loadtexture,
    loadimagegroup = loadimagegroup,
    loadani        = loadani,
    loadparticle   = loadparticle,
    loadFX         = loadFX,
}
for k, v in pairs(_def) do
    require('xe.node_def._def').DefineNode(k, v)
end
