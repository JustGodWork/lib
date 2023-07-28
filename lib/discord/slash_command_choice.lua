---@class lib.discord.slash_command_choice: BaseObject
---@field public name string
---@field public value string
---@overload fun(name: string, value: string): lib.discord.slash_command_choice
local SlashCommandChoice = lib.class.new 'lib.discord.slash_command_choice';

---@param name string
---@param value string
function SlashCommandChoice:Constructor(name, value)
    self.name = name;
    self.value = value;
end

return SlashCommandChoice;