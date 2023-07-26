---@param textEntry string
---@param maxLength number
---@param text string
---@return string | number
return function(textEntry, maxLength, text)

    assert(not lib.is_server, 'This function can only be called on the client.');

    AddTextEntry('FMMC_KEY_TIP1', textEntry);
    DisplayOnscreenKeyboard(

        1,
        "FMMC_KEY_TIP1",
        "",
        text,
        nil,
        nil,
        nil,
        maxLength or 10

    );

    while (UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2) do
        DisableAllControlActions(0);
        async.wait(0);
    end

    if (UpdateOnscreenKeyboard() ~= 2) then
        local result = GetOnscreenKeyboardResult();

        async.wait(500);

        if (result) then

            if (tonumber(result)) then
                return tonumber(result);
            end

            return result;

        end

        return nil;

    else

        async.wait(500);
        return nil;

    end

end