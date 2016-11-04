local events = require("Engine.events")

return function(config) --A function that creates a new GPU peripheral.
  
  --Load the config--
  local _LIKO_W, _LIKO_H = config._LIKO_W or 192, config._LIKO_H or 128 --The interal screen width.
  local _LIKO_X, _LIKO_Y = 0,0 --LIKO12 Screen padding in the HOST screen.
  
  local _HOST_W, _HOST_H = love.graphics.getDimensions() --The host window size.
  
  local _GIFSCALE = math.floor(config._GIFSCALE) or 2 --The gif scale factor (must be int).
  local _LIKOScale = math.floor(config._LIKOScale) or 3 --The default LIKO12 screen scale to the host screen scale.
  local _LIKOScaleX, _LIKOScaleY = 1,1
  
  local _FontChars = config._FontChars or 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"\'`-_/1234567890!?[](){}.,;:<>+=%#^*~ '
  local _Font = love.graphics.newImageFont(config._FontPath or "/Engine/font.png", _FontChars, config._FontExtraSpacing or 1)
  
  --Hook the resize function--
  events:register("love:resize",function(w,h) --Do some calculations
    _HOST_W, _HOST_H = w, h
    local TSX, TSY = w/_LIKO_W, h/_LIKO_H --TestScaleX, TestScaleY
    if TSX < TSY then
      _LIKOScaleX, _LIKOScaleY, _LIKOScale = w/_LIKO_W, w/_LIKO_W, w/_LIKO_W
      _LIKO_X, _LIKO_Y = 0, (_HOST_H-_LIKO_H*_LIKOScaleY)/2
    else
      _LIKOScaleX, _LIKOScaleY, _LIKOScale = h/_LIKO_H, h/_LIKO_H, h/_LIKO_H
      __LIKO_X, _LIKO_Y = (_HOST_W-_LIKO_W*_LIKOScaleX)/2, 0
    end
    --_ShouldDraw = true
  end)
  
  --Initialize the gpu--
  local _ScreenCanvas = love.graphics.newCanvas(_LIKO_W, _LIKO_H) --Create the screen canvas.
  _ScreenCanvas:setFilter("nearest") --Set the scaling filter to the nearest pixel.
  
  local _GifCanvas = love.graphics.newCanvas(_LIKO_W*_GIFSCALE,_LIKO_H*_GIFSCALE) --Create the gif canvas, used to apply the gif scale factor.
  _GifCanvas:setFilter("nearest") --Set the scaling filter to the nearest pixel.
  
  love.graphics.clear(0,0,0,255) --Clear the host screen.
  
  love.graphics.setCanvas(_ScreenCanvas) --Activate LIKO12 canvas.
  love.graphics.clear(0,0,0,255) --Clear LIKO12 screen for the first time.
  
  --love.graphics.translate(_ScreenTX,_ScreenTY) --Offset all the drawing opereations.
  
  event:trigger("love:resize", _HOST_W, _HOST_H) --Calculate LIKO12 scale to the host window for the first time.
  
  love.graphics.setLineStyle("rough") --Set the line style.
  love.graphics.setLineJoin("miter") --Set the line join style.
  
  love.graphics.setFont(_Font) --Apply the default font.
  
  --api.clear() --Clear the canvas for the first time
  --api.stroke(1) --Set the line width to 1
  
  --The api starts here--
  local GPU = {}
  
  return GPU
end