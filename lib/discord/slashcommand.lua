---@class lib.discord.slash_command: EventEmitter
---@field public name string
---@field public description string
---@field public role string
---@overload fun(name: string, description: string, callback: fun(notify: fun(message: string), userId: string, ...:any), roleId: string): lib.discord.slash_command
local SlashCommand = Class.extends('lib.discord.slash_command', 'EventEmitter');

function SlashCommand:Constructor(name, description, callback, roleId)
    self:super();
    assert(lib.is_server, 'This function can only be called on the server.');
    assert(type(name) == 'string', 'lib.discord.slash_command:Constructor(): name must be a string');
    assert(type(description) == 'string', 'lib.discord.slash_command:Constructor(): description must be a string');
    assert(type(callback) == 'function', 'lib.discord.slash_command:Constructor(): callback must be a function');
    self.name = name;
    self.description = description;
    self.role = roleId;
    exports['lib']:discord_add_command(name, description, function(notify, userId, data)
        console.log(data);
        callback(notify, userId, table.unpack(data));
        self:emit('execute', userId, table.unpack(data));
    end, roleId);
end

---@param name string
---@param description string
---@param choices table
---@param required boolean
function SlashCommand:AddStringOption(name, description, choices, required)
    assert(type(name) == 'string', 'lib.discord.slash_command:AddStringOption(): name must be a string');
    assert(type(description) == 'string', 'lib.discord.slash_command:AddStringOption(): description must be a string');
    assert(type(choices) == 'table' or choices == nil, 'lib.discord.slash_command:AddStringOption(): choices must be a table or nil');
    assert(type(required) == 'boolean' or required == nil, 'lib.discord.slash_command:AddStringOption(): required must be a boolean or nil');
    exports['lib']:discord_add_string_option(self.name, name, description, choices, required);
    return self;
end

---@param name string
---@param description string
---@param choices table
---@param required boolean
function SlashCommand:AddNumberOption(name, description, choices, required)
    assert(type(name) == 'string', 'lib.discord.slash_command:AddNumberOption(): name must be a string');
    assert(type(description) == 'string', 'lib.discord.slash_command:AddNumberOption(): description must be a string');
    assert(type(choices) == 'table' or choices == nil, 'lib.discord.slash_command:AddNumberOption(): choices must be a table or nil');
    assert(type(required) == 'boolean' or required == nil, 'lib.discord.slash_command:AddNumberOption(): required must be a boolean or nil');
    exports['lib']:discord_add_number_option(self.name, name, description, choices, required);
    return self;
end

---@param name string
---@param description string
---@param required boolean
function SlashCommand:AddBooleanOption(name, description, required)
    assert(type(name) == 'string', 'lib.discord.slash_command:AddBooleanOption(): name must be a string');
    assert(type(description) == 'string', 'lib.discord.slash_command:AddBooleanOption(): description must be a string');
    assert(type(required) == 'boolean' or required == nil, 'lib.discord.slash_command:AddBooleanOption(): required must be a boolean or nil');
    exports['lib']:discord_add_boolean_option(self.name, name, description, required);
    return self;
end

return SlashCommand;