local GET_ENTITY_COORDS = GetEntityCoords;
local GET_ENTITY_HEADING = GetEntityHeading;

---@param entity number
---@return vector4
return function(entity)

    if (not lib.entity.does_exist(entity)) then
        return vector4(0.0, 0.0, 0.0, 0.0);
    end

    local coords = GET_ENTITY_COORDS(entity);
    local heading = GET_ENTITY_HEADING(entity);

    return vector4(coords.x, coords.y, coords.z, heading);

end