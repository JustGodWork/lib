local InternalZone = require 'internal.game.zone.InternalZone';

---@type ZoneService
local ZoneService = Class.singleton('ZoneService', 'EventEmitter', function(class)

    ---@class ZoneService: BaseObject
    ---@field public zones table<string, InternalZone>
    ---@field private resources table<string, string[]>
    local self = class;

    function self:Constructor()
        self:super();
        self.zones = {};
        self.resources = {};
    end

    ---@param zone Zone
    function self:Register(zone)
        assert(not lib.is_server, 'ZoneService:Register is only available on client.');
        if (typeof(self.zones[zone.id]) == 'InternalZone') then
            console.warn(("^7[^6ZoneService^7] ^3Zone ^7[^5%s^7] ^3is already registered, overwriting..."):format(zone.id));
        end
        self.zones[zone.id] = InternalZone(zone.id, zone.resource);
        self.resources[zone.resource] = type(self.resources[zone.resource]) == 'table' and self.resources[zone.resource] or {};
        self.resources[zone.resource][#self.resources[zone.resource] + 1] = zone.id;
        console.success(("^7[^6ZoneService^7] ^3Zone ^7[^5%s^7] ^3has been registered."):format(zone.id));
    end

    ---@param id string
    ---@return InternalZone
    function self:Get(id)
        assert(not lib.is_server, 'ZoneService:Get is only available on client.');
        return self.zones[id];
    end

    ---@return table<string, InternalZone>
    function self:GetAll()
        assert(not lib.is_server, 'ZoneService:GetAll is only available on client.')
        return self.zones;
    end

    ---@param resource string
    ---@param id string
    ---@return table<string, InternalZone>, number
    function self:GetByResource(resource, id)
        assert(not lib.is_server, 'ZoneService:GetByResource is only available on client.');
        if (type(self.resources[resource]) == 'table') then
            for i = 1, #self.resources[resource] do
                if (self.resources[resource][i] == id) then
                    return self.zones[id], i;
                end
            end
        end
    end

    ---@param resource string
    ---@return table<string, InternalZone> | nil
    function self:GetAllByResource(resource)
        assert(not lib.is_server, 'ZoneService:GetAllByResource is only available on client.');
        if (type(self.resources[resource]) == 'table') then
            local zones = {};
            for i = 1, #self.resources[resource] do
                zones[self.resources[resource][i]] = self.zones[self.resources[resource][i]];
            end
            return zones;
        end
        return nil;
    end

    ---@param id string
    function self:Remove(id)
        if (typeof(self.zones[id]) == 'InternalZone') then
            local _, index = self:GetByResource(self.zones[id].resource, id);
            self.zones[id] = nil;
            self.resources[self.zones[id].resource][index] = nil;
            console.warn(("^7[^6ZoneService^7] ^3Zone ^7[^5%s^7] ^3has been removed."):format(id));
        end
    end

    ---@param resource string
    function self:RemoveByResource(resource)
        assert(not lib.is_server, 'ZoneService:RemoveByResource is only available on client.');
        if (type(self.resources[resource]) == 'table') then
            for i = 1, #self.resources[resource] do
                self.zones[self.resources[resource][i]] = nil;
                console.warn(("^7[^6ZoneService^7] ^3Zone ^7[^5%s^7] ^3has been removed due to ^7[^5%s^7] ^3resource stop."):format(self.resources[resource][i], resource));
            end
            self.resources[resource] = nil;
        end
    end

    return self;

end);

return ZoneService;