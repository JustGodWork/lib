exports('discord_on_ready', (callback) => {
    if (client.isReady()) {
        if (typeof callback === 'function') {
            callback();
        };
    } else {
        client.on(Events.ClientReady, () => {
            if (typeof callback === 'function') {
                callback();
            };
        });
    };
});