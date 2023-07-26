local _RenderRectangle = lib.ui.RenderRectangle;
local _RenderSprite = lib.ui.RenderSprite;
local _RenderText = lib.ui.RenderText;

---@type table
local SettingsButton = {
    Rectangle = { Y = 0, Width = 431, Height = 38 },
    Text = { X = 8 + 27, Y = 3, Scale = 0.33 },
	LeftBadge = { Y = -2, Width = 40, Height = 40 },
    SelectedSprite = { Dictionary = "commonmenu", Texture = "gradient_nav", Y = 0, Width = 431, Height = 38 },
}

---@type table
local SettingsSlider = {
    Background = { X = 250, Y = 14.5, Width = 150, Height = 9 },
    Slider = { X = 250, Y = 14.5, Width = 75, Height = 9 },
    Divider = { X = 323.5, Y = 9, Width = 2.5, Height = 20 },
    LeftArrow = { Dictionary = "mpleaderboard", Texture = "leaderboard_female_icon", X = 215, Y = 0, Width = 40, Height = 40 },
    RightArrow = { Dictionary = "mpleaderboard", Texture = "leaderboard_male_icon", X = 395, Y = 0, Width = 40, Height = 40 },
}

local Items = {}

CreateThread(function()
    for i = 1, 10 do
        table.insert(Items, i)
    end
end);

function UIItems:UISliderHeritage(Label, ItemIndex, Description, Actions, Value)

    local CurrentMenu = lib.ui.CurrentMenu;
    local Audio = lib.ui.Settings.Audio

    if CurrentMenu ~= nil then
        if CurrentMenu then

            ---@type number
            local Option = lib.ui.Options + 1

            if CurrentMenu.Pagination.Minimum <= Option and CurrentMenu.Pagination.Maximum >= Option then

                ---@type number
                local value = Value or 0.1
                local Selected = CurrentMenu.Index == Option

                ---@type boolean
                local LeftArrowHovered, RightArrowHovered = false, false

                lib.ui.SafeZone(CurrentMenu)

                local Hovered = false;
                local RightOffset = 0

                ---@type boolean
                if CurrentMenu.EnableMouse == true and (CurrentMenu.CursorStyle == 0) or (CurrentMenu.CursorStyle == 1) then
                    Hovered = lib.ui.MouseBounds(CurrentMenu, Selected, Option, SettingsButton);
                end

                if Selected then
                    _RenderSprite(SettingsButton.SelectedSprite.Dictionary, SettingsButton.SelectedSprite.Texture, CurrentMenu.X, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, SettingsButton.SelectedSprite.Width + CurrentMenu.WidthOffset, SettingsButton.SelectedSprite.Height)
                    LeftArrowHovered = lib.ui.IsMouseInBounds(CurrentMenu.X + SettingsSlider.LeftArrow.X + CurrentMenu.SafeZoneSize.X + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsSlider.LeftArrow.Y + CurrentMenu.SafeZoneSize.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, SettingsSlider.LeftArrow.Width, SettingsSlider.LeftArrow.Height)
                    RightArrowHovered = lib.ui.IsMouseInBounds(CurrentMenu.X + SettingsSlider.RightArrow.X + CurrentMenu.SafeZoneSize.X + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsSlider.RightArrow.Y + CurrentMenu.SafeZoneSize.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, SettingsSlider.RightArrow.Width, SettingsSlider.RightArrow.Height)
                end

                RightOffset = RightOffset

                if Selected then
                    _RenderText(Label, CurrentMenu.X + SettingsButton.Text.X, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, 0, SettingsButton.Text.Scale, 0, 0, 0, 255)

                    _RenderSprite(SettingsSlider.LeftArrow.Dictionary, SettingsSlider.LeftArrow.Texture, CurrentMenu.X + SettingsSlider.LeftArrow.X + CurrentMenu.WidthOffset - RightOffset, CurrentMenu.Y + SettingsSlider.LeftArrow.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, SettingsSlider.LeftArrow.Width, SettingsSlider.LeftArrow.Height, 0, 0, 0, 0, 255)
                    _RenderSprite(SettingsSlider.RightArrow.Dictionary, SettingsSlider.RightArrow.Texture, CurrentMenu.X + SettingsSlider.RightArrow.X + CurrentMenu.WidthOffset - RightOffset, CurrentMenu.Y + SettingsSlider.RightArrow.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, SettingsSlider.RightArrow.Width, SettingsSlider.RightArrow.Height, 0, 0, 0, 0, 255)

					local LeftBadge = lib.ui.BadgeStyle.Star();
					_RenderSprite(

						LeftBadge.BadgeDictionary or "commonmenu",
						LeftBadge.BadgeTexture or "",
						CurrentMenu.X,
						CurrentMenu.Y + SettingsButton.LeftBadge.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset,
						SettingsButton.LeftBadge.Width,
						SettingsButton.LeftBadge.Height, 0,
						LeftBadge.BadgeColour and LeftBadge.BadgeColour.R or 255,
						LeftBadge.BadgeColour and LeftBadge.BadgeColour.G or 255,
						LeftBadge.BadgeColour and LeftBadge.BadgeColour.B or 255,
						LeftBadge.BadgeColour and LeftBadge.BadgeColour.A or 255

					);

				else
                    _RenderText(Label, CurrentMenu.X + SettingsButton.Text.X, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, 0, SettingsButton.Text.Scale, 245, 245, 245, 255)

                    _RenderSprite(SettingsSlider.LeftArrow.Dictionary, SettingsSlider.LeftArrow.Texture, CurrentMenu.X + SettingsSlider.LeftArrow.X + CurrentMenu.WidthOffset - RightOffset, CurrentMenu.Y + SettingsSlider.LeftArrow.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, SettingsSlider.LeftArrow.Width, SettingsSlider.LeftArrow.Height, 0, 255, 255, 255, 255)
                    _RenderSprite(SettingsSlider.RightArrow.Dictionary, SettingsSlider.RightArrow.Texture, CurrentMenu.X + SettingsSlider.RightArrow.X + CurrentMenu.WidthOffset - RightOffset, CurrentMenu.Y + SettingsSlider.RightArrow.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, SettingsSlider.RightArrow.Width, SettingsSlider.RightArrow.Height, 0, 255, 255, 255, 255)

					local LeftBadge = lib.ui.BadgeStyle.Star();
					_RenderSprite(

						LeftBadge.BadgeDictionary or "commonmenu",
						LeftBadge.BadgeTexture or "",
						CurrentMenu.X,
						CurrentMenu.Y + SettingsButton.LeftBadge.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset,
						SettingsButton.LeftBadge.Width,
						SettingsButton.LeftBadge.Height, 0,
						LeftBadge.BadgeColour and LeftBadge.BadgeColour.R or 255,
						LeftBadge.BadgeColour and LeftBadge.BadgeColour.G or 255,
						LeftBadge.BadgeColour and LeftBadge.BadgeColour.B or 255,
						LeftBadge.BadgeColour and LeftBadge.BadgeColour.A or 255

					);

				end

                _RenderRectangle(CurrentMenu.X + SettingsSlider.Background.X + CurrentMenu.WidthOffset - RightOffset, CurrentMenu.Y + SettingsSlider.Background.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, SettingsSlider.Background.Width, SettingsSlider.Background.Height, 4, 32, 57, 255)
                _RenderRectangle(CurrentMenu.X + SettingsSlider.Slider.X + (((SettingsSlider.Background.Width - SettingsSlider.Slider.Width) / (#Items)) * (ItemIndex)) + CurrentMenu.WidthOffset - RightOffset, CurrentMenu.Y + SettingsSlider.Slider.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, SettingsSlider.Slider.Width, SettingsSlider.Slider.Height, 57, 116, 200, 255)

                _RenderRectangle(CurrentMenu.X + SettingsSlider.Divider.X + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsSlider.Divider.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, SettingsSlider.Divider.Width, SettingsSlider.Divider.Height, 245, 245, 245, 255)

                lib.ui.ItemOffset = lib.ui.ItemOffset + SettingsButton.Rectangle.Height

                lib.ui.SetDescription(CurrentMenu, Description, Selected);

                if Selected and (CurrentMenu.Controls.SliderLeft.Active or (CurrentMenu.Controls.Click.Active and LeftArrowHovered)) and not (CurrentMenu.Controls.SliderRight.Active or (CurrentMenu.Controls.Click.Active and RightArrowHovered)) then
                    ItemIndex = ItemIndex - value
                    if ItemIndex < 0.1 then
                        ItemIndex = 0.0
                    else
                        lib.ui.PlaySound(Audio[Audio.Use].Slider.audioName, Audio[Audio.Use].Slider.audioRef, true)
                    end
                    if (Actions.onSliderChange ~= nil) then
                        Actions.onSliderChange(ItemIndex / 10, ItemIndex);
                    end
                elseif Selected and (CurrentMenu.Controls.SliderRight.Active or (CurrentMenu.Controls.Click.Active and RightArrowHovered)) and not (CurrentMenu.Controls.SliderLeft.Active or (CurrentMenu.Controls.Click.Active and LeftArrowHovered)) then
                    ItemIndex = ItemIndex + value
                    if ItemIndex > #Items then
                        ItemIndex = 10
                    else
                        lib.ui.PlaySound(Audio[Audio.Use].Slider.audioName, Audio[Audio.Use].Slider.audioRef, true)
                    end
                    if (Actions.onSliderChange ~= nil) then
                        Actions.onSliderChange(ItemIndex / 10, ItemIndex);
                    end
                end

                if Selected and (CurrentMenu.Controls.Select.Active or ((Hovered and CurrentMenu.Controls.Click.Active) and (not LeftArrowHovered and not RightArrowHovered))) then
                    if (Actions.onSelected ~= nil) then
                        Actions.onSelected(ItemIndex / 10, ItemIndex);
                    end
                    lib.ui.PlaySound(Audio[Audio.Use].Select.audioName, Audio[Audio.Use].Select.audioRef, false)
                elseif Selected then
                    if(Actions.onActive ~= nil) then
                        Actions.onActive()
                    end
                end

            end

            lib.ui.Options = lib.ui.Options + 1
        end
    end
end



