lib.events.on.callback('open_example_server', function(src, response, randomNumber)

    if (randomNumber == 1) then
        response(true); -- RESPONSE TO CLIENT THAT WE ARE ALLOWED TO OPEN THE MENU
        lib.game.notification:SendTo(src, 'You were lucky !', eHUDColorIndex.GREEN);
    else
        response(false); -- RESPONSE TO CLIENT THAT WE ARE NOT ALLOWED TO OPEN THE MENU
        lib.game.notification:SendTo(src, 'You were not lucky !', eHUDColorIndex.RED);
    end

end);