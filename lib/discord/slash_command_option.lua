---@class lib.discord.slash_command_option: BaseObject
---@field public name string
---@field public description string
---@field public choices lib.discord.slash_command_choice[]
---@field public required boolean
---@overload fun(command: lib.discord.slash_command, name: string, description: string, required: boolean, choices: lib.discord.slash_command_choice[]): lib.discord.slash_command_option
local SlashCommandOption = Class.new 'lib.discord.slash_command_option';

---@param command string
---@param name string
---@param description string
---@param required boolean
---@param choices lib.discord.slash_command_choice[]
function SlashCommandOption:Constructor(command, name, description, required, choices, type)
    self.name = name;
    self.description = description;
    self.choices = choices;
    self.required = required;
    if (type == 'number') then
        exports['lib']:discord_add_number_option(command, name, description, required, table.unpack(choices or {}));
    elseif (type == 'string') then
        exports['lib']:discord_add_string_option(command, name, description, required, table.unpack(choices or {}));
    elseif (type == 'boolean') then
        exports['lib']:discord_add_boolean_option(command, name, description, required);
    end
end

return SlashCommandOption;