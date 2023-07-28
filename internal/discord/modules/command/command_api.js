const { REST, Routes, SlashCommandBuilder } = require('discord.js');
const client = require('../client');
const logger = require('../logger');

const clientId = GetConvar('justgod_lib_discord_client_id', 'N/A');
const token = GetConvar('justgod_lib_discord_token', 'N/A');

const _token = token !== 'N/A' && typeof token === 'string' ? token : null;
const client_id = clientId !== 'N/A' && typeof clientId === 'string' ? clientId : null;

const rest = _token !== null ? new REST().setToken(token): null;

/**
 *
 * @param {string} guildId
 * @return {Promise<Array>}
 */
const get_commands = async (guildId) => {
    if (_token !== null && client_id !== null) {
        try {

            const commands = await rest.get(Routes.applicationGuildCommands(client_id, guildId));
            return commands;

        } catch (error) {
            logger.error(error);
        };
    };
};

module.exports = {
    /**
     *
     * @param {string} guildId
     * @param {string} commandName
     * @param {SlashCommandBuilder} data
     */
    add: async (guildId, commandName, data) => {
        if (_token !== null && client_id !== null) {

            //todo: check why get_commands is sometime not working (Maybe timedout ?)
            const command = get_commands(guildId)?.find(command => command.name === commandName);
            if (command !== undefined && command !== null) return;

            try {
                await rest.post(
                    Routes.applicationGuildCommands(clientId, guildId),
                    { body: data.toJSON() },
                );
            } catch (error) {
                logger.error(error);
            };

        };
    },
    /**
     *
     * @param {string} guildId
     * @param {string} commandName
     */
    remove: async (guildId, commandName) => {
        if (_token !== null && client_id !== null) {

            //todo check why i can't delete commands

            const command = get_commands(guildId).find(command => command.name === commandName);
            if (command === undefined || command === null) return;

            try {
                await rest.delete(
                    Routes.applicationGuildCommand(clientId, guildId, command.id),
                );
            } catch (error) {
                logger.error(error);
            };

        };
    },
    /**
     *
     * @param {string} guildId
     * @param {string} commandName
     * @param {SlashCommandBuilder} data
     */
    update: async (guildId, data) => {
        if (_token !== null && client_id !== null) {

            try {
                await rest.post(
                    Routes.applicationGuildCommands(clientId, guildId),
                    { body: data.toJSON() },
                );
            } catch (error) {
                logger.error(error);
            };

        };
    }
};