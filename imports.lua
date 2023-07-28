lib = {};
lib.cache = {};
lib.cache.type = type;
lib.classes = {};
lib.is_server = IsDuplicityVersion();
lib.name = 'lib';
lib.current_resource = GetCurrentResourceName();
lib.debug = GetConvar('justgod_lib_debug', "false") == "true";

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
    current_resource = lib.cache.type(resource) == 'string' and resource or GetCurrentResourceName();
end

---@param modname string
---@return any
function require(modname)

    if lib.cache.type(modname) ~= 'string' then return; end

    local module = modules[modname];

    if (not module) then

        if (module == false) then
            error(("^1circular-dependency occurred when loading module '%s'^0"):format(modname), 0);
        end

        local success, result = pcall(_require, modname);

        if (success) then
            modules[modname] = result;
            return result;
        end

        local modpath = modname:gsub('%.', '/');

        for path in _path:gmatch('[^;]+') do

            local script = path:gsub('?', modpath):gsub('%.+%/+', '');
            local resourceFile = LoadResourceFile(current_resource, script);

            if (resourceFile) then

                modules[modname] = false;
                script = ('@@%s/%s'):format(current_resource, script)

                local chunk, err = load(resourceFile, script)

                if (err or not chunk) then
                    modules[modname] = nil;
                    return error(err or ("Unable to load module '%s'"):format(modname), 0);
                end

                if (lib.cache.type(console) == 'table' and lib.cache.type(console.debug) == 'function') then
                    if (lib.current_resource == current_resource) then
                        console.debug(('Loaded module ^7\'^2%s^7\'^0'):format(modname));
                    else
                        console.debug(('Loaded module ^7\'^2%s^7\'^0 from ^7\'^3%s^7\'^0'):format(modname, current_resource));
                    end
                end

                module = chunk(modname) or true;
                modules[modname] = module;

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
lib.locale = require 'system.modules.locale';
lib.uuid = require 'system.modules.uuid';

lib.classes.events = require 'system.modules.classes.EventEmitter';

require 'lib.index';

lib.set_required_resource();