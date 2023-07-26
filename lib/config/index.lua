---@class lib.config @Config
---@field public class table
---@field public default table<string, Config>
lib.config = {};
lib.config.class = {};
lib.config.default = {};

lib.config.class.config = require 'lib.config.classes.Config';

lib.config.register = require 'lib.config.register';
lib.config.register_sub = require 'lib.config.register_sub';
lib.config.get_valid = require 'lib.config.get_valid';
lib.config.get = lib.config.get_valid;
lib.config.get_valid_sub = require 'lib.config.get_valid_sub';
lib.config.get_sub = lib.config.get_valid_sub;

return lib.config;