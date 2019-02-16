LinkLuaModifier("modifier_Bullet_Stats_aura", "heroes/hero_bullet/Bullet_Stats.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Bullet_Stats_aura_debuff", "heroes/hero_bullet/Bullet_Stats.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Bullet_Stats", "heroes/hero_bullet/Bullet_Stats.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Bullet_Stats_debuff", "heroes/hero_bullet/Bullet_Stats.lua", LUA_MODIFIER_MOTION_NONE)

Bullet_Stats = Bullet_Stats or class({})

function Bullet_Stats:GetIntrinsicModifierName()
	return "modifier_Bullet_Stats_aura"
end

function Bullet_Stats:GetCastRange()
	return 600
end

function Bullet_Stats:OnSpellStart()
	if IsServer() then
		if self:GetCaster():HasModifier("modifier_Bullet_Stats_aura") then
			self:GetCaster():RemoveModifierByName("modifier_Bullet_Stats_aura")
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_Bullet_Stats_aura_debuff", {})
			self:GetCaster():EmitSound("Hero_Rubick.NullField.Offense")
		elseif self:GetCaster():HasModifier("modifier_Bullet_Stats_aura_debuff") then
			self:GetCaster():RemoveModifierByName("modifier_Bullet_Stats_aura_debuff")
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_Bullet_Stats_aura", {})
			self:GetCaster():EmitSound("Hero_Rubick.NullField.Defense")
		end
	end
end

function Bullet_Stats:GetAbilityTextureName()
	local debuff = self:GetCaster():HasModifier("modifier_Bullet_Stats_aura_debuff")
	if debuff then
		return "Bullet/stats"
	end
	return "Bullet/stats_friendly"
end

modifier_Bullet_Stats_aura = modifier_Bullet_Stats_aura or class({})

function modifier_Bullet_Stats_aura:IsAura() return true end
function modifier_Bullet_Stats_aura:IsAuraActiveOnDeath() return false end
function modifier_Bullet_Stats_aura:IsBuff() return false end
function modifier_Bullet_Stats_aura:IsHidden() return true end
function modifier_Bullet_Stats_aura:IsPermanent() return true end
function modifier_Bullet_Stats_aura:IsPurgable() return false end

function modifier_Bullet_Stats_aura:GetAuraRadius()
	return 600
end

function modifier_Bullet_Stats_aura:GetAuraSearchFlags()
	return self:GetAbility():GetAbilityTargetFlags()
end

function modifier_Bullet_Stats_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_Bullet_Stats_aura:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

function modifier_Bullet_Stats_aura:GetModifierAura()
	return "modifier_Bullet_Stats"
end

modifier_Bullet_Stats_aura_debuff = modifier_Bullet_Stats_aura_debuff or class({})

function modifier_Bullet_Stats_aura_debuff:IsAura() return true end
function modifier_Bullet_Stats_aura_debuff:IsAuraActiveOnDeath() return false end
function modifier_Bullet_Stats_aura_debuff:IsBuff() return true end
function modifier_Bullet_Stats_aura_debuff:IsHidden() return true end
function modifier_Bullet_Stats_aura_debuff:IsPermanent() return true end
function modifier_Bullet_Stats_aura_debuff:IsPurgable() return false end

-- Aura properties
function modifier_Bullet_Stats_aura_debuff:GetAuraRadius()
	return 600
end

function modifier_Bullet_Stats_aura_debuff:GetAuraSearchFlags()
	return self:GetAbility():GetAbilityTargetFlags()
end

function modifier_Bullet_Stats_aura_debuff:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_Bullet_Stats_aura_debuff:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

function modifier_Bullet_Stats_aura_debuff:GetModifierAura()
	return "modifier_Bullet_Stats_debuff"
end

modifier_Bullet_Stats = modifier_Bullet_Stats or class({})

function modifier_Bullet_Stats:IsHidden() return false end
function modifier_Bullet_Stats:IsPurgable() return false end

function modifier_Bullet_Stats:OnCreated()
	local Talent = self:GetCaster():FindAbilityByName("special_bonus_unique_beastmaster_3")
	
	if Talent:GetLevel() == 1 then
		self.atributes = self:GetAbility():GetSpecialValueFor("stat") + 15
	else
		self.atributes = self:GetAbility():GetSpecialValueFor("stat")
	end
end

function modifier_Bullet_Stats:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}

	return funcs
end

function modifier_Bullet_Stats:GetModifierBonusStats_Strength()
	return self.atributes
end

function modifier_Bullet_Stats:GetModifierBonusStats_Agility()
	return self.atributes
end

function modifier_Bullet_Stats:GetModifierBonusStats_Intellect()
	return self.atributes
end

modifier_Bullet_Stats_debuff = modifier_Bullet_Stats_debuff or class({})

function modifier_Bullet_Stats_debuff:IsHidden() return false end
function modifier_Bullet_Stats_debuff:IsPurgable() return false end

function modifier_Bullet_Stats_debuff:OnCreated()
	local Talent = self:GetCaster():FindAbilityByName("special_bonus_unique_beastmaster_3")
	
	if Talent:GetLevel() == 1 then
		self.atributes = (self:GetAbility():GetSpecialValueFor("stat") + 15) * (-1)
	else
		self.atributes = self:GetAbility():GetSpecialValueFor("stat") * (-1)
	end
end

function modifier_Bullet_Stats_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}

	return funcs
end

function modifier_Bullet_Stats_debuff:GetModifierBonusStats_Strength()
	return self.atributes
end

function modifier_Bullet_Stats_debuff:GetModifierBonusStats_Agility()
	return self.atributes
end

function modifier_Bullet_Stats_debuff:GetModifierBonusStats_Intellect()
	return self.atributes
end
