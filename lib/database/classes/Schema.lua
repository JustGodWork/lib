---@class lib.database.schema: BaseObject
---@field public name string
---@field public fields table<string, string>
---@overload fun(name: string, fields: table<string, string>): lib.database.schema
local Schema = lib.class.new 'lib.database.schema';

---@param name string
---@param fields table<string, any>
function Schema:Constructor(name, fields)
    self.name = name;
    self.fields = type(fields) == 'table' and fields or {};
end

---@param object BaseObject
---@return table<string, any>
function Schema:Serialize(object)
    assert(typeof(object, self.name), ('lib.database.schema:Serialize() %s: Invalid object type'):format(self.name));
    local serialized = {};

    for key, value in pairs(self.fields) do
        if (type(self.fields[key]) == 'table') then
            if (type(object[key]) == self.fields[key].type) then
                serialized[key] = object[key];
            else
                serialized[key] = self.fields[key].default;
            end
        end
    end

    return serialized;
end

return Schema;