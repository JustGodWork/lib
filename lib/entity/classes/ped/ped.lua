local SET_PED_DEFAULT_COMPONENT_VARIATION = SetPedDefaultComponentVariation;
local SET_PED_RANDOM_COMPONENT_VARIATION = SetPedRandomComponentVariation;
local GET_SELECTED_PED_WEAPON = GetSelectedPedWeapon;
local REMOVE_WEAPON_FROM_PED = RemoveWeaponFromPed;
local CLEAR_PED_BLOOD_DAMAGE = ClearPedBloodDamage;
local GIVE_WEAPON_TO_PED = GiveWeaponToPed;


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

--- Get the current equiped weapon hash
---@return number
function Ped:GetCurrentWeapon()
    ---@todo: Create Weapon Class
    return GET_SELECTED_PED_WEAPON(self:GetHandle());
end

---@param name string
---@param ammo number
---@param forceInHand boolean
function Ped:AddWeapon(name, ammo, forceInHand)
    ---todo: Create Weapon Class
    assert(type(name) == 'string', 'weaponName must be a string');
    local hash = lib.game.hash(name:upper());
    GIVE_WEAPON_TO_PED(self:GetHandle(), hash, ammo, false, forceInHand);
end

---@param name string
function Ped:RemoveWeapon(name)
    assert(type(name) == 'string', 'weaponName must be a string');
    local hash = lib.game.hash(name:upper());
    REMOVE_WEAPON_FROM_PED(self:GetHandle(), hash);
end

return Ped;