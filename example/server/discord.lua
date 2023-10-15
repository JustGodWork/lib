local guild = lib.discord:AddGuild('guild_id');
local channel = guild:AddChannel('channel_id');

local message = lib.discord.message()
        :SetAuthor('Test')
        :SetText('Test message')
        :AddField({
            name = 'Test field',
            value = 'Test field', 'Test value',
            inline = false
        })
        :AddField({
            name = 'Test field 2',
            value = 'Test value 2',
            inline = false
        })
        :SetFooterImage('https://www.madinjapan.fr/29785-home_default/transformers-statue-bumblebee-prime-1-studio.jpg')
        :SetColor(eDiscordColor.LightGreen)
        :SetFooterText('Test footer');

local message2 = lib.discord.message()
    :SetAuthor('Test')
    :SetText('Test message')
    :SetFields({
        {
            name = 'This is my first field',
            value = tostring(1),
            inline = true
        },
        {
            name = 'This is my second field',
            value = tostring(2),
            inline = true
        },
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
    console.log(message.text .. ' was sent to discord');
end);

local command = lib.discord.slash_command('testcommand', 'This is my first lua command!', function(notify, userId, ...)
    notify('This is my first lua command!');
    console.log(...);
end, 'SOME_ROLE_ID OR NOTHING')
    :AddBooleanOption('test_boolean', 'This is my first boolean option', true)
    :AddStringOption('test_string', 'This is my first string option', true, {
        {
            name = 'test',
            value = 'This is my first choice'
        },
        {
            name = 'test2',
            value = 'This is my second choice'
        },
        {
            name = 'test3',
            value = 'This is my third choice'
        }
    })
    :AddNumberOption('test_number', 'This is my first number option', true);

command:on('execute', function(userId, ...)
    console.log('User ' .. userId .. ' executed the command with args:', {...});
end);

--ALL METHODS BELOW ARE API RELATED SPAMMING THEM WILL RESULT IN A TIMEOUT FROM DISCORD API
--lib.discord:UpdateCommands(); -- Update all commands in discord (will delete all commands and re-create them)