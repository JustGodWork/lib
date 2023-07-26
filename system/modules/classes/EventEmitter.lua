---@class EventEmitter: BaseObject
---@field public events table<string, table<number, fun(...: vararg)>
---@overload fun(): EventEmitter
EventEmitter = Class.new 'EventEmitter';

function EventEmitter:Constructor()
    self.events = {};
end

---@param eventName string
---@param callback fun(...: vararg)
---@return table
function EventEmitter:on(eventName, callback)

    if (type(eventName) ~= "string") then
        return error("EventEmitter:on(): Invalid event name", 0);
    end

    if (type(callback) ~= "function") then
        return error("EventEmitter:on(): Invalid event callback", 0);
    end

    if (not self.events[eventName]) then
        self.events[eventName] = {};
    end

    local id = #self.events[eventName] + 1;
    self.events[eventName][id] = function(...)

        local args = {...};

        async(function()

            if (type(callback) == "function") then

                local success, result = pcall(callback, table.unpack(args));

                if not (success) then
                    console.err(("An error occured while executing event ^7(^4%s^7)^0, stack: ^7(^1%s^7)"):format(eventName, result));
                end

            else
                console.err(("An error occured while executing event ^7(^4%s^7)^0, stack: ^7(^1%s^7)"):format(eventName, "Callback is not a function"));
            end

        end);

    end;

    return {
        name = eventName,
        id = id
    };

end

---@param eventName string
---@vararg any
function EventEmitter:emit(eventName, ...)

    if (type(eventName) ~= "string") then
        return error("EventEmitter:emit(): Invalid event name", 3);
    end

    if (self.events[eventName]) then
        for i = 1, #self.events[eventName] do
            if (type(self.events[eventName][i]) == "function") then
                self.events[eventName][i](...);
            end
        end
    end

end

---@param eventData table
function EventEmitter:remove(eventData)

    if (type(eventData) ~= "table") then
        return error("EventEmitter:remove(): Invalid eventHandler", 3);
    end

    if (self.events[eventData.name]) then
        self.events[eventData.name][eventData.id] = nil;
    end

end

return EventEmitter;