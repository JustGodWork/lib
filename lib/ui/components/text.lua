local _BeginTextCommandWidth = BeginTextCommandWidth;
local _AddTextComponentSubstringPlayerName = AddTextComponentSubstringPlayerName;
local _SetTextFont = SetTextFont;
local _SetTextScale = SetTextScale;
local _EndTextCommandGetWidth = EndTextCommandGetWidth;
local _BeginTextCommandDisplayText = BeginTextCommandDisplayText;
local _SetTextCentre = SetTextCentre;
local _SetTextRightJustify = SetTextRightJustify;
local _SetTextWrap = SetTextWrap;
local _SetTextColour = SetTextColour;
local _SetTextDropShadow = _SetTextDropShadow;
local _SetTextOutline = SetTextOutline;
local _BeginTextCommandLineCount = BeginTextCommandLineCount;
local _GetTextScreenLineCount = GetTextScreenLineCount;
local _EndTextCommandDisplayText = EndTextCommandDisplayText;

---StringToArray
---
--- Reference : Frazzle <3
---
---@param str string
---@return table, number
function StringToArray(str)
    local charCount = #str;
    local strCount = math.ceil(charCount / 20);
    local strings = {};
    local count = 0;

    for i = 1, strCount do
        local start = (i - 1) * 99 + 1
        local clamp = math.clamp(#string.sub(str, start), 0, 20)
        local finish = ((i ~= 1) and (start - 1) or 0) + clamp

        strings[i] = string.sub(str, start, finish)
        count = count + 1;
    end

    return strings, count;
end

---MeasureStringWidth
---
--- Reference : Frazzle <3
---
---@param str string
---@param font number
---@param scale number
---@return _G
---@public
function MeasureStringWidth(str, font, scale)
    _BeginTextCommandWidth("CELL_EMAIL_BCON")
    _AddTextComponentSubstringPlayerName(str)
    _SetTextFont(font or 0)
    _SetTextScale(1.0, scale or 0)
    return _EndTextCommandGetWidth(true) * 1920
end


---AddText
---
--- Reference : Frazzle <3
---
---@param str string
function AddText(str)
    local str = tostring(str)
    local charCount = #str

    if charCount < 100 then
        _AddTextComponentSubstringPlayerName(str)
    else
        local strings = StringToArray(str)

        for s = 1, #strings do
            _AddTextComponentSubstringPlayerName(strings[s])
        end
    end
end


---GetLineCount
---
--- Reference : Frazzle <3
---
---@param Text string
---@param X number
---@param Y number
---@param Font number
---@param Scale number
---@param R number
---@param G number
---@param B number
---@param A number
---@param Alignment string
---@param DropShadow boolean
---@param Outline boolean
---@param WordWrap number
---@return function
---@public
function GetLineCount(Text, X, Y, Font, Scale, R, G, B, A, Alignment, DropShadow, Outline, WordWrap)
    ---@type table
    local Text, X, Y = tostring(Text), (tonumber(X) or 0) / 1920, (tonumber(Y) or 0) / 1080
    SetTextFont(Font or 0)
    SetTextScale(1.0, Scale or 0)
    _SetTextColour(tonumber(R) or 255, tonumber(G) or 255, tonumber(B) or 255, tonumber(A) or 255)
    if DropShadow then
        _SetTextDropShadow()
    end
    if Outline then
        _SetTextOutline()
    end
    if Alignment ~= nil then
        if Alignment == 1 or Alignment == "Center" or Alignment == "Centre" then
            _SetTextCentre(true)
        elseif Alignment == 2 or Alignment == "Right" then
            _SetTextRightJustify(true)
        end
    end
    if tonumber(WordWrap) and tonumber(WordWrap) ~= 0 then
        if Alignment == 1 or Alignment == "Center" or Alignment == "Centre" then
            _SetTextWrap(X - ((WordWrap / 1920) / 2), X + ((WordWrap / 1920) / 2))
        elseif Alignment == 2 or Alignment == "Right" then
            _SetTextWrap(0, X)
        else
            _SetTextWrap(X, X + (WordWrap / 1920))
        end
    else
        if Alignment == 2 or Alignment == "Right" then
            _SetTextWrap(0, X)
        end
    end

    _BeginTextCommandLineCount("CELL_EMAIL_BCON")
    AddText(Text)
    return _GetTextScreenLineCount(X, Y)
end

---lib.ui.RenderText
---
--- Reference : https://github.com/iTexZoz/NativeUILua_Reloaded/blob/master/UIElements/UIResText.lua#L189
---
---@param Text string
---@param X number
---@param Y number
---@param Font number
---@param Scale number
---@param R number
---@param G number
---@param B number
---@param A number
---@param Alignment string
---@param DropShadow boolean
---@param Outline boolean
---@param WordWrap number
---@return nil
---@public
return function(Text, X, Y, Font, Scale, R, G, B, A, Alignment, DropShadow, Outline, WordWrap)
    ---@type table
    local Text, X, Y = tostring(Text), (tonumber(X) or 0) / 1920, (tonumber(Y) or 0) / 1080
    _SetTextFont(Font or 0)
    _SetTextScale(1.0, Scale or 0)
    _SetTextColour(tonumber(R) or 255, tonumber(G) or 255, tonumber(B) or 255, tonumber(A) or 255)
    if DropShadow then
        _SetTextDropShadow()
    end
    if Outline then
        SetTextOutline()
    end
    if Alignment ~= nil then
        if Alignment == 1 or Alignment == "Center" or Alignment == "Centre" then
            _SetTextCentre(true)
        elseif Alignment == 2 or Alignment == "Right" then
            _SetTextRightJustify(true)
        end
    end
    if tonumber(WordWrap) and tonumber(WordWrap) ~= 0 then
        if Alignment == 1 or Alignment == "Center" or Alignment == "Centre" then
            _SetTextWrap(X - ((WordWrap / 1920) / 2), X + ((WordWrap / 1920) / 2))
        elseif Alignment == 2 or Alignment == "Right" then
            _SetTextWrap(0, X)
        else
            _SetTextWrap(X, X + (WordWrap / 1920))
        end
    else
        if Alignment == 2 or Alignment == "Right" then
            _SetTextWrap(0, X)
        end
    end
    _BeginTextCommandDisplayText("CELL_EMAIL_BCON")
    AddText(Text)
    _EndTextCommandDisplayText(X, Y)
end
