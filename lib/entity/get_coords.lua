local GET_ENTITY_COORDS = GetEntityCoords;
local GET_ENTITY_HEADING = GetEntityHeading;

---@param entity number
---@param vec4 boolean
---@return vector3 | vector4
return function(entity, vec4)

    if (not lib.entity.does_exist(entity)) then
        return vec4 and vector4(0.0, 0.0, 0.0, 0.0) or vector3(0.0, 0.0, 0.0);
    end

    if (vec4) then
        local coords = GET_ENTITY_COORDS(entity);
        local heading = GET_ENTITY_HEADING(entity);
        return vector4(coords.x, coords.y, coords.z, heading);
    end

    return GET_ENTITY_COORDS(entity);

end