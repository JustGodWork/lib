exports('discord_remove_command', (guildId, commandName) => {
    command_handler.remove(guildId, commandName);
});