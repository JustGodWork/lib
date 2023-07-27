local example_menu = UIMenu.CreateMenu('Example Menu', 'Example Menu Subtitle');
local example_submenu = UIMenu.CreateSubMenu(example_menu, 'Example Submenu', 'Example Submenu Subtitle');

example_menu:IsVisible(function(Items)

    Items:Button('This is a button', 'This is a button description', {}, true, {
        onSelected = function()
            console.log('This is a button but selected');
        end
    });

    Items:Button('This is a submenu button', 'This is a submenu button description', {}, true, {
        onSelected = function()
            print('This is a submenu button but selected');
        end
    }, example_submenu);

end);

local list = {
    {
        _label = 'My First index',
        func = function(index)
            console.log('My First index selected with index: ' .. index);
        end
    },
    {
        _label = 'My Second index',
        func = function(index)

            console.log('My Second index selected with index: ' .. index);

            SetTimecycleModifier('hud_def_blur');
            SetTimecycleModifierStrength(1.0);

            lib.game.notification:Send('I thinks this is a cool effect', eHUDColorIndex.BLUE);

            SetTimeout(5000, function()
                ClearTimecycleModifier();
                lib.game.notification:Send('Oufff ! Effect was cleared.', eHUDColorIndex.ORANGE);
            end);

        end
    },
};

local current_index = 1;

example_submenu:IsVisible(function(Items)

    Items:List('This is a list', list, current_index, 'This is a list description', {}, true, {
        onListChange = function(index)
            current_index = index;
        end,
        onSelected = function(index)
            if (type(list[index]) == 'table') then
                if (type(list[index].func) == 'function') then
                    list[index].func(index);
                else
                    console.err('Something went wrong with the list item function: ' .. index);
                end
            else
                console.err('Something went wrong with the list item: ' .. index);
            end
        end
    });

end);

return {
    menu = example_menu,
    submenu = example_submenu
};