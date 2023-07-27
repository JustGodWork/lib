exports('discord_send_message', (guildId, channelId, author, author_image, message, fields, footer_text, footer_image, color) => {
    if (client.isReady()) {
        message_handler.send(guildId, channelId, author, author_image, message, fields, footer_text, footer_image, color);
    } else {
        message_handler.sendDeffered(guildId, channelId, author, author_image, message, fields, footer_text, footer_image, color);
    };
});