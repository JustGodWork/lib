local ENTITY = Entity;

---@class lib.entity: EventEmitter
---@overload fun(handle?: number): lib.entity
local Entity = lib.class.extends('lib.entity', 'EventEmitter');

---@param handle number
function Entity:Constructor(handle)

    self:super();

    local metatable = self:GetMetatable();

    self.handle = handle;
    self.model = nil;
    self.type = metatable.__name;

end

---@param entity? Entity
---@return boolean
function Entity.IsValid(entity)
    return typeof(entity) == entity.type and lib.entity.does_exist(entity:GetHandle());
end

---@return number
function Entity:GetHandle()
    return self.handle;
end

---@return Entity
function Entity:GetState()
    return ENTITY(self:GetHandle()).state;
end

---@return vector4
function Entity:GetCoords()
    return lib.entity.get_coords(self:GetHandle());
end

---@param coords vector3 | vector4
---@param no_offset boolean
function Entity:SetCoords(coords, no_offset)
    lib.entity.set_coords(self:GetHandle(), coords, no_offset);
    self:emit(eEntityEvents.UpdatedCoords, coords);
end

---@param toggle boolean
function Entity:FreezePosition(toggle)
    lib.entity.freeze_position(self:GetHandle(), toggle);
end

return Entity;