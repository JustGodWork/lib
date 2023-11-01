lib = {};
lib.cache = {};
lib.classes = {};
lib.is_server = IsDuplicityVersion();
lib.name = 'lib';
lib.current_resource = GetCurrentResourceName();
lib.debug = GetConvar('justgod_lib_debug', "false") == "true";

if (lib.current_resource ~= lib.name) then

    local state = GetResourceState(lib.name);

    if (not state:find('start')) then
        print('^7(^6lib^7)^0 => ^1Unable to import lib! Please start lib before using it.^0');
    end

end

local current_resource = lib.name;

local modules = {};
local _require = require;
local _path = './?.lua;';

---@return string
function lib.get_required_resource()
    return current_resource;
end

---@param resource? string
function lib.set_required_resource(resource)
    current_resource = type(resource) == 'string' and resource or lib.current_resource;
end

---@param modname string
---@return any
function require(modname)

    if type(modname) ~= 'string' then return; end

    local mod_id = ('%s.%s'):format(current_resource, modname);
    local module = modules[mod_id];

    if (not module) then

        if (module == false) then
            error(("^1circular-dependency occurred when loading module '%s'^0"):format(modname), 0);
        end

        local success, result = pcall(_require, modname);

        if (success) then
            modules[mod_id] = result;
            return result;
        end

        local modpath = modname:gsub('%.', '/');

        for path in _path:gmatch('[^;]+') do

            local script = path:gsub('?', modpath):gsub('%.+%/+', '');
            local resourceFile = LoadResourceFile(current_resource, script);

            if (type(resourceFile) == 'string') then

                modules[mod_id] = false;
                script = ('@@%s/%s'):format(current_resource, script)

                local chunk, err = load(resourceFile, script)

                if (err or not chunk) then
                    modules[mod_id] = nil;
                    return error(err or ("Unable to load module '%s'"):format(modname), 0);
                end

                if (type(console) == 'table' and type(console.debug) == 'function') then
                    if (lib.current_resource == current_resource) then
                        console.debug(('Loaded module ^7\'^2%s^7\'^0'):format(modname));
                    else
                        console.debug(('Loaded module ^7\'^2%s^7\'^0 from ^7\'^3%s^7\'^0'):format(modname, current_resource));
                    end
                end

                module = chunk(modname) or true;
                modules[mod_id] = module;

                return module;

            end

        end

        return error(("module ^7\'^3%s^7\'^1 not found^0"):format(modname), 0);

    end

    return module;

end

lib.enums = require 'enums.index';

lib.console = require 'system.console';
lib.class = require 'system.class';

lib.math = require 'system.modules.math';
lib.string = require 'system.modules.string';
lib.table = require 'system.modules.table';
lib.async = require 'system.modules.async';
lib.uuid = require 'system.modules.uuid';
lib.error_handler = require 'system.modules.error_handler';

lib.classes.locale = require 'system.modules.locale';
lib.classes.events = require 'system.modules.classes.EventEmitter';
lib.classes.list = require 'system.modules.classes.List';
lib.classes.map = require 'system.modules.classes.Map';
lib.classes.color = require 'system.modules.classes.Color';

require 'lib.index';