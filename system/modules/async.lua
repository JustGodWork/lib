---@class async
---@field wait async fun(ms: number): void
---@overload fun(callback: function): void
async = table.overload(CreateThread, {

    ---@async
    ---@param ms number
    wait = function(ms)
        Wait(ms);
    end

});

return async;