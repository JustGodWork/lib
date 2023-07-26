local _HasStreamedTextureDictLoaded = HasStreamedTextureDictLoaded;
local _RequestStreamedTextureDict = RequestStreamedTextureDict;
local _DrawSprite = DrawSprite;
local _tonumber = tonumber;

---RenderSprite
---
--- Reference : https://github.com/iTexZoz/NativeUILua_Reloaded/blob/master/UIElements/Sprite.lua#L90
---
---@param TextureDictionary string
---@param TextureName string
---@param X number
---@param Y number
---@param Width number
---@param Height number
---@param Heading number
---@param R number
---@param G number
---@param B number
---@param A number
---@return nil
---@public
return function(TextureDictionary, TextureName, X, Y, Width, Height, Heading, R, G, B, A)
    ---@type number
    local X, Y, Width, Height = (_tonumber(X) or 0) / 1920, (_tonumber(Y) or 0) / 1080, (_tonumber(Width) or 0) / 1920, (_tonumber(Height) or 0) / 1080

    if not _HasStreamedTextureDictLoaded(TextureDictionary) then
        _RequestStreamedTextureDict(TextureDictionary, true)
    end

    _DrawSprite(TextureDictionary, TextureName, X + Width * 0.5, Y + Height * 0.5, Width, Height, Heading or 0, _tonumber(R) or 255, _tonumber(G) or 255, _tonumber(B) or 255, _tonumber(A) or 255)
end