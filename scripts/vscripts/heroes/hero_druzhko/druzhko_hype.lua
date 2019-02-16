Druzhko_Hype = class({})
LinkLuaModifier( "modifier_hype", "heroes/hero_druzhko/modifier_hype", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function Druzhko_Hype:OnSpellStart()
	EmitGlobalSound( "druzhkoXaip" )
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_hype", { duration = self:GetSpecialValueFor( "duration" ) } )
end
--------------------------------------------------------------------------------