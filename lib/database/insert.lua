---@param collection string
---@param documents table
---@param options table
---@param callback fun(success: boolean, insertedCount: number, insertedIds: table) | fun(success: boolean, error: string)
---@overload fun(collection: string, documents: table, callback: fun(success: boolean, insertedCount: number, insertedIds: table) | fun(success: boolean, error: string))
return function(collection, documents, options, callback)

    assert(lib.is_server, 'This function can only be called on the server.');

    local _callback = type(options) == "function" and options or callback;

    return exports['lib']:mongo_insert({
        collection = collection,
        documents = lib.database.validate_object(documents) or {},
        options = lib.database.validate_object(options)
    }, _callback);

end