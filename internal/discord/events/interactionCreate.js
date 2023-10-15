const client = require('../modules/client');
const { Events } = require('discord.js');
const logger = require('../modules/logger');

client.on(Events.InteractionCreate, async (interaction) => {

    if (!interaction.isCommand()) return;

    await interaction.deferReply({ ephemeral: true });

    const { commandName } = interaction;
    const command = client.commands.get(commandName);
    if (!command) return;

    if (!interaction) return;

    if ('data' in command && 'execute' in command) {
        try {

            if (command.role !== null && !interaction.member?.roles?.cache?.has(command.role)) {
                await interaction.followUp({
                    content: 'You do not have permission to use this command!',
                    ephemeral: true
                });
            } else {
                await command.execute(async function(message){
                    await interaction.followUp({ content: message, ephemeral: true });
                }, interaction.user.id, interaction.options.data);
                setTimeout(async () => {
                    if (!interaction.replied)
                        await interaction.deleteReply();
                }, 8000);
            };

        } catch (error) {
            logger.error(error);
            await interaction.followUp({
                content: 'There was an error while executing this command!',
                ephemeral: true
            });
        };
    } else {
        logger.error('Command is missing data or execute.');
        await interaction.followUp({
            content: 'There was an error while executing this command!',
            ephemeral: true
        });
    };

});