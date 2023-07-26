---@class eventData
---@field public key number
---@field public name string

lib.events = {};
lib.events.safe_callback = require 'lib.events.safe_callback';
lib.events.on = require 'lib.events.on';
lib.events.remove = require 'lib.events.remove';
lib.events.emit = require 'lib.events.emit';

return lib.events;