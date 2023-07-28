exports('discord_add_boolean_option', (commandName, optionName, optionDescription, required) => {
    command_handler.addBooleanOption(commandName, optionName, optionDescription, required);
});