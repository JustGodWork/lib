exports('discord_add_string_option', (commandName, optionName, optionDescription, required, ...args) => {
    command_handler.addStringOption(commandName, optionName, optionDescription, required, ...args);
});