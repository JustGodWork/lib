---
--- @author Dylan MALANDAIN
--- @version 2.0.0
--- @since 2020
---
--- ui Is Advanced UI Libs in LUA for make beautiful interface like RockStar GAME.
---
---
--- Commercial Info.
--- Any use for commercial purposes is strictly prohibited and will be punished.
---
--- @see ui
---

local _IsDisabledControlJustPressed = IsDisabledControlJustPressed;
local _IsDisabledControlPressed = IsDisabledControlPressed;
local _RenderSprite = lib.ui.RenderSprite;
local _RenderRectangle = lib.ui.RenderRectangle;
local _SetScriptGfxAlign = SetScriptGfxAlign;
local _SetScriptGfxAlignParams = SetScriptGfxAlignParams;
local _CreateThread = CreateThread;
local _Wait = Wait;

lib.ui.LastControl = false

local ControlActions = {
    'Left',
    'Right',
    'Select',
    'Click',
}

---GoUp
---@param Options number
---@return nil
---@public
function lib.ui.GoUp(Options)
    local CurrentMenu = lib.ui.CurrentMenu;
    if CurrentMenu ~= nil then
        Options = CurrentMenu.Options
        if CurrentMenu then
            if (Options ~= 0) then
                if Options > CurrentMenu.Pagination.Total then
                    if CurrentMenu.Index <= CurrentMenu.Pagination.Minimum then
                        if CurrentMenu.Index == 1 then
                            CurrentMenu.Pagination.Minimum = Options - (CurrentMenu.Pagination.Total - 1)
                            CurrentMenu.Pagination.Maximum = Options
                            CurrentMenu.Index = Options
                        else
                            CurrentMenu.Pagination.Minimum = (CurrentMenu.Pagination.Minimum - 1)
                            CurrentMenu.Pagination.Maximum = (CurrentMenu.Pagination.Maximum - 1)
                            CurrentMenu.Index = CurrentMenu.Index - 1
                        end
                    else
                        CurrentMenu.Index = CurrentMenu.Index - 1
                    end
                else
                    if CurrentMenu.Index == 1 then
                        CurrentMenu.Pagination.Minimum = Options - (CurrentMenu.Pagination.Total - 1)
                        CurrentMenu.Pagination.Maximum = Options
                        CurrentMenu.Index = Options
                    else
                        CurrentMenu.Index = CurrentMenu.Index - 1
                    end
                end

                local Audio = lib.ui.Settings.Audio
                lib.ui.PlaySound(Audio[Audio.Use].UpDown.audioName, Audio[Audio.Use].UpDown.audioRef)
                lib.ui.LastControl = true
                if (CurrentMenu.onIndexChange ~= nil) then
                    _CreateThread(function()
                        CurrentMenu.onIndexChange(CurrentMenu.Index)
                    end)
                end
            else
                local Audio = lib.ui.Settings.Audio
                lib.ui.PlaySound(Audio[Audio.Use].Error.audioName, Audio[Audio.Use].Error.audioRef)
            end
        end
    end
end

---GoDown
---@param Options number
---@return nil
---@public
function lib.ui.GoDown(Options)
    local CurrentMenu = lib.ui.CurrentMenu;
    if CurrentMenu ~= nil then
        Options = CurrentMenu.Options
        if CurrentMenu then
            if (Options ~= 0) then
                if Options > CurrentMenu.Pagination.Total then
                    if CurrentMenu.Index >= CurrentMenu.Pagination.Maximum then
                        if CurrentMenu.Index == Options then
                            CurrentMenu.Pagination.Minimum = 1
                            CurrentMenu.Pagination.Maximum = CurrentMenu.Pagination.Total
                            CurrentMenu.Index = 1
                        else
                            CurrentMenu.Pagination.Maximum = (CurrentMenu.Pagination.Maximum + 1)
                            CurrentMenu.Pagination.Minimum = CurrentMenu.Pagination.Maximum - (CurrentMenu.Pagination.Total - 1)
                            CurrentMenu.Index = CurrentMenu.Index + 1
                        end
                    else
                        CurrentMenu.Index = CurrentMenu.Index + 1
                    end
                else
                    if CurrentMenu.Index == Options then
                        CurrentMenu.Pagination.Minimum = 1
                        CurrentMenu.Pagination.Maximum = CurrentMenu.Pagination.Total
                        CurrentMenu.Index = 1
                    else
                        CurrentMenu.Index = CurrentMenu.Index + 1
                    end
                end
                local Audio = lib.ui.Settings.Audio
                lib.ui.PlaySound(Audio[Audio.Use].UpDown.audioName, Audio[Audio.Use].UpDown.audioRef)
                lib.ui.LastControl = false
                if (CurrentMenu.onIndexChange ~= nil) then
                    _CreateThread(function()
                        CurrentMenu.onIndexChange(CurrentMenu.Index)
                    end)
                end
            else
                local Audio = lib.ui.Settings.Audio
                lib.ui.PlaySound(Audio[Audio.Use].Error.audioName, Audio[Audio.Use].Error.audioRef)
            end
        end
    end
end

function lib.ui.GoActionControl(Controls, Action)
    if Controls[Action or 'Left'].Enabled then
        for Index = 1, #Controls[Action or 'Left'].Keys do
            if not Controls[Action or 'Left'].Pressed then
                if _IsDisabledControlJustPressed(Controls[Action or 'Left'].Keys[Index][1], Controls[Action or 'Left'].Keys[Index][2]) then
                    Controls[Action or 'Left'].Pressed = true
                    _CreateThread(function()
                        Controls[Action or 'Left'].Active = true
                        _Wait(0.01)
                        Controls[Action or 'Left'].Active = false
                        _Wait(175)
                        while Controls[Action or 'Left'].Enabled and _IsDisabledControlPressed(Controls[Action or 'Left'].Keys[Index][1], Controls[Action or 'Left'].Keys[Index][2]) do
                            Controls[Action or 'Left'].Active = true
                            _Wait(1)
                            Controls[Action or 'Left'].Active = false
                            _Wait(124)
                        end
                        Controls[Action or 'Left'].Pressed = false
                        if (Action ~= ControlActions[5]) then
                            _Wait(10)
                        end
                    end)
                    break
                end
            end
        end
    end
end

function lib.ui.GoActionControlSlider(Controls, Action)
    if Controls[Action].Enabled then
        for Index = 1, #Controls[Action].Keys do
            if not Controls[Action].Pressed then
                if _IsDisabledControlJustPressed(Controls[Action].Keys[Index][1], Controls[Action].Keys[Index][2]) then
                    Controls[Action].Pressed = true
                    _CreateThread(function()
                        Controls[Action].Active = true
                        _Wait(1)
                        Controls[Action].Active = false
                        while Controls[Action].Enabled and _IsDisabledControlPressed(Controls[Action].Keys[Index][1], Controls[Action].Keys[Index][2]) do
                            Controls[Action].Active = true
                            _Wait(1)
                            Controls[Action].Active = false
                        end
                        Controls[Action].Pressed = false
                    end)
                    break
                end
            end
        end
    end
end

local _SetMouseCursorActiveThisFrame = SetMouseCursorActiveThisFrame;
local _IsDisabledControlJustPressed = IsDisabledControlJustPressed;
local _DisableAllControlActions = DisableAllControlActions;
local _EnableControlAction = EnableControlAction;

---Controls
---@return nil
---@public
function lib.ui.Controls()
    local CurrentMenu = lib.ui.CurrentMenu;
    if CurrentMenu ~= nil then
        if CurrentMenu then
            if CurrentMenu:IsOpen() then

                local Controls = CurrentMenu.Controls;
                ---@type number
                local Options = CurrentMenu.Options
                lib.ui.Options = CurrentMenu.Options
                if CurrentMenu.EnableMouse then
                    _DisableAllControlActions(2);
                end

                if not IsInputDisabled(2) then
                    for Index = 1, #Controls.Enabled.Controller do
                        _EnableControlAction(Controls.Enabled.Controller[Index][1], Controls.Enabled.Controller[Index][2], true)
                    end
                else
                    for Index = 1, #Controls.Enabled.Keyboard do
                        _EnableControlAction(Controls.Enabled.Keyboard[Index][1], Controls.Enabled.Keyboard[Index][2], true)
                    end
                end

                if Controls.Up.Enabled then
                    for Index = 1, #Controls.Up.Keys do
                        if not Controls.Up.Pressed then
                            if _IsDisabledControlJustPressed(Controls.Up.Keys[Index][1], Controls.Up.Keys[Index][2]) then
                                Controls.Up.Pressed = true
                                _CreateThread(function()
                                    lib.ui.GoUp(Options)
                                    _Wait(175)
                                    while Controls.Up.Enabled and _IsDisabledControlPressed(Controls.Up.Keys[Index][1], Controls.Up.Keys[Index][2]) do
                                        lib.ui.GoUp(Options)
                                        _Wait(50)
                                    end
                                    Controls.Up.Pressed = false
                                end)
                                break
                            end
                        end
                    end
                end

                if Controls.Down.Enabled then
                    for Index = 1, #Controls.Down.Keys do
                        if not Controls.Down.Pressed then
                            if _IsDisabledControlJustPressed(Controls.Down.Keys[Index][1], Controls.Down.Keys[Index][2]) then
                                Controls.Down.Pressed = true
                                _CreateThread(function()
                                    lib.ui.GoDown(Options)
                                    _Wait(175)
                                    while Controls.Down.Enabled and _IsDisabledControlPressed(Controls.Down.Keys[Index][1], Controls.Down.Keys[Index][2]) do
                                        lib.ui.GoDown(Options)
                                        _Wait(50)
                                    end
                                    Controls.Down.Pressed = false
                                end)
                                break
                            end
                        end
                    end
                end

                for i = 1, #ControlActions do
                    lib.ui.GoActionControl(Controls, ControlActions[i])
                end

                lib.ui.GoActionControlSlider(Controls, 'SliderLeft')
                lib.ui.GoActionControlSlider(Controls, 'SliderRight')

                if Controls.Back.Enabled then
                    for Index = 1, #Controls.Back.Keys do
                        if not Controls.Back.Pressed then
                            if _IsDisabledControlJustPressed(Controls.Back.Keys[Index][1], Controls.Back.Keys[Index][2]) then
                                Controls.Back.Pressed = true
                                _CreateThread(function()
                                    _Wait(175)
                                    Controls.Down.Pressed = false
                                end)
                                break
                            end
                        end
                    end
                end

            end
        end
    end
end

---Navigation
---@return nil
---@public
function lib.ui.Navigation()
    local CurrentMenu = lib.ui.CurrentMenu;
    if CurrentMenu ~= nil then
        if CurrentMenu and (CurrentMenu.Display.Navigation) then
            if CurrentMenu.EnableMouse then
                _SetMouseCursorActiveThisFrame()
            end
            if lib.ui.Options > CurrentMenu.Pagination.Total then

                ---@type boolean
                local UpHovered = false

                ---@type boolean
                local DownHovered = false

                if not CurrentMenu.SafeZoneSize then
                    CurrentMenu.SafeZoneSize = { X = 0, Y = 0 }

                    if CurrentMenu.Safezone then
                        CurrentMenu.SafeZoneSize = lib.ui.GetSafeZoneBounds()

                        _SetScriptGfxAlign(76, 84)
                        _SetScriptGfxAlignParams(0, 0, 0, 0)
                    end
                end

                if CurrentMenu.EnableMouse then
                    UpHovered = lib.ui.IsMouseInBounds(CurrentMenu.X + CurrentMenu.SafeZoneSize.X, CurrentMenu.Y + CurrentMenu.SafeZoneSize.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, lib.ui.Settings.Items.Navigation.Rectangle.Width + CurrentMenu.WidthOffset, lib.ui.Settings.Items.Navigation.Rectangle.Height)
                    DownHovered = lib.ui.IsMouseInBounds(CurrentMenu.X + CurrentMenu.SafeZoneSize.X, CurrentMenu.Y + lib.ui.Settings.Items.Navigation.Rectangle.Height + CurrentMenu.SafeZoneSize.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, lib.ui.Settings.Items.Navigation.Rectangle.Width + CurrentMenu.WidthOffset, lib.ui.Settings.Items.Navigation.Rectangle.Height)

                    if CurrentMenu.Controls.Click.Active then
                        if UpHovered then
                            lib.ui.GoUp(lib.ui.Options)
                        elseif DownHovered then
                            lib.ui.GoDown(lib.ui.Options)
                        end
                    end

                    if UpHovered then
                        _RenderRectangle(CurrentMenu.X, CurrentMenu.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, lib.ui.Settings.Items.Navigation.Rectangle.Width + CurrentMenu.WidthOffset, lib.ui.Settings.Items.Navigation.Rectangle.Height, 30, 30, 30, 255)
                    else
                        _RenderRectangle(CurrentMenu.X, CurrentMenu.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, lib.ui.Settings.Items.Navigation.Rectangle.Width + CurrentMenu.WidthOffset, lib.ui.Settings.Items.Navigation.Rectangle.Height, 0, 0, 0, 200)
                    end

                    if DownHovered then
                        _RenderRectangle(CurrentMenu.X, CurrentMenu.Y + lib.ui.Settings.Items.Navigation.Rectangle.Height + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, lib.ui.Settings.Items.Navigation.Rectangle.Width + CurrentMenu.WidthOffset, lib.ui.Settings.Items.Navigation.Rectangle.Height, 30, 30, 30, 255)
                    else
                        _RenderRectangle(CurrentMenu.X, CurrentMenu.Y + lib.ui.Settings.Items.Navigation.Rectangle.Height + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, lib.ui.Settings.Items.Navigation.Rectangle.Width + CurrentMenu.WidthOffset, lib.ui.Settings.Items.Navigation.Rectangle.Height, 0, 0, 0, 200)
                    end
                else
                    _RenderRectangle(CurrentMenu.X, CurrentMenu.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, lib.ui.Settings.Items.Navigation.Rectangle.Width + CurrentMenu.WidthOffset, lib.ui.Settings.Items.Navigation.Rectangle.Height, 0, 0, 0, 200)
                    _RenderRectangle(CurrentMenu.X, CurrentMenu.Y + lib.ui.Settings.Items.Navigation.Rectangle.Height + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, lib.ui.Settings.Items.Navigation.Rectangle.Width + CurrentMenu.WidthOffset, lib.ui.Settings.Items.Navigation.Rectangle.Height, 0, 0, 0, 200)
                end
                _RenderSprite(lib.ui.Settings.Items.Navigation.Arrows.Dictionary, lib.ui.Settings.Items.Navigation.Arrows.Texture, CurrentMenu.X + lib.ui.Settings.Items.Navigation.Arrows.X + (CurrentMenu.WidthOffset / 2), CurrentMenu.Y + lib.ui.Settings.Items.Navigation.Arrows.Y + CurrentMenu.SubtitleHeight + lib.ui.ItemOffset, lib.ui.Settings.Items.Navigation.Arrows.Width, lib.ui.Settings.Items.Navigation.Arrows.Height)
                lib.ui.ItemOffset = lib.ui.ItemOffset + (lib.ui.Settings.Items.Navigation.Rectangle.Height * 2)
            end
        end
    end
end

---GoBack
---@return nil
---@public
function lib.ui.GoBack()
    local CurrentMenu = lib.ui.CurrentMenu
    if CurrentMenu ~= nil then
        local Audio = lib.ui.Settings.Audio
        lib.ui.PlaySound(Audio[Audio.Use].Back.audioName, Audio[Audio.Use].Back.audioRef)
        if CurrentMenu.Parent ~= nil then
            if CurrentMenu.Parent then
                lib.ui.NextMenu = CurrentMenu.Parent
            else
                lib.ui.NextMenu = nil
                lib.ui.Visible(CurrentMenu, false)
            end
        else
            lib.ui.NextMenu = nil
            lib.ui.Visible(CurrentMenu, false)
            lib.ui.TextEnabled = true;
        end
    end
end

---GoBackTo
---@param menu UIMenu
---@param callback function
---@public
function lib.ui.GoBackTo(menu, callback)
    local CurrentMenu = lib.ui.CurrentMenu;
    if (CurrentMenu ~= nil) then

        local Audio = lib.ui.Settings.Audio;
        lib.ui.PlaySound(Audio[Audio.Use].Back.audioName, Audio[Audio.Use].Back.audioRef);

        if (menu and menu.IsOpen and not menu:IsOpen()) then
            lib.ui.NextMenu = menu;
        else

            lib.ui.NextMenu = nil
            lib.ui.Visible(CurrentMenu, false)
            lib.ui.TextEnabled = true;

        end

        if (callback) then callback() end

    end
end

---Reset Current Menu description
function lib.ui.ResetDescription()

    local currentMenu = lib.ui.GetCurrentMenu();

    currentMenu.Description = nil;

end
