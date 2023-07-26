---@param parent string
---@param key string
---@return any
return function(parent, key)

    if (typeof(lib.config.default[parent], 'Config')) then

        if (lib.config.default[parent].type == 'table') then

            local config = lib.config.get(parent);

            if (typeof(lib.config.default[parent].data[key], 'Config')) then
                if (type(config[key]) == lib.config.default[parent].data[key].type) then
                    return config[key];
                elseif (type(lib.config.default[parent].data[key].secondary_type) == 'string') then
                    if (type(config[key]) == lib.config.default[parent].data[key].secondary_type) then
                        return config[key];
                    end
                else
                    console.err(("^3Config key ^1Config.%s.%s^3 is not valid! Switching to default."):format(parent, key));
                    config[key] = lib.config.default[parent].data[key].value;
                    console.debug(("^3Config key ^1Config.%s.%s^3 is now set to ^1%s^3."):format(parent, key, type(config[key])));
                    return config[key];
                end
            else
                console.err(("^3Config key ^1Config.%s.%s^3 is not registered!"):format(parent, key));
            end

        else
            console.err(("^3Config key ^1%s^3 is not a valid parent!"):format(parent));
        end

    else
        console.err(("^3Config key ^1%s^3 is not registered!"):format(parent));
    end

end