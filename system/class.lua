local classes = {};
local singletons = {};

---@param v any
---@return string
function typeof(v)
    if (type(v) == 'table') then
        if (Class.HasMetatable(v)) then
            return Class.GetName(v);
        end
    end
    return type(v);
end

---FiveM | RedM Only
---@param var any
function is_function(var)
    return (type(var) == 'function' or type(var) == 'table' and var['__cfx_functionReference'] ~= nil);
end

---@param v any
---@return boolean
function is_class(v)
    return type(v) == "table" and Class.IsValid(v);
end

function is_singleton(v)
    return type(v) == "table" and Class.IsSingleton(v);
end

---@param v any
---@return boolean
function is_instance(v)
    return type(v) == "table" and Class.IsInstance(v);
end

---@param v any
---@return string | nil
function get_class_name(v)
    return type(v) == "table" and Class.GetName(v) or nil;
end

---@param name string
---@return BaseObject
local function class_require(name)
    return classes[name];
end

---@param name string
---@return BaseObject
local function singleton_require(name)
    return singletons[name];
end

---@param self BaseObject
local function get_super_list(self)

    local list = {};

    local function recursive(_self)
        local metatable = getmetatable(_self);
        local super = metatable.__super;
        if (super) then
            table.insert(list, super);
            return recursive(super);
        end
        return list;
    end

    return recursive(self);

end

---@param class BaseObject
---@return BaseObject | nil
local function class_super(class)
    assert(type(class) == 'table', "Attempt to get super from an invalid class");
	local metatable = getmetatable(class);
	local meta_super = metatable.__super;
	if (meta_super) then
		return meta_super;
	end
	return nil;
end

---@param class BaseObject
---@return table
local function class_build(class)

    assert(type(class) == 'table', "Attempt to build from an invalid class");

    local metatable = getmetatable(class);

    assert(type(metatable) == 'table', "Attempt to build from an invalid class");
    assert(singletons[metatable.__name] == nil, "Attempt to build instance from a singleton");

    local super = class_super(class);

    return setmetatable({}, {
        __index = class;
        __super = super;
        __newindex = metatable.__newindex;
        --__call = metatable.__call; -- Remove because we don't want to create a new instance from another one.
        __len = metatable.__len;
        __unm = metatable.__unm;
        __add = metatable.__add;
        __sub = metatable.__sub;
        __mul = metatable.__mul;
        __div = metatable.__div;
        __pow = metatable.__pow;
        __concat = metatable.__concat;
        __type = metatable.__newtype;
        __name = metatable.__name;
        __super_called = 0;
    });

end

---@param class BaseObject
---@vararg
---@return BaseObject
local function class_instance(class, ...)

	if (class) then

		local instance = class_build(class);

        local metatable = getmetatable(instance);
        local metasuper = getmetatable(metatable.__super);

		if (type(instance["Constructor"]) == "function") then

            local success, err = pcall(instance["Constructor"], instance, ...);

            if (not success) then
                console.err("^1Constructor of class ^7(^6" .. metatable.__name .. "^7)^1 has triggered an error^0: ^7(^6" .. err .. "^7)");
                return nil;
            end

            if (metasuper.__name ~= "BaseObject") then

                if (metatable.__super_called == 0) then
                    console.err("^1Constructor ^7(^6" .. metatable.__name .. "^7)^1 not called super().^0");
                    return nil;
                end

            end

        elseif (metatable.__type ~= "singleton" or (metatable.__type == "singleton" and metasuper.__name ~= 'BaseObject')) then
            console.err("^1Constructor ^7(^6" .. metatable.__name .. "^7)^1 not found.^0");
            return nil;
		end

		return instance;

	end

end

---@param name string
---@param fromClass table
---@param tbl table
---@param newType string
---@param metatable table
local function prepare(name, fromClass, tbl, newType, metatable)
    return setmetatable(tbl, {
        __index = fromClass;
        __super = fromClass;
        __newindex = metatable.__newindex;
        __call = metatable.__call;
        __len = metatable.__len;
        __unm = metatable.__unm;
        __add = metatable.__add;
        __sub = metatable.__sub;
        __mul = metatable.__mul;
        __div = metatable.__div;
        __pow = metatable.__pow;
        __concat = metatable.__concat;
        __type = "class";
        __newtype = newType;
        __name = name;
    });
end

--- Callback optional
---@param name string
---@param fromClass string
---@param callback? fun(class: BaseObject): table
---@return BaseObject
local function class_prepare(name, fromClass, callback)

    local _class = type(fromClass) == "string" and classes[fromClass] or fromClass;

    assert(type(_class) == 'table', "Attempt to extends from an invalid class");
    assert(singletons[name] == nil, "Attempt to extends from a singleton");

    local tbl = type(callback) == "function" and callback({}) or {};
    local metatable = getmetatable(_class);

    classes[name] = prepare(name, _class, tbl, "instance", metatable);

    local metainstance = getmetatable(classes[name]);

    console.debug(('Created class ^6%s^0 from class ^3%s^0'):format(metainstance.__name, metatable.__name));

    return classes[name];

end

--- Callback required
---@param name string
---@param fromClass string | BaseObject
---@param callback fun(class: BaseObject): table
---@vararg any
local function singleton_prepare(name, fromClass, callback, ...)

    local _class = type(fromClass) == "string" and classes[fromClass] or fromClass;
    assert(type(_class) == 'table', ("Attempt to extends from an invalid class '%s'"):format(type(fromClass)));

    local metatable = getmetatable(_class);
    assert(callback, ("Attempt to create a singleton '%s' without callback"):format(name));

    local tbl = callback({});

    assert(type(tbl) == 'table', ("Attempt to create a singleton '%s' without return."):format(name));

    classes[name] = prepare(name, _class, tbl, "singleton", metatable);
    singletons[name] = classes[name](...);

    local metainstance = getmetatable(singletons[name]);

    console.debug(('Created singleton ^6%s^0 from class ^3%s^0'):format(metainstance.__name, metatable.__name));

    return singletons[name];

end

--- Callback required
---@param name string
---@param callback fun(class: BaseObject): table
---@vararg any
---@return BaseObject
---@overload fun(name: string, fromClass: string | BaseObject, callback: fun(class: BaseObject): table, ...): BaseObject
local function singleton(name, callback, ...)
    if (is_function(callback)) then
        return singleton_prepare(name, classes["BaseObject"], callback, ...);
    end
    return singleton_prepare(name, callback, ...);
end

--- Callback optional
---@param name string
---@param callback fun(class: BaseObject): table
---@return BaseObject
local function class_new(name, callback)
	return class_prepare(name, classes["BaseObject"], callback);
end

--- Callback optional
---@param name string
---@param fromClass string | BaseObject
---@param callback fun(class: BaseObject): table
---@return BaseObject
local function class_extends(name, fromClass, callback)
    return class_prepare(name, fromClass, callback);
end

--CLASS

---@class Class
Class = {};

Class.extends = class_extends;
Class.singleton = singleton;
Class.new = class_new;
Class.require = class_require;
Class.singleton_require = singleton_require;

---@param var any
---@return boolean
function Class.HasMetatable(var)
    return type(var) == "table" and type(getmetatable(var)) == "table";
end

---@param var any
---@return table | nil
function Class.GetMetatable(var)
    return Class.HasMetatable(var) and getmetatable(var) or nil;
end

---@param var any
---@return string | nil
function Class.GetName(var)
    local metatable = Class.GetMetatable(var);
    return metatable and metatable.__name or nil;
end

---@param var any
---@return boolean
function Class.IsValid(var)
    local metatable = Class.GetMetatable(var);
    return metatable and metatable.__type == "class" or false;
end

---@param var any
---@return boolean
function Class.IsInstance(var)
    local metatable = Class.GetMetatable(var);
    return metatable and metatable.__type == "instance" or false;
end

---@param var any
---@param class BaseObject | string
---@return boolean
function Class.IsInstanceOf(var, class)

    local _class = type(class) == "string" and Class.require(class) or class;

    if (Class.IsInstance(var)) then
        return var:IsInstanceOf(Class.GetName(_class));
    end

    return false;

end

---@param var any
---@return boolean
function Class.IsSingleton(var)
    local metatable = Class.GetMetatable(var);
    return metatable and metatable.__type == "singleton" or false;
end

--BASE OBJECT

---@class BaseObject
---@field private Constructor fun(): BaseObject
local BaseObject = setmetatable({}, {
    __name = "BaseObject";
    __type = "class";
    __call = function(self, ...)
        return self:new(...);
    end
});

---@private
---@return BaseObject
function BaseObject:new(...)
    return class_instance(self, ...);
end

---@return string
function BaseObject:GetType()
    local mt = self:GetMetatable();
    return type(mt) == 'table' and mt.__name;
end

---@private
---@param name string
function BaseObject:SetToString(name)
    local metatable = self:GetMetatable();
    metatable.__tostring = function()
        return name;
    end;
    return self;
end

---@return string
function BaseObject:ToString()
    return tostring(self);
end

---@vararg any
function BaseObject:super(...)

    local metatable = getmetatable(self);
    local list = get_super_list(self);
    metatable.__super_called = metatable.__super_called + 1;
    local class = list[metatable.__super_called];

    assert(class, "BaseObject:super(): Class not found");

    if (type(class["Constructor"]) == "function") then
        return class["Constructor"](self, ...);
    end

    return nil;

end

---@private
---@param parentClass? BaseObject
---@param methodName string
---@vararg any
---@return any
function BaseObject:CallParentMethod(methodName, ...)

    local metatable = getmetatable(self);
    local class = metatable.__super;
    assert(class, "BaseObject:CallParentMethod(): Class not found");

    if (type(class[methodName]) == "function") then
        return class[methodName](self, ...);
    end

    return nil;

end

---@private
---@param key string
---@param value any
function BaseObject:SetValue(key, value)
    if (string.sub(key, 1, 2) ~= "__") then
        self[key] = value;
    end
end

---@private
---@param key string
---@return any
function BaseObject:GetValue(key)
    if (string.sub(key, 1, 2) ~= "__") then
        return self[key];
    end
end

---@param class_name string | BaseObject
---@return boolean
function BaseObject:IsInstanceOf(class_name)

    local _class = type(class_name) == "string" and classes[class_name] or class_name;

    if(type(_class) ~= "table") then return false; end
    local class_metatable = classes[class_name]:GetMetatable();

    local _class_name = class_metatable and class_metatable.__name or nil;
    if (not _class_name) then return false; end

    local metatable = self:GetMetatable();
    return class_name == metatable.__name or false;

end

---@private
---@return table
function BaseObject:GetMetatable()
    return getmetatable(self);
end

classes["BaseObject"] = BaseObject;

return Class;