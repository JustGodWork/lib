local class_builder = {};
local classes = {};
local singletons = {};

---@alias type
---| "nil"
---| "number"
---| "string"
---| "boolean"
---| "table"
---| "function"
---| "thread"
---| "userdata"
---| "BaseObject"

---@param v any
---@return type type
---@nodiscard
function type(v)
    if (lib.cache.type(v) == "table" and Class.HasMetatable(v)) then
        return Class.GetName(v) or lib.cache.type(v);
    end
    return lib.cache.type(v);
end

---@param v any
---@param varType string | table
---@return boolean
function typeof(v, varType)

    if (lib.cache.type(varType) == 'table' or lib.cache.type(varType) == 'string' and classes[varType]) then
        if (Class.HasMetatable(v)) then
            return Class.IsInstanceOf(v, varType) or lib.cache.type(v) == varType;
        end
        return lib.cache.type(v) == varType;
    end

    return lib.cache.type(v) == varType;

end

---@param v any
---@return boolean
function is_class(v)
    return lib.cache.type(v) == "table" and Class.IsValid(v);
end

---@param v any
---@return boolean
function is_object(v)
    return lib.cache.type(v) == "table" and Class.IsInstance(v);
end

---@param name string
---@return BaseObject
function class_builder.require(name)
    return classes[name];
end

---@param name string
---@return BaseObject
function class_builder.singleton_require(name)
    return singletons[name];
end

---@param self BaseObject
function class_builder.get_super_list(self)

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
function class_builder.super(class)
	local metatable = getmetatable(class);
	local metaSuper = metatable.__super;
	if (metaSuper) then
		return metaSuper;
	end
	return nil;
end

---@param class BaseObject
---@return table
function class_builder.build(class)

    assert(class, "Attempt to build from an invalid class");

    local metatable = getmetatable(class);

    assert(metatable, "Attempt to build from an invalid class");
    assert(singletons[metatable.__name] == nil, "Attempt to build instance from a singleton");

    local super = class_builder.super(class);

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
        __type = metatable.__new_type;
        __name = metatable.__name;
        __super_called = 0;
    });

end

---@param class BaseObject
---@vararg
---@return BaseObject
function class_builder.instance(class, ...)

	if (class) then

		local instance = class_builder.build(class);

        local metatable = getmetatable(instance);
        local metasuper = getmetatable(metatable.__super);

		if (lib.cache.type(instance["Constructor"]) == "function") then

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

--- Callback optional
---@param name string
---@param fromClass string
---@param callback? fun(class: BaseObject): table
---@return BaseObject
function class_builder.prepare(name, fromClass, callback)

    local _class = lib.cache.type(fromClass) == "string" and classes[fromClass] or fromClass;

    assert(_class, "Attempt to extends from an invalid class");
    assert(singletons[name] == nil, "Attempt to extends from a singleton");

    local tbl = lib.cache.type(callback) == "function" and callback({}) or {};
    local metatable = getmetatable(_class);

    classes[name] = setmetatable(tbl, {
        __index = _class;
        __super = _class;
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
        __new_type = "instance";
        __name = name;
    });

    console.debug(('Created class ^6%s^0 from class ^3%s^0'):format(classes[name]:ToString(), _class:ToString()));

    return classes[name];

end

--- Callback required
---@param name string
---@param fromClass string | BaseObject
---@param callback fun(class: BaseObject): table
---@vararg any
function class_builder.prepare_singleton(name, fromClass, callback, ...)

    local _class = lib.cache.type(fromClass) == "string" and classes[fromClass] or fromClass;
    assert(lib.cache.type(_class) == 'table', ("Attempt to extends from an invalid class '%s'"):format(lib.cache.type(fromClass)));

    local metatable = getmetatable(_class);
    assert(callback, ("Attempt to create a singleton '%s' without callback"):format(name));

    local tbl = callback({});

    assert(lib.cache.type(tbl) == 'table', ("Attempt to create a singleton '%s' without return."):format(name));

    classes[name] = setmetatable(tbl, {
        __index = _class;
        __super = _class;
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
        __new_type = "singleton";
        __name = name;
    });

    singletons[name] = classes[name](...);

    console.debug(('Created singleton ^6%s^0 from class ^3%s^0'):format(classes[name]:ToString(), _class:ToString()));

    return singletons[name];

end

--- Callback required
---@param name string
---@param callback fun(class: BaseObject): table
---@vararg any
---@return BaseObject
function class_builder.singleton(name, callback, ...)
    return class_builder.prepare_singleton(name, classes["BaseObject"], callback, ...);
end

--- Callback required
---@param name string
---@param fromClass string | BaseObject
---@param callback fun(class: BaseObject): table
---@vararg any
function class_builder.singleton_extends(name, fromClass, callback, ...)
    return class_builder.prepare_singleton(name, fromClass, callback, ...);
end

--- Callback optional
---@param name string
---@param callback fun(class: BaseObject): table
---@return BaseObject
function class_builder.new(name, callback)
	return class_builder.prepare(name, classes["BaseObject"], callback);
end

--- Callback optional
---@param name string
---@param fromClass string | BaseObject
---@param callback fun(class: BaseObject): table
---@return BaseObject
function class_builder.extends(name, fromClass, callback)
    return class_builder.prepare(name, fromClass, callback);
end

--CLASS

---@class Class
Class = {};

Class.extends = class_builder.extends;
Class.singleton = class_builder.singleton;
Class.singleton_extends = class_builder.singleton_extends;
Class.new = class_builder.new;
Class.require = class_builder.require;
Class.singleton_require = class_builder.singleton_require;

---@param var any
---@return boolean
function Class.HasMetatable(var)
    return lib.cache.type(var) == "table" and lib.cache.type(getmetatable(var)) == "table";
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

    local _class = lib.cache.type(class) == "string" and Class.require(class) or class;

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
    return class_builder.instance(self, ...);
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
    local list = class_builder.get_super_list(self);
    metatable.__super_called = metatable.__super_called + 1;
    local class = list[metatable.__super_called];

    assert(class, "BaseObject:super(): Class not found");

    if (lib.cache.type(class["Constructor"]) == "function") then
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

    if (lib.cache.type(class[methodName]) == "function") then
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

    local _class = lib.cache.type(class_name) == "string" and classes[class_name] or class_name;

    if(lib.cache.type(_class) ~= "table") then return false; end
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