---@class lib.database.schema.field: BaseObject
---@field public name string
---@field public type string
---@field public default any
---@field public schema lib.database.schema
---@overload fun(name: string, type: string, default: any, schema?: lib.database.schema): lib.database.schema.field
local SchemaField = lib.class.new 'lib.database.schema.field';

---@param name string
---@param type string
---@param default any
---@param schema? lib.database.schema
function SchemaField:Constructor(name, type, default, schema)
    assert(lib.is_server, 'lib.database.schema.field can only be called on the server.');
    self.name = name;
    self.type = type;
    self.default = default;
    self.schema = schema;
end

return SchemaField;