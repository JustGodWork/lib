exports('discord_send_command', (guildId, commandName) => {
    command_handler.send(guildId, commandName);
});