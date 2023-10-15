const { REST, Routes } = require('discord.js');
const client = require('../client');
const logger = require('../logger');

const clientId = GetConvar('justgod_lib_discord_client_id', 'N/A');
const token = GetConvar('justgod_lib_discord_token', 'N/A');

class CommandAPI {

    constructor() {
        this._token = token !== 'N/A' && typeof token === 'string' ? token : null;
        this.client_id = clientId !== 'N/A' && typeof clientId === 'string' ? clientId : null;
        this.rest = this._token !== null ? new REST().setToken(this._token): null;
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