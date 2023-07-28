exports('discord_add_number_option', (commandName, optionName, optionDescription, required, ...args) => {
    command_handler.addNumberOption(commandName, optionName, optionDescription, required, ...args);
});