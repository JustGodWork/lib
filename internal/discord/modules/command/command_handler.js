const { Events } = require('discord.js');
const { SlashCommandBuilder } = require('@discordjs/builders');
const client = require('../client');
const api = require('./command_api');
const logger = require('../logger');

class CommandHandler {

    /**
     *
     * @param {string} name
     * @param {string} description
     * @param {Function} execute
     * @param {string | null} roleId
     */
    register(name, description, execute, roleId) {

        const data = new SlashCommandBuilder()
            .setName(name)
            .setDescription(description);

        client.commands.set(name, {
            data: data,
            execute: typeof execute === 'function' ? execute : () => logger.error(`Command ${name}: execute is not a function.`),
            role: typeof roleId === 'string' ? roleId : null
        });

        return data;

    };

    /**
     *
     * @param {string} commandName
     * @param {string} optionName
     * @param {string} optionDescription
     * @param {boolean} required
     */
    addStringOption(commandName, optionName, optionDescription, required, ...args) {

        const command = client.commands.get(commandName);
        if (command === undefined) return;

        command.data.addStringOption(option =>
            option.setName(typeof optionName === 'string' ? optionName: 'error_undefined_name')
            .setDescription(typeof optionDescription === 'string' ? optionDescription: 'error_undefined_description')
            .setRequired(typeof required === 'boolean' ? required: false)
            .addChoices(...args)
        );

    };

    /**
     *
     * @param {string} commandName
     * @param {string} optionName
     * @param {string} optionDescription
     * @param {boolean} required
     */
    addNumberOption(commandName, optionName, optionDescription, required, ...args) {

        const command = client.commands.get(commandName);
        if (command === undefined) return;

        command.data.addNumberOption(option =>
            option.setName(typeof optionName === 'string' ? optionName: 'error_undefined_name')
            .setDescription(typeof optionDescription === 'string' ? optionDescription: 'error_undefined_description')
            .setRequired(typeof required === 'boolean' ? required: false)
            .addChoices(...args)
        );

    };

    /**
     *
     * @param {string} commandName
     * @param {string} optionName
     * @param {string} optionDescription
     * @param {boolean} required
     */
    addBooleanOption(commandName, optionName, optionDescription, required) {

        const command = client.commands.get(commandName);
        if (command === undefined) return;

        command.data.addBooleanOption((option) =>
            option.setName(typeof optionName === 'string' ? optionName: 'error_undefined_name')
            .setDescription(typeof optionDescription === 'string' ? optionDescription: 'error_undefined_description')
            .setRequired(typeof required === 'boolean' ? required: false)
        );

    };

    /**
     *
     * @param {Function} callback
     */
    deffer(callback) {
        if (client.isReady()) {
            if (typeof callback === 'function') callback();
        } else {
            client.on(Events.ClientReady, callback);
        };
    };

    /**
     *
     * @param {string} guildId
     * @param {string} commandName
     */
    send(guildId, commandName) {
        const command = client.commands.get(commandName);
        if (command === undefined) return;
        this.deffer(() => {
            if (!client.guilds.cache.has(guildId)) return;
            api.add(guildId, command.data.name, command.data);
        });
    };

    /**
     *
     * @param {string} guildId
     * @param {string} commandName
     */
    remove(guildId, commandName) {
        this.deffer(() => {
            if (!client.guilds.cache.has(guildId)) return;
            api.remove(guildId, commandName);
        });
    };

    removeAll(guildId) {
        this.deffer(() => {
            if (!client.guilds.cache.has(guildId)) return;
            api.remove_all(guildId);
        });
    };

    /**
     *
     * @param {string} guildId
     * @param {string} commandName
     */
    update(guildId, commandName) {
        const command = client.commands.get(commandName);
        if (command === undefined) return;
        this.deffer(() => {
            if (!client.guilds.cache.has(guildId)) return;
            api.update(guildId, command.data);
        });
    };

};

module.exports = new CommandHandler();