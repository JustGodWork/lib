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

local command = lib.discord.slash_command('testcommand', 'This is my first lua command!', function(notify, userId, ...)
    notify('This is my first lua command!');
    console.log(...);
end, 'SOME_ROLE_ID OR NOTHING')
    :AddBooleanOption('test_boolean', 'This is my first boolean option', true)
    :AddStringOption('test_string', 'This is my first string option', true, {
        lib.discord.slash_command_choice('test', 'This is my first choice'),
        lib.discord.slash_command_choice('test2', 'This is my second choice'),
    })
    :AddNumberOption('test_number', 'This is my first number option', true);

command:on('execute', function(userId, ...)
    console.log('User ' .. userId .. ' executed the command with args:', {...});
end);

--ALL METHODS BELOW ARE API RELATED SPAMMING THEM WILL RESULT IN A TIMEOUT FROM DISCORD API
--guild:UpdateCommand(command); -- Update a command that already exist in your guild
--guild:RemoveCommand(command.name); -- Remove a command that already exist in your guild (Not working for now)
--guild:AddCommand(command); -- Add a command to your guild
--guild:RemoveAllCommands(); -- Remove all commands created by the bot from your guild