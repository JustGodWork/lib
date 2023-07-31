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

---@async
---@param model string | number
function PlayerPed:SetModel(model)
    local _model = lib.is_server and model or lib.entity.request_model(model);
    self.model = _model;
    SET_PLAYER_MODEL(self.id, _model);
    if (not lib.is_server) then
        lib.entity.release_model(_model);
    end
end

---@param coords? vector4
function PlayerPed:Resurrect(coords)
    NETWORK_RESURRECT_LOCAL_PLAYER(type(coords) == 'vector4' and coords or self:GetCoords());
end

return PlayerPed;