local _error = error;

---@param message string
---@param level number
function error(message, level)
    return _error(message, type(level) == 'number' and level or 0);
end

---@overload fun(callback: function, catch: fun(error: string)): any
local error_handler = setmetatable({}, {
    __name = 'TryCatch System',
    __call = function(_, callback, catch)
        local success, result = pcall(callback);
        if (not success) then
            if (type(catch) == 'function') then
                catch(result);
            end
        end
        return success and result;
    end;
});

return error_handler;