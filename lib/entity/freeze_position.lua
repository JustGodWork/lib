local FREEZE_ENTITY_POSITION = FreezeEntityPosition;

---@param entity number
---@param state boolean
return function(entity, state)
    if (not lib.entity.does_exist(entity)) then return; end
    FREEZE_ENTITY_POSITION(entity, state);
end