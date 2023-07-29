local SET_PED_DEFAULT_COMPONENT_VARIATION = SetPedDefaultComponentVariation;
local SET_PED_RANDOM_COMPONENT_VARIATION = SetPedRandomComponentVariation;
local CLEAR_PED_BLOOD_DAMAGE = ClearPedBloodDamage;

---@class lib.entity.ped: lib.entity
---@field public handle number
---@field public model string
---@field public coords vector4
---@overload fun(): lib.entity.ped
local Ped = lib.class.extends('lib.entity.ped', 'lib.entity');

---@param handle number
function Ped:Constructor(handle)
    self:super(handle);
end

function Ped:SetDefaultComponent()
    SET_PED_DEFAULT_COMPONENT_VARIATION(self:GetHandle());
end

function Ped:SetRandomComponent()
    SET_PED_RANDOM_COMPONENT_VARIATION(self:GetHandle());
end

function Ped:ClearBloodDamage()
    CLEAR_PED_BLOOD_DAMAGE(self:GetHandle());
end

return Ped;