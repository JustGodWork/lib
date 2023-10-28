if (lib.is_server) then return; end

lib.events.on.internal(eLibEvents.zoneStateChange, function(_, zoneId, key, value)

    local zone = lib.game.classes.zone.Get(zoneId);

    if (zone ~= nil) then
        zone[key] = value;
        if (key == 'active') then
            if (value == true) then
                zone:emit('enter', zone);
                zone:Start();
            else
                zone:emit('exit', zone);
                zone:Stop();
            end
        end
    end

end);