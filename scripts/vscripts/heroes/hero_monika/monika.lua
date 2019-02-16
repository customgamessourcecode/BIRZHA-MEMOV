--[[
Author: uBluewolfu
Special For Birzha Memov.	
© Copyright 2019. All Right Reserved. The BirzhaMemov Development Team. 
Just Monika.
--]]
local file = "heroes/hero_monika/monika"
local modifiers =
{
"modifier_fourtwall_agility_boost",
"modifier_fourtwall_str_boost",
"modifier_fourthwall_boost_ag_interval",
"modifier_fourthwall_boost_str_interval",
"modifier_monika_ult_casted",
"modifier_monica_concept",
"modifier_monika_concept_ill",
"monika_fourthwall_int_bonus"
}

for _,v in pairs(modifiers) do
LinkLuaModifier( v, file, LUA_MODIFIER_MOTION_NONE )
end


monika_fourthwall_1 = class({})
monika_fourthwall_int_bonus = class({})
modifier_fourthwall_boost_ag_interval = class({})
modifier_fourtwall_agility_boost = class({})
modifier_fourtwall_str_boost = class({})
modifier_fourthwall_boost_str_interval = class({})

function monika_fourthwall_1:GetIntrinsicModifierName()
return "modifier_fourtwall_agility_boost"
end

function modifier_fourtwall_agility_boost:RemoveOnDeath()
return false
end

function modifier_fourtwall_str_boost:RemoveOnDeath()
return false
end

function modifier_fourtwall_agility_boost:OnCreated()
end

function  monika_fourthwall_int_bonus:IsHidden()
return true
end

function monika_fourthwall_int_bonus:DeclareFunctions()
return {MODIFIER_PROPERTY_STATS_INTELLECT_BONUS }
end

function monika_fourthwall_int_bonus:GetModifierBonusStats_Intellect()
return self:GetAbility():GetSpecialValueFor("bonus_int")
end 

function monika_fourthwall_int_bonus:RemoveOnDeath()
return false
end

function monika_fourthwall_1:OnUpgrade()
local str_ab = self:GetCaster():FindAbilityByName("monika_fourthwall_2") 
	if self:GetLevel() == 1 then
		str_ab:SetHidden(false)	
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "monika_fourthwall_int_bonus", {})
	end
	str_ab:SetLevel(self:GetLevel())	
	
end

function monika_fourthwall_1:OnSpellStart()
local caster = self:GetCaster()
local ag_interval = caster:FindModifierByName("modifier_fourthwall_boost_ag_interval")
local str_interval = caster:FindModifierByName("modifier_fourthwall_boost_str_interval")
	if ag_interval then
	ag_interval:Destroy()
	return
	end
	if str_interval then
		str_interval:Destroy()
	end
	caster:AddNewModifier(caster, self, "modifier_fourthwall_boost_ag_interval", {})
end


monika_fourthwall_2 = class({})

function monika_fourthwall_2:GetIntrinsicModifierName()
return "modifier_fourtwall_str_boost"
end

function monika_fourthwall_2:OnUpgrade()

end

function monika_fourthwall_2:OnSpellStart()
local caster = self:GetCaster()
local ag_interval = caster:FindModifierByName("modifier_fourthwall_boost_ag_interval")
local str_interval = caster:FindModifierByName("modifier_fourthwall_boost_str_interval")
	if str_interval then
	str_interval:Destroy()
	return
	end
	if ag_interval then
		ag_interval:Destroy()
	end
	caster:AddNewModifier(caster, self, "modifier_fourthwall_boost_str_interval", {})
end


function modifier_fourtwall_agility_boost:OnCreated()
self:SetStackCount(self:GetCaster():GetBaseAgility())
end

function modifier_fourtwall_str_boost:OnCreated()
self:SetStackCount(self:GetCaster():GetBaseStrength())
end

function modifier_fourthwall_boost_ag_interval:OnCreated()
self.interval = self:GetAbility():GetSpecialValueFor("interval")
if self:GetCaster():FindAbilityByName("special_bonus_unique_lone_druid_2"):GetLevel() > 0 then
self.interval = 0.04
end
self:StartIntervalThink(self.interval)
end

function modifier_fourthwall_boost_ag_interval:OnIntervalThink()
local str_stacks = self:GetCaster():FindModifierByName("modifier_fourtwall_str_boost")
local ag_stacks = self:GetCaster():FindModifierByName("modifier_fourtwall_agility_boost")

	if self:GetCaster():GetBaseStrength() >= 1 then
		str_stacks:SetStackCount(str_stacks:GetStackCount() - 1)
		ag_stacks:SetStackCount(ag_stacks:GetStackCount() + 1)
	
		self:GetCaster():SetBaseStrength(self:GetCaster():GetBaseStrength() - 1)
		self:GetCaster():SetBaseAgility(self:GetCaster():GetBaseAgility() + 1)
		self:GetCaster():CalculateStatBonus()
	end
end

function modifier_fourthwall_boost_str_interval:OnCreated()
self.interval = self:GetAbility():GetSpecialValueFor("interval")
if self:GetCaster():FindAbilityByName("special_bonus_unique_lone_druid_2"):GetLevel() > 0 then
self.interval = 0.04
end
self:StartIntervalThink(self.interval)
end

function modifier_fourthwall_boost_str_interval:OnIntervalThink()
	local str_stacks = self:GetCaster():FindModifierByName("modifier_fourtwall_str_boost")
	local ag_stacks = self:GetCaster():FindModifierByName("modifier_fourtwall_agility_boost")

	if self:GetCaster():GetBaseAgility() >= 1 then
		str_stacks:SetStackCount(str_stacks:GetStackCount() + 1)
		ag_stacks:SetStackCount(ag_stacks:GetStackCount() - 1)

		self:GetCaster():SetBaseStrength(self:GetCaster():GetBaseStrength() + 1)
		self:GetCaster():SetBaseAgility(self:GetCaster():GetBaseAgility() - 1)
		self:GetCaster():CalculateStatBonus()
	end
end

function modifier_fourthwall_boost_ag_interval:GetEffectName()
	return "particles/units/heroes/hero_morphling/morphling_morph_agi.vpcf"
end

function modifier_fourthwall_boost_str_interval:GetEffectName()
	return "particles/units/heroes/hero_morphling/morphling_morph_str.vpcf"
end

function modifier_fourtwall_str_boost:IsHidden()
return true
end

function modifier_fourtwall_agility_boost:IsHidden()
return true
end
-------------------------
-- Monika  : Perception
-------------------------
monika_perception = class({})
monika_perception_teleport = class({})


function monika_perception:CastFilterResultTarget(target)
	if target:GetUnitName() == "npc_dota_bristlekek" or target:GetUnitName() == "npc_dota_LolBlade" then
		return UF_FAIL_CUSTOM
	end
	if	not self:GetCaster():HasTalent("special_bonus_unique_lone_druid_1") and target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
	return UF_FAIL_CUSTOM
	end
	return UF_SUCCESS
end	

function monika_perception:GetCustomCastErrorTarget(target)
	if target:GetUnitName() == "npc_dota_bristlekek" or target:GetUnitName() == "npc_dota_LolBlade" then
		return "#dota_hud_error_cant_cast_on_self"
	end
	if not self:GetCaster():HasTalent("special_bonus_unique_lone_druid_1") and target:GetTeamNumber() ~= self:GetCaster() then
	return "#dota_hud_error_cant_cast_on_self"
	end
end


function monika_perception:OnSpellStart()
self.target = self:GetCursorTarget()
self.caster = self:GetCaster()
if self.caster:HasModifier("modifier_monika_ult_casted") then return end
self:GetCaster().swap_ended = nil
self:GetCaster():EmitSound("monikaultimate")
self.second_ab = self.caster:FindAbilityByName("monika_perception_teleport")
self.caster:AddNewModifier(self.caster, self, "modifier_monika_ult_casted", {})
self:GetCaster().teleport_unit = self.target
self:GetCaster().teleport_unit:AddNewModifier(self.caster, self, "modifier_monika_ult_casted", {})
local telep = self.caster:FindAbilityByName("monika_perception_teleport")
if telep then telep:SetLevel(1) end
self.caster:SwapAbilities("monika_perception", "monika_perception_teleport", false, true)
end

function monika_perception_teleport:OnSpellStart()
if self:GetCaster().teleport_unit then
self:GetCaster().teleport_unit:SetAbsOrigin(self:GetCursorPosition())
FindClearSpaceForUnit(self:GetCaster().teleport_unit, self:GetCursorPosition(), true)
self:GetCaster().teleport_unit:RemoveModifierByName("modifier_monika_ult_casted")
end
end


modifier_monika_ult_casted = class({})

function modifier_monika_ult_casted:OnDestroy()
if not self:GetCaster().swap_ended then
self:GetCaster().swap_ended = true
self:GetCaster():RemoveModifierByName("modifier_monika_ult_casted")
self:GetCaster().teleport_unit:RemoveModifierByName("modifier_monika_ult_casted")
self:GetCaster().teleport_unit:EmitSound("Hero_AbyssalUnderlord.DarkRift.Complete")
self:GetCaster().teleport_unit = nil
local percepion = self:GetCaster():FindAbilityByName("monika_perception")
percepion:StartCooldown(percepion:GetSpecialValueFor("cd"))
self:GetCaster():SwapAbilities("monika_perception_teleport", "monika_perception", false, true)
local telep = self:GetCaster():FindAbilityByName("monika_perception_teleport")
if telep then telep:SetLevel(0) end
end
end

function modifier_monika_ult_casted:GetEffectName()
	return "particles/monika/monika_ultimate_target.vpcf"
end

function modifier_monika_ult_casted:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

---------------
-- Monika: Omnipresence
--------------

monika_omniper = class({})


function monika_omniper:OnSpellStart()
self.damage = self:GetSpecialValueFor("damage")
self.radius = self:GetSpecialValueFor("radius")
if self:GetCaster():HasTalent("special_bonus_unique_lone_druid_4") then
	self.radius = self.radius + 350
end

self.caster = self:GetCaster()
self.position = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector() * self.radius
local vDirection = self.position - self:GetCaster():GetOrigin()
	vDirection.z = 0.0
	vDirection = vDirection:Normalized()

local info = {
	EffectName = "particles/econ/items/faceless_void/faceless_void_jewel_of_aeons/fv_time_walk_jewel.vpcf",
	Ability = self,
	vSpawnOrigin = self:GetCaster():GetOrigin(), 
	fStartRadius = 150,
	fEndRadius = 150,
	vVelocity = vDirection * 10000,
	fDistance = self.radius,
	Source = self:GetCaster(),
	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
}
self.caster:EmitSound("Hero_FacelessVoid.TimeWalk.Aeons")
local blinkIndex = ParticleManager:CreateParticle("particles/monika/monika_blink.vpcf", PATTACH_ABSORIGIN, self.caster)
Timers:CreateTimer( 1, function()
	ParticleManager:DestroyParticle( blinkIndex, false )
	return nil
	end
)

ProjectileManager:CreateLinearProjectile( info )
self:GetCaster():SetAbsOrigin(self.position)
FindClearSpaceForUnit(self:GetCaster(), self.position, false)
end

function monika_omniper:OnProjectileHit(t, l)
	ApplyDamage({victim = t, attacker = self:GetCaster(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
	if t then
		t:AddNewModifier( self:GetCaster(), self, "modifier_stunned", {duration = 0.25})
		t:EmitSound("Hero_FacelessVoid.TimeLockImpact")
	end
	local blinkIndex2 = ParticleManager:CreateParticle("particles/monika/monika_blink_flame.vpcf", PATTACH_ABSORIGIN, t)
	Timers:CreateTimer( 1, function()
		ParticleManager:DestroyParticle( blinkIndex2, false )
		return nil
		end
	)
end

---------------------
-- Monika : Concept Damage
--------------------
monika_concept = class({})
modifier_monica_concept = class({})
modifier_monika_concept_ill = class({})

function monika_concept:GetIntrinsicModifierName()
	if not self:GetCaster():IsIllusion() then
		return "modifier_monica_concept"
	end
end


function modifier_monica_concept:OnCreated()
self.caster = self:GetCaster()
self.chance = self:GetAbility():GetSpecialValueFor("chance")
end

function modifier_monica_concept:DeclareFunctions()
return {MODIFIER_EVENT_ON_ATTACK_LANDED}
end

function modifier_monica_concept:OnAttackLanded(t)
	if t.attacker == self:GetParent() then
	if t.attacker:GetHealth() <= 0 then return end
		if self.chance >= RandomInt(1,100) then
		self:CreateIllusion(t)
		end
	
	end
end

function modifier_monica_concept:CreateIllusion(table)
local monika_ill = {}
	for i = 1,3 do
	monika_ill[i] = CreateUnitByName(self:GetCaster():GetUnitName(), table.target:GetAbsOrigin(), true, self:GetCaster(), nil, self:GetCaster():GetTeamNumber())
	FindClearSpaceForUnit(monika_ill[i], table.target:GetAbsOrigin(), true)
	monika_ill[i]:AddNewModifier(self:GetCaster(), self, "modifier_illusion", {})
	monika_ill[i]:AddNewModifier(self:GetCaster(), self, "modifier_phased", {})
	monika_ill[i]:AddNewModifier(self:GetCaster(), self, "modifier_kill", {duration = 3})
	monika_ill[i]:SetRenderColor(255,20,147)
	monika_ill[i]:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_monika_concept_ill", {count = i})
	monika_ill[i].ill_count = i
	self:SetupIllusion(monika_ill[i])
	monika_ill[i]:SetOwner(self:GetCaster())
	monika_ill[i]:MakeIllusion()
	monika_ill[i]:SetForceAttackTarget(table.target)
	end

end

function modifier_monika_concept_ill:OnCreated(keys)
self.caster = self:GetCaster()
self.b_damage = self:GetAbility():GetSpecialValueFor("b_damage")
if self:GetCaster():FindAbilityByName("special_bonus_unique_lone_druid_3"):GetLevel() > 0 then
	self.b_damage = self.b_damage + 150
end
self.ill_count = keys.count
local damage_type = {
DAMAGE_TYPE_MAGICAL,
DAMAGE_TYPE_PURE,
DAMAGE_TYPE_PHYSICAL
}
self.damage_type = damage_type[self.ill_count]	   
end

function modifier_monika_concept_ill:DeclareFunctions()
return {MODIFIER_EVENT_ON_ATTACK_LANDED}
end

function modifier_monika_concept_ill:OnAttackLanded(table)
	if table.attacker == self:GetParent() then
	table.target:SetHealth(table.target:GetHealth() + table.damage)
	ApplyDamage({victim = table.target,
	attacker = self:GetParent(),
	damage = table.damage + self.b_damage,
	damage_type = self.damage_type,})
	self:GetParent():Destroy()
	end

end
function modifier_monica_concept:SetupIllusion(unit)
self.caster = self:GetCaster()
	for i = 0, 5 do
	local item = self.caster:GetItemInSlot(i)
		if item then
			unit:AddItemByName(item:GetName())
		end
	
	end
	for i = 1, 14 do
	local ability = self.caster:GetAbilityByIndex(i)
			if ability then
			local ill_ability = unit:FindAbilityByName(ability:GetName())
			ill_ability:SetLevel(ability:GetLevel()	)
			end
		end
end

function modifier_monica_concept:IsHidden()
return true
end