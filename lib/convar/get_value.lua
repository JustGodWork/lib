---@param key string
---@return any
return function(key)

    local convar = GetConvar(key);

    if (type(convar) == 'string') then
        return lib.convar.get_type(convar);
    end

    return nil;

end