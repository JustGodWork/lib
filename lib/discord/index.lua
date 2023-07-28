---@type lib.discord
lib.discord = Class.singleton_extends('lib.discord', 'EventEmitter', function(class)

    ---@class lib.discord: EventEmitter
    ---@field public guild lib.discord.guild
    ---@field public channel lib.discord.channel
    ---@field public field lib.discord.field
    ---@field public message lib.discord.message
    ---@field public guilds table<string, lib.discord.guild>
    local self = class;

    function self:Constructor()
        self:super();
        self.guild = require 'lib.discord.guild';
        self.channel = require 'lib.discord.channel';
        self.field = require 'lib.discord.field';
        self.message = require 'lib.discord.message';
        self.slash_command = require 'lib.discord.slashcommand';
        self.slash_command_option = require 'lib.discord.slash_command_option';
        self.slash_command_choice = require 'lib.discord.slash_command_choice';
        self.guilds = {};
    end

    ---@param callback function
    function self:Ready(callback)
        exports['lib']:discord_on_ready(callback);
    end

    ---@return boolean
    function self:IsReady()
        return exports['lib']:discord_is_ready();
    end

    ---@param guildId string
    ---@return boolean
    function self:DoesGuildExist(guildId)
        assert(type(guildId) == 'string', 'lib.discord:DoesGuildExist(): guildId must be a string');
        return exports['lib']:discord_guild_exist(guildId);
    end

    ---@param id string
    ---@return lib.discord.guild | nil
    function self:GetGuild(id)
        assert(type(id) == 'string', 'lib.discord:GetGuild(): id must be a string');
        return self.guilds[id];
    end

    ---@param guildId string
    ---@return lib.discord.guild
    function self:AddGuild(guildId)
        assert(type(guildId) == 'string', 'lib.discord:AddGuild(): guildId must be a string');
        if (typeof(self.guilds[guildId], 'lib.discord.guild')) then
            local color = lib.color.get_current();
            console.warn(('lib.discord:AddGuild(): guild ^7(%s%s^7)^0 has already been registered.'):format(color, guildId));
        else
            local guild = lib.discord.guild(guildId);
            self.guilds[guild.id] = guild;
        end
        return self.guilds[guildId];
    end

    ---@param guildId string
    ---@return boolean
    function self:RemoveGuild(guildId)
        assert(type(guildId) == 'string', 'lib.discord:RemoveGuild(): guildId must be a string');
        if (typeof(self.guilds[guildId], 'lib.discord.guild')) then
            self.guilds[guildId] = nil;
            return true;
        else
            local color = lib.color.get_current();
            console.warn(('lib.discord:RemoveGuild(): guild ^7(%s%s^7)^0 not exists.'):format(color, guildId));
        end
        return false;
    end

    return self;

end);