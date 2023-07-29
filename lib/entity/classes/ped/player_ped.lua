local PLAYER_PED_ID = PlayerPedId;
local GET_PLAYER_PED = GetPlayerPed;
local SET_PLAYER_MODEL = SetPlayerModel;
local NETWORK_RESURRECT_LOCAL_PLAYER = NetworkResurrectLocalPlayer;

---@class lib.entity.player_ped: lib.entity.ped
---@field public id number
---@overload fun(id: number): lib.entity.player_ped
local PlayerPed = lib.class.extends('lib.entity.player_ped', 'lib.entity.ped');

---@param id number
function PlayerPed:Constructor(id)
    self:super();
    self.id = id;
end

function PlayerPed:GetHandle()
    return lib.is_server and GET_PLAYER_PED(self.id) or PLAYER_PED_ID();
end

---@param model string | number
function PlayerPed:SetModel(model)
    self.model = model;
    SET_PLAYER_MODEL(self.id, model);
end

---@param coords? vector4
function PlayerPed:Resurrect(coords)
    NETWORK_RESURRECT_LOCAL_PLAYER(type(coords) == 'vector4' and coords or self:GetCoords());
end

return PlayerPed;