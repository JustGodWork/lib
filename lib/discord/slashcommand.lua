---@class lib.discord.slash_command: EventEmitter
---@field public name string
---@field public description string
---@field public role string
---@field public options lib.discord.slash_command_option[]
---@overload fun(name: string, description: string, callback: fun(notify: fun(message: string), userId: string, ...:any), roleId: string): lib.discord.slash_command
local SlashCommand = Class.extends('lib.discord.slash_command', 'EventEmitter');

---@param name string
---@param description string
---@param callback fun(notify: fun(message: string), userId: string, ...:any)
---@param roleId string
function SlashCommand:Constructor(name, description, callback, roleId)
    self:super();
    assert(lib.is_server, 'This function can only be called on the server.');
    assert(type(name) == 'string', 'lib.discord.slash_command:Constructor(): name must be a string');
    assert(type(description) == 'string', 'lib.discord.slash_command:Constructor(): description must be a string');
    assert(type(callback) == 'function', 'lib.discord.slash_command:Constructor(): callback must be a function');
    self.name = name;
    self.description = description;
    self.role = roleId;
    self.options = {};
    exports['lib']:discord_add_command(name, description, function(notify, userId, data)
        callback(notify, userId, table.unpack(data));
        self:emit('execute', userId, table.unpack(data));
    end, roleId);
end

---@param name string
---@param description string
---@param required boolean
---@param choices lib.discord.slash_command_choice[]
function SlashCommand:AddStringOption(name, description, required, choices)
    assert(type(name) == 'string', 'lib.discord.slash_command:AddStringOption(): name must be a string');
    assert(type(description) == 'string', 'lib.discord.slash_command:AddStringOption(): description must be a string');
    assert(type(choices) == 'table' or choices == nil, 'lib.discord.slash_command:AddStringOption(): choices must be a table or nil');
    assert(type(required) == 'boolean' or required == nil, 'lib.discord.slash_command:AddStringOption(): required must be a boolean or nil');
    self.options[name] = lib.discord.slash_command_option(self.name, name, description, required, choices, 'string');
    return self;
end

---@param name string
---@param description string
---@param required boolean
---@param choices lib.discord.slash_command_choice[]
function SlashCommand:AddNumberOption(name, description, required, choices)
    assert(type(name) == 'string', 'lib.discord.slash_command:AddNumberOption(): name must be a string');
    assert(type(description) == 'string', 'lib.discord.slash_command:AddNumberOption(): description must be a string');
    assert(type(choices) == 'table' or choices == nil, 'lib.discord.slash_command:AddNumberOption(): choices must be a table or nil');
    assert(type(required) == 'boolean' or required == nil, 'lib.discord.slash_command:AddNumberOption(): required must be a boolean or nil');
    self.options[name] = lib.discord.slash_command_option(self.name, name, description, required, choices, 'number');
    return self;
end

---@param name string
---@param description string
---@param required boolean
function SlashCommand:AddBooleanOption(name, description, required)
    assert(type(name) == 'string', 'lib.discord.slash_command:AddBooleanOption(): name must be a string');
    assert(type(description) == 'string', 'lib.discord.slash_command:AddBooleanOption(): description must be a string');
    assert(type(required) == 'boolean' or required == nil, 'lib.discord.slash_command:AddBooleanOption(): required must be a boolean or nil');
    self.options[name] = lib.discord.slash_command_option(self.name, name, description, required, nil, 'boolean');
    return self;
end

function SlashCommand:GetOption(name)
    assert(type(name) == 'string', 'lib.discord.slash_command:GetOption(): name must be a string');
    return self.options[name];
end

return SlashCommand;