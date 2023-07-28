---@class lib.discord.guild: EventEmitter
---@field public id string
---@field public channels table<string, lib.discord.channel>
---@overload fun(id: string): lib.discord.guild
local Guild = lib.class.extends('lib.discord.guild', 'EventEmitter');

---@param id string
function Guild:Constructor(id)
    self:super();
    assert(lib.is_server, 'This function can only be called on the server.');
    assert(type(id) == 'string', 'lib.discord.guild:Constructor(): id must be a string');
    self.id = id;
    self.channels = {};
end

---@param channelId string
---@return boolean
function Guild:DoesChannelExist(channelId)
    assert(type(channelId) == 'string', 'lib.discord:DoesChannelExist(): channelId must be a string');
    return exports['lib']:discord_channel_exist(channelId);
end

---@param channelId string
---@return lib.discord.channel
function Guild:AddChannel(channelId)
    assert(type(channelId) == 'string', 'lib.discord.guild:AddChannel(): channel must be a string');
    if (typeof(self.channels[channelId], 'lib.discord.channel')) then
        local color = lib.color.get_current();
        console.warn(('lib.discord.guild:AddChannel(): guild ^7(%s%s^7)^0 has already a channel with id ^7(%s%s^7)^0.'):format(color, self.id, color, channel.id));
    else
        local channel = lib.discord.channel(channelId);
        channel.guild = self.id;
        self.channels[channel.id] = channel;
    end
    return self.channels[channelId];
end

---@param id string
---@return lib.discord.channel | nil
function Guild:GetChannel(id)
    assert(type(id) == 'string', 'lib.discord.guild:GetChannel(): id must be a string');
    return self.channels[id];
end

---@param command lib.discord.slash_command
function Guild:AddCommand(command)
    assert(type(command) == 'lib.discord.slash_command', 'lib.discord.guild:AddCommand(): command must be a lib.discord.slash_command');
    exports['lib']:discord_send_command(self.id, command.name);
    return self;
end

---@param command lib.discord.slash_command
function Guild:UpdateCommand(command)
    assert(type(command) == 'lib.discord.slash_command', 'lib.discord.guild:UpdateCommand(): command must be a lib.discord.slash_command');
    exports['lib']:discord_update_command(self.id, command.name);
    return self;
end

---@param commandName string
function Guild:RemoveCommand(commandName)
    assert(type(commandName) == 'string', 'lib.discord.guild:RemoveCommand(): commandName must be a string');
    exports['lib']:discord_remove_command(self.id, commandName);
    return self;
end

function Guild:RemoveAllCommands()
    exports['lib']:discord_remove_all_commands(self.id);
    return self;
end

return Guild;