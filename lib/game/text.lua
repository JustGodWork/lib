
local SET_TEXT_FONT = SetTextFont;
local SET_TEXT_SCALE = SetTextScale;
local SET_TEXT_COLOUR = SetTextColour;
local SET_TEXT_CENTRE = SetTextCentre;
local SET_DRAW_ORIGIN = SetDrawOrigin;
local CLEAR_DRAW_ORIGIN = ClearDrawOrigin;
local GET_GAMEPLAY_CAM_FOV = GetGameplayCamFov;
local SET_TEXT_PROPORTIONAL = SetTextProportional;
local GET_FINAL_RENDERED_CAM_COORD = GetFinalRenderedCamCoord;
local END_TEXT_COMMAND_DISPLAY_TEXT = EndTextCommandDisplayText;
local BEGIN_TEXT_COMMAND_DISPLAY_TEXT = BeginTextCommandDisplayText;
local ADD_TEXT_COMPONENT_SUBSTRING_PLAYER_NAME = AddTextComponentSubstringPlayerName;

---@param text string
---@param coords vector3 | table
---@param size number
---@param font number
---@return void
return function(text, coords, size, font)
	assert(not lib.is_server, 'This function can only be used on the client side.');
	assert(type(text) == 'string', 'lib.game.text - The text must be a string.');
	local vector = type(coords) == "vector3" and coords
		or vector3(coords.x, coords.y, coords.z);
    local camCoords = GET_FINAL_RENDERED_CAM_COORD();
    local distance = #(vector - camCoords);
	local _size = type(size) == 'number' and size or 1;
	local _font = type(font) == 'number' and font or 0;
    local scale = (_size / distance) * 2;
    local fov = (1 / GET_GAMEPLAY_CAM_FOV()) * 100;
	local _scale = (scale * fov);

    SET_TEXT_SCALE(0.0, 0.55 * _scale);
    SET_TEXT_FONT(_font);
    SET_TEXT_PROPORTIONAL(1);
    SET_TEXT_COLOUR(255, 255, 255, 215);
    BEGIN_TEXT_COMMAND_DISPLAY_TEXT('STRING');
    SET_TEXT_CENTRE(true);
    ADD_TEXT_COMPONENT_SUBSTRING_PLAYER_NAME(text);
    SET_DRAW_ORIGIN(vector, 0);
    END_TEXT_COMMAND_DISPLAY_TEXT(0.0, 0.0);
    CLEAR_DRAW_ORIGIN();
end