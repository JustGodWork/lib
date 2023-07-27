const client = require('./client');
const { Events, EmbedBuilder } = require('discord.js');
const logger = require('./logger');
const default_image = GetConvar('justgod_lib_discord_default_image', '');

class MessageHandler {

    /**
     *
     * @param {string} guildId
     * @param {string} channelId
     * @param {Object} messageData
     */
    sendToChannel(guildId, channelId, messageData) {
        const guild = client.guilds.cache.get(guildId);
        if (!guild) return logger.error(`The guild with the ID ${guildId} was not found.`);

        const channel = guild.channels.cache.get(channelId);
        if (!channel) return logger.error(`The channel with the ID ${channelId} was not found.`);
        channel.send(messageData);
    };

    /**
     *
     * @param {string} image
     * @returns {boolean}
     */
    isImageValid(image) {
        if (image === undefined || image === null || typeof image !== 'string') return false;
        if (image === '') return false;
        return true;
    };

    /**
     *
     * @param {string} guildId
     * @param {string} channelId
     * @param {string} author
     * @param {string} author_image
     * @param {string} message
     * @param {Array<object>} fields
     * @param {string} footer_text
     * @param {string} footer_image
     * @param {number} color
     */
    send(guildId, channelId, author, author_image, message, fields, footer_text, footer_image, color) {

        const embed = new EmbedBuilder()
            .setAuthor({
                name: author || 'JustGod Lib',
                iconURL: this.isImageValid(author_image) ? author_image : default_image
            })
            .setColor(typeof color === 'number' ? color : 0xCC00CC)
            .setDescription(typeof message === 'string' ? message : '')
            .setFooter({
                text: footer_text || 'Provided by JustGod Lib',
                iconURL: this.isImageValid(footer_image) ? footer_image : default_image
            })
            .setTimestamp();

        if (fields !== undefined && fields !== null) {
            embed.setFields(fields);
        };

        this.sendToChannel(guildId, channelId, { embeds: [embed] });

    };

    /**
     *
     * @param {string} guildId
     * @param {string} channelId
     * @param {string} author
     * @param {string} author_image
     * @param {string} message
     * @param {Array<object>} fields
     * @param {string} footer_text
     * @param {string} footer_image
     * @param {number} color
     */
    sendDeffered(guildId, channelId, author, author_image, message, fields, footer_text, footer_image, color) {
        client.on(Events.ClientReady, () => {
            this.send(guildId, channelId, author, author_image, message, fields, footer_text, footer_image, color);
        });
    };

};

module.exports = new MessageHandler();