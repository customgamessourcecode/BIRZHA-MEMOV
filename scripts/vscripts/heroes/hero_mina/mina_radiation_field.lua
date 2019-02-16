mina_radiation_field = class({})
LinkLuaModifier( "modifier_radiation_field", "heroes/hero_mina/modifier_radiation_field", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function mina_radiation_field:GetIntrinsicModifierName()
	return "modifier_radiation_field"
end