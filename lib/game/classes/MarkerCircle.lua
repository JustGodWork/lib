---@class MarkerCircle: Marker
local MarkerCircle = Class.extends('MarkerCircle', 'Marker');

---@private
function MarkerCircle:Constructor()

    self:super();
    self:SetType(eMarkerType.HorizontalCircleSkinny_Arrow);
    self:SetScale(vector3(0.5, 0.5, 0.5));
    self:SetColor(Color());
    self:SetDirection(vector3(0.0, 0.0, 0.0));
    self:SetRotation(vector3(0.0, 0.0, 0.0));
    self:SetBobUpAndDown(false);
    self:SetFaceCamera(false);
    self:SetRotate(true);

end

return MarkerCircle;