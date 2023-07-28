exports('discord_add_command', (name, description, callback, roleId) => {
    command_handler.register(name, description, callback, roleId);
});