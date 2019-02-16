modifier_Sobolev_Egoism = class ({})


function modifier_Sobolev_Egoism:IsPurgable()
	return true
end 

function modifier_Sobolev_Egoism:IsBuff()
	return true
end 

function modifier_Sobolev_Egoism:GetEffectName()
	return "particles/econ/items/lifestealer/lifestealer_immortal_backbone_gold/lifestealer_immortal_backbone_gold_rage.vpcf"
end

function modifier_Sobolev_Egoism:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

----------------------------------------------

function modifier_Sobolev_Egoism:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
 
	return funcs
end

function modifier_Sobolev_Egoism:GetModifierMoveSpeedBonus_Percentage(params)
	return self.bonus_move_speed
end

function modifier_Sobolev_Egoism:GetModifierAttackSpeedBonus_Constant(params)
	return self.bonus_attack_speed
end

function modifier_Sobolev_Egoism:GetModifierPreAttack_BonusDamage(params)
	return self:GetStackCount()
end

function modifier_Sobolev_Egoism:OnCreated(params)
	self.power_of_scourge_stacks = 0

	self.damage_per_stack = self:GetAbility():GetSpecialValueFor("damage_per_attack")
	self.bonus_damage = 0

	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.bonus_move_speed = self:GetAbility():GetSpecialValueFor("bonus_move_speed")
	
	local Talent = self:GetCaster():FindAbilityByName("special_bonus_unique_lone_druid_7")
	if Talent:GetLevel() == 1 then
		self.damage_per_stack = self.damage_per_stack + 20	
	end
end

function modifier_Sobolev_Egoism:OnAttackLanded(params)
	if IsServer() then
		if params.attacker == self:GetParent() and not self:GetParent():IsIllusion() and params.target:GetTeamNumber() ~= params.attacker:GetTeamNumber() then
			self.bonus_damage = self.bonus_damage + self.damage_per_stack
			self.power_of_scourge_stacks = self.power_of_scourge_stacks + 1
			self:SetStackCount(self.bonus_damage)
		end
	end
end

