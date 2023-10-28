---@class lib.events.net_event: lib.events.base_event
---@overload fun(): lib.events.net_event
local NetEvent = Class.extends('lib.events.net_event', 'lib.events.base_event');

function NetEvent:Constructor()
	self:super();
	self.type = 'NetEvent';
end

function NetEvent:SetHandler()
	self.handler = RegisterNetEvent(self.name, function(...)
		local src = source;
		self.callback(src, ...);
	end);
	return self;
end

return NetEvent;

