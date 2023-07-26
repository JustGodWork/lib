---@class Config: BaseObject
---@field public value any
---@field public type string
---@field public secondary_type string
---@field public data Config[]
---@overload fun(value: any, valueType: string, secondaryType: string, parent: Config): Config
local Config = Class.new 'Config';

---@param value any
---@param valueType string
---@param secondaryType string
function Config:Constructor(value, valueType, secondaryType, parent)
    self.value = value;
    self.type = valueType;
    self.secondary_type = secondaryType;
    self.data = {};
end

return Config;