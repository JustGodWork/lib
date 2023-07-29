---@param collection string
---@param document table
---@param options table
---@param callback fun(success: boolean, insertedCount: number, insertedIds: table) | fun(success: boolean, error: string)
---@overload fun(collection: string, document: table, callback: fun(success: boolean, insertedCount: number, insertedIds: table) | fun(success: boolean, error: string))
return function(collection, document, options, callback)

    local _callback = type(options) == "function" and options or callback;

    return exports['lib']:mongo_insert_one({
        collection = collection,
        document = lib.database.validate_object(document) or {},
        options = lib.database.validate_object(options)
    }, _callback);

end