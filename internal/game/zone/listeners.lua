local zoneService = require 'internal.game.zone.ZoneService';

if (lib.is_server) then return; end

local PLAYER_PED_ID = PlayerPedId;
local GET_ENTITY_COORDS = GetEntityCoords;

lib.events.on(eLibEvents.zoneAdd, function(_, zone)
    zoneService:Register(zone);
end);

lib.events.on(eCitizenFXEvents.onResourceStop, function(_, resource)
    zoneService:RemoveByResource(resource);
end);

lib.events.on(eLibEvents.zoneUpdate, function(_, zoneId, key, value)
    local zone = zoneService:Get(zoneId);

    if (typeof(zone) == 'InternalZone') then
        zone[key] = value;
    end
end);

async(function()
    while true do
        local zones = zoneService:GetAll();
        local ped = PLAYER_PED_ID();
        local coords = GET_ENTITY_COORDS(ped);

        for zoneId, zone in pairs(zones) do
            if (typeof(zone) ~= 'InternalZone') then goto continue; end

            if (zone.position == nil or zone.size == 0) then
                goto continue;
            end

            local distance = #(coords - zone.position);

            if (distance <= zone.size) then
                if (not zone.active) then
                    lib.events.emit(eLibEvents.zoneStateChange, zoneId, 'active', true);
                    zone.active = true;
                end
            else
                if (zone.active) then
                    lib.events.emit(eLibEvents.zoneStateChange, zoneId, 'active', false);
                    zone.active = false;
                end
            end
            ::continue::
        end
        async.wait(1000);
    end
end);