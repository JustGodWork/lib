---@class List: BaseObject
---@field private data table<number, any>
---@overload fun(): List
List = Class.new 'List';

function List:Constructor()
	self.data = {};
end

---@param value any
function List:add(value)
	self.data[#self.data + 1] = value;
	return self;
end

---@param index number
function List:remove(index)
	self.data[index] = nil;
	return self;
end

---@param index number
---@return any
function List:at(index)
	return self.data[index];
end

---@param callback fun(index: number, value: any)
function List:forEach(callback)
	for i = 1, #self.data do
		callback(i, self.data[i]);
	end
	return self;
end

---@param callback fun(value: any): boolean
---@return boolean
function List:contains(callback)
	for i = 1, #self.data do
		if (callback(self.data[i])) then
			return true;
		end
	end
	return false;
end

---@param callback fun(value: any): boolean
---@return any
function List:find(callback)
	for i = 1, #self.data do
		if (callback(self.data[i])) then
			return self.data[i];
		end
	end
	return nil;
end

---@param value any
---@return number | nil
function List:index(value)
	for i = 1, #self.data do
		if (self.data[i] == value) then
			return i;
		end
	end
	return nil;
end

---@param callback fun(index: number, value: any): any
---@return List
function List:list(callback)
	local result = List();
	for i = 1, #self.data do
		result:add(callback(i, self.data[i]));
	end
	return result;
end

return List;