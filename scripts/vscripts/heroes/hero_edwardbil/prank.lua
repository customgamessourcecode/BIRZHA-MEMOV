--[[
Author: uBluewolfu
Special For Birzha Memov.	
© Copyright 2018. All Right Reserved. The BirzhaMemov Development Team. 
-]]
LinkLuaModifier( "modifier_edward_bil_prank_invis", "heroes/hero_edwardbil/prank", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_edward_bil_prank_invis_talent", "heroes/hero_edwardbil/prank", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_EdwardBil_Chi_Yes_slow", "heroes/hero_edwardbil/EdwardBil_Chi_Yes.lua", LUA_MODIFIER_MOTION_NONE)
---------
edward_bil_prank = class({})
modifier_edward_bil_prank_invis = class({})

function edward_bil_prank:OnSpellStart()
self.duration = self:GetSpecialValueFor("invis_duration")
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_invisible", {duration = self.duration})
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_edward_bil_prank_invis", {duration = self.duration})
if self:GetCaster():HasTalent("special_bonus_unique_silencer") then
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_edward_bil_prank_invis_talent", {duration = self.duration})
end
end

function modifier_edward_bil_prank_invis:CheckState()
return {[MODIFIER_STATE_INVISIBLE] = true,}
end

function modifier_edward_bil_prank_invis:DeclareFunctions()
return {MODIFIER_EVENT_ON_ATTACK_LANDED}
end

function modifier_edward_bil_prank_invis:IsHidden()
	return true
end

function modifier_edward_bil_prank_invis:OnAttackLanded(inf)
	EdwardBil_Chi_Yes = self:GetCaster():FindAbilityByName("EdwardBil_Chi_Yes")
	if EdwardBil_Chi_Yes ~= nil then
		self.damage = EdwardBil_Chi_Yes:GetSpecialValueFor("bonus_damage")
	else
		self.damage = 0
	end
	
	if inf.attacker == self:GetCaster() then
		self:Destroy()
		inf.target:AddNewModifier( inf.attacker, self, "modifier_EdwardBil_Chi_Yes_slow", {duration = 0.5})
		ApplyDamage({victim = inf.target, attacker = inf.attacker, damage = self.damage, damage_type = DAMAGE_TYPE_PHYSICAL})
		inf.attacker:EmitSound("edwardchida")
	end
end 

modifier_edward_bil_prank_invis_talent = class({})


function modifier_edward_bil_prank_invis_talent:IsHidden()
	return true
end

function modifier_edward_bil_prank_invis_talent:CheckState()
return {[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,}
end
