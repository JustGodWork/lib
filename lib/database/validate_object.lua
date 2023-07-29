---@param object table
---@return table
return function(object)
    return type(object) == "table" and object or {};
end