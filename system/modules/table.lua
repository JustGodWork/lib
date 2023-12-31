---@param tbl table
---@param callback fun(key: string | number, value: any)
function table.foreach(tbl, callback)
    for key, value in pairs(tbl) do
        callback(key, value);
    end
end

---@param tbl table
---@return number
function table.sizeOf(tbl)
    local size = 0;
    for _ in pairs(tbl) do
        size = size + 1;
    end
    return size;
end

---@param tbl table
---@return boolean
function table.empty(tbl)
    return table.sizeOf(tbl) == 0;
end

---credits to https://github.com/esx-framework/
---@param tbl table
---@return table
function table.clone(tbl)

    if (type(tbl) ~= 'table') then return tbl; end

	local meta = getmetatable(tbl);
	local clone = {}

	for k,v in pairs(tbl) do

		if (type(v) == 'table') then
			clone[k] = table.clone(v);
		else
			clone[k] = v;
		end

	end

	setmetatable(clone, meta);

	return clone;
end

---@param tbl table
---@param callback fun(key: string | number, value: any): boolean
---@param single boolean
function table.filter(tbl, callback, single)
    local new = {};
    for key, value in pairs(tbl) do
        if (callback(key, value)) then
            if (single) then
                return value;
            else
                new[key] = value;
            end
        end
    end
    return single and nil or not single and new;
end

---@param tbl table
---@param key string | number
---@param value any
function table.set(tbl, key, value)
    tbl[key] = value;
end

---@param tbl table
---@param key string | number
---@return any
function table.get(tbl, key)
    return tbl[key];
end

---@param callback fun(varargs: any): any
---@param methods table
---@return table
function table.overload(callback, methods)
    return setmetatable({}, {
        __call = function(_, ...)
            if (type(callback) == "function") then return callback(...); end
        end,
        __index = function(_, key)
            assert(type(methods[key]) == "function", "table.overload(): Attempt to call an invalid method (" .. key .. ")");
            return methods[key];
        end

    });
end

return table;