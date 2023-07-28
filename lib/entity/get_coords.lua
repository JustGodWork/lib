local GET_ENTITY_COORDS = GetEntityCoords;
local GET_ENTITY_HEADING = GetEntityHeading;

---@param entity number
---@param vec4 boolean
---@return vector3
return function(entity, vec4)

    local entity_valid = lib.entity.does_exist(entity);

    if (vec4) then
        local coords = GET_ENTITY_COORDS(entity);
        local heading = GET_ENTITY_HEADING(entity);
        return entity_valid and vector4(coords.x, coords.y, coords.z, heading) or vector4(0, 0, 0, 0);
    end
    return entity_valid and GET_ENTITY_COORDS(entity) or vector3(0, 0, 0);
end