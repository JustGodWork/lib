---@class lib.discord.message: BaseObject
---@field public author string
---@field public author_image string
---@field public text string
---@field public fields lib.discord.field[]
---@field public footer_text string
---@field public footer_image string
---@field public color eDiscordColor
---@overload fun(): lib.discord.message
local Message = lib.class.new 'lib.discord.message';

function Message:Constructor()
    self.author = nil;
    self.author_image = nil;
    self.text = nil;
    self.fields = {};
    self.footer_text = nil;
    self.footer_image = nil;
    self.color = nil;
end

---@param author string
---@param image string
function Message:SetAuthor(author, image)
    assert(type(author) == 'string', 'lib.discord.message:SetAuthor(): author must be a string');
    self.author = author;
    self.author_image = image;
    return self;
end

---@param image string
function Message:SetAuthorImage(image)
    assert(type(image) == 'string', 'lib.discord.message:SetAuthorImage(): image must be a string');
    self.author_image = image;
    return self;
end

---@param text string
function Message:SetText(text)
    self.text = tostring(text);
    return self;
end

---@param field lib.discord.field
function Message:AddField(field)
    assert(type(field) == 'lib.discord.field', 'lib.discord.message:AddField(): field must be a lib.discord.field');
    assert(type(field.name) == 'string', 'lib.discord.message:AddField(): field.name must be a string');
    assert(type(field.value) == 'string', 'lib.discord.message:AddField(): field.value must be a string');
    assert(type(field.inline) == 'boolean', 'lib.discord.message:AddField(): field.inline must be a boolean');
    table.insert(self.fields, field);
    return self;
end

---@param fields lib.discord.field[]
function Message:SetFields(fields)
    assert(type(fields) == 'table', 'lib.discord.message:SetFields(): fields must be a table');
    self.fields = {};
    for _, field in pairs(fields) do
        self:AddField(field);
    end
    return self;
end

---@param text string
function Message:SetFooterText(text)
    assert(type(text) == 'string', 'lib.discord.message:SetFooterText(): text must be a string')
    self.footer_text = text;
    return self;
end

---@param image string
function Message:SetFooterImage(image)
    assert(type(image) == 'string', 'lib.discord.message:SetFooterImage(): image must be a string');
    self.footer_image = image;
    return self;
end

---@param color eDiscordColor
function Message:SetColor(color)
    assert(type(color) == 'number', 'lib.discord.message:SetColor(): color must be a number');
    self.color = color;
    return self;
end

return Message;