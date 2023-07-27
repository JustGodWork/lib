local guild = lib.discord:AddGuild('guild_id');
local channel = guild:AddChannel('channel_id');

local message = lib.discord.message()
        :SetAuthor('Test')
        :SetText('Test message')
        :AddField(lib.discord.field('Test field', 'Test value', false))
        :AddField(lib.discord.field('Test field 2', 'Test value 2', false))
        :SetFooterImage('https://www.madinjapan.fr/29785-home_default/transformers-statue-bumblebee-prime-1-studio.jpg')
        :SetColor(eDiscordColor.LightGreen)
        :SetFooterText('Test footer');

local message2 = lib.discord.message()
    :SetAuthor('Test')
    :SetText('Test message')
    :SetFields({
        lib.discord.field('This is my first field', 1, true),
        lib.discord.field('This is my second field', 2, true),
    })
    :SetFooterImage('https://www.madinjapan.fr/29785-home_default/transformers-statue-bumblebee-prime-1-studio.jpg')
    :SetColor(eDiscordColor.Blue)
    :SetFooterText('Test footer');

RegisterCommand('send_log', function(src)

    local name = src > 0 and GetPlayerName(src) or 'Console';
    message:SetAuthor(name);
    message2:SetAuthor(name);

    channel:Send(message);
    channel:Send(message2);

end);

channel:on('message', function(message)
    print(message.text .. ' was sent to discord');
end);