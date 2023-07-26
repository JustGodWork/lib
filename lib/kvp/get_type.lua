local to_number = tonumber;

---@param value any
---@return string
return function(value)
    if (type(value) == 'string') then
        if (value == 'null') then return nil; end
        local number = to_number(value);
        return ((value == 'true' or value == 'false') and value == 'true') or number and number or value;
    end
    return value;
end