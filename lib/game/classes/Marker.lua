local DRAW_MARKER = DrawMarker;

---@class Marker: BaseObject
---@field private id string
---@field public type eMarkerType
---@field public position vector3
---@field public direction Direction
---@field public rotation Rotation
---@field public scale Scale
---@field public color Color
---@field public bobUpAndDown boolean
---@field public faceCamera boolean
---@field private p19 number
---@field public rotate boolean
---@field public textureDict string
---@field public textureName string
---@field public drawOnEnts boolean
---@overload fun(eMarkerType?: eMarkerType, position?: vector3, direction?: vector3, rotation?: vector3, scale?: vector3, color?: Color, bobUpAndDown?: boolean, faceCamera?: boolean, rotate?: boolean, textureDict?: string, textureName?: string, drawOnEnts?: boolean): Marker
local Marker = Class.new 'Marker';

---@private
---@param eMarkerType? eMarkerType
---@param position? vector3
---@param direction? vector3
---@param rotation? vector3
---@param scale? vector3
---@param color? Color
---@param bobUpAndDown? boolean
---@param faceCamera? boolean
---@param rotate? boolean
---@param textureDict? string
---@param textureName? string
---@param drawOnEnts? boolean
function Marker:Constructor(eMarkerType, position, direction, rotation, scale, color, bobUpAndDown, faceCamera, rotate, textureDict, textureName, drawOnEnts)

    self.id = lib.uuid();
    self.type = eMarkerType;
    self.position = position;
    self.direction = direction;
    self.rotation = rotation;
    self.scale = scale;
    self.color = color;
    self.bobUpAndDown = bobUpAndDown;
    self.faceCamera = faceCamera;
    self.p19 = 2;
    self.rotate = rotate;
    self.textureDict = textureDict;
    self.textureName = textureName;
    self.drawOnEnts = drawOnEnts;

end

---@param eMarkerType eMarkerType
function Marker:SetType(eMarkerType)
    self.type = eMarkerType;
    return self;
end

---@param position vector3
function Marker:SetPosition(position)
    self.position = position;
    return self;
end

---@param direction vector3
function Marker:SetDirection(direction)
    self.direction = direction;
    return self;
end

---@param rotation vector3
function Marker:SetRotation(rotation)
    self.rotation = rotation;
    return self;
end

---@param scale vector3
function Marker:SetScale(scale)
    self.scale = scale;
    return self;
end

---@param color Color
function Marker:SetColor(color)
    self.color = color;
    return self;
end

---@param bobUpAndDown boolean
function Marker:SetBobUpAndDown(bobUpAndDown)
    self.bobUpAndDown = bobUpAndDown;
    return self;
end

---@param faceCamera boolean
function Marker:SetFaceCamera(faceCamera)
    self.faceCamera = faceCamera;
    return self;
end

---@param rotate boolean
function Marker:SetRotate(rotate)
    self.rotate = rotate;
    return self;
end

---@param textureDict string
function Marker:SetTextureDict(textureDict)
    self.textureDict = textureDict;
    return self;
end

---@param textureName string
function Marker:SetTextureName(textureName)
    self.textureName = textureName;
    return self;
end

---@param drawOnEnts boolean
function Marker:SetDrawOnEnts(drawOnEnts)
    self.drawOnEnts = drawOnEnts;
    return self;
end

---Draw the marker with the current settings
function Marker:Draw()
    DRAW_MARKER(

        self.type,
        self.position.x,
        self.position.y,
        self.position.z,
        self.direction.x,
        self.direction.y,
        self.direction.z,
        self.rotation.x,
        self.rotation.y,
        self.rotation.z,
        self.scale.x,
        self.scale.y,
        self.scale.z,
        self.color.r,
        self.color.g,
        self.color.b,
        self.color.a,
        self.bobUpAndDown,
        self.faceCamera,
        self.p19,
        self.rotate,
        self.textureDict,
        self.textureName,
        self.drawOnEnts

    );
end

return Marker;