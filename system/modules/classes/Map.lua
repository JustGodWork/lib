---@class Map: BaseObject
---@field private data table<string, any>
---@overload fun(): Map
Map = Class.new 'Map';

function Map:Constructor()
	self.data = {};
end

---@param key string
---@return any
function Map:get(key)
	return self.data[key]
end

---@param key string
---@param value any
function Map:set(key, value)
	self.data[key] = value
	return self;
end

---@param key string
---@return boolean
function Map:has(key)
	return self.data[key] ~= nil;
end

---@param key string
---@return boolean
function Map:remove(key)
	if (self:has(key)) then
		self.data[key] = nil;
		return true;
	end
	return false;
end

---@param callback fun(key: string, value: any): any
function Map:forEach(callback)
	for key, value in pairs(self.data) do
		callback(key, value);
	end
	return self;
end

---@param callback? fun(key: string): void
---@return table<string, any>
function Map:keys(callback)
	local result = {};
	for key, _ in pairs(self.data) do
		if (is_function(callback)) then
			callback(key);
		end
		result[#result + 1] = key;
	end
	return result;
end

---@param callback? fun(value: any): void
---@return table<string, any>
function Map:values(callback)
	local result = {};
	for _, value in pairs(self.data) do
		if (is_function(callback)) then
			callback(value);
		end
		result[#result + 1] = value;
	end
	return result;
end

---@param callback fun(key: string, value: any): boolean
function Map:filter(callback)
	local result = Map();
	for key, value in pairs(self.data) do
		if (callback(key, value)) then
			result:set(key, value);
		end
	end
	return result;
end

---@param callback fun(key: string, value: any): boolean
---@return boolean
function Map:predicate(callback)
	for key, value in pairs(self.data) do
		if (callback(key, value)) then
			return true;
		end
	end
	return false;
end

---@param callback fun(key: string, value: any): any
---@return Map
function Map:map(callback)
	local result = Map();
	for key, value in pairs(self.data) do
		result:set(key, callback(key, value));
	end
	return result;
end

return Map;