--[[
Author: uBluewolfu
Special For Birzha Memov.	
© Copyright 2018. All Right Reserved. The BirzhaMemov Development Team. 
-]]
LinkLuaModifier( "modifier_item_overheal_trank", "items/overheal_trank", LUA_MODIFIER_MOTION_NONE )
item_overheal_trank = class({})
modifier_item_overheal_trank = class({})
function item_overheal_trank:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_rune_regen", {duration = 30})
	self:GetCaster():EmitSound("Rune.Regen")
end

function item_overheal_trank:GetIntrinsicModifierName() 
return "modifier_item_overheal_trank"
end

modifier_item_overheal_trank = class({})

function modifier_item_overheal_trank:OnCreated()
self.a = self:GetAbility()
self.m = self.a:GetSpecialValueFor("movespeed")
self.r = self.a:GetSpecialValueFor("regen")
end

function modifier_item_overheal_trank:IsHidden()
return true
end

function modifier_item_overheal_trank:DeclareFunctions()
return {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT}
end

function modifier_item_overheal_trank:GetModifierConstantHealthRegen()
return self.r
end

function modifier_item_overheal_trank:GetModifierMoveSpeedBonus_Constant()
return self.m
end

