---@class vector2
---@field x number
---@field y number
---@overload fun(x: number, y: number): vector2

---@class vector3
---@field x number
---@field y number
---@field z number
---@overload fun(x: number, y: number, z: number): vector3

---@class vector4
---@field x number
---@field y number
---@field z number
---@field w number
---@overload fun(x: number, y: number, z: number, w: number): vector4

---@class StateBag
---@field public set fun(self: StateBag, key: string, value: any, replicated: boolean): void
---@field public get fun(self: StateBag, key: string): any

---@class GlobalState: StateBag
---@class Entity: StateBag
---@class Player: StateBag
---@class LocalPlayer: StateBag