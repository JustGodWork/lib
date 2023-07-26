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
};

---@type table
local SettingsList = {
    LeftArrow = { Dictionary = "commonmenu", Texture = "arrowleft", X = 378, Y = 3, Width = 30, Height = 30 },
    RightArrow = { Dictionary = "commonmenu", Texture = "arrowright", X = 400, Y = 3, Width = 30, Height = 30 },
    Text = { X = 403, Y = 3, Scale = 0.35 },
};

local config_color = lib.color.get_current();

function UIItems:List(Label, Items, Index, Description, Style, Enabled, Actions, Submenu)
    ---@type table
    local CurrentMenu = lib.ui.CurrentMenu;

    if CurrentMenu ~= nil then
        if CurrentMenu then

            ---@type number
            local Option = lib.ui.Options + 1

            if CurrentMenu.Pagination.Minimum <= Option and CurrentMenu.Pagination.Maximum >= Option then

                ---@type number
                local Selected = CurrentMenu.Index == Option

                ---@type boolean
                local LeftArrowHovered, RightArrowHovered = false, false

                lib.ui.SafeZone(CurrentMenu)

                local Hovered = false;
                local LeftBadgeOffset = ((Style.LeftBadge == lib.ui.BadgeStyle.None) and 0 or 27)
                local RightBadgeOffset = ((Style.RightBadge == lib.ui.BadgeStyle.None or Style.RightBadge == nil) and 0 or 32)
                local RightOffset = 0
                ---@type boolean
                if CurrentMenu.EnableMouse == true and (CurrentMenu.CursorStyle == 0) or (CurrentMenu.CursorStyle == 1) then
                    Hovered = lib.ui.MouseBounds(CurrentMenu, Selected, Option, SettingsButton);
                end
                local ListText = (type(Items[Index]) == "table") and string.format("← %s%s~s~ →", config_color, Items[Index]._label) or string.format("← %s%s~s~ →", config_color, Items[Index]) or "undefined"

                if Selected then
                    _RenderSprite(SettingsButton.SelectedSprite.Dictionary, SettingsButton.SelectedSprite.Texture, CurrentMenu.X, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, SettingsButton.SelectedSprite.Width + CurrentMenu.WidthOffset, SettingsButton.SelectedSprite.Height)
                end
                if Enabled == true or Enabled == nil then
                    if Selected then
                        if Style.RightLabel ~= nil and Style.RightLabel ~= "" then
                            _RenderText(Style.RightLabel, CurrentMenu.X + SettingsButton.RightText.X - RightBadgeOffset + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsButton.RightText.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, 0, SettingsButton.RightText.Scale, 0, 0, 0, 255, 2)
                            RightOffset = MeasureStringWidth(Style.RightLabel, 0, 0.35)
                        end
                    else
                        if Style.RightLabel ~= nil and Style.RightLabel ~= "" then
                            RightOffset = MeasureStringWidth(Style.RightLabel, 0, 0.35)
                            _RenderText(Style.RightLabel, CurrentMenu.X + SettingsButton.RightText.X - RightBadgeOffset + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsButton.RightText.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, 0, SettingsButton.RightText.Scale, 245, 245, 245, 255, 2)
                        end
                    end
                end
                RightOffset = RightBadgeOffset * 1.3 + RightOffset
                if Enabled == true or Enabled == nil then
                    if Selected then
                        ListText = (type(Items[Index]) == "table") and string.format("← ~s~%s~s~ →", Items[Index]._label) or string.format("← ~s~%s~s~ →", Items[Index]) or "undefined"
                        _RenderText(Label, CurrentMenu.X + SettingsButton.Text.X + LeftBadgeOffset, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, 0, SettingsButton.Text.Scale, 0, 0, 0, 255)
                        _RenderText(ListText, CurrentMenu.X + SettingsList.Text.X + 15 + CurrentMenu.WidthOffset - RightOffset, CurrentMenu.Y + SettingsList.Text.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, 0, SettingsList.Text.Scale, 0, 0, 0, 255, 2)
                    else
                        ListText = (type(Items[Index]) == "table") and string.format("← %s%s~s~ →", config_color, Items[Index]._label) or string.format("← %s%s~s~ →", config_color, Items[Index]) or "undefined"
                        _RenderText(Label, CurrentMenu.X + SettingsButton.Text.X + LeftBadgeOffset, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, 0, SettingsButton.Text.Scale, 245, 245, 245, 255)
                        _RenderText(ListText, CurrentMenu.X + SettingsList.Text.X + 15 + CurrentMenu.WidthOffset - RightOffset, CurrentMenu.Y + SettingsList.Text.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, 0, SettingsList.Text.Scale, 245, 245, 245, 255, 2)
                    end
                else
                    if Selected then
                        _RenderText(Label, CurrentMenu.X + SettingsButton.Text.X + LeftBadgeOffset, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, 0, SettingsButton.Text.Scale, 163, 159, 148, 255)
                        ListText = (type(Items[Index]) == "table") and string.format("← %s%s~s~ →", config_color, Items[Index]._label) or string.format("← %s%s~s~ →", config_color, Items[Index]) or "undefined"
                        _RenderText(ListText, CurrentMenu.X + SettingsList.Text.X + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsList.Text.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, 0, SettingsList.Text.Scale, 163, 159, 148, 255, 2)
                    else
                        _RenderText(Label, CurrentMenu.X + SettingsButton.Text.X + LeftBadgeOffset, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, 0, SettingsButton.Text.Scale, 163, 159, 148, 255)
                        ListText = (type(Items[Index]) == "table") and string.format("← %s%s~s~ →", config_color, Items[Index]._label) or string.format("← %s%s~s~ →", config_color, Items[Index]) or "undefined"
                        _RenderText(ListText, CurrentMenu.X + SettingsList.Text.X + 15 + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsList.Text.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, 0, SettingsList.Text.Scale, 163, 159, 148, 255, 2)
                    end
                end

                if type(Style) == "table" then
                    if Style.Enabled == true or Style.Enabled == nil then
                        if type(Style) == 'table' then
                            if Style.LeftBadge ~= lib.ui.BadgeStyle.None then
                                local BadgeData = Style.LeftBadge and Style.LeftBadge(Selected) or lib.ui.BadgeStyle.Star(Selected)
                                _RenderSprite(BadgeData.BadgeDictionary or "commonmenu", BadgeData.BadgeTexture or "", CurrentMenu.X, CurrentMenu.Y + SettingsButton.LeftBadge.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, SettingsButton.LeftBadge.Width, SettingsButton.LeftBadge.Height, 0, BadgeData.BadgeColour and BadgeData.BadgeColour.R or 255, BadgeData.BadgeColour and BadgeData.BadgeColour.G or 255, BadgeData.BadgeColour and BadgeData.BadgeColour.B or 255, BadgeData.BadgeColour and BadgeData.BadgeColour.A or 255)
                            end

                            if Style.RightBadge ~= nil then
                                if Style.RightBadge ~= lib.ui.BadgeStyle.None then
                                    local BadgeData = Style.RightBadge(Selected)

                                    _RenderSprite(BadgeData.BadgeDictionary or "commonmenu", BadgeData.BadgeTexture or "", CurrentMenu.X + SettingsButton.RightBadge.X + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsButton.RightBadge.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, SettingsButton.RightBadge.Width, SettingsButton.RightBadge.Height, 0, BadgeData.BadgeColour and BadgeData.BadgeColour.R or 255, BadgeData.BadgeColour and BadgeData.BadgeColour.G or 255, BadgeData.BadgeColour and BadgeData.BadgeColour.B or 255, BadgeData.BadgeColour and BadgeData.BadgeColour.A or 255)
                                end
                            end
                        end
                    else
                        ---@type table
                        local LeftBadge = lib.ui.BadgeStyle.Lock
                        ---@type number
                        if LeftBadge ~= lib.ui.BadgeStyle.None and LeftBadge ~= nil then
                            local BadgeData = LeftBadge(Selected)

                            _RenderSprite(BadgeData.BadgeDictionary or "commonmenu", BadgeData.BadgeTexture or "", CurrentMenu.X, CurrentMenu.Y + SettingsButton.LeftBadge.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, SettingsButton.LeftBadge.Width, SettingsButton.LeftBadge.Height, 0, BadgeData.BadgeColour.R or 255, BadgeData.BadgeColour.G or 255, BadgeData.BadgeColour.B or 255, BadgeData.BadgeColour.A or 255)
                        end
                    end
                else
                    error("UICheckBox Style is not a `table`")
                end

                LeftArrowHovered = lib.ui.IsMouseInBounds(CurrentMenu.X + SettingsList.Text.X + CurrentMenu.WidthOffset - RightOffset + CurrentMenu.SafeZoneSize.X, CurrentMenu.Y + SettingsList.Text.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset + 2.5  + CurrentMenu.SafeZoneSize.Y , 15, 22.5)

                RightArrowHovered = lib.ui.IsMouseInBounds(CurrentMenu.X + SettingsList.Text.X + CurrentMenu.WidthOffset + CurrentMenu.SafeZoneSize.X - RightOffset - MeasureStringWidth(ListText, 0, SettingsList.Text.Scale), CurrentMenu.Y + SettingsList.Text.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset + 2.5 + CurrentMenu.SafeZoneSize.Y , 15, 22.5)
                lib.ui.ItemOffset = lib.ui.ItemOffset + SettingsButton.Rectangle.Height

                lib.ui.SetDescription(CurrentMenu, Description, Selected);

                if Enabled == true or Enabled == nil then
                    if Selected and (CurrentMenu.Controls.Left.Active or (CurrentMenu.Controls.Click.Active and LeftArrowHovered)) and not (CurrentMenu.Controls.Right.Active or (CurrentMenu.Controls.Click.Active and RightArrowHovered)) then
                        Index = Index - 1
                        if Index < 1 then
                            Index = #Items
                        end
                        if (Actions.onListChange ~= nil) then
                            Actions.onListChange(Index, Items[Index]);
                        end
                        local Audio = lib.ui.Settings.Audio
                        lib.ui.PlaySound(Audio[Audio.Use].LeftRight.audioName, Audio[Audio.Use].LeftRight.audioRef)
                    elseif Selected and (CurrentMenu.Controls.Right.Active or (CurrentMenu.Controls.Click.Active and RightArrowHovered)) and not (CurrentMenu.Controls.Left.Active or (CurrentMenu.Controls.Click.Active and LeftArrowHovered)) then
                        Index = Index + 1
                        if Index > #Items then
                            Index = 1
                        end
                        if (Actions.onListChange ~= nil) then
                            Actions.onListChange(Index, Items[Index]);
                        end
                        local Audio = lib.ui.Settings.Audio
                        lib.ui.PlaySound(Audio[Audio.Use].LeftRight.audioName, Audio[Audio.Use].LeftRight.audioRef)
                    end

                    if Selected and (CurrentMenu.Controls.Select.Active or ((Hovered and CurrentMenu.Controls.Click.Active) and (not LeftArrowHovered and not RightArrowHovered))) then
                        local Audio = lib.ui.Settings.Audio
                        lib.ui.PlaySound(Audio[Audio.Use].Select.audioName, Audio[Audio.Use].Select.audioRef)

                        if (Actions.onSelected ~= nil) then
                            Actions.onSelected(Index, Items[Index]);
                        end

                        if Submenu ~= nil and type(Submenu) == "table" then
                            lib.ui.NextMenu = Submenu.id and Submenu or Submenu[Index]
                        end
                    elseif Selected then
                        if(Actions.onActive ~= nil) then
                            Actions.onActive()
                        end
                    end
                end
            end

            lib.ui.Options = lib.ui.Options + 1
        end
    end
end
