if (lib.is_server) then
    lib.events.on(eCitizenFXEvents.onResourceStart, function(_, resource_name)

        if (resource_name ~= lib.name) then return; end

        local version = lib.resource.get_metadata(lib.name, 'version');

        if (not version) then
            console.err('^7(^6lib^7)^0 => Unable to check for updates! Please update manually');
            return;
        end

        --- todo: Create HTTP Request utility
        PerformHttpRequest('https://api.github.com/repos/JustGodWork/lib/releases/latest', function(status, response)

            if (status ~= 200) then return; end

            local data = json.decode(response);

            if (type(data.tag_name) == 'string') then

                local latest = data.tag_name:match('%d%.%d+%.%d+');

                if (not latest) then
                    console.err('^7(^6lib^7)^0 => Failed to parse latest version informations!');
                elseif (latest > version) then
                    console.warn(('^7(^6lib^7)^0 => A new version is available! Please update to ^3%s'):format(latest));
                    console.warn('^7(^6lib^7)^0 => Download link: ^3https://github.com/repos/JustGodWork/lib/releases/latest');
                elseif (latest < version) then
                    console.err(('^7(^6lib^7)^0 => Your version doesn\'t match any version in our repository. Latest version found on our repository: ^3%s'):format(latest));
                else
                    console.success(('^7(^6lib^7)^0 => You are using the latest version ^7(^2%s^7)'):format(version));
                end

            else
                console.err('^7(^6lib^7)^0 => Failed to parse latest version informations!');
            end

        end, 'GET');

    end);
end