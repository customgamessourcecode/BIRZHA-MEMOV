Sobolev_Egoism = class ({})
LinkLuaModifier("modifier_Sobolev_Egoism", "heroes/hero_sobolev/modifier_Sobolev_Egoism.lua", LUA_MODIFIER_MOTION_NONE)

function Sobolev_Egoism:OnSpellStart()
	EmitGlobalSound( "sobolevult" )
	local hCaster = self:GetCaster()

	if hCaster == nil then
		return
	end

	hCaster:AddNewModifier(hCaster, self, "modifier_Sobolev_Egoism", { duration = self:GetDuration() })


end