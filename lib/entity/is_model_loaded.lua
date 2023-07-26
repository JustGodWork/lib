
local HAS_MODEL_LOADED = HasModelLoaded;

---@param model number
---@return boolean
return function(model)

    assert(not lib.is_server, 'This function can only be called on the client.');

    if (type(model) == 'number' and model ~= -1) then
        return HAS_MODEL_LOADED(model);
    end
    return false;

end