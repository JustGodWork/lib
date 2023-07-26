---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by iTexZ.
--- DateTime: 05/11/2020 02:17
---

local _RenderSprite = lib.ui.RenderSprite;

local TextPanels = {
    Background = { Dictionary = "commonmenu", Texture = "gradient_bgd", Y = 4, Width = 431, Height = 42 },
}

---@type UIPanels
function UIPanels:RenderSprite(Dictionary, Texture)
    local CurrentMenu = lib.ui.CurrentMenu
    if CurrentMenu ~= nil then
        if CurrentMenu then
            _RenderSprite(Dictionary, Texture, CurrentMenu.X, CurrentMenu.Y + TextPanels.Background.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset + (lib.ui.StatisticPanelCount * 42), TextPanels.Background.Width + CurrentMenu.WidthOffset, TextPanels.Background.Height + 200, 0, 255, 255, 255, 255);
            lib.ui.StatisticPanelCount = lib.ui.StatisticPanelCount + 1
        end
    end
end
