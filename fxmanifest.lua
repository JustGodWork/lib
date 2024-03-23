fx_version 'cerulean';
game 'gta5';

lua54 'yes';

author 'JustGod';
name "lib - (NO DISCORD VERSION)";
description 'Providing all the tools you need to reproduce javascript classes in lua and more !';
version '1.1.2';

server_script 'internal/index.js'; -- DO NOT TOUCH THIS FILE !
server_script 'internal/mongo/exports.js'; -- INTERNAL EXPORTS
--[[
    Discord exports are disabled for now due to issues with discord-js and FiveM NodeJS
    server_script 'internal/discord/exports/*.js'; -- DISCORD EXPORTS
]]

shared_script 'imports.lua'; -- IMPORT LIB INTO LIB WTF ?! DON'T TOUCH PLZ
shared_script 'internal/index.lua';

files {
    'internal/**',
    'system/**',
    'enums/**',
    'lib/**',
};

provide 'lib';