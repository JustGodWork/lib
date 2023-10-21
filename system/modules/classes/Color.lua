---@class Color: BaseObject
---@field public r number
---@field public g number
---@field public b number
---@field public a number
---@overload fun(r: number, g: number, b: number, a: number): Color
Color = Class.new 'Color';

---@private
---@param r number
---@param g number
---@param b number
---@param a number
function Color:Constructor(r, g, b, a)

    self.r = type(r) == "number" and r or 255;
    self.g = type(g) == "number" and g or 255;
    self.b = type(b) == "number" and b or 255;
    self.a = type(a) == "number" and a or 255;

    local metatable = self:GetMetatable();
    metatable.__tostring = function()
        return string.format("Color(%s, %s, %s, %s)", self.r, self.g, self.b, self.a);
    end

end

return Color;