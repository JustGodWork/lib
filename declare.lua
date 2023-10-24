---@alias game
---|>'"common"' # Runs on any game, but can't access game-specific APIs - only CitizenFX APIs.
---|> '"gta4"' # Runs on LibertyM.
---|> '"gta5"' # Runs on FiveM.
---|> '"rdr3"' # Runs on RedM.

--- fxmanifest resource metadata
---
--- Resource citizenfx manifest version
---@param version string
function fx_version(version)end

--- fxmanifest resource metadata
---
--- Resource game version
---@param game game
function game(game)end

--- fxmanifest resource metadata
---
--- Resource games
---@param games game[]
function games(games)end

---@alias lua_version
---|>'yes' # Lua 5.4 GLM
---|> 'no' # CfxLua 5.3

--- fxmanifest resource metadata
---
--- Resource lua version use lua 5.4
---@param lua_version lua_version
function lua54(lua_version)end

--- fxmanifest resource metadata
---
--- Resource descriptor
---@param description string
function description(description)end

--- fxmanifest resource metadata
---
--- Resource author
---@param author string
function author(author)end

--- fxmanifest resource metadata
---
--- Resource repository
---@param repository string
function repository(repository)end

--- fxmanifest resource metadata
---
--- Resource version
---@param version string
function version(version)end

--- fxmanifest resource metadata
---
--- Resource files
---@param files string[]
function files(files)end

--- fxmanifest resource metadata
---
--- Resource file
---@param file string
function file(file)end

--- fxmanifest resource metadata
---
--- Resource shared scripts list
---@param shared_scripts table
function shared_scripts(shared_scripts)end

--- fxmanifest resource metadata
---
--- Resource shared script
---@param shared_script string
function shared_script(shared_script)end

--- fxmanifest resource metadata
---
--- Resource client scripts list
---@param client_scripts table
function client_scripts(client_scripts)end

--- fxmanifest resource metadata
---
--- Resource client script
---@param client_script string
function client_script(client_script)end

--- fxmanifest resource metadata
---
--- Resource server scripts list
---@param server_scripts table
function server_scripts(server_scripts)end

--- fxmanifest resource metadata
---
--- Resource server script
---@param server_script string
function server_script(server_script)end

--- fxmanifest resource metadata
---
--- Resource dependency list
---@param dependencies table
function dependencies(dependencies)end

--- fxmanifest resource metadata
---
--- Resource dependency
---@param dependency string
function dependency(dependency)end

---@class vector2
---@field public x number
---@field public y number

---@param x number
---@param y number
---@return vector2
function vector2(x, y) end

---@class vector3
---@field public x number
---@field public y number
---@field public z number

---@param x number
---@param y number
---@param z number
---@return vector3
function vector3(x, y, z) end

---@class vector4
---@field public x number
---@field public y number
---@field public z number
---@field public w number

---@param x number
---@param y number
---@param z number
---@param w number
---@return vector4
function vector4(x, y, z, w) end

---@class eventData
---@field public key number
---@field public name string

---@class deferrals
---@field public defer fun(): void
---@field public presentCard fun(card: table, cb: fun(data: table, rawData: string): void): void
---@field public update fun(message: string): void
---@field public done fun(failureReason: string): void

---@class StateBag
---@field public set fun(self: StateBag, key: string, value: any, replicated: boolean): void
---@field public get fun(self: StateBag, key: string): any

---@class GlobalState: StateBag
---@class Entity: StateBag
---@class Player: StateBag
---@class LocalPlayer: StateBag

---@class lib.database.schema.field
---@field public name string
---@field public type string
---@field public default? any
---@field public schema? lib.database.schema

---@class lib.DiscordField
---@field public name string
---@field public value string
---@field public inline boolean

---@class lib.DiscordSlashCommandChoice
---@field public name string
---@field public value string