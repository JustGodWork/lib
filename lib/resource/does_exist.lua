---@param resource string
---@return boolean
return function(resource)
    local state = GetResourceState(resource);
    return state ~= 'missing' and state ~= 'uninitialized' and state ~= 'unknown' and state ~= 'stopped';
end