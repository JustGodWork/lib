---@param eventName string
---@param callback fun(event: lib.events.base_event | lib.events.net_event, src: number, ...: any)
---@vararg any
---@overload fun(eventName: string, callback: fun(...: any), ...: any)
return function(eventName, callback, ...)
    local success, result = pcall(callback, ...);
    if (not success) then
        console.err(("An error occured while executing event ^7(^4%s^7)^0, stack: ^7(^1%s^7)"):format(eventName, result));
    end
end