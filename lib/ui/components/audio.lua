local _PlaySoundFrontend = PlaySoundFrontend;
local _CreateThread = CreateThread;
local _GetSoundId = GetSoundId;
local _ReleaseSoundId = ReleaseSoundId;
local _StopSound = StopSound;
local _Wait = Wait;

---PlaySound
---
--- Reference : N/A
---
---@param Library string
---@param Sound string
---@param IsLooped boolean
---@return nil
---@public
return function(Library, Sound, IsLooped)
    local audioId
    if not IsLooped then
        _PlaySoundFrontend(-1, Sound, Library, true)
    else
        if not audioId then
            _CreateThread(function()
                audioId = _GetSoundId();
                _PlaySoundFrontend(audioId, Sound, Library, true);
                _Wait(0.01);
                _StopSound(audioId);
                _ReleaseSoundId(audioId);
                audioId = nil;
            end)
        end
    end
end


