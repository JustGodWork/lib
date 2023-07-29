---@param collection string
---@param query table
---@param options table
---@param limit number
---@param callback fun(success: boolean, documents: table) | fun(success: boolean, error: string)
---@overload fun(collection: string, query: table, limit: number, callback: fun(success: boolean, documents: table) | fun(success: boolean, error: string))
return function(collection, query, options, limit, callback)

    assert(lib.is_server, 'This function can only be called on the server.');

    local _options, _limit, _callback = options, limit, callback;

    if (type(options) == "number" and type(limit) == "function") then
        _options = {};
        _limit = options;
        _callback = limit;
    end

    return exports['lib']:mongo_find({
        collection = collection,
        query = lib.database.validate_object(query) or {},
        options = lib.database.validate_object(_options),
        limit = _limit
    }, _callback);

end