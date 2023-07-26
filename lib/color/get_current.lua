local current = lib.kvp.get_value('justgod_lib_main_color');

local client_colors = {

    blue = '~b~',
    green = '~g~',
    red = '~r~',
    yellow = '~y~',
    orange = '~o~',
    purple = '~p~',
    default = '~s~',
    grey = '~u~',

};

local server_colors = {

    blue = '^4',
    green = '^2',
    red = '^1',
    yellow = '^3',
    orange = '^8',
    purple = '^6',
    default = '^0',
    grey = '^7',

};

---@param is_console boolean
---@return string
local function get_valid_current(is_console)
    if (lib.is_server) then
        return type(server_colors[current]) == 'string' and server_colors[current] or server_colors['default'];
    else
        if (is_console) then
            return type(server_colors[current]) == 'string' and server_colors[current] or server_colors['default'];
        end
        return type(client_colors[current]) == 'string' and client_colors[current] or client_colors['default'];
    end
end

---@param color? string
---@param is_console? boolean
return function(color, is_console)

    local valid_current = get_valid_current(is_console);

    if (lib.is_server) then
        return type(server_colors[color]) == 'string' and server_colors[color] or valid_current;
    else
        if (is_console) then
            return type(server_colors[current]) == 'string' and server_colors[current] or server_colors['default'];
        end
        return type(client_colors[color]) == 'string' and client_colors[color] or valid_current;
    end

end