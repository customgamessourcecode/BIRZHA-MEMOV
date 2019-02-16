JohnCena_Grab = class({})
LinkLuaModifier( "modifier_JohnCena_Grab", "heroes/hero_johncena/modifier_JohnCena_Grab", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_JohnCena_Grabbed_buff", "heroes/hero_johncena/modifier_JohnCena_Grabbed_buff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_JohnCena_Grabbed_debuff", "heroes/hero_johncena/modifier_JohnCena_Grabbed_debuff", LUA_MODIFIER_MOTION_BOTH )

--------------------------------------------------------------------------------

function JohnCena_Grab:ProcsMagicStick()
	return false
end

--------------------------------------------------------------------------------

function JohnCena_Grab:OnSpellStart()
	if IsServer() then
		if self:GetCursorTarget():IsHero() then
			if self:GetCaster():FindModifierByName( "modifier_JohnCena_Grabbed_buff" ) ~= nil then
				return
			end
			self.animation_time = self:GetSpecialValueFor( "animation_time" )
			self.initial_delay = self:GetSpecialValueFor( "initial_delay" )
			local ability2 = self:GetCaster():FindAbilityByName("JohnCena_Grab")
			local kv = {}
			kv["duration"] = self.animation_time
			kv["initial_delay"] = self.initial_delay
			local hBuff = self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_JohnCena_Grab", kv )
			EmitSoundOn( "sena", self:GetCaster() )
			if hBuff ~= nil then
				hBuff.hTarget = self:GetCursorTarget()
				local ability = self:GetCaster():FindAbilityByName("JohnCena_ThrowTheEnemy")
				local lvl = ability2:GetLevel()
				ability:SetLevel(lvl)
			end
		end
	end
	return true
end

--------------------------------------------------------------------------------

function JohnCena_Grab:OnAbilityPhaseInterrupted()
	if IsServer() then
		self:GetCaster():RemoveModifierByName( "modifier_JohnCena_Grab" )
	end
end

--------------------------------------------------------------------------------

function JohnCena_Grab:GetPlaybackRateOverride()
	return 0.35
end

--------------------------------------------------------------------------------

function JohnCena_Grab:GetCastRange( vLocation, hTarget )
	if IsServer() then
		if self:GetCaster():FindModifierByName( "modifier_JohnCena_Grab" ) ~= nil then
			return 99999
		end
	end

	return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end 