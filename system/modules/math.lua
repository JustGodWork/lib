---@param number number
---@param decimals number
---@return number
function math.round(number, decimals)
    local _decimals = type(decimals) == 'number' and decimals or 0;
    local power = 10 ^ _decimals;
    return math.floor(number * power + 0.5) / power;
end

---@param number number | string
---@return number | nil
function math.trim(number)
	return number and (string.gsub(number, "^%s*(.-)%s*$", "%1")) or nil;
end

return math;