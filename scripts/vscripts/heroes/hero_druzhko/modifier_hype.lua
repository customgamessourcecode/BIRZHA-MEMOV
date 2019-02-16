modifier_hype = class({})

--------------------------------------------------------------------------------

function modifier_hype:OnCreated( kv )
	self.move_speed = self:GetAbility():GetSpecialValueFor( "move_speed" )
	self.model_scale = self:GetAbility():GetSpecialValueFor( "model_scale" )
	self.bonus_strength = self:GetAbility():GetSpecialValueFor( "bonus_strength" )
	self.bonus_intellect = self:GetAbility():GetSpecialValueFor( "bonus_intellect" )
	self.bonus_agility = 0
	
	local Talent = self:GetParent():FindAbilityByName("special_bonus_unique_invoker_1")
	
	if Talent:GetLevel() == 1 then
		self.bonus_agility = self.bonus_agility + 50
	end
	
	if IsServer() then
		self.nHealTicks = 0
		self:StartIntervalThink( 0.05 )
	end
end

--------------------------------------------------------------------------------

function modifier_hype:OnRemoved()
	if IsServer() then
		local flHealth = self:GetParent():GetHealth() 
		local flMaxHealth = self:GetParent():GetMaxHealth()
		local flHealthPct = flHealth / flMaxHealth

		self:GetParent():CalculateStatBonus()

		local flNewHealth = self:GetParent():GetHealth()  
		local flNewMaxHealth = self:GetParent():GetMaxHealth()

		local flNewDesiredHealth = flNewMaxHealth * flHealthPct
		if flNewHealth ~= flNewDesiredHealth then
			self:GetParent():ModifyHealth( flNewDesiredHealth, self:GetAbility(), false, 0 )
		end	
	end
end

--------------------------------------------------------------------------------

function modifier_hype:OnIntervalThink()
	if IsServer() then
		self:GetParent():Heal( ( self.bonus_strength * 20 ) * 0.05, self:GetAbility() )
		self.nHealTicks = self.nHealTicks + 1
		if self.nHealTicks >= 20 then
			self:StartIntervalThink( -1 )
		end
	end
end

--------------------------------------------------------------------------------

function modifier_hype:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_EXTRA_STRENGTH_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}

	return funcs
end

--------------------------------------------------------------------------------


function modifier_hype:OnAttackLanded( params )
	if IsServer() then
		local hTarget = params.target

		if hTarget == nil or hTarget ~= self:GetParent() then
			return 0
		end
		EmitGlobalSound( "lolkek" )
	end
end

--------------------------------------------------------------------------------

function modifier_hype:GetModifierModelScale( params )
	return self.model_scale
end

function modifier_hype:GetModifierExtraStrengthBonus( params )
	return self.bonus_strength
end

function modifier_hype:GetModifierBonusStats_Intellect( params )
	return self.bonus_intellect
end

function modifier_hype:GetModifierMoveSpeed_Limit( params )
	return self.move_speed
end

function modifier_hype:GetModifierBonusStats_Agility( params )
	return self.bonus_agility
end
