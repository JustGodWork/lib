exports('discord_add_number_option', (commandName, optionName, optionDescription, choices, required) => {
    command_handler.addNumberOption(commandName, optionName, optionDescription, choices, required);
});