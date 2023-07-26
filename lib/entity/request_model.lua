local IS_MODEL_IN_CDIMAGE = IsModelInCdimage;
local HAS_MODEL_LOADED = HasModelLoaded;
local REQUEST_MODEL = RequestModel;

---@async
---@param model string | number
---@return number
return function(model)

    assert(not lib.is_server, 'This function can only be called on the client.');

    local _model = lib.game.hash(model);

    if (IS_MODEL_IN_CDIMAGE(_model)) then
        while (not HAS_MODEL_LOADED(_model)) do
            REQUEST_MODEL(_model);
            async.wait(0);
        end
        return _model;
    end

    return -1;

end