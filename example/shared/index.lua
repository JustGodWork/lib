infos = {};

require 'shared.resource_infos';

console.warn('Resource: ^1' .. infos.name .. '^0 (^1'.. infos.description ..'^0) by ^1' .. infos.author .. '^0 loaded!');

--example try catch
lib.error_handler(function()
    error('This an example error!');
end, function(error)
    console.err('Example error is showing there:', error);
end);