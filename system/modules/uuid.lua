local random = math.random;
---@param template string
---@return string
function uuid(template)
    local _template = type(template) == "string" and template or 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx';
    return string.gsub(_template, '[xy]', function (index)
        local value = (index == 'x') and random(0, 0xf) or random(8, 0xb);
        return string.format('%x', value);
    end);
end

return uuid;