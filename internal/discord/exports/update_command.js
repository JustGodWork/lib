exports('discord_update_command', (guildId, commandName) => {
    command_handler.update(guildId, commandName);
});