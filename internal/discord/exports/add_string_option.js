exports('discord_add_string_option', (commandName, optionName, optionDescription, required, ...choices) => {
    command_handler.addStringOption(commandName, optionName, optionDescription, required, ...choices);
});