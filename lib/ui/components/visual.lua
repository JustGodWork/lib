---
--- @author Dylan MALANDAIN
--- @version 2.0.0
--- @since 2020
---
--- ui Is Advanced UI Libs in LUA for make beautiful interface like RockStar GAME.
---
---
--- Commercial Info.
--- Any use for commercial purposes is strictly prohibited and will be punished.
---
--- @see ui
---

local _AddTextComponentSubstringPlayerName = AddTextComponentSubstringPlayerName;
local _BeginTextCommandDisplayHelp = BeginTextCommandDisplayHelp;
local _EndTextCommandDisplayHelp = EndTextCommandDisplayHelp;
local _BeginTextCommandBusyspinnerOn = BeginTextCommandBusyspinnerOn;
local _EndTextCommandBusyspinnerOn = EndTextCommandBusyspinnerOn;
local _BeginTextCommandPrint = BeginTextCommandPrint;
local _EndTextCommandPrint = EndTextCommandPrint;
local _ClearPrints = ClearPrints;
local _CreateThread = CreateThread;
local _BusyspinnerIsOn = BusyspinnerIsOn;
local _BusyspinnerOff = BusyspinnerOff;
local _Wait = Wait;

---@class Visual
local visual = Visual or {};

local function AddLongString(txt)
    for i = 100, string.len(txt), 99 do
        local sub = string.sub(txt, i, i + 99)
        _AddTextComponentSubstringPlayerName(sub)
    end
end

function visual.Subtitle(text, time)
    _ClearPrints()
    _BeginTextCommandPrint("STRING")
    _AddTextComponentSubstringPlayerName(text)
    _EndTextCommandPrint(time and math.ceil(time) or 0, true)
end

function visual.FloatingHelpText(text, sound, loop)
    _BeginTextCommandDisplayHelp("jamyfafi")
    _AddTextComponentSubstringPlayerName(text)
    if string.len(text) > 99 then
        AddLongString(text)
    end
    _EndTextCommandDisplayHelp(0, loop or 0, sound or true, -1)
end

function visual.Prompt(text, spinner)
    _BeginTextCommandBusyspinnerOn("STRING")
    _AddTextComponentSubstringPlayerName(text)
    _EndTextCommandBusyspinnerOn(spinner or 1)
end

function visual.PromptDuration(duration, text, spinner)
    _CreateThread(function()
        _Wait(0)
        visual.Prompt(text, spinner)
        _Wait(duration)
        if (_BusyspinnerIsOn()) then
            _BusyspinnerOff();
        end
    end)
end

function visual.ResetPrompt()
    if (_BusyspinnerIsOn()) then
        _BusyspinnerOff();
    end
end

return visual;