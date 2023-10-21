---@class ZoneRadius: EventEmitter
---@field private id string
---@field public position vector3
---@field public size number
---@field public actions List
local ZoneRadius = Class.extends('ZoneRadius', 'EventEmitter');

function ZoneRadius:Constructor()
	assert(not lib.is_server, 'ZoneRadius class is only available on client.');
	self:super();
	self.id = lib.uuid();
	self.position = nil;
	self.size = 0;
	self.active = false;
	self.actions = List();
end

---@param position vector3
function ZoneRadius:SetPosition(position)
	self.position = position;
	return self;
end

---@param size number
function ZoneRadius:SetSize(size)
	self.size = size;
	return self;
end

---@param action fun(self: ZoneRadius)
function ZoneRadius:AddAction(action)
	self.actions:add(action);
	return self;
end

function ZoneRadius:IsIn()
	local playerPed = PlayerPedId();
	local playerCoords = GetEntityCoords(playerPed);
	local distance = #(playerCoords - self.position);
	return distance <= self.size;
end

---@param callback fun(self: ZoneRadius)
function ZoneRadius:OnEnter(callback)
	self:on('enter', callback);
	return self;
end

---@param callback fun(self: ZoneRadius)
function ZoneRadius:OnExit(callback)
	self:on('exit', callback);
	return self;
end

---@private
--- Should not be called directly.
function ZoneRadius:Handle()
	if (self.position == nil) then return; end
	if (self:IsIn()) then
		if (not self.active) then
			self.active = true;
			self:emit('enter', self);
		end
		self.actions:forEach(function(index, action)
			if (is_function(action)) then
				action(self);
			end
		end);
	else
		if (self.active) then
			self.active = false;
			self:emit('exit', self);
		end
	end
end

return ZoneRadius;