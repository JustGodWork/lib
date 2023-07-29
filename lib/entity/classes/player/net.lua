local PLAYER = Player;

---@class lib.entity.player.net: EventEmitter
---@field public id number
---@field public ped lib.entity.player_ped
---@overload fun(id: number): lib.entity.player.net
local Player = lib.class.extends('lib.entity.player.net', 'EventEmitter');

---@param id number
function Player:Constructor(id)
    self:super();
    self.id = id;
    self.ped = lib.entity.classes.player_ped(self.id);
end

---@return Player
function Player:GetState()
    return PLAYER(self.id).state;
end

---@return lib.entity.player_ped
function Player:GetPed()
    return self.ped;
end

---@param eventName string
---@vararg any
function Player:TriggerEvent(eventName, ...)
    lib.events.emit.net(eventName, self.id, ...);
    self:emit(eventName, ...);
end

---@param message string
---@param hudColorIndex eHUDColorIndex
---@param isTranslation boolean
---@vararg any
function Player:ShowNotification(message, hudColorIndex, isTranslation, ...)
    lib.game.notification:SendTo(self.id, message, hudColorIndex, isTranslation, ...);
end

return Player;