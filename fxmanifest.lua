fx_version 'cerulean';
game 'gta5';

lua54 'yes';

author 'JustGod';
description 'Providing all the tools you need to reproduce javascript classes in lua and more !';
version '1.0.0';

server_script 'internal/discord/index.js'; -- DISCORD BOT
server_script 'internal/discord/exports/*.js'; -- DISCORD EXPORTS

shared_script 'imports.lua'; -- IMPORT LIB INTO LIB WTF ?! DON'T TOUCH PLZ
shared_script 'internal/index.lua';

files {
    'internal/**',
    'system/**',
    'enums/**',
    'lib/**',
};