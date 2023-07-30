---@type lib.promise
lib.promise = lib.class.new('lib.promise', function(class)

    ---@class lib.promise
    ---@field public Then fun(callback: fun(result: any)): lib.promise
    ---@field public Catch fun(callback: fun(error: string)): lib.promise
    ---@overload fun(callback: fun()): lib.promise
    local self = class;

    function lib.promise:Try(callback)
        assert(type(callback) == 'function', 'lib.promise:Try(): callback must be a function');
        local status <const>, retval <const> = pcall(callback);

        return (setmetatable({}, {
            __index = {
                Then = function(self, result)
                    if (status) then
                        result(retval);
                    end

                    return (self);
                end,
                Catch = function(self, throw)
                    if (not status) then
                        throw(retval);
                    end

                    return (self);
                end
            }
        }));
    end
end);

return lib.promise;

