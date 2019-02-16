pudge_dismember_3 = class({})
LinkLuaModifier( "modifier_dismember_lua", "heroes/hero_pudge/modifier_dismember_lua.lua" ,LUA_MODIFIER_MOTION_NONE )


function pudge_dismember_3:GetConceptRecipientType()
	return DOTA_SPEECH_USER_ALL
end

function pudge_dismember_3:SpeakTrigger()
	return DOTA_ABILITY_SPEAK_CAST
end

function pudge_dismember_3:GetChannelTime()
	self.hero_duration = self:GetSpecialValueFor( "duration" )

	if IsServer() then
		if self.hVictim ~= nil then
			if self.hVictim:IsConsideredHero() then
				return self.hero_duration
			else
				return self.hero_duration
			end
		end

		return 0.0
	end

	return self.hero_duration
end

--------------------------------------------------------------------------------

function pudge_dismember_3:OnAbilityPhaseStart()
	if IsServer() then
		self.hVictim = self:GetCursorTarget()
	end

	return true
end

--------------------------------------------------------------------------------

function pudge_dismember_3:OnSpellStart()
	if self.hVictim == nil then
		return
	end
	
	if self.hVictim:TriggerSpellAbsorb( self ) then
		self.hVictim = nil
		self:GetCaster():Interrupt()
	else
		self.hVictim:AddNewModifier( self:GetCaster(), self, "modifier_dismember_lua", { duration = self:GetChannelTime() } )
		self.hVictim:Interrupt()
	end
end


--------------------------------------------------------------------------------

function pudge_dismember_3:OnChannelFinish( bInterrupted )
	if self.hVictim ~= nil then
		self.hVictim:RemoveModifierByName( "modifier_dismember_lua" )
	end
end

--------------------------------------------------------------------------------