---@class lib.discord.field: BaseObject
---@field public name string
---@field public value string
---@field public inline boolean
---@overload fun(): lib.discord.field
local Field = Class.new 'lib.discord.field';

function Field:Constructor(name, value, inline)
    self.name = tostring(name);
    self.value = tostring(value);
    self.inline = inline == true;
end

---@param name string
function Field:SetName(name)
    self.name = tostring(name);
    return self;
end

---@param value string
function Field:SetValue(value)
    self.value = tostring(value);
    return self;
end

---@param inline boolean
function Field:SetInline(inline)
    self.inline = inline;
    return self;
end

return Field;