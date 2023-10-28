local events = {};

---@class lib.events.base_event: BaseObject
---@field public name string
---@field public handler eventData
---@field public times_triggered number
---@field public callback fun(...: any)
---@field private type string
---@overload fun(): lib.events.base_event
local Event = Class.new 'lib.events.base_event';

function Event:Constructor()
	self.id = uuid();
	self.name = nil;
	self.handler = nil;
	self.times_triggered = 0;
	self.callback = nil;
	self.type = 'BaseEvent';
	events[self.id] = self;
end

---@param id string
---@return lib.events.base_event
function Event.Get(id)
	return events[id];
end

---@param event lib.events.base_event
---@return boolean
function Event.Remove(event)
	if (is_instance(event)) then
		lib.events.remove(event.handler);
		events[event.id] = nil;
		console.debug(('Removing event ^7(^6%s^0, ^6%s^7)'):format(event.name, event.id));
		return true;
	end
	return false;
end

function Event:GetName()
	return self.name;
end

---@param name string
function Event:SetName(name)
	assert(type(name) == 'string', 'Event:SetName() - name must be a string');
	self.name = name;
	return self;
end

function Event:SetHandler()
	self.handler = AddEventHandler(self.name, function(...)
		local src = source;
		self.callback(src, ...);
	end);
	console.debug(('Registering event ^7(^6%s^0, ^6%s^7)'):format(self.name, self.id));
	return self;
end

---@param callback fun(event: lib.events.base_event | lib.events.net_event, source: number, ...: any)
function Event:SetCallback(callback)
	self.callback = function (...)
		self.times_triggered += 1;
		if (is_function(callback)) then
			callback(self, ...);
		end
	end;
	return self;
end

return Event;