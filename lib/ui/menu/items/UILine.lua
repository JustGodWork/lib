--[[
--Created Date: Friday June 24th 2022
--Author: JustGod
--Made with ❤
-------
--Last Modified: Friday June 24th 2022 2:10:55 pm
-------
--Copyright (c) 2022 JustGodWork, All Rights Reserved.
--This file is part of commonmenu project.
--Unauthorized using, copying, modifying and/or distributing of this file
--via any medium is strictly prohibited. This code is confidential.
-------
--]]

local _RenderSprite = lib.ui.RenderSprite;

---@type table
local SettingsButton = {
    Rectangle = { Y = 0, Width = 431, Height = 38 },
    Text = { X = 25, Y = 5, Scale = 0.33 },
    LeftBadge = { Y = -2, Width = 40, Height = 40 },
    RightBadge = { X = 385, Y = -2, Width = 40, Height = 40 },
    RightText = { X = 420, Y = 4, Scale = 0.35 },
    SelectedSprite = { Dictionary = "commonmenu", Texture = "gradient_nav", Y = 0, Width = 431, Height = 38 },
}

function UIItems:Line()
    local CurrentMenu = lib.ui.CurrentMenu
    if CurrentMenu ~= nil then
        if CurrentMenu then
            local Option = lib.ui.Options + 1
            if CurrentMenu.Pagination.Minimum <= Option and CurrentMenu.Pagination.Maximum >= Option then
                _RenderSprite("UILine", "line", CurrentMenu.X + SettingsButton.Text.X, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, 380, 30, 255, 230, 230, 230, 255)
                lib.ui.ItemOffset = lib.ui.ItemOffset + SettingsButton.Rectangle.Height
                if (CurrentMenu.Index == Option) then
                    if (lib.ui.LastControl) then
                        CurrentMenu.Index = Option - 1
                        if (CurrentMenu.Index < 1) then
                            CurrentMenu.Index = lib.ui.CurrentMenu.Options
                        end
                    else
                        CurrentMenu.Index = Option + 1
                    end
                end
            end
            lib.ui.Options = lib.ui.Options + 1
        end
    end
end