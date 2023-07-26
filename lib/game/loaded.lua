local events = EventEmitter();

if (not lib.is_server) then

    local NETWORK_IS_PLAYER_ACTIVE = NetworkIsPlayerActive;
    local player_id = PlayerId();

    async(function()
        while true do
            if (NETWORK_IS_PLAYER_ACTIVE(player_id)) then
                events:emit('client:ready');
                break;
            end
            async.wait(100);
        end
    end);

end

---@param callback function
return function(callback)
    assert(not lib.is_server, 'This function can only be called on the client.');
    return events:on('client:ready', callback);
end