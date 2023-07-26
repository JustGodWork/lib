local _RenderSprite = lib.ui.RenderSprite;
local _RenderText = lib.ui.RenderText;

---@type table
local SettingsButton = {
    Rectangle = { Y = 0, Width = 431, Height = 38 },
    Text = { X = 8, Y = 3, Scale = 0.33 },
    LeftBadge = { Y = -2, Width = 40, Height = 40 },
    RightBadge = { X = 385, Y = -2, Width = 40, Height = 40 },
    RightText = { X = 420, Y = 3, Scale = 0.33 },
    SelectedSprite = { Dictionary = "commonmenu", Texture = "gradient_nav", Y = 0, Width = 431, Height = 38 },
}

---@type table
local SettingsCheckbox = {
    Dictionary = "commonmenu", Textures = {
        "shop_box_blankb", -- 1
        "shop_box_tickb", -- 2
        "shop_box_blank", -- 3
        "shop_box_tick", -- 4
        "shop_box_crossb", -- 5
        "shop_box_cross", -- 6
    },
    X = 380, Y = -6, Width = 50, Height = 50
}

lib.ui.CheckboxStyle = {
    Tick = 1,
    Cross = 2
}

---StyleCheckBox
---@param Selected number
---@param Checked boolean
---@param Box number
---@param BoxSelect number
---@return nil
local function StyleCheckBox(Selected, Checked, Box, BoxSelect, OffSet)
    ---@type table
    local CurrentMenu = lib.ui.CurrentMenu;
    if OffSet == nil then
        OffSet = 0
    end
    if Selected then
        if Checked then
            _RenderSprite(SettingsCheckbox.Dictionary, SettingsCheckbox.Textures[Box], CurrentMenu.X + SettingsCheckbox.X + CurrentMenu.WidthOffset - OffSet, CurrentMenu.Y + SettingsCheckbox.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, SettingsCheckbox.Width, SettingsCheckbox.Height)
        else
            _RenderSprite(SettingsCheckbox.Dictionary, SettingsCheckbox.Textures[1], CurrentMenu.X + SettingsCheckbox.X + CurrentMenu.WidthOffset - OffSet, CurrentMenu.Y + SettingsCheckbox.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, SettingsCheckbox.Width, SettingsCheckbox.Height)
        end
    else
        if Checked then
            _RenderSprite(SettingsCheckbox.Dictionary, SettingsCheckbox.Textures[BoxSelect], CurrentMenu.X + SettingsCheckbox.X + CurrentMenu.WidthOffset - OffSet, CurrentMenu.Y + SettingsCheckbox.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, SettingsCheckbox.Width, SettingsCheckbox.Height)
        else
            _RenderSprite(SettingsCheckbox.Dictionary, SettingsCheckbox.Textures[3], CurrentMenu.X + SettingsCheckbox.X + CurrentMenu.WidthOffset - OffSet, CurrentMenu.Y + SettingsCheckbox.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, SettingsCheckbox.Width, SettingsCheckbox.Height)
        end
    end
end


function UIItems:Checkbox(Label, Description, Checked, Style, Actions)
    ---@type table
    local CurrentMenu = lib.ui.CurrentMenu;
    if CurrentMenu ~= nil then
        if CurrentMenu then

            ---@type number
            local Option = lib.ui.Options + 1
            if CurrentMenu.Pagination.Minimum <= Option and CurrentMenu.Pagination.Maximum >= Option then
                ---@type number
                local Active = CurrentMenu.Index == Option
                local LeftBadgeOffset = ((Style.LeftBadge == lib.ui.BadgeStyle.None) and 0 or 27)
                local RightBadgeOffset = ((Style.RightBadge == lib.ui.BadgeStyle.None or Style.RightBadge == nil) and 0 or 32)
                local BoxOffset = 0
                lib.ui.SafeZone(CurrentMenu)

                local Hovered = false;

                ---@type boolean
                if CurrentMenu.EnableMouse == true and (CurrentMenu.CursorStyle == 0) or (CurrentMenu.CursorStyle == 1) then
                    Hovered = lib.ui.MouseBounds(CurrentMenu, Active, Option, SettingsButton);
                end
                if Active then
                    _RenderSprite(SettingsButton.SelectedSprite.Dictionary, SettingsButton.SelectedSprite.Texture, CurrentMenu.X, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, SettingsButton.SelectedSprite.Width + CurrentMenu.WidthOffset, SettingsButton.SelectedSprite.Height)
                end

                if type(Style) == "table" then
                    if Style.Enabled == true or Style.Enabled == nil then
                        if Active then
                            _RenderText(Label, CurrentMenu.X + SettingsButton.Text.X + LeftBadgeOffset, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, 0, SettingsButton.Text.Scale, 0, 0, 0, 255)
                        else
                            _RenderText(Label, CurrentMenu.X + SettingsButton.Text.X + LeftBadgeOffset, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, 0, SettingsButton.Text.Scale, 245, 245, 245, 255)
                        end
                        if type(Style) == 'table' then
                            if Style.LeftBadge ~= lib.ui.BadgeStyle.None then
                                local BadgeData = Style.LeftBadge and Style.LeftBadge(Active) or lib.ui.BadgeStyle.Star(Active)
                                _RenderSprite(BadgeData.BadgeDictionary or "commonmenu", BadgeData.BadgeTexture or "", CurrentMenu.X, CurrentMenu.Y + SettingsButton.LeftBadge.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, SettingsButton.LeftBadge.Width, SettingsButton.LeftBadge.Height, 0, BadgeData.BadgeColour and BadgeData.BadgeColour.R or 255, BadgeData.BadgeColour and BadgeData.BadgeColour.G or 255, BadgeData.BadgeColour and BadgeData.BadgeColour.B or 255, BadgeData.BadgeColour and BadgeData.BadgeColour.A or 255)
                            end
                            if Style.RightBadge ~= nil then
                                if Style.RightBadge ~= lib.ui.BadgeStyle.None then
                                    local BadgeData = Style.RightBadge(Active)
                                    _RenderSprite(BadgeData.BadgeDictionary or "commonmenu", BadgeData.BadgeTexture or "", CurrentMenu.X + SettingsButton.RightBadge.X + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsButton.RightBadge.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, SettingsButton.RightBadge.Width, SettingsButton.RightBadge.Height, 0, BadgeData.BadgeColour and BadgeData.BadgeColour.R or 255, BadgeData.BadgeColour and BadgeData.BadgeColour.G or 255, BadgeData.BadgeColour and BadgeData.BadgeColour.B or 255, BadgeData.BadgeColour and BadgeData.BadgeColour.A or 255)
                                end
                            end
                        end
                    else
                        ---@type table
                        local LeftBadge = lib.ui.BadgeStyle.Lock
                        ---@type number
                        local LeftBadgeOffset = ((LeftBadge == lib.ui.BadgeStyle.None or LeftBadge == nil) and 0 or 27)

                        if Active then
                            _RenderText(Label, CurrentMenu.X + SettingsButton.Text.X + LeftBadgeOffset, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, 0, SettingsButton.Text.Scale, 0, 0, 0, 255)
                        else
                            _RenderText(Label, CurrentMenu.X + SettingsButton.Text.X + LeftBadgeOffset, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, 0, SettingsButton.Text.Scale, 163, 159, 148, 255)
                        end

                        if LeftBadge ~= lib.ui.BadgeStyle.None and LeftBadge ~= nil then
                            local BadgeData = LeftBadge(Active)

                            _RenderSprite(BadgeData.BadgeDictionary or "commonmenu", BadgeData.BadgeTexture or "", CurrentMenu.X, CurrentMenu.Y + SettingsButton.LeftBadge.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, SettingsButton.LeftBadge.Width, SettingsButton.LeftBadge.Height, 0, BadgeData.BadgeColour.R or 255, BadgeData.BadgeColour.G or 255, BadgeData.BadgeColour.B or 255, BadgeData.BadgeColour.A or 255)
                        end
                    end

                    if Style.Enabled == true or Style.Enabled == nil then
                        if Active then
                            if Style.RightLabel ~= nil and Style.RightLabel ~= "" then

                                _RenderText(Style.RightLabel, CurrentMenu.X + SettingsButton.RightText.X - RightBadgeOffset + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsButton.RightText.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, 0, SettingsButton.RightText.Scale, 0, 0, 0, 255, 2)
                                BoxOffset = MeasureStringWidth(Style.RightLabel, 0, 0.35)
                            end
                        else
                            if Style.RightLabel ~= nil and Style.RightLabel ~= "" then
                                _RenderText(Style.RightLabel, CurrentMenu.X + SettingsButton.RightText.X - RightBadgeOffset + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsButton.RightText.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, 0, SettingsButton.RightText.Scale, 245, 245, 245, 255, 2)
                                BoxOffset = MeasureStringWidth(Style.RightLabel, 0, 0.35)
                            end
                        end
                    end

                    BoxOffset = RightBadgeOffset + BoxOffset
                    if Style.Style ~= nil then
                        if Style.Style == lib.ui.CheckboxStyle.Tick then
                            StyleCheckBox(Active, Checked, 2, 4, BoxOffset)
                        elseif Style.Style == lib.ui.CheckboxStyle.Cross then
                            StyleCheckBox(Active, Checked, 5, 6, BoxOffset)
                        else
                            StyleCheckBox(Active, Checked, 2, 4, BoxOffset)
                        end
                    else
                        StyleCheckBox(Active, Checked, 2, 4, BoxOffset)
                    end

                    if Active and (CurrentMenu.Controls.Select.Active or (Hovered and CurrentMenu.Controls.Click.Active)) and (Style.Enabled == true or Style.Enabled == nil) then
                        local Audio = lib.ui.Settings.Audio
                        lib.ui.PlaySound(Audio[Audio.Use].Select.audioName, Audio[Audio.Use].Select.audioRef)
                        Checked = not Checked
                        if (Checked) then
                            if (Actions.onChecked ~= nil) then
                                Actions.onChecked();
                            end
                        else
                            if (Actions.onUnChecked ~= nil) then
                                Actions.onUnChecked();
                            end
                        end
                    end
                else
                    error("UICheckBox Style is not a `table`")
                end

                lib.ui.ItemOffset = lib.ui.ItemOffset + SettingsButton.Rectangle.Height

                lib.ui.SetDescription(CurrentMenu, Description, Active)

                local Selected = (CurrentMenu.Controls.Select.Active or (Hovered and CurrentMenu.Controls.Click.Active)) and Active
                if (Selected) then
                    if (Actions.onSelected ~= nil) then
                        Actions.onSelected(Checked);
                    end
                end

            end
            lib.ui.Options = lib.ui.Options + 1
        end
    end
end


