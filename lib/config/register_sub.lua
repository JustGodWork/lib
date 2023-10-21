---@param parent string
---@param key string
---@param value any
---@param valueType string
---@param secondaryType string
return function(parent, key, value, valueType, secondaryType)
    if (typeof(lib.config.default[parent]) == 'Config') then
        if (type(lib.config.default[parent].data[key]) ~= 'Config') then
            lib.config.default[parent].data[key] = lib.config.class.config(value, valueType, secondaryType);
        else
            console.warn(("^3Config key ^1%s^3 already registered!"):format(key));
        end
    else
        console.warn(("^3Config key ^1%s^3 is not a valid parent!"):format(parent));
    end
end