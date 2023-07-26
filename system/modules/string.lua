---@param str string
---@param sep string
---@return table
function string.split(str, sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    str:gsub(pattern, function(c) fields[#fields + 1] = c end)
    return fields;
end

---@param str string
---@param maxLen number
---@return string
function string.reduce(str, maxLen)
    if (#str > maxLen) then
        return str:sub(1, maxLen) .. '...';
    end
    return str;
end

---@param str string
---@return table
function string.spacerSplit(str)
    local tbl = {};
    local function recursive(lastStr)
        local spacerStart, spacerEnd = lastStr:find('\n');
        if (type(spacerStart) == 'number' and type(spacerEnd) == 'number') then
            tbl[#tbl+1] = lastStr:sub(1, spacerStart-1);
            return recursive(lastStr:sub(spacerEnd+1));
        else
            tbl[#tbl+1] = lastStr;
            return tbl;
        end
    end
    return recursive(str);
end

---Return hashed string
---@param str string | number
---@return number
function string.hash(str)
    return type(str) == 'string' and GetHashKey(str) or str;
end

--- todo: fix all toVector methods Error: 'unfinished capture'

---@param str string
function string.toVector2(str)
    if (str:find('vector2(') and str:find(')')) then
        str = str:gsub('vector2(', '');
        str = str:gsub(')', '');
    end

    local vector = string.split(str, ',');
    return vector2(tonumber(vector[1]), tonumber(vector[2]));
end

---@param str string
---@return vector3
function string.toVector3(str)
    if (str:find('vector3(') and str:find(')')) then
        str = str:gsub('vector3(', '');
        str = str:gsub(')', '');
    end

    local vector = string.split(str, ',');
    return vector3(tonumber(vector[1]), tonumber(vector[2]), tonumber(vector[3]));
end

---@param str string
---@return vector4
function string.toVector4(str)
    if (str:find('vector4(') and str:find(')')) then
        str = str:gsub('vector4(', '');
        str = str:gsub(')', '');
    end

    local vector = string.split(str, ',');
    return vector4(tonumber(vector[1]), tonumber(vector[2]), tonumber(vector[3]), tonumber(vector[4]));
end

return string;