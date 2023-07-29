---@param collection string
---@param query table
---@param update table
---@param options table
---@param callback fun(success: boolean, updatedCount: number) | fun(success: boolean, error: string)
---@overload fun(collection: string, query: table, update: table, callback: fun(success: boolean, updatedCount: number) | fun(success: boolean, error: string))
return function(collection, query, update, options, callback)

    local _callback = type(options) == "function" and options or callback;

    return exports['lib']:mongo_update_one({
        collection = collection,
        query = lib.database.validate_object(query) or {},
        update = lib.database.validate_object(update) or {},
        options = lib.database.validate_object(options)
    }, _callback);

end