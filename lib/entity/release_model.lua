local SET_MODEL_AS_NO_LONGER_NEEDED = SetModelAsNoLongerNeeded;

---@param model number
return function(model)

    assert(not lib.is_server, 'This function can only be called on the client.');

    if (type(model) == 'number' and model ~= -1) then
        SET_MODEL_AS_NO_LONGER_NEEDED(model);
    end

end