---@param callback function
---@return table
return function(callback)

    assert(lib.is_server, 'This function can only be called on the server.');

    local is_ready = lib.database.is_ready();

    if (type(callback) == 'function') then

        if (not is_ready) then
            lib.events.on('lib.database.connected', callback);
            return;
        end

        callback();
        return;

    end

    console.err('^7(^6Database^7)^0 => lib.database.on_ready: callback is not a function.');

end