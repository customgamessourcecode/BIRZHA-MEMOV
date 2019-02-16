LinkLuaModifier("modifier_edward_gopnik_aura", "heroes/hero_edwardbil/edward_gopnik.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_edward_gopnik_aura_debuff", "heroes/hero_edwardbil/edward_gopnik.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_edward_gopnik", "heroes/hero_edwardbil/edward_gopnik.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_edward_gopnik_debuff", "heroes/hero_edwardbil/edward_gopnik.lua", LUA_MODIFIER_MOTION_NONE)

edward_gopnik = edward_gopnik or class({})

function edward_gopnik:GetIntrinsicModifierName()
	return "modifier_edward_gopnik_aura"
end

function edward_gopnik:OnUpgrade()
	local caster = self:GetCaster()
	caster:RemoveModifierByName("modifier_edward_gopnik_aura")
	caster:AddNewModifier(caster, self, "modifier_edward_gopnik_aura", {})
	caster:RemoveModifierByName("modifier_edward_gopnik_aura_debuff")
	caster:AddNewModifier(caster, self, "modifier_edward_gopnik_aura_debuff", {})
	if self:GetLevel() == 1 then
		self.Wmotka1 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/meepo/dosa_back/dosa_back.vmdl"})
		self.Wmotka2 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/meepo/dosa_hat/dosa_hat.vmdl"})
		self.Wmotka3 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/meepo/dosa_shoulder/dosa_shoulder.vmdl"})
		self.Wmotka4 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/meepo/dosa_tail/dosa_tail.vmdl"})
		self.Wmotka1:FollowEntity(caster, true)
		self.Wmotka2:FollowEntity(caster, true)
		self.Wmotka3:FollowEntity(caster, true)
		self.Wmotka4:FollowEntity(caster, true)
	elseif self:GetLevel() == 2 then
		UTIL_Remove(self.Wmotka1)
        UTIL_Remove(self.Wmotka2)
        UTIL_Remove(self.Wmotka3)
        UTIL_Remove(self.Wmotka4)
		self.Wmotka1 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/meepo/sir_meepalot_arms/sir_meepalot_arms.vmdl"})
		self.Wmotka2 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/meepo/sir_meepalot_back/sir_meepalot_back.vmdl"})
		self.Wmotka3 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/meepo/sir_meepalot_head/sir_meepalot_head.vmdl"})
		self.Wmotka4 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/meepo/sir_meepalot_shoulder/sir_meepalot_shoulder.vmdl"})
		self.Wmotka1:FollowEntity(caster, true)
		self.Wmotka2:FollowEntity(caster, true)
		self.Wmotka3:FollowEntity(caster, true)
		self.Wmotka4:FollowEntity(caster, true)
	elseif self:GetLevel() == 3 then
		UTIL_Remove(self.Wmotka1)
        UTIL_Remove(self.Wmotka2)
        UTIL_Remove(self.Wmotka3)
        UTIL_Remove(self.Wmotka4)
		self.Wmotka1 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/meepo/meepo_skeletonkey_bandana/meepo_skeletonkey_bandana.vmdl"})
		self.Wmotka2 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/meepo/colossal_crystal_chorus/colossal_crystal_chorus.vmdl"})
		self.Wmotka3 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/meepo/riftshadow_roamer_hat/riftshadow_roamer_hat.vmdl"})
		self.Wmotka4 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/meepo/sir_meepalot_shoulder/sir_meepalot_shoulder.vmdl"})
		self.Wmotka1:FollowEntity(caster, true)
		self.Wmotka2:FollowEntity(caster, true)
		self.Wmotka3:FollowEntity(caster, true)
		self.Wmotka4:FollowEntity(caster, true)
	end
end

function edward_gopnik:GetCastRange()
	return self:GetSpecialValueFor("radius")
end

function edward_gopnik:GetAbilityTextureName()
	return "edwardbil/gopnik"
end

modifier_edward_gopnik_aura = modifier_edward_gopnik_aura or class({})

function modifier_edward_gopnik_aura:IsAura() return true end
function modifier_edward_gopnik_aura:IsAuraActiveOnDeath() return false end
function modifier_edward_gopnik_aura:IsBuff() return false end
function modifier_edward_gopnik_aura:IsHidden() return true end
function modifier_edward_gopnik_aura:IsPermanent() return true end
function modifier_edward_gopnik_aura:IsPurgable() return false end

function modifier_edward_gopnik_aura:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_edward_gopnik_aura:GetAuraSearchFlags()
	return self:GetAbility():GetAbilityTargetFlags()
end

function modifier_edward_gopnik_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_edward_gopnik_aura:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

function modifier_edward_gopnik_aura:GetModifierAura()
	return "modifier_edward_gopnik"
end

modifier_edward_gopnik_aura_debuff = modifier_edward_gopnik_aura_debuff or class({})

function modifier_edward_gopnik_aura_debuff:IsAura() return true end
function modifier_edward_gopnik_aura_debuff:IsAuraActiveOnDeath() return false end
function modifier_edward_gopnik_aura_debuff:IsBuff() return true end
function modifier_edward_gopnik_aura_debuff:IsHidden() return true end
function modifier_edward_gopnik_aura_debuff:IsPermanent() return true end
function modifier_edward_gopnik_aura_debuff:IsPurgable() return false end

-- Aura properties
function modifier_edward_gopnik_aura_debuff:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_edward_gopnik_aura_debuff:GetAuraSearchFlags()
	return self:GetAbility():GetAbilityTargetFlags()
end

function modifier_edward_gopnik_aura_debuff:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_edward_gopnik_aura_debuff:GetAuraSearchType()
	return self:GetAbility():GetAbilityTargetType()
end

function modifier_edward_gopnik_aura_debuff:GetModifierAura()
	return "modifier_edward_gopnik_debuff"
end

modifier_edward_gopnik = modifier_edward_gopnik or class({})

function modifier_edward_gopnik:IsHidden() return false end
function modifier_edward_gopnik:IsPurgable() return false end

function modifier_edward_gopnik:OnCreated()
	self.fr_damage = self:GetAbility():GetSpecialValueFor("friendly_damage")
	self.fr_at = self:GetAbility():GetSpecialValueFor("friendly_at")
	self.fr_armor = self:GetAbility():GetSpecialValueFor("friendly_armor")
end

function modifier_edward_gopnik:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_edward_gopnik:GetModifierBaseDamageOutgoing_Percentage()
	return self.fr_damage
end

function modifier_edward_gopnik:GetModifierPhysicalArmorBonus()
	return self.fr_armor
end

function modifier_edward_gopnik:GetModifierAttackSpeedBonus_Constant()
	return self.fr_at
end

modifier_edward_gopnik_debuff = modifier_edward_gopnik_debuff or class({})

function modifier_edward_gopnik_debuff:IsHidden() return false end
function modifier_edward_gopnik_debuff:IsPurgable() return false end

function modifier_edward_gopnik_debuff:OnCreated()
	self.en_damage = self:GetAbility():GetSpecialValueFor("enemy_damage")
	self.en_at = self:GetAbility():GetSpecialValueFor("enemy_at")
	self.en_armor = self:GetAbility():GetSpecialValueFor("enemy_armor")
end

function modifier_edward_gopnik_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_edward_gopnik_debuff:GetModifierBaseDamageOutgoing_Percentage()
	return self.en_damage
end

function modifier_edward_gopnik_debuff:GetModifierPhysicalArmorBonus()
	return self.en_armor
end

function modifier_edward_gopnik_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.en_at
end
