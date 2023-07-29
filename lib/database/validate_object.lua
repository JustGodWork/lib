---@param object table
---@return table
return function(object)
    assert(lib.is_server, 'This function can only be called on the server.');
    return type(object) == "table" and object or {};
end