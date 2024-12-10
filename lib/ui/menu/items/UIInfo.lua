local _RenderRectangle = lib.ui.RenderRectangle;
local _RenderText = lib.ui.RenderText;

local settings = {
    text = {
        maximumLines = 7 -- 7 is the maximum number of lines possible, otherwise they won't be displayed.
    }
}

---@param title string
---@param righText table
---@param leftText table
function UIItems:Info(title, righText, leftText)
    local CurrentMenu = lib.ui.CurrentMenu;

    assert(righText and type(righText) == 'table', '"righText" must be a table and cannot be empty');
    assert(leftText and type(leftText) == 'table', '"righText" must be a table and cannot be empty');
    assert(#righText == #leftText, '"righText" and "leftText" must be equal');
    assert(#righText <= settings.text.maximumLines or #leftText <= settings.text.maximumLines, 'The table "righText" and "leftText" must have a maximum of 7 lines');

    if (CurrentMenu ~= nil) then
        
        if (CurrentMenu) then
            
            local lineCount = #righText >= #leftText and #righText or #leftText

            if (title ~= nil) then
                assert(type(title) == 'string', '"title" muste be a string');
                _RenderText("~h~" .. title .. "~h~", CurrentMenu.X + 330 + 20 + 100, CurrentMenu.Y + 7, 0, 0.34, 255, 255, 255, 255, 0)
            end
            if (righText ~= nil) then
                _RenderText(table.concat(righText, "\n"), CurrentMenu.X + 330 + 20 + 100, title ~= nil and CurrentMenu.Y + 37 or CurrentMenu.Y + 7, 0, 0.28, 255, 255, 255, 255, 0)
            end
            if (leftText ~= nil) then
                _RenderText(table.concat(leftText, "\n"), CurrentMenu.X + 330 + 432 + 100, title ~= nil and CurrentMenu.Y + 37 or CurrentMenu.Y + 7, 0, 0.28, 255, 255, 255, 255, 2)
            end

            _RenderRectangle(CurrentMenu.X + 330 + 10 + 100, CurrentMenu.Y, 432, title ~= nil and 50 + (lineCount * 20) or ((lineCount + 1) * 20), 0, 0, 0, 160)
            
        end

    end 
end