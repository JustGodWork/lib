const { Client, Partials, GatewayIntentBits, Events } = require('discord.js');
const logger = require('./logger');

const token = GetConvar('justgod_lib_discord_token', 'N/A');

const client = new Client({

    intents: [

        GatewayIntentBits.AutoModerationConfiguration,
        GatewayIntentBits.AutoModerationExecution,
        GatewayIntentBits.DirectMessageReactions,
        GatewayIntentBits.DirectMessageTyping,
        GatewayIntentBits.DirectMessages,
        GatewayIntentBits.GuildModeration,
        GatewayIntentBits.GuildEmojisAndStickers,
        GatewayIntentBits.GuildIntegrations,
        GatewayIntentBits.GuildInvites,
        GatewayIntentBits.GuildMembers,
        GatewayIntentBits.GuildMessageReactions,
        GatewayIntentBits.GuildMessageTyping,
        GatewayIntentBits.GuildMessages,
        GatewayIntentBits.GuildPresences,
        GatewayIntentBits.GuildScheduledEvents,
        GatewayIntentBits.GuildVoiceStates,
        GatewayIntentBits.GuildWebhooks,
        GatewayIntentBits.Guilds,
        GatewayIntentBits.MessageContent,

    ],
    partials: [

        Partials.Channel,
        Partials.GuildMember,
        Partials.Message,
        Partials.Reaction,
        Partials.User,
        Partials.GuildScheduledEvent,
        Partials.ThreadMember

    ]
});

if (token !== 'N/A' && typeof token === 'string') {
    client.login(token);
    client.on(Events.ClientReady, () => {
        logger.success('Discord client is ready.');
    });
};

module.exports = client;