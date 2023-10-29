local PLAYER = Player;
local PLAYERS_IDENTIFIERS = {};

---@class lib.entity.player.net: EventEmitter
---@field public id number
---@field public identifier string
---@field public ped lib.entity.player_ped
---@overload fun(id: number): lib.entity.player.net
local Player = lib.class.extends('lib.entity.player.net', 'EventEmitter');

---@param id number
function Player:Constructor(id)

    self:super();

    self.id = id;
    self.identifier = Player.GetIdentifier(self.id, eIdentifierType.License, true);
    self.ped = lib.entity.classes.player_ped(self.id);

    lib.entity.players[self.id] = self;
    PLAYERS_IDENTIFIERS[self.identifier] = self.id;

end

---@param id number | lib.entity.player.net
---@return lib.entity.player.net
function Player.Get(id)
    return is_instance(id) and id or lib.entity.players[tonumber(id)];
end

---@param id number | lib.entity.player.net
function Player.Remove(id)
    local player = Player.Get(id);

    if (player) then
        lib.entity.players[player.id] = nil;
        PLAYERS_IDENTIFIERS[player.identifier] = nil;
    end
end

---@return lib.entity.player.net[]
function Player.GetAll()
    return lib.entity.players;
end

---@return string[]
function Player.GetAllFromID()
    return GetPlayers();
end

---@param playerId number
---@param identifierType eIdentifierType
---@param truncate boolean
---@return string
function Player.GetIdentifier(playerId, identifierType, truncate)
    local _type = identifierType or eIdentifierType.License;
    local pattern = ('%s:'):format(_type);
    local result = GetPlayerIdentifierByType(playerId, _type);
    return truncate and result:gsub(pattern, '') or result;
end

---@param identifier string
---@return lib.entity.player.net | nil
function Player.GetByIdentifier(identifier)
    return lib.entity.players[PLAYERS_IDENTIFIERS[identifier]];
end

---@param player? lib.entity.player.net
---@return boolean
function Player.IsValid(player)
    if (is_instance(player)) then

        local ped = player:GetPed();

        if (typeof(ped) == 'lib.entity.player_ped') then
            return ped:IsValid() and player:GetPing() > 0;
        end

    end
    return false;
end

---@return string
function Player:GetName()
    return GetPlayerName(self.id);
end

---@return Player
function Player:GetState()
    return PLAYER(self.id).state;
end

---@return lib.entity.player_ped
function Player:GetPed()
    return self.ped;
end

function Player:GetPing()
    local ping = GetPlayerPing(self.id);
    return type(ping) == 'number' and ping > 0 and ping or 0;
end

---@param eventName string
---@vararg any
function Player:TriggerEvent(eventName, ...)
    lib.events.emit.net(eventName, self.id, ...);
    self:emit(eventName, ...);
end

---@param eventName string
---@param callback fun(...: any): void
---@vararg any
function Player:TriggerCallback(eventName, callback, ...)
    lib.events.emit.callback(eventName, self.id, callback, ...);
end

---@param message string
---@param hudColorIndex eHUDColorIndex
---@param isTranslation boolean
---@vararg any
function Player:ShowNotification(message, hudColorIndex, isTranslation, ...)
    lib.game.notification:SendTo(self.id, message, hudColorIndex, isTranslation, ...);
end

---@param reason string
function Player:Kick(reason)
    DropPlayer(self.id, reason);
    self:Remove();
end

return Player;