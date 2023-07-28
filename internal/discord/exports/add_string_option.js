exports('discord_add_string_option', (commandName, optionName, optionDescription, choices, required) => {
    command_handler.addStringOption(commandName, optionName, optionDescription, choices, required);
});