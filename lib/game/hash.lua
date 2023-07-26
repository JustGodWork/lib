---@param value string | number
---@return number
return function(value)
    return type(value) == 'string' and joaat(value) or type(value) == 'number' and value or -1;
end