---@class lib.events.emit
---@field public net fun(eventName: string, ...: any) | fun(eventName: string, src: number | boolean, ...: any)
---@field public broadcast fun(eventName: string, ...: any): void
---@field public callback fun(eventName: string, src: number, callback: fun(...: any), ...: any): void | fun(eventName: string, callback: fun(...: any), ...: any): void
---@overload fun(eventName: string, src: number | boolean, ...: any): void
---@overload fun(eventName: string, ...: any): void
local emit = table.overload(TriggerEvent, {
    ---@param eventName string
    ---@param src number | boolean
    ---@vararg any
    ---@overload fun(eventName: string, ...: any): void
    net = function(eventName, ...)
        if (lib.is_server) then
            TriggerClientEvent(eventName, ...);
        else
            TriggerServerEvent(eventName, ...);
        end
    end,
    ---@param eventName string
    ---@vararg any
    broadcast = function(eventName, ...)
        TriggerClientEvent(eventName, -1, ...);
    end,
    ---@param eventName string
    ---@param src number
    ---@param callback fun(...: any)
    ---@vararg any
    ---@overload fun(eventName: string, callback: fun(...: any), ...: any): void
    callback = function(eventName, src, callback, ...)
        if (lib.is_server) then
            exports['lib']:emit_callback(eventName, callback, src, ...);
        else
            exports['lib']:emit_callback(eventName, src, callback, ...);
        end
    end
});

return emit;