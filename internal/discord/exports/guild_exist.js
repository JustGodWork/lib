exports('discord_guild_exist', (guildId) => {
    return client.guilds.cache.has(guildId);
});