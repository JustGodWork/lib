--[[
----
----Created Date: 2:27 Friday October 14th 2022
----Author: JustGod
----Made with ❤
----
----File: [Menu]
----
----Copyright (c) 2022 JustGodWork, All Rights Reserved.
----This file is part of JustGodWork project.
----Unauthorized using, copying, modifying and/or distributing of this file
----via any medium is strictly prohibited. This code is confidential.
----
--]]

local Menus = {};
local SubMenus = {};

---@class UIMenu: EventEmitter
---@overload fun(Title: string, Subtitle: string, X: number, Y: number, TextureDictionary: string, TextureName: string, R: number, G: number, B: number, A: number ): UIMenu
UIMenu = lib.class.extends('UIMenu', 'EventEmitter');

local config_showHeader = lib.kvp.get_value('justgod_lib_ui_show_header');
local config_displayGlare = lib.kvp.get_value('justgod_lib_ui_show_glare');
local config_displaySubtitle = lib.kvp.get_value('justgod_lib_ui_show_subtitle');
local config_displayBackground = lib.kvp.get_value('justgod_lib_ui_show_background');
local config_displayNavigationBar = lib.kvp.get_value('justgod_lib_ui_show_navbar');
local config_displayInstructionalButton = lib.kvp.get_value('justgod_lib_ui_show_instructionnal_button');
local config_displayPageCounter = lib.kvp.get_value('justgod_lib_ui_show_page_counter');
local config_titles = lib.kvp.get_value('justgod_lib_ui_titles');
local config_titleFont = lib.kvp.get_value('justgod_lib_ui_title_font');

local config_textureDict = lib.kvp.get_value('justgod_lib_ui_texture_dictionnary');
local config_textureName = lib.kvp.get_value('justgod_lib_ui_texture_name');
local config_color = {
    R = lib.kvp.get_value('justgod_lib_ui_color_red'),
    G = lib.kvp.get_value('justgod_lib_ui_color_green'),
    B = lib.kvp.get_value('justgod_lib_ui_color_blue'),
    A = lib.kvp.get_value('justgod_lib_ui_color_alpha')
};

---CreateMenu
---@public
---@param Title string
---@param Subtitle string
---@param X number
---@param Y number
---@param TextureDictionary string
---@param TextureName string
---@param R number
---@param G number
---@param B number
---@param A number
function UIMenu:Constructor(Title, Subtitle, X, Y, TextureDictionary, TextureName, R, G, B, A)

    self:super();

    self.Display = {};

    self.InstructionalButtons = {}

    self.Display.Header = config_showHeader == true or true;
    self.Display.Glare = config_displayGlare == true or false;
    self.Display.Subtitle = config_displaySubtitle == true or true;
    self.Display.Background = config_displayBackground == true or true;
    self.Display.Navigation = config_displayNavigationBar == true or true;
    self.Display.InstructionalButton = config_displayInstructionalButton == true or true;
    self.Display.PageCounter = config_displayPageCounter == true or true;

    self.Title = config_titles or Title or ""
    self.TitleFont = config_titleFont or 6
    self.TitleScale = 1.2
    self.Subtitle = Subtitle or ""
    self.SubtitleHeight = -37
    self.Description = nil
    self.DescriptionHeight = lib.ui.Settings.Items.Description.Background.Height
    self.X = X or 0
    self.Y = Y or 0
    self.Parent = nil
    self.WidthOffset = lib.ui.Data.Style[lib.ui.Data.Current].Width
    self.open = false
    self.Controls = lib.ui.Settings.Controls
    self.Index = 1
    self.Sprite = {
        Dictionary = type(TextureDictionary) == 'string' and TextureDictionary or (config_textureDict or "commonmenu"),
        Texture = type(TextureName) == 'string' and TextureName or (config_textureName or "interaction_bgd"),
        Color = {
            R = (config_color.R) or R or 255,
            G = (config_color.G) or G or 255,
            B = (config_color.B) or B or 255,
            A = (config_color.A) or A or 255
        }
    }
    self.Rectangle = nil
    self.Pagination = { Minimum = 1, Maximum = 10, Total = 10 }
    self.Safezone = true
    self.SafeZoneSize = nil
    self.EnableMouse = false
    self.Options = 0
    self.Closable = true
    self.InstructionalScaleform = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS")
    self.CursorStyle = 1
    self.id = lib.uuid("xx6xx-xxxxx");
    self.data = {}

    if string.starts(self.Subtitle, "~") then
        self.PageCounterColour = string.lower(string.sub(self.Subtitle, 1, 3))
    else
        self.PageCounterColour = ""
    end

    if self.Subtitle ~= "" then
        local SubtitleLineCount = GetLineCount(self.Subtitle, self.X + lib.ui.Settings.Items.Subtitle.Text.X, self.Y + lib.ui.Settings.Items.Subtitle.Text.Y, 0, lib.ui.Settings.Items.Subtitle.Text.Scale, 245, 245, 245, 255, nil, false, false, lib.ui.Settings.Items.Subtitle.Background.Width + self.WidthOffset)

        if SubtitleLineCount > 1 then
            self.SubtitleHeight = 18 * SubtitleLineCount
        else
            self.SubtitleHeight = 0
        end
    end

    Citizen.CreateThread(function()
        if not HasScaleformMovieLoaded(self.InstructionalScaleform) then
            self.InstructionalScaleform = RequestScaleformMovie("INSTRUCTIONAL_BUTTONS")
            while not HasScaleformMovieLoaded(self.InstructionalScaleform) do
                Citizen.Wait(0)
            end
        end
    end)

    Citizen.CreateThread(function()
        local ScaleformMovie = RequestScaleformMovie("MP_MENU_GLARE")
        while not HasScaleformMovieLoaded(ScaleformMovie) do
            Citizen.Wait(0)
        end
    end)

    Menus[self.id] = self;
    SubMenus[self.id] = {};
end

function UIMenu:DisplayHeader(boolean)
    self.Display.Header = boolean;
    return self.Display.Header;
end

function UIMenu:DisplayGlare(boolean)
    self.Display.Glare = boolean;
    return self.Display.Glare;
end

function UIMenu:DisplaySubtitle(boolean)
    self.Display.Subtitle = boolean;
    return self.Display.Subtitle;
end

function UIMenu:DisplayNavigation(boolean)
    self.Display.Navigation = boolean;
    return self.Display.Navigation;
end

function UIMenu:DisplayInstructionalButton(boolean)
    self.Display.InstructionalButton = boolean;
    return self.Display.InstructionalButton;
end

function UIMenu:DisplayPageCounter(boolean)
    self.Display.PageCounter= boolean;
    return self.Display.PageCounter;
end

---SetTitle
---@param Title string
---@return nil
---@public
function UIMenu:SetTitle(Title)
    self.Title = Title
end

function UIMenu:SetStyleSize(Value)
    local witdh
    if Value >= 0 and Value <= 100 then
        witdh = Value
    else
        witdh = 100
    end
    self.WidthOffset = witdh
end

---GetStyleSize
---@return any
---@public
function UIMenu:GetStyleSize()
    if (self.WidthOffset == 100) then
        return "ui"
    elseif (self.WidthOffset == 0) then
        return "NativeUI";
    else
        return self.WidthOffset;
    end
end

---SetStyleSize
---@param Int string
---@return void
---@public
function UIMenu:SetCursorStyle(Int)
    self.CursorStyle = Int or 1 or 0
    SetMouseCursorSprite(Int)
end

---ResetCursorStyle
---@return void
---@public
function UIMenu:ResetCursorStyle()
    self.CursorStyle = 1
    SetMouseCursorSprite(1)
end

---UpdateCursorStyle
---@return void
---@public
function UIMenu:UpdateCursorStyle()
    SetMouseCursorSprite(self.CursorStyle)
end

---RefreshIndex
---@return void
---@public
function UIMenu:RefreshIndex()
    self.Index = 1
end

---SetSubtitle
---@param Subtitle string
---@return nil
---@public
function UIMenu:SetSubtitle(Subtitle)
    self.Subtitle = Subtitle;
    if self.Subtitle ~= "" then
        local SubtitleLineCount = GetLineCount(self.Subtitle, self.X + lib.ui.Settings.Items.Subtitle.Text.X, self.Y + lib.ui.Settings.Items.Subtitle.Text.Y, 0, lib.ui.Settings.Items.Subtitle.Text.Scale, 245, 245, 245, 255, nil, false, false, lib.ui.Settings.Items.Subtitle.Background.Width + self.WidthOffset)

        if SubtitleLineCount > 1 then
            self.SubtitleHeight = 18 * SubtitleLineCount
        else
            self.SubtitleHeight = 0
        end
    end
end

---PageCounter
---@param Subtitle string
---@return nil
---@public
function UIMenu:SetPageCounter(Subtitle)
    self.PageCounter = Subtitle
end

---EditSpriteColor
---@param Colors table
---@return nil
---@public
function UIMenu:EditSpriteColor(R, G, B, A)
    if self.Sprite.Dictionary == "commonmenu" then
        self.Sprite.Color = { R = tonumber(R) or 255, G = tonumber(G) or 255, B = tonumber(B) or 255, A = tonumber(A) or 255 }
    end
end
---SetPosition
---@param X number
---@param Y number
---@return nil
---@public
function UIMenu:SetPosition(X, Y)
    self.X = tonumber(X) or self.X
    self.Y = tonumber(Y) or self.Y
end

---SetTotalItemsPerPage
---@param Value number
---@return nil
---@public
function UIMenu:SetTotalItemsPerPage(Value)
    self.Pagination.Total = tonumber(Value) or self.Pagination.Total
end

---SetRectangleBanner
---@param R number
---@param G number
---@param B number
---@param A number
---@return nil
---@public
function UIMenu:SetRectangleBanner(R, G, B, A)
    self.Rectangle = { R = tonumber(R) or 255, G = tonumber(G) or 255, B = tonumber(B) or 255, A = tonumber(A) or 255 }
    self.Sprite = nil
end

---SetSpriteBanner
---@param TextureDictionary string
---@param Texture string
---@return nil
---@public
function UIMenu:SetSpriteBanner(TextureDictionary, Texture)
    self.Sprite = { Dictionary = TextureDictionary or "commonmenu", Texture = Texture or "interaction_bgd" }
    self.Rectangle = nil
end

function UIMenu:SetClosable(boolean)
    if type(boolean) == "boolean" then
        self.Closable = boolean
    else
        error("Type is not boolean")
    end
end

function UIMenu:IsClosable()
    return self.Closable;
end

---@return boolean
function UIMenu:IsOpen()
    return self.open;
end

---@param parent UIMenu
function UIMenu:SetHasSubMenu(parent)
    self:CleanParentSubMenu();
    table.insert(SubMenus[parent.id], self.id)
    self.Parent = parent
end

---PERFORM A CLEAN FOR OPTIMIZATION PURPOSE
function UIMenu:CleanParentSubMenu()
    if self.Parent ~= nil then
        for k, v in pairs(SubMenus[self.Parent.id]) do
            if v == self.id then
                table.remove(SubMenus[self.Parent.id], k)
                break
            end
        end
        self.Parent = nil
    end
end

---Reset visibles items
function UIMenu:ResetVisibleItems()
    self.func = nil;
    self.panels = nil;
    self.Closed = nil;
end

---@param Items fun(Items: UIItems)
---@param Panels fun(Panels: UIPanels)
---@param onClose function
function UIMenu:IsVisible(Items, Panels, onClose)

    if type(Items) == "function" and ((Panels and type(Panels) == "function") or true) then

        self.func = Items;
        self.panels = Panels;
        self.Closed = onClose;

    else

        error("Type is not function (Items or panels)");

    end

end

function UIMenu:GetSubMenus()
    if #SubMenus[self.id] > 0 then
        for _, submenu in pairs(SubMenus[self.id]) do
            lib.ui.IsVisible(Menus[submenu])
            Menus[submenu]:GetSubMenus();
        end
    end
end

function UIMenu:Open()
    CreateThread(function()
        if (lib.ui.GetCurrentMenu() == nil and not IsPauseMenuActive()) then
            local Audio = lib.ui.Settings.Audio;
            lib.ui.PlaySound(Audio[Audio.Use].Select.audioName, Audio[Audio.Use].Select.audioRef);
            lib.ui.Visible(self, true);
            lib.ui.TextEnabled = false;
            CreateThread(function()
                while lib.ui.CurrentMenu ~= nil do
                    if (lib.ui.CurrentMenu.Closable) then

                        lib.ui.DisableControlsOnMenu();
                        lib.ui.IsVisible(self);
                        self:GetSubMenus();

                    else
                        self:Close();
                    end
                    Wait(1);
                end
            end);
        end
    end);
end

---@return void
function UIMenu:Close()
    if (lib.ui.GetCurrentMenu() == self) then
        if (self.Closed) then
            self.Closed();
        end
        lib.ui.Visible(self, false);
        self.Index = 1
        self.Pagination.Minimum = 1
        self.Pagination.Maximum = self.Pagination.Total
        lib.ui.CurrentMenu = nil
        ResetScriptGfxAlign()
        local Audio = lib.ui.Settings.Audio
        if (not lib.ui.NextMenu) then
            lib.ui.TextEnabled = true;
        end
        lib.ui.PlaySound(Audio[Audio.Use].Select.audioName, Audio[Audio.Use].Select.audioRef)
        return
    end
    if #SubMenus[self.id] > 0 then
        for _, submenu in pairs(SubMenus[self.id]) do
            if lib.ui.GetCurrentMenu() ~= nil then
                Menus[submenu]:Close();
            end
        end
    end
end

function UIMenu:Toggle()
    CreateThread(function()
        if (lib.ui.CurrentMenu ~= nil and lib.ui.CurrentMenu.Closable) then
            local Audio = lib.ui.Settings.Audio;
            lib.ui.PlaySound(Audio[Audio.Use].Back.audioName, Audio[Audio.Use].Back.audioRef);
            lib.ui.CurrentMenu:Close();
        else
            self:Open();
        end
    end);
end

---@param key string
---@param value any
function UIMenu:SetData(key, value)
    self.data[key] = value
    return self.data[key]
end

---@param key string
function UIMenu:GetData(key)
    return self.data[key]
end

function UIMenu:AddInstructionButton(button)
    if type(button) == "table" and #button == 2 then
        table.insert(self.InstructionalButtons, button)
        self:UpdateInstructionalButtons(true);
    end
end

function UIMenu:RemoveInstructionButton(button)
    if type(button) == "table" then
        for i = 1, #self.InstructionalButtons do
            if button == self.InstructionalButtons[i] then
                table.remove(self.InstructionalButtons, i)
                self:UpdateInstructionalButtons(true);
                break
            end
        end
    else
        if tonumber(button) then
            if self.InstructionalButtons[tonumber(button)] then
                table.remove(self.InstructionalButtons, tonumber(button))
                self:UpdateInstructionalButtons(true);
            end
        end
    end
end

function UIMenu:UpdateInstructionalButtons(Visible)

    if (not Visible) then
        return
    end

    BeginScaleformMovieMethod(self.InstructionalScaleform, "CLEAR_ALL")
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(self.InstructionalScaleform, "TOGGLE_MOUSE_BUTTONS")
    ScaleformMovieMethodAddParamInt(0)
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(self.InstructionalScaleform, "CREATE_CONTAINER")
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(self.InstructionalScaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(0)
    PushScaleformMovieMethodParameterButtonName(GetControlInstructionalButton(2, 176, 0))
    PushScaleformMovieMethodParameterString(GetLabelText("HUD_INPUT2"))
    EndScaleformMovieMethod()

    if (self.Closable) then
        BeginScaleformMovieMethod(self.InstructionalScaleform, "SET_DATA_SLOT")
        ScaleformMovieMethodAddParamInt(1)
        PushScaleformMovieMethodParameterButtonName(GetControlInstructionalButton(2, 177, 0))
        PushScaleformMovieMethodParameterString(GetLabelText("HUD_INPUT3"))
        EndScaleformMovieMethod()
    end

    local count = 2

    if (self.InstructionalButtons ~= nil) then
        for i = 1, #self.InstructionalButtons do
            if self.InstructionalButtons[i] then
                if #self.InstructionalButtons[i] == 2 then
                    BeginScaleformMovieMethod(self.InstructionalScaleform, "SET_DATA_SLOT")
                    ScaleformMovieMethodAddParamInt(count)
                    PushScaleformMovieMethodParameterButtonName(self.InstructionalButtons[i][1])
                    PushScaleformMovieMethodParameterString(self.InstructionalButtons[i][2])
                    EndScaleformMovieMethod()
                    count = count + 1
                end
            end
        end
    end

    BeginScaleformMovieMethod(self.InstructionalScaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    ScaleformMovieMethodAddParamInt(-1)
    EndScaleformMovieMethod()
end

---@return UIMenu | boolean
function UIMenu:IsShowing()

    if (lib.ui.CurrentMenu == self) then

        return self;

    end

    if (#SubMenus[self.id] > 0) then

        for _, submenu in pairs(SubMenus[self.id]) do

            if (lib.ui.CurrentMenu ~= nil) then

                local Menu = Menus[submenu]:IsShowing();

                if (Menu) then
                    return Menu;
                end

            end

        end

    end

    return false;

end

---CreateMenu
---@param Title string
---@param Subtitle string
---@param X number
---@param Y number
---@param TextureDictionary string
---@param TextureName string
---@param R number
---@param G number
---@param B number
---@param A number
---@return UIMenu
---@public
function UIMenu.CreateMenu(Title, Subtitle, X, Y, TextureDictionary, TextureName, R, G, B, A)
    return UIMenu(Title, Subtitle, X, Y, TextureDictionary, TextureName, R, G, B, A);
end

---CreateSubMenu
---@param ParentMenu UIMenu
---@param Title string
---@param Subtitle string
---@param X number
---@param Y number
---@param TextureDictionary string
---@param TextureName string
---@param R number
---@param G number
---@param B number
---@param A number
---@return UIMenu
---@public
function UIMenu.CreateSubMenu(ParentMenu, Title, Subtitle, X, Y, TextureDictionary, TextureName, R, G, B, A)

    if (ParentMenu ~= nil) then

        if (ParentMenu) then

            local Menu = UIMenu(Title or ParentMenu.Title, Subtitle or ParentMenu.Subtitle, X or ParentMenu.X, Y or ParentMenu.Y);
            Menu.Parent = ParentMenu;
            Menu.WidthOffset = ParentMenu.WidthOffset;
            Menu.Safezone = ParentMenu.Safezone;

            if (ParentMenu.Sprite) then

                Menu.Sprite = {

                    Dictionary = TextureDictionary or ParentMenu.Sprite.Dictionary,
                    Texture = TextureName or ParentMenu.Sprite.Texture,
                    Color = {

                        R = R or ParentMenu.Sprite.Color.R,
                        G = G or ParentMenu.Sprite.Color.G,
                        B = B or ParentMenu.Sprite.Color.B,
                        A = A or ParentMenu.Sprite.Color.A

                    }

                };

            else

                Menu.Rectangle = ParentMenu.Rectangle;

            end

            SubMenus[ParentMenu.id][#SubMenus[ParentMenu.id] + 1] = Menu.id;
            return Menu;

        else
            return nil;
        end

    else
        return nil;
    end

end
