local _DrawRect = DrawRect;
local _tonumber = tonumber;

---lib.ui.RenderRectangle
---
--- Reference : https://github.com/iTexZoz/NativeUILua_Reloaded/blob/master/UIElements/UIResRectangle.lua#L84
---
---@param X number
---@param Y number
---@param Width number
---@param Height number
---@param R number
---@param G number
---@param B number
---@param A number
---@return nil
---@public
return function(X, Y, Width, Height, R, G, B, A)
    local X, Y, Width, Height = (_tonumber(X) or 0) / 1920, (_tonumber(Y) or 0) / 1080, (_tonumber(Width) or 0) / 1920, (_tonumber(Height) or 0) / 1080
    return _DrawRect(X + Width * 0.5, Y + Height * 0.5, Width, Height, _tonumber(R) or 255, _tonumber(G) or 255, _tonumber(B) or 255, _tonumber(A) or 255)
end
