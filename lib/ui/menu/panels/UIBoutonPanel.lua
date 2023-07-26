local _MeasureStringWidth = MeasureStringWidth;
local _RenderRectangle = lib.ui.RenderRectangle;
local _RenderText = lib.ui.RenderText;

local TextPanels = {
    Background = { Dictionary = "commonmenu", Texture = "gradient_bgd", Y = 4, Width = 431, Height = 42 },
    Text = {
        Left = { X = 8, Y = 10, Scale = 0.35 },
        Right = { X = 8, Y = 10, Scale = 0.35 },
    },
}

---BoutonPanel
---@param LeftText string
---@param RightText string
---@public
function UIPanels:ButtonPanel(LeftText, RightText, Index)
    local CurrentMenu = lib.ui.CurrentMenu
    if CurrentMenu ~= nil then
        local leftTextSize = _MeasureStringWidth(LeftText)
        if CurrentMenu and (Index == nil or (CurrentMenu.Index == Index)) then
            _RenderRectangle(CurrentMenu.X, CurrentMenu.Y + TextPanels.Background.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset + (lib.ui.StatisticPanelCount * 42), TextPanels.Background.Width + CurrentMenu.WidthOffset, TextPanels.Background.Height, 0, 0, 0, 170)
            _RenderText(LeftText or "", CurrentMenu.X + TextPanels.Text.Left.X, (lib.ui.StatisticPanelCount * 40) + CurrentMenu.Y + TextPanels.Text.Left.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, 0, TextPanels.Text.Left.Scale, 245, 245, 245, 255, 0)
            _RenderText(RightText or "", CurrentMenu.X + TextPanels.Background.Width + CurrentMenu.WidthOffset - leftTextSize, (lib.ui.StatisticPanelCount * 40) + CurrentMenu.Y + TextPanels.Text.Left.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, 0, TextPanels.Text.Left.Scale, 245, 245, 245, 255, 2)
            lib.ui.StatisticPanelCount = lib.ui.StatisticPanelCount + 1
        end
    end
end