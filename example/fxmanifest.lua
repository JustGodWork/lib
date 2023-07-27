fx_version 'cerulean';
game 'gta5';

author 'JustGod';
description 'Example resource for the library.';

--[[
    To see usage about classes,
    check: https://github.com/JustGodWork/Lua-Class/blob/main/example.lua or https://github.com/JustGodWork/Lua-Class/blob/main/example_callback.lua
]]--

shared_script '@lib/imports.lua'; -- IMPORTING THE LIBRARY INTO THE RESOURCE

shared_script 'shared/index.lua';
server_script 'server/index.lua';
client_script 'client/index.lua';

files { 'shared/**', 'client/**' };