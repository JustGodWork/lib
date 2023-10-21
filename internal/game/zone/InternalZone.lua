---@class InternalZone: BaseObject
---@field public id string
---@field public resource string
---@field public active boolean
---@field public position vector3
---@field public size number
---@field public metadata Map
---@overload fun(id: string, resource: string): InternalZone
local InternalZone = Class.new "InternalZone";

---@param id string
---@param resource string
function InternalZone:Constructor(id, resource)
    self.id = id;
    self.resource = resource;
    self.active = false;
    self.position = nil;
    self.size = 0;
    self.metadata = Map();
end

return InternalZone;