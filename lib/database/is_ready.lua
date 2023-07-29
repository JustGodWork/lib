---@return boolean
return function()
    assert(lib.is_server, 'This function can only be called on the server.');
    return exports['lib']:mongo_is_connected();
end