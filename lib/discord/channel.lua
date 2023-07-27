---@class lib.discord.channel: EventEmitter
---@field public id string
---@field public guild string
---@overload fun(id: string): lib.discord.channel
local Channel = Class.extends('lib.discord.channel', 'EventEmitter');

---@param id string
function Channel:Constructor(id)
    self:super();
    assert(lib.is_server, 'This function can only be called on the server.');
    assert(type(id) == 'string', 'lib.discord.channel:Constructor(): id must be a string');
    self.id = id;
    self.guild = nil;
end

---@param message lib.discord.message
function Channel:Send(message)
    assert(type(message) == 'lib.discord.message', 'lib.discord.channel:Send(): message must be a lib.discord.message');
    exports['lib']:discord_send_message(

        self.guild,
        self.id,
        message.author,
        message.author_image,
        message.text,
        message.fields,
        message.footer_text,
        message.footer_image,
        message.color

    );
    self:emit('message', message);
    return self;
end

return Channel;