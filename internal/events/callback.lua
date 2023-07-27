local current_id = 1;
local callbacks = {};
local requests = {};

---@return number
local function increment_request_id()
    current_id = current_id > 65535 and 1 or current_id + 1;
    console.debug(('Incrementing request id to ^7(%s%s^7)^0'):format(lib.color.get_current(nil, true) ,current_id));
    return current_id;
end

---@param callback fun(...: any)
local function is_callback_valid(callback)
    return type(callback) == 'function' or type(callback) == 'table' and callback['__cfx_functionReference'] ~= nil;
end

---@param eventName string
---@param callback fun(src: number, ...: any)
---@vararg any
---@overload fun(eventName: string, callback: fun(...: any), ...: any)
local function safe_callback(eventName, callback, ...)
    local success, result = pcall(callback, ...);
    if (not success) then
        console.err(("An error occured while executing event ^7(%s%s^7)^0, stack: ^7(^1%s^7)"):format(lib.color.get_current(nil, true), eventName, result));
    end
end

---@param eventName string
---@param callback fun(src: number, response: fun(...: any), ...: any) | fun(response: fun(...: any), ...: any)
---@param ... any
local function register_callback(eventName, callback, ...)
    if (is_callback_valid(callback)) then
        if (is_callback_valid(callbacks[eventName])) then
            console.warn(("Event callback ^7(%s%s^7)^0 already has a callback registered, overwriting..."):format(lib.color.get_current(nil, true) ,eventName));
        end
        callbacks[eventName] = callback;
    end
end

---@param eventName string
---@param callback fun(...: any)
---@param src number
---@vararg any
local function emit_callback(eventName, callback, src, ...)

    local args = {...};

    if (is_callback_valid(callback)) then

        requests[current_id] = function(...)

            local success, result = pcall(callback, ...);

            if (not success) then
                console.err(("An error occured while executing event ^7(%s%s^7)^0, stack: ^7(^1%s^7)"):format(lib.color.get_current(nil, true) ,eventName, result));
            end

        end;

        if (lib.is_server) then
            lib.events.emit.net(eLibEvents.emitCallback, src, eventName, current_id, table.unpack(args));
        else
            lib.events.emit.net(eLibEvents.emitCallback, eventName, current_id, src, table.unpack(args));
        end

        increment_request_id();

    else
        console.err(('An error occured while emitting event callback ^7(%s%s^7)^0, stack: ^7(^1Invalid callback^7)'):format(lib.color.get_current(nil, true) ,eventName or 'nil'));
    end

end

RegisterNetEvent(eLibEvents.emitCallback, function(eventName, requests_id, ...)

    local src = source;
    local args = {...};

    if (lib.is_server) then
        safe_callback(eventName, callbacks[eventName], src, function(...)
            lib.events.emit.net(eLibEvents.receiveCallback, src, eventName, requests_id, ...);
        end, table.unpack(args));
    else
        safe_callback(eventName, callbacks[eventName], function(...)
            lib.events.emit.net(eLibEvents.receiveCallback, eventName, requests_id, ...);
        end, table.unpack(args));
    end

end);

RegisterNetEvent(eLibEvents.receiveCallback, function(eventName, requests_id, ...)

    if (not lib.is_server) then
        local invoking = GetInvokingResource();
        if (invoking ~= nil) then
            lib.game.crash(eLibEvents.receiveCallback);
        end
    end

    safe_callback(eventName, requests[requests_id], ...);
    requests[requests_id] = nil;

end);

exports('register_callback', register_callback);
exports('emit_callback', emit_callback);