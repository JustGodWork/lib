---@param message string
---@param hudColorIndex eHudColorIndex
---@param isTranslation boolean
---@vararg any
return function(message, hudColorIndex, isTranslation, ...)

    assert(not lib.is_server, 'This function can only be called on the client.');

    if (type(message) == 'string') then

        local _message = isTranslation and _U(message, ...) or message;

        if (lib.current_resource ~= lib.name) then

            local notification = lib.config.get('custom_notification');

            if (notification) then
                notification(_message);
                return;
            end

        end

        BeginTextCommandThefeedPost('STRING');
        AddTextComponentSubstringPlayerName(_message);

        if (type(hudColorIndex) == 'number') then
            ThefeedSetNextPostBackgroundColor(hudColorIndex);
        end

        EndTextCommandThefeedPostTicker(false, true);

    end

end