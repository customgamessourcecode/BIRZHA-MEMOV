--[[
Author: uBluewolfu
Special For Birzha Memov.	
© Copyright 2018. All Right Reserved. The BirzhaMemov Development Team. 
Chill Aquilas functions
-]]

LinkLuaModifier( "modifier_drum_of_speedrun_aura", "items/drum_of_speedrun", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drum_of_speedrun", "items/drum_of_speedrun", LUA_MODIFIER_MOTION_NONE )
----------------
-- Chill Aquila
----------------
item_drum_of_speedrun = class({})
modifier_drum_of_speedrun = class({})
modifier_drum_of_speedrun_aura = class({})

function item_drum_of_speedrun:OnSpellStart()
	local targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,unit in pairs(targets) do
		unit:AddNewModifier(self:GetCaster(), self, "modifier_rune_haste", {duration = 20})
	end
	self:GetCaster():EmitSound("Rune.Haste")
end

function item_drum_of_speedrun:GetIntrinsicModifierName() 
return "modifier_drum_of_speedrun_aura"
end

function modifier_drum_of_speedrun_aura:OnCreated()
self.caster = self:GetCaster()
self.radius = self:GetAbility():GetSpecialValueFor("radius")
self.ag = self:GetAbility():GetSpecialValueFor("bonus_agility")
self.str = self:GetAbility():GetSpecialValueFor("bonus_str")
self.int = self:GetAbility():GetSpecialValueFor("bonus_int")
self.resist = self:GetAbility():GetSpecialValueFor("mag_resist")
end
function modifier_drum_of_speedrun_aura:IsAura()
return true
end

function modifier_drum_of_speedrun_aura:GetAuraRadius()
return self.radius
end

function modifier_drum_of_speedrun_aura:GetAuraSearchTeam()
return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_drum_of_speedrun_aura:GetAuraSearchType()
return DOTA_UNIT_TARGET_HERO
end

function modifier_drum_of_speedrun_aura:IsHidden()
return true
end
function modifier_drum_of_speedrun_aura:GetModifierAura()
return "modifier_drum_of_speedrun"
end

function modifier_drum_of_speedrun_aura:DeclareFunctions()
return {MODIFIER_PROPERTY_STATS_AGILITY_BONUS, MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS  }
end
function modifier_drum_of_speedrun_aura:GetModifierBonusStats_Agility()
return self.ag
end

function modifier_drum_of_speedrun_aura:GetModifierMagicalResistanceBonus()
return self.resist
end

function modifier_drum_of_speedrun_aura:GetModifierBonusStats_Intellect()
return self.int
end

function modifier_drum_of_speedrun_aura:GetModifierBonusStats_Strength()
return self.str
end
function modifier_drum_of_speedrun:OnCreated()
self.mv = self:GetAbility():GetSpecialValueFor("movespeed")
self.mg = self:GetAbility():GetSpecialValueFor("mana_regen")
end

function modifier_drum_of_speedrun:DeclareFunctions()
return {MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT }
end

function modifier_drum_of_speedrun:GetModifierConstantManaRegen()
return self.mg
end

function modifier_drum_of_speedrun:GetModifierMoveSpeedBonus_Constant()
return self.mv 
end
