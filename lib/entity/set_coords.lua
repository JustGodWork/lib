---@param coords vector3 | vector4
local function are_coords_valid(coords)
    return type(coords.x) == 'number' and type(coords.y) == 'number' and type(coords.z) == 'number';
end

---@param entity number
---@param coords vector3 | vector4
---@param no_offset boolean
local function set_coords(entity, coords, no_offset)
    if (not lib.is_server and no_offset) then
        SetEntityCoordsNoOffset(entity, coords);
    else
        SetEntityCoords(entity, coords);
    end
end

---@param entity number
---@param coords vector3 | vector4
---@param no_offset boolean
return function(entity, coords, no_offset)

    if (not lib.entity.does_exist(entity)) then return; end

    if (type(coords) == 'table' or type(coords) == 'vector3' or type(coords) == 'vector4') then

        if (not are_coords_valid(coords)) then return; end

        if (type(coords.w) == 'number') then
            SetEntityHeading(entity, coords.w);
        end

        set_coords(entity, coords, no_offset);

    end

end