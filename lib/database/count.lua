---@param collection string
---@param query table
---@param options table
---@param callback fun(success: boolean, count: number) | fun(success: boolean, error: string)
---@overload fun(collection: string, query: table, callback: fun(success: boolean, count: number) | fun(success: boolean, error: string))
return function(collection, query, options, callback)

    local _callback = type(options) == "function" and options or callback;

    return exports['lib']:mongo_count({
        collection = collection,
        query = lib.database.validate_object(query) or {},
        options = lib.database.validate_object(options)
    }, _callback);

end