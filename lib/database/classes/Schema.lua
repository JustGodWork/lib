---@class lib.database.schema: BaseObject
---@field public name string
---@field public fields table<string, lib.database.schema.field>
---@overload fun(name: string, fields: table<string, lib.database.schema.field>): lib.database.schema
local Schema = lib.class.new 'lib.database.schema';

---@param name string
---@param fields table<string, any>
function Schema:Constructor(name, fields)
    assert(lib.is_server, 'lib.database.schema can only be called on the server.');
    self.name = name;
    self.fields = type(fields) == 'table' and fields or {};
end

---@param object BaseObject
---@return table<string, any>
function Schema:Serialize(object)
    assert(typeof(object) == self.name, ('lib.database.schema:Serialize() %s: Invalid object type'):format(self.name));
    local serialized = {};

    for key, value in pairs(self.fields) do
        if (type(self.fields[key]) == 'table') then
            if (typeof(self.fields[key].schema) == 'lib.database.schema') then
                serialized[key] = self.fields[key].schema:Serialize(object[key]);
            elseif (self.fields[key].type == 'vector2' and type(object[key]) == 'vector2') then
                serialized[key] = { x = object[key].x, y = object[key].y };
            elseif (self.fields[key].type == 'vector3' and type(object[key]) == 'vector3') then
                serialized[key] = { x = object[key].x, y = object[key].y, z = object[key].z };
            elseif (self.fields[key].type == 'vector4' and type(object[key]) == 'vector4') then
                serialized[key] = { x = object[key].x, y = object[key].y, z = object[key].z, w = object[key].w };
            elseif (type(object[key]) == self.fields[key].type) then
                serialized[key] = object[key];
            else
                serialized[key] = self.fields[key].default;
            end
        end
    end

    return serialized;
end

---@param result table<string, any>
function Schema:GetResult(result)

    local object = {};

    for key, value in pairs(self.fields) do
        if (type(self.fields[key]) == 'table') then
            if (typeof(self.fields[key].schema) == 'lib.database.schema') then
                object[key] = self.fields[key].schema:GetResult(result[key]);
            elseif (self.fields[key].type == 'vector2' and type(result[key]) == 'table') then
                object[key] = vector2(result[key].x, result[key].y);
            elseif (self.fields[key].type == 'vector3' and type(result[key]) == 'table') then
                object[key] = vector3(result[key].x, result[key].y, result[key].z);
            elseif (self.fields[key].type == 'vector4' and type(result[key]) == 'table') then
                object[key] = vector4(result[key].x, result[key].y, result[key].z, result[key].w);
            elseif (type(result[key]) == self.fields[key].type) then
                object[key] = result[key];
            else
                object[key] = self.fields[key].default;
            end
        end
    end

    return object;

end

---@return table<string, any>
function Schema:Default()
    local default = {};

    for key, value in pairs(self.fields) do
        if (type(self.fields[key]) == 'table') then
            if (typeof(self.fields[key].schema) == 'lib.database.schema') then
                default[key] = self.fields[key].schema:Default();
            elseif (self.fields[key].type == 'vector2') then
                if (type(self.fields[key].default) == 'vector2') then
                    default[key] = self.fields[key].default;
                else
                    default[key] = vector2(0, 0);
                end
            elseif(self.fields[key].type == 'vector3') then
                if (type(self.fields[key].default) == 'vector3') then
                    default[key] = self.fields[key].default;
                else
                    default[key] = vector3(0, 0, 0);
                end
            elseif(self.fields[key].type == 'vector4') then
                if (type(self.fields[key].default) == 'vector4') then
                    default[key] = self.fields[key].default;
                else
                    default[key] = vector4(0, 0, 0, 0);
                end
            else
                default[key] = self.fields[key].default;
            end
        end
    end

    return default;
end

return Schema;