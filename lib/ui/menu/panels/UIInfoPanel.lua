--[[
--Created Date: Friday August 26th 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Friday August 26th 2022 12:51:40 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of JustGodWork project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

local _RenderRectangle = lib.ui.RenderRectangle;
local _RenderText = lib.ui.RenderText;

---@param Title string
---@param LeftText table
---@param RightText table
---@param Index number
---@param startAt number
function UIPanels:info(Title, LeftText, RightText, Index, startAt)

    local CurrentMenu = lib.ui.CurrentMenu
    local LineCount = (RightText and LeftText and #LeftText >= #RightText and #LeftText or LeftText and #LeftText) or 1;

    if (CurrentMenu) then

        if (not Index and not startAt) or ((not Index and startAt) and CurrentMenu.Index >= startAt) or ((not startAt and Index) and CurrentMenu.Index == Index) then
            if Title ~= nil then
                _RenderText("~h~" .. Title .. "~h~", 330 + 20 + 100, 7, 0, 0.34, 255, 255, 255, 255, 0)
            end
            if LeftText ~= nil then
                _RenderText(table.concat(LeftText, "\n"), 330 + 20 + 100, Title ~= nil and 37 or 7, 0, 0.25, 255, 255, 255, 255, 0)
            end
            if RightText ~= nil then
                _RenderText(table.concat(RightText, "\n"), 330 + 342 + 80, Title ~= nil and 37 or 7, 0, 0.25, 255, 255, 255, 255, 2)
            end
            _RenderRectangle(320 + 10 + 100, 0, 342, Title ~= nil and 50 + (LineCount * 20), 0, 0, 0, 160)
        end

    end

end