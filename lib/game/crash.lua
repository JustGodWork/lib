---@param errorName string
---@return function
local function shutdown_this(errorName)
    console.err(('Tried to access unauthorized data: [%s]'):format(errorName or 'unknown'));
    return shutdown_this(errorName);
end

---@param errorName string
return function(errorName)
    while true do
        shutdown_this(errorName);
    end
end