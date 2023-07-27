exports('discord_channel_exist', (channelId) => {
    return client.channels.cache.has(channelId);
});