---@param collection string
---@param query table
---@param options table
---@param callback fun(success: boolean, deletedCount: number) | fun(success: boolean, error: string)
---@overload fun(collection: string, query: table, callback: fun(success: boolean, deletedCount: number) | fun(success: boolean, error: string))
return function(collection, query, options, callback)

    assert(lib.is_server, 'This function can only be called on the server.');

    local _callback = type(options) == "function" and options or callback;

    return exports['lib']:mongo_delete({
        collection = collection,
        query = lib.database.validate_object(query) or {},
        options = lib.database.validate_object(options)
    }, _callback);

end