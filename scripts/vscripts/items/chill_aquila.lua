--[[
Author: uBluewolfu
Special For Birzha Memov.	
© Copyright 2018. All Right Reserved. The BirzhaMemov Development Team. 
Chill Aquilas functions
-]]

LinkLuaModifier( "modifier_chill_aquila_aura", "items/chill_aquila", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chill_aquila", "items/chill_aquila", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chill_aquila_dd", "items/chill_aquila", LUA_MODIFIER_MOTION_NONE )
----------------
-- Chill Aquila
----------------
item_chill_aquila = class({})
modifier_chill_aquila = class({})
modifier_chill_aquila_aura = class({})
modifier_chill_aquila_dd = class({})

function item_chill_aquila:OnSpellStart()
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_rune_doubledamage", {duration = 15})
self:GetCaster():EmitSound("Rune.DD")

end

function item_chill_aquila:GetIntrinsicModifierName() 
return "modifier_chill_aquila_aura"
end

function modifier_chill_aquila_dd:DeclareFunctions()
return {MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE}
end

function modifier_chill_aquila_dd:OnCreated()
self.caster = self:GetCaster()
self.dmax = self.caster:GetBaseDamageMax()
self.dmin = self.caster:GetBaseDamageMin()
end
function modifier_chill_aquila_dd:GetModifierBaseAttack_BonusDamage()
return self.dmax
end

function modifier_chill_aquila_dd:GetEffectName()
return "particles/generic_gameplay/rune_doubledamage_owner.vpcf"
end
--

function modifier_chill_aquila_aura:OnCreated()
self.caster = self:GetCaster()
self.radius = self:GetAbility():GetSpecialValueFor("radius")
self.ag = self:GetAbility():GetSpecialValueFor("bonus_agility")
self.str = self:GetAbility():GetSpecialValueFor("bonus_str")
self.int = self:GetAbility():GetSpecialValueFor("bonus_int")
self.damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
self.at = self:GetAbility():GetSpecialValueFor("bonus_at")
end
function modifier_chill_aquila_aura:IsAura()
return true
end

function modifier_chill_aquila_aura:GetAuraRadius()
return self.radius
end

function modifier_chill_aquila_aura:GetAuraSearchTeam()
return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_chill_aquila_aura:GetAuraSearchType()
return DOTA_UNIT_TARGET_HERO
end

function modifier_chill_aquila_aura:IsHidden()
return true
end
function modifier_chill_aquila_aura:GetModifierAura()
return "modifier_chill_aquila"
end

function modifier_chill_aquila_aura:DeclareFunctions()
return {MODIFIER_PROPERTY_STATS_AGILITY_BONUS, MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT  }
end
function modifier_chill_aquila_aura:GetModifierBonusStats_Agility()
return self.ag
end

function modifier_chill_aquila_aura:GetModifierPreAttack_BonusDamage()
return self.damage
end

function modifier_chill_aquila_aura:GetModifierAttackSpeedBonus_Constant()
return self.at
end

function modifier_chill_aquila_aura:GetModifierBonusStats_Intellect()
return self.int
end

function modifier_chill_aquila_aura:GetModifierBonusStats_Strength()
return self.str
end
function modifier_chill_aquila:OnCreated()
self.ar = self:GetAbility():GetSpecialValueFor("armor")
self.mg = self:GetAbility():GetSpecialValueFor("mana_regen")
end

function modifier_chill_aquila:DeclareFunctions()
return {MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS }
end

function modifier_chill_aquila:GetModifierConstantManaRegen()
return self.mg
end

function modifier_chill_aquila:GetModifierPhysicalArmorBonus()
return self.ar 
end
