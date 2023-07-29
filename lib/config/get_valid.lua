---@param key string
---@return any
return function(key)

    if (has_type(lib.config.default[key], 'Config')) then

        if (type(Config) == 'table') then

            if (type(Config[key]) == lib.config.default[key].type) then
                return Config[key];
            end

            if (type(lib.config.default[key].secondary_type) == 'string') then
                if (type(Config[key]) == lib.config.default[key].secondary_type) then
                    return Config[key];
                end
            end
        else
            Config = {};
        end

        console.err(("^3Config key ^1%s^3 is not valid! Switching to default."):format(key));
        Config[key] = lib.config.default[key].value;
        console.debug(("^3Config key ^1%s^3 is now set to ^1%s^3."):format(key, type(Config[key])));
        return Config[key];

    end

    console.err(("^3Config key ^1%s^3 is not registered!"):format(key));

end