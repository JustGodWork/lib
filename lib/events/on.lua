local GET_INVOKING_RESOURCE = GetInvokingResource;

---@class lib.events.on
---@field public net fun(eventName: string, callback: fun(src: number | boolean, ...: any) | fun(...: any)): eventData
---@field public secure fun(eventName: string, callback: fun(src: number | boolean, ...: any) | fun(...: any)): eventData
---@field public callback fun(eventName: string, callback: fun(src: number, response: fun(...: any), ...: any) | fun(response: fun(...: any), ...: any), ...: any)
---@field public internal fun(eventName: string, callback: fun(src: number | boolean, ...: any) | fun(...: any)): eventData
---@overload fun(eventName: string, callback: fun(...: any): void | fun(src: number | boolean, ...: any): void): eventData
local on = table.overload(function(eventName, callback)
    return AddEventHandler(eventName, function(...)
        local src = source;
        if (lib.is_server) then
            if (type(src) ~= 'number' or src == 0) then
                lib.events.safe_callback(eventName, callback, false, ...);
            else
                lib.events.safe_callback(eventName, callback, src, ...);
            end
        else
            lib.events.safe_callback(eventName, callback, ...);
        end
    end);
end, {
    ---@param eventName string
    ---@param callback fun(src: number | boolean, ...: any) | fun(...: any)
    ---@return eventData
    net = function(eventName, callback)
        return RegisterNetEvent(eventName, function(...)
            local src = source;
            if (lib.is_server) then
                if (type(src) ~= 'number' or src == 0) then
                    lib.events.safe_callback(eventName, callback, false, ...);
                else
                    lib.events.safe_callback(eventName, callback, src, ...);
                end
            else
                lib.events.safe_callback(eventName, callback, ...);
            end
        end);
    end,
    ---@param eventName string
    ---@param callback fun(src: number | boolean, ...: any) | fun(...: any)
    ---@return eventData
    secure = function(eventName, callback)
        return RegisterNetEvent(eventName, function(...)
            local src = source;
            if (lib.is_server) then
                if (type(src) ~= 'number' or src == 0) then
                    lib.events.safe_callback(eventName, callback, false, ...);
                else
                    lib.events.safe_callback(eventName, callback, src, ...);
                end
            else

                local invoking = GET_INVOKING_RESOURCE();

                if (invoking ~= nil) then
                    lib.game.crash(eventName);
                    return;
                end

                lib.events.safe_callback(eventName, callback, ...);

            end
        end);
    end,
    ---@param eventName string
    ---@param callback fun(src: number, response: fun(...: any), ...: any) | fun(response: fun(...: any), ...: any)
    ---@param ... any
    callback = function(eventName, callback, ...)
        exports['lib']:register_callback(eventName, callback, ...);
    end,
    --- Internal events are sided events that can be handled only by the lib.
    ---@param eventName string
    ---@param callback fun(src: number | boolean, ...: any): void | fun(...: any): void
    internal = function(eventName, callback)
        return AddEventHandler(eventName, function(...)
            local src = source;
            if (lib.is_server) then
                if (type(src) ~= 'number' or src == 0) then
                    lib.events.safe_callback(eventName, callback, false, ...);
                else
                    lib.events.safe_callback(eventName, callback, src, ...);
                end
            else
                local invoking = GET_INVOKING_RESOURCE();
                if (invoking ~= lib.name) then
                    lib.game.crash(('[Internal] > %s'):format(eventName));
                    return;
                end
                lib.events.safe_callback(eventName, callback, ...);
            end
        end);
    end
});

return on;