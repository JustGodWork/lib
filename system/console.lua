---@class console
console = {};

-- Cache table.insert as local because it's faster
local table_insert = table.insert;
local _print = print;
local logTypes = {
    ["INFO"] = "^4INFO",
    ["WARN"] = "^3WARN",
    ["ERROR"] = "^1ERROR",
    ["DEBUG"] = "^6DEBUG",
    ["SUCCESS"] = "^2SUCCESS",
};

---@private
---@param tbl table
---@param show_metatable boolean
local function dump_table(tbl, show_metatable)

    local data, buffer = {}, {};

    -- Internal recursive function
    local function dump_table_recursive(object, indentation, show_meta)

        local object_type = lib.cache.type(object);

        -- If it's a table and was not outputted yet
        if (object_type == 'table' and not data[object]) then
            local object_metatable = getmetatable(object);

            if (object_metatable and show_meta) then
                dump_table_recursive(object_metatable, indentation, show_meta);
            end
            -- Marks as visited
            data[object] = true;

            -- Stores all keys in another table, sorting it
            local keys = {};

            for key in pairs(object) do
                table_insert(keys, key);
            end

            table.sort(keys, function(a, b)
                if lib.cache.type(a) == "number" and lib.cache.type(b) == "number" then
                    return a < b
                else
                    return tostring(a) < tostring(b);
                end
            end)

            -- Increases one indentation, as we will start outputting table elements
            indentation = indentation + 1

            -- Main table displays '{' in a separated line, subsequent ones will be in the same line
            table_insert(buffer, indentation == 1 and "\n^7{^0" or "^7{^0");

            -- For each member of the table, recursively outputs it
            for _, key in ipairs(keys) do

                local formatted_key = lib.cache.type(key) == "number" and tostring(key) or '^7"^5' .. tostring(key) .. '^7"^0';

                -- Appends the Key with indentation
                table_insert(buffer, "\n" .. string.rep(" ", indentation * 4) .. formatted_key .. " = ");

                -- Appends the Element
                dump_table_recursive(object[key], indentation, show_meta);

                -- Appends a last comma
                table_insert(buffer, ",");
            end

            -- After outputted the whole table, backs one indentation
            indentation = indentation - 1

            -- Adds the closing bracket
            table_insert(buffer, "\n" .. string.rep(" ", indentation * 4) .. "^7}^0");
        else

            local obj = tostring(object);
            local obj_msg = "";

            if (object_type == "string") then
                obj_msg = '^7"^3' .. obj .. '^7"^0';
            elseif (object_type == "number") then
                obj_msg = '^2' .. obj .. '^0';
            elseif (object_type == "boolean") then
                obj_msg = '^5' .. obj .. '^0';
            elseif (object_type == "nil") then
                obj_msg = '^11undefined^0';
            elseif (object_type == "table") then
                obj_msg = '^8'.. obj ..'^0';
            else
                obj_msg = '^6' .. obj .. '^0';
            end

            table_insert(buffer, obj_msg);

        end

        return data, buffer;

    end

    -- Main call
    dump_table_recursive(tbl, 0, show_metatable);

    -- After all, concats the results
    return table.concat(buffer);

end

---@private
---@param logType string
---@param message any
---@param messageType string
---@vararg
---@return string | boolean
local function format_message(logType, ...)

    local msg = string.format("^7(%s^7)^0 =>", logTypes[logType]);
    local args = { ... };

    if (#args > 0) then

        for i = 1, #args do

            if (lib.cache.type(args[i]) == "table") then
                msg = ("%s\n^5table^0: ^3%s"):format(msg, dump_table(args[i], args[i].show_meta));
            else
                msg = ("%s %s"):format(msg, tostring(args[i]));
            end

        end

        return string.format("%s^0", msg);

    else
        return false;
    end

end

---@private
---@param logType string
---@param ... any
local function send_message(logType, ...)

    local success, msg = pcall(format_message, logType, ...);

    if (success) then
        if (lib.cache.type(msg) == "string") then
            _print(msg);
        end
    else
        console.err(("An error occured when trying to trace content, stack: ^7(^1%s^7)"):format(msg));
    end

end

---@vararg any
function console.log(...)
    return send_message("INFO", ...);
end

---@vararg any
function console.warn(...)
    return send_message("WARN", ...);
end

---@vararg any
function console.err(...)
    return send_message("ERROR", ...);
end

---@varargs any
function console.debug(...)

    if (lib.debug) then
        return send_message("DEBUG", ...);
    end

end

---@varargs any
function console.success(...)
    return send_message("SUCCESS", ...);
end

print = console.log;
_G._print = _print;

local resource = GetCurrentResourceName();

AddEventHandler(('__internal_console_log_%s'):format(resource), console.log);
AddEventHandler(('__internal_console_warn_%s'):format(resource), console.warn);
AddEventHandler(('__internal_console_err_%s'):format(resource), console.err);
AddEventHandler(('__internal_console_debug_%s'):format(resource), console.debug);
AddEventHandler(('__internal_console_success_%s'):format(resource), console.success);

return console;