local _IsDisabledControlPressed = IsDisabledControlPressed;
local _GetControlNormal = GetControlNormal;
local _RenderRectangle = lib.ui.RenderRectangle;
local _RenderSprite = lib.ui.RenderSprite;
local _RenderText = lib.ui.RenderText;

local Percentage = {
    Background = { Dictionary = "commonmenu", Texture = "gradient_bgd", Y = 4, Width = 431, Height = 76 },
    Bar = { X = 9, Y = 50, Width = 413, Height = 10 },
    Text = {
        Left = { X = 55, Y = 15, Scale = 0.35 },
        Middle = { X = 215.5, Y = 15, Scale = 0.35 },
        Right = { X = 378, Y = 15, Scale = 0.35 },
    },
}

---PercentagePanel
---@param Percent number
---@param HeaderText string
---@param MinText string
---@param MaxText string
---@param Callback function
---@param Index number
---@return nil
---@public
function UIPanels:PercentagePanel(Percent, HeaderText, MinText, MaxText, Action, Index)
    local CurrentMenu = lib.ui.CurrentMenu

    if CurrentMenu ~= nil then
        if CurrentMenu and (Index == nil or (CurrentMenu.Index == Index)) then

            ---@type boolean
            local Hovered = lib.ui.IsMouseInBounds(CurrentMenu.X + Percentage.Bar.X + CurrentMenu.SafeZoneSize.X, CurrentMenu.Y + Percentage.Bar.Y + CurrentMenu.SafeZoneSize.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset - 4, Percentage.Bar.Width + CurrentMenu.WidthOffset, Percentage.Bar.Height + 8)

            ---@type boolean
            local Selected = false

            ---@type number
            local Progress = Percentage.Bar.Width

            if Percent < 0.0 then
                Percent = 0.0
            elseif Percent > 1.0 then
                Percent = 1.0
            end

            Progress = Progress * Percent

            _RenderSprite(Percentage.Background.Dictionary, Percentage.Background.Texture, CurrentMenu.X, CurrentMenu.Y + Percentage.Background.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, Percentage.Background.Width + CurrentMenu.WidthOffset, Percentage.Background.Height)
            _RenderRectangle(CurrentMenu.X + Percentage.Bar.X + (CurrentMenu.WidthOffset / 2), CurrentMenu.Y + Percentage.Bar.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, Percentage.Bar.Width, Percentage.Bar.Height, 87, 87, 87, 255)
            _RenderRectangle(CurrentMenu.X + Percentage.Bar.X + (CurrentMenu.WidthOffset / 2), CurrentMenu.Y + Percentage.Bar.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, Progress, Percentage.Bar.Height, 245, 245, 245, 255)

            _RenderText(HeaderText or "Opacity", CurrentMenu.X + Percentage.Text.Middle.X + (CurrentMenu.WidthOffset / 2), CurrentMenu.Y + Percentage.Text.Middle.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, 0, Percentage.Text.Middle.Scale, 245, 245, 245, 255, 1)
            _RenderText(MinText or "0%", CurrentMenu.X + Percentage.Text.Left.X + (CurrentMenu.WidthOffset / 2), CurrentMenu.Y + Percentage.Text.Left.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, 0, Percentage.Text.Left.Scale, 245, 245, 245, 255, 1)
            _RenderText(MaxText or "100%", CurrentMenu.X + Percentage.Text.Right.X + (CurrentMenu.WidthOffset / 2), CurrentMenu.Y + Percentage.Text.Right.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, 0, Percentage.Text.Right.Scale, 245, 245, 245, 255, 1)

            if Hovered then
                if (_IsDisabledControlPressed(0, 24)) then
                    Selected = true

                    Progress = math.round(_GetControlNormal(2, 239) * 1920) - CurrentMenu.SafeZoneSize.X - (CurrentMenu.X + Percentage.Bar.X + (CurrentMenu.WidthOffset / 2))

                    if Progress < 0 then
                        Progress = 0
                    elseif Progress > (Percentage.Bar.Width) then
                        Progress = Percentage.Bar.Width
                    end

                    Percent = math.round(Progress / Percentage.Bar.Width, 2)
                    if (Action.onProgressChange ~= nil) then
                        Action.onProgressChange(Percent, Progress);
                    end
                end
            end

            lib.ui.ItemOffset = lib.ui.ItemOffset + Percentage.Background.Height + Percentage.Background.Y

            if Hovered and Selected then
                local Audio = lib.ui.Settings.Audio
                lib.ui.PlaySound(Audio[Audio.Use].Slider.audioName, Audio[Audio.Use].Slider.audioRef, true)
                if (Action.onSelected ~= nil) then
                    Action.onSelected(Percent, Progress);
                end
            end
        end
    end
end
