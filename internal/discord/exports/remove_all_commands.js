exports('discord_remove_all_commands', (guildId) => {
    command_handler.removeAll(guildId);
});