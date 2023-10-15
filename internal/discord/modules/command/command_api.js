const { REST, Routes, Events } = require('discord.js');
const client = require('../client');
const logger = require('../logger');

const clientId = GetConvar('justgod_lib_discord_client_id', 'N/A');
const token = GetConvar('justgod_lib_discord_token', 'N/A');

class CommandAPI {

    constructor() {
        this._token = token !== 'N/A' && typeof token === 'string' ? token : null;
        this.client_id = clientId !== 'N/A' && typeof clientId === 'string' ? clientId : null;
        this.rest = this._token !== null ? new REST().setToken(this._token): null;
        this.initialize();
    };

    initialize() {
        client.on(Events.ClientReady, async () => {
            if (this.isInitialized())
            logger.info('^0Discord integration ^2ready^0 ! Don\'t forget to use command: ^7"^4update_commands^7" after creating commands.');
        });
        RegisterCommand('update_commands', async (source) => {
            if (source !== 0) return;
            if (!this.isInitialized())
                return logger.error('Invalid state. Please check your token and client id.');
            await this.update();
        });
    };

    isInitialized() {
        return this._token !== null && this.client_id !== null;
    };

    /**
     *
     * @return {Array}
     */
    format() {
        if (!this.isInitialized()) return;
        const commands = [];
        for (const [name, command] of client.commands) {
            if ('execute' in command && 'data' in command)
                commands.push(command.data.toJSON());
            else
                logger.error(`Command ${name} is not formatted correctly.`);
        };
        return commands;
    };

    async update() {
        if (!this.isInitialized()) return;

        try {
            logger.info('Started registering commands...');
            const commands = this.format();

            await this.rest.put(
                Routes.applicationCommands(this.client_id),
                {body: commands},
            );

            logger.success('Successfully registered commands.');
        } catch (error) {
            logger.error(error);
        };

    };

};

module.exports = new CommandAPI();