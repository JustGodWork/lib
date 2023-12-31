---@type Locale
Locale = lib.class.singleton('Locale', function(class)

    ---@class Locale: BaseObject
    ---@field public lang string
    ---@field public color string
    ---@field public locales table<string, table<string, string>>
    local self = class;

    function self:Constructor()
        self.lang = GetConvar("justgod_scripts_locale", "en");
        self.locales = {};
        assert(type(self.lang) == 'string', 'Locale:Constructor: justgod_scripts_locale must be a string');
    end

    ---@private
    ---@param str string
    ---@param ... any
    function self:ConvertStr(str, ...)  -- Translate string

        assert(type(str) == 'string', ("Locale:ConvertStr: Attempt to index a '%s' value field: 'str'"):format(type(str)));

        local _lang = self.lang:upper();
        local language = self.locales[_lang];
        local final = str:lower();

        if (type(language) == 'table') then

            if (type(language[final]) == 'string') then

                if (language[final]:find("!^")) then
                    language[final] = language[final]:gsub("!^", lib.color.get_current());
                    return language[final]:format(...);
                end

                return language[final]:format(...);

            else

                if (not lib.is_server) then
                    return 'Missing entry for [~r~'..final..'~s~]'
                else
                    return '^7Missing entry for ^0[^1'..final..'^0]^7'
                end

            end

        else

            if (not lib.is_server) then
                return 'Locale [~r~' .. _lang .. '~s~] does not exist.'
            else
                return '^7Locale ^0[^1' .. _lang .. '^0]^7 does not exist.'
            end

        end

    end

    ---@param name string
    ---@param data table
    function self:Register(name, data)

        assert(type(name) == 'string', 'Locale:Register: name must be a string');
        assert(type(data) == 'table', 'Locale:Register: data must be a table');

        local _name = name:upper();

        self.locales[_name] = type(self.locales[_name]) == 'table' and self.locales[_name] or {};

        local count = 0;

        for key, value in pairs(data) do
            if (type(self.locales[_name][key:lower()]) == 'string') then
                count = count + 1;
                console.warn(('Locale:Register: overwritting key ^3%s^0 in locale ^1%s^0'):format(key, _name));
            end
            self.locales[_name][key:lower()] = value;
        end

        if (count > 0) then
            console.debug(('Locale:Register: Replaced ^3x%s^0 keys in locale ^1%s^0'):format(count, _name));
        end

        return self;

    end

    ---@param str string
    ---@vararg any
    ---@return string
    function self:Translate(str, ...)
        return tostring(self:ConvertStr(str, ...));
    end

    return self;

end);

---@param str string
---@vararg any
function _U(str, ...)
    return Locale:Translate(str, ...);
end

---@param lang string
---@param data table
function _C(lang, data)
    console.debug(('^7(^6Locale^7)^0 => Registering ^7(^1%s^7)'):format(lang));
    return Locale:Register(lang, data);
end

return Locale;

