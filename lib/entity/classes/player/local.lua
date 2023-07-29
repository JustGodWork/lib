local SET_PLAYER_WANTED_LEVEL_NOW = SetPlayerWantedLevelNow;
local SET_PLAYER_WANTED_LEVEL = SetPlayerWantedLevel;
local SET_MAX_WANTED_LEVEL = SetMaxWantedLevel;
local PLAYER_ID = PlayerId;
local LOCAL_PLAYER = LocalPlayer;

---@type lib.entity.player.local
local LocalPlayer = lib.class.singleton_extends("lib.entity.player.local", "EventEmitter", function(class)

    ---@class lib.entity.player.local: EventEmitter
    ---@field public ped lib.entity.player_ped
    ---@overload fun(): lib.entity.player.local
    local self = class;

    function self:Constructor()
        self:super();
        self.id = PLAYER_ID();
        self.ped = lib.entity.classes.player_ped(self.id);
    end

    ---@return lib.entity.player_ped
    function self:GetPed()
        return self.ped;
    end

    ---@param message string
    ---@param hudColorIndex eHUDColorIndex
    ---@param isTranslation boolean
    ---@vararg any
    function self:ShowNotification(message, hudColorIndex, isTranslation, ...)
        lib.game.notification:Send(message, hudColorIndex, isTranslation, ...);
    end

    ---@param level number
    function self:SetWantedLevel(level)
        assert(type(level) == "number", "lib.local_player:SetWantedLevellevel: must be a number");
        SET_PLAYER_WANTED_LEVEL(self.id, level, false);
    end

    ---@param level number
    function self:SetWantedLevelNow(level)
        assert(type(level) == "number", "lib.local_player:SetWantedLevelNow: must be a number");
        SET_PLAYER_WANTED_LEVEL_NOW(self.id, level);
    end

    ---@param level number
    function self:SetMaxWantedLevel(level)
        SET_MAX_WANTED_LEVEL(level);
    end

    return self;

end);

return LocalPlayer;