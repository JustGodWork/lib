local _RenderRectangle = lib.ui.RenderRectangle;
local _RenderText = lib.ui.RenderText;

local Statistics = {
    Background = { Dictionary = "commonmenu", Texture = "gradient_bgd", Y = 4, Width = 431, Height = 42 },
    Text = {
        Left = { X = -40, Y = 15, Scale = 0.35 },
    },
    Bar = { Right = 8, Y = 27, Width = 200, Height = 10, OffsetRatio = 0.5 },
    Divider = {
        [1] = { X = 200, Y = 27, Width = 2, Height = 10 },
        [2] = { X = 200, Y = 27, Width = 2, Height = 10 },
        [3] = { X = 200, Y = 27, Width = 2, Height = 10 },
        [4] = { X = 200, Y = 27, Width = 2, Height = 10 },
        [5] = { X = 200, Y = 27, Width = 2, Height = 10 },
    }
}

function UIPanels:StatisticPanel(Percent, Text, Index)
    local CurrentMenu = lib.ui.CurrentMenu
    if CurrentMenu ~= nil then
        if CurrentMenu and (Index == nil or (CurrentMenu.Index == Index)) then

            ---@type number
            local BarWidth = Statistics.Bar.Width + CurrentMenu.WidthOffset * Statistics.Bar.OffsetRatio

            _RenderRectangle(CurrentMenu.X, CurrentMenu.Y + Statistics.Background.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset + (lib.ui.StatisticPanelCount * 42), Statistics.Background.Width + CurrentMenu.WidthOffset, Statistics.Background.Height, 0, 0, 0, 170)
            _RenderText(Text or "", CurrentMenu.X + 8.0, (lib.ui.StatisticPanelCount * 40) + CurrentMenu.Y + Statistics.Text.Left.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, 0, Statistics.Text.Left.Scale, 245, 245, 245, 255, 0)
            _RenderRectangle(CurrentMenu.X + lib.ui.Settings.Items.Title.Background.Width - BarWidth - Statistics.Bar.Right + CurrentMenu.WidthOffset, (lib.ui.StatisticPanelCount * 40) + CurrentMenu.Y + Statistics.Bar.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, BarWidth, Statistics.Bar.Height, 87, 87, 87, 255)
            _RenderRectangle(CurrentMenu.X + lib.ui.Settings.Items.Title.Background.Width - BarWidth - Statistics.Bar.Right + CurrentMenu.WidthOffset, (lib.ui.StatisticPanelCount * 40) + CurrentMenu.Y + Statistics.Bar.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, Percent * BarWidth, Statistics.Bar.Height, 255, 255, 255, 255)
            for i = 1, #Statistics.Divider, 1 do
                _RenderRectangle((CurrentMenu.X + lib.ui.Settings.Items.Title.Background.Width - BarWidth - Statistics.Bar.Right) + i * ((BarWidth - (#Statistics.Divider / Statistics.Divider[i].Width)) / (#Statistics.Divider + 1)) + CurrentMenu.WidthOffset, (lib.ui.StatisticPanelCount * 40) + CurrentMenu.Y + Statistics.Divider[i].Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, Statistics.Divider[i].Width, Statistics.Divider[i].Height, 0, 0, 0, 255)
            end
            lib.ui.StatisticPanelCount = lib.ui.StatisticPanelCount + 1
        end
    end
end

function UIPanels:StatisticPanelAdvanced(Text, Percent, RGBA1, Percent2, RGBA2, RGBA3, Index)
    local CurrentMenu = lib.ui.CurrentMenu
    if CurrentMenu ~= nil then
        if CurrentMenu and (Index == nil or (CurrentMenu.Index == Index)) then

            RGBA1 = RGBA1 or { 255, 255, 255, 255 }
            local BarWidth = Statistics.Bar.Width + CurrentMenu.WidthOffset * Statistics.Bar.OffsetRatio

            ---@type number
            _RenderRectangle(CurrentMenu.X, CurrentMenu.Y + Statistics.Background.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset + (lib.ui.StatisticPanelCount * 42), Statistics.Background.Width + CurrentMenu.WidthOffset, Statistics.Background.Height, 0, 0, 0, 170)
            _RenderText(Text or "", CurrentMenu.X + 8.0, (lib.ui.StatisticPanelCount * 40) + CurrentMenu.Y + Statistics.Text.Left.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, 0, Statistics.Text.Left.Scale, 245, 245, 245, 255, 0)
            _RenderRectangle(CurrentMenu.X + lib.ui.Settings.Items.Title.Background.Width - BarWidth - Statistics.Bar.Right + CurrentMenu.WidthOffset, (lib.ui.StatisticPanelCount * 40) + CurrentMenu.Y + Statistics.Bar.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, BarWidth, Statistics.Bar.Height, 87, 87, 87, 255)
            _RenderRectangle(CurrentMenu.X + lib.ui.Settings.Items.Title.Background.Width - BarWidth - Statistics.Bar.Right + CurrentMenu.WidthOffset, (lib.ui.StatisticPanelCount * 40) + CurrentMenu.Y + Statistics.Bar.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, Percent * BarWidth, Statistics.Bar.Height, RGBA1[1], RGBA1[2], RGBA1[3], RGBA1[4])
            RGBA2 = RGBA2 or { 0, 153, 204, 255 }
            RGBA3 = RGBA3 or { 185, 0, 0, 255 }

            if Percent2 and Percent2 > 0 then
                local X = CurrentMenu.X + lib.ui.Settings.Items.Title.Background.Width - BarWidth - Statistics.Bar.Right + CurrentMenu.WidthOffset + Percent * BarWidth
                _RenderRectangle(X, (lib.ui.StatisticPanelCount * 40) + CurrentMenu.Y + Statistics.Bar.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, Percent2 * BarWidth, Statistics.Bar.Height, RGBA2[1], RGBA2[2], RGBA2[3], RGBA2[4])
            elseif Percent2 and Percent2 < 0 then
                local X = CurrentMenu.X + lib.ui.Settings.Items.Title.Background.Width - BarWidth - Statistics.Bar.Right + CurrentMenu.WidthOffset + Percent * BarWidth
                _RenderRectangle(X, (lib.ui.StatisticPanelCount * 40) + CurrentMenu.Y + Statistics.Bar.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, Percent2 * BarWidth, Statistics.Bar.Height, RGBA3[1], RGBA3[2], RGBA3[3], RGBA3[4])
            end

            for i = 1, #Statistics.Divider, 1 do
                _RenderRectangle((CurrentMenu.X + lib.ui.Settings.Items.Title.Background.Width - BarWidth - Statistics.Bar.Right) + i * ((BarWidth - (#Statistics.Divider / Statistics.Divider[i].Width)) / (#Statistics.Divider + 1)) + CurrentMenu.WidthOffset, (lib.ui.StatisticPanelCount * 40) + CurrentMenu.Y + Statistics.Divider[i].Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, Statistics.Divider[i].Width, Statistics.Divider[i].Height, 0, 0, 0, 255)
            end

            lib.ui.StatisticPanelCount = lib.ui.StatisticPanelCount + 1
        end
    end
end

