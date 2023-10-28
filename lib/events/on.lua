local GET_INVOKING_RESOURCE = GetInvokingResource;
local base_event = require 'lib.events.classes.base_event';
local net_event = require 'lib.events.classes.net_event';

---@class lib.events.on
---@field public net fun(eventName: string, callback: fun(event: lib.events.net_event, src: number | boolean, ...: any) | fun(...: any)): lib.events.net_event
---@field public secure fun(eventName: string, callback: fun(event: lib.events.net_event, src: number | boolean, ...: any) | fun(...: any)): lib.events.net_event
---@field public callback fun(eventName: string, callback: fun(src: number, response: fun(...: any), ...: any) | fun(response: fun(...: any), ...: any), ...: any): void
---@field public internal fun(eventName: string, callback: fun(event: lib.events.base_event, src: number | boolean, ...: any) | fun(...: any)): lib.events.base_event
---@field public game fun(eventName: string, callback: fun(event: lib.events.base_event, ...: any)): lib.events.base_event
---@overload fun(eventName: string, callback: fun(event: lib.events.base_event, ...: any): void | fun(event: lib.events.base_event, src: number | boolean, ...: any): void): lib.events.base_event
local on = table.overload(function(eventName, callback)
    return base_event()
        :SetName(eventName)
        :SetCallback(function(event, source, ...)
            if (lib.is_server) then
                if (type(source) ~= 'number' or v == 0) then
                    lib.events.safe_callback(eventName, callback, event, false, ...);
                else
                    lib.events.safe_callback(eventName, callback, event, source, ...);
                end
            else
                lib.events.safe_callback(eventName, callback, event, ...);
            end
        end)
        :SetHandler();
end, {
    ---@param eventName string
    ---@param callback fun(event: lib.events.net_event, src: number | boolean, ...: any) | fun(event: lib.events.net_event, ...: any)
    ---@return lib.events.net_event
    net = function(eventName, callback)
        return net_event()
            :SetName(eventName)
            :SetCallback(function(event, source, ...)
                if (lib.is_server) then
                    if (type(source) ~= 'number' or source == 0) then
                        lib.events.safe_callback(eventName, callback, event, false, ...);
                    else
                        lib.events.safe_callback(eventName, callback, event, source, ...);
                    end
                else
                    lib.events.safe_callback(eventName, callback, event, ...);
                end
            end)
            :SetHandler();
    end,
    ---@param eventName string
    ---@param callback fun(event: lib.events.net_event, src: number | boolean, ...: any) | fun(event: lib.events.net_event, ...: any)
    ---@return lib.events.net_event
    secure = function(eventName, callback)
        return net_event()
            :SetName(eventName)
            :SetCallback(function(event, source, ...)
                if (lib.is_server) then
                    if (type(source) ~= 'number' or source == 0) then
                        lib.events.safe_callback(eventName, callback, event, false, ...);
                    else
                        lib.events.safe_callback(eventName, callback, event, source, ...);
                    end
                else

                    local invoking = GET_INVOKING_RESOURCE();

                    if (invoking ~= nil) then
                        lib.game.crash(eventName);
                        return;
                    end

                    lib.events.safe_callback(eventName, callback, ...);

                end
            end)
            :SetHandler();
    end,
    ---@param eventName string
    ---@param callback fun(src: number, response: fun(...: any), ...: any) | fun(response: fun(...: any), ...: any)
    ---@param ... any
    callback = function(eventName, callback, ...)
        exports['lib']:register_callback(eventName, callback, ...);
    end,
    --- Internal events are sided events that can be handled only by the lib.
    ---@param eventName string
    ---@param callback fun(event: lib.events.base_event, src: number | boolean, ...: any): void | fun(event: lib.events.base_event, ...: any): void
    ---@return lib.events.base_event
    internal = function(eventName, callback)
        return base_event()
            :SetName(eventName)
            :SetCallback(function(event, source, ...)
                if (lib.is_server) then
                    if (type(source) ~= 'number' or source == 0) then
                        lib.events.safe_callback(eventName, callback, event, false, ...);
                    else
                        lib.events.safe_callback(eventName, callback, event, source, ...);
                    end
                else
                    local invoking = GET_INVOKING_RESOURCE();
                    if (invoking ~= lib.name) then
                        lib.game.crash(('[Internal] > %s'):format(eventName));
                        return;
                    end
                    lib.events.safe_callback(eventName, callback, event, ...);
                end
            end)
            :SetHandler();
    end,
    ---@param eventName string
    ---@param callback fun(event: lib.events.base_event, ...: any): void
    ---@return lib.events.base_event
    game = function(eventName, callback)
        return base_event()
            :SetName("gameEventTriggered")
            :SetCallback(function(event, _, event_name, ...)
                if (eventName == event) then
                    lib.events.safe_callback(("Game Event (%s)"):format(eventName), callback, event, ...);
                end
            end)
            :SetHandler();
    end
});

return on;