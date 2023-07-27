local menus = require 'client.menu';

RegisterCommand('open_example', function()
    menus.menu:Toggle();
end);

RegisterCommand('open_example_server', function()

    local random = math.random(1, 3);

    lib.events.emit.callback('open_example_server', function(wasLucky)
        if (wasLucky) then
            menus.menu:Toggle();
        end
    end, random); --SENDING RANDOM NUMBER TO SERVER TO SHOW CALLBACK USAGE

end);