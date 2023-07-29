---@class Player: BaseObject
---@field public name string
---@field public age number
---@field public is_admin boolean
---@overload fun(): Player
local TestPlayer = lib.class.new 'Player';

local schema = lib.database.schema('Player', {
    name = {
        type = 'string',
        default = 'no_name',
    },
    age = {
        type = 'number',
        default = 0,
    },
    is_admin = {
        type = 'boolean',
        default = false,
    }
});

function TestPlayer:Constructor()
    self.name = 'John';
    self.age = 20;
end

local player = TestPlayer();

lib.database.ready(function()
    console.log('Database is ready');
    lib.database.insert_one('users', schema:Serialize(player), function(success, insertedCount, insertedIds)
        console.log(success, insertedCount, insertedIds);
    end);
end);