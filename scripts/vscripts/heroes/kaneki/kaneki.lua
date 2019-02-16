
LinkLuaModifier( "modifier_kaneki_ghoul", "heroes/kaneki/kaneki", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_kaneki_ghoul_stacks", "heroes/kaneki/kaneki", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_cup_buff", "heroes/kaneki/kaneki", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_kaneki_feeling_debuff", "heroes/kaneki/kaneki", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_kaneki_feeling", "heroes/kaneki/kaneki", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_kaneki_feeling_v", "heroes/kaneki/kaneki", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_kaneki_rage", "heroes/kaneki/kaneki", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_kaneki_ghoul_slow", "heroes/kaneki/kaneki", LUA_MODIFIER_MOTION_NONE )
---------
-- Kaneki : Ghoul  Creator UBLUEWOLF
---------
kaneki_ghoul = class({})
modifier_kaneki_ghoul = class({})
modifier_kaneki_ghoul_stacks = class({})

function modifier_kaneki_ghoul:IsHidden()
return true
end

function kaneki_ghoul:GetIntrinsicModifierName()
if not self:GetCaster():IsIllusion() then
return "modifier_kaneki_ghoul"
end
end

function modifier_kaneki_ghoul:OnCreated()
self.caster = self:GetCaster()
self:StartIntervalThink(0.1)
end

function modifier_kaneki_ghoul:OnIntervalThink()
	if self:GetAbility():IsCooldownReady() and not self.caster:HasModifier("modifier_kaneki_ghoul_stacks") then
	self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_kaneki_ghoul_stacks", {})
	end
end

function modifier_kaneki_ghoul_stacks:OnCreated()
self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.heal = self.ability:GetSpecialValueFor("heal")
self.cd = self.ability:GetCooldown(self.ability:GetLevel())
self.maxstack = self.ability:GetSpecialValueFor("max_stack")
self.bsdamage = self.ability:GetSpecialValueFor("damage_ps")
self.bsattack = self.ability:GetSpecialValueFor("attackspeed_ps")
self.bshp = self.ability:GetSpecialValueFor("hp_ps")
end

function modifier_kaneki_ghoul_stacks:DeclareFunctions()
return {
MODIFIER_EVENT_ON_ATTACK_LANDED,
MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
}
end

function modifier_kaneki_ghoul_stacks:OnAttackLanded(info)
local kaneki = info.attacker
local target = info.target
local heal = target:GetHealth() / 100 * self.heal
if kaneki == self:GetCaster() then
if kaneki:PassivesDisabled() then
return
end
self:SetDuration(10, true)
self:SetStackCount(self:GetStackCount() + 1)
if self:GetStackCount() > self.maxstack then
self.ability:StartCooldown(self.cd)
self:Destroy()
return
end
kaneki:Heal(heal, kaneki)
target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_kaneki_ghoul_slow", { duration = 1})
local nCasterFX = ParticleManager:CreateParticle( "particles/econ/items/ogre_magi/ogre_ti8_immortal_weapon/ogre_ti8_immortal_bloodlust_buff_ground.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
ParticleManager:SetParticleControlEnt( nCasterFX, 1, target, PATTACH_ABSORIGIN_FOLLOW, nil, target:GetOrigin(), false )
ParticleManager:ReleaseParticleIndex( nCasterFX )

end


end


function modifier_kaneki_ghoul_stacks:GetModifierPreAttack_BonusDamage()
	return self.bsdamage * self:GetStackCount()
end

function modifier_kaneki_ghoul_stacks:GetModifierAttackSpeedBonus_Constant()
return self.bsattack * self:GetStackCount()
end

modifier_kaneki_ghoul_slow = class({})

function modifier_kaneki_ghoul_slow:OnCreated()
self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.resist = self.ability:GetSpecialValueFor("mg_resist")
end


function modifier_kaneki_ghoul_slow:DeclareFunctions()
return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

function modifier_kaneki_ghoul_slow:GetModifierMoveSpeedBonus_Percentage()
return -32
end

function modifier_kaneki_ghoul_slow:GetModifierAttackSpeedBonus_Constant()
return -64
end

function modifier_kaneki_ghoul_slow:GetEffectName()
return "particles/units/heroes/hero_visage/visage_grave_chill_tgt.vpcf"
end


-----------
-- Kaneki : Coffee
-----------
kaneki_coffee = class({})
modifier_cup_buff = class({})
function kaneki_coffee:GetChannelAnimation()
return 
end

function kaneki_coffee:OnSpellStart()
self:GetCaster():EmitSound("kanekidrink")
end

function kaneki_coffee:OnChannelFinish(fin)
if fin == true then self:GetCaster():StopSound("kaneki_drink") return end
self.caster = self:GetCaster()
self.radius = 1000
self.damage = self:GetSpecialValueFor("damage")
self.stun = self:GetSpecialValueFor("stun")
self.duration = self:GetSpecialValueFor("buff_duration")
self.caster:AddNewModifier(self.caster, self, "modifier_cup_buff", {duration = self.duration})
local Talent = self:GetCaster():FindAbilityByName("special_bonus_unique_bloodseeker")
local Talent2 = self:GetCaster():FindAbilityByName("special_bonus_unique_bloodseeker_2")
if Talent:GetLevel() == 1 then
	self.damage = self.damage + 150
end
if Talent2:GetLevel() == 1 then
	self.stun = self.stun + 1
end
local units = FindUnitsInRadius( self:GetCaster():GetTeam(), self.caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )

for _,ent in pairs (units) do
local info = {
EffectName = "particles/kaneki_cup2.vpcf",
Dodgeable = true,
Ability = self,
ProvidesVision = true,
VisionRadius = 600,
bVisibleToEnemies = true,
iMoveSpeed = 1000,
Source = self.caster,
iVisionTeamNumber = self.caster:GetTeamNumber(),
Target = ent,
bReplaceExisting = false,
}
local cup = ProjectileManager:CreateTrackingProjectile(info)
return
end
end

function kaneki_coffee:OnProjectileHit(target,_)
if target ~= nil and target:IsAlive() then
target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = self.stun})
ApplyDamage({attacker = self.caster, victim = target, ability = self, damage = self.damage, damage_type = DAMAGE_TYPE_PURE})
end
end


function modifier_cup_buff:OnCreated()
self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.resist = self.ability:GetSpecialValueFor("mg_resist")
end


function modifier_cup_buff:DeclareFunctions()
return {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,}
end

function modifier_cup_buff:GetModifierMagicalResistanceBonus()
return self.resist
end

function modifier_cup_buff:GetEffectName()
return "particles/kaneki/cup_buff.vpcf"
end

---------
-- Kaneki : Blood Feeling
---------

kaneki_feeling = class({})
modifier_kaneki_feeling = class({})
modifier_kaneki_feeling_debuff = class({})
modifier_kaneki_feeling_v = class({})

function kaneki_feeling:GetIntrinsicModifierName()
return "modifier_kaneki_feeling"
end

function kaneki_feeling:OnUpgrade()
	local caster = self:GetCaster()
	caster:RemoveModifierByName("modifier_kaneki_feeling")
	caster:AddNewModifier(caster, self, "modifier_kaneki_feeling", {})
end

function modifier_kaneki_feeling:OnCreated()
self.caster = self:GetCaster()
self.bsspeed = self:GetAbility():GetSpecialValueFor("bs_speed")
self.damage = self:GetAbility():GetSpecialValueFor("bs_damage")
self:StartIntervalThink(0.1)
end

function modifier_kaneki_feeling:DeclareFunctions()
return {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE }
end

function modifier_kaneki_feeling:GetModifierPreAttack_BonusDamage( params )
return self.damage * self:GetStackCount()
end

function modifier_kaneki_feeling:GetModifierMoveSpeedBonus_Constant( params )
return self.bsspeed * self:GetStackCount()
end

function modifier_kaneki_feeling:OnIntervalThink()
local stack = 0
for _,hero in pairs (HeroList:GetAllHeroes()) do
if hero:HasModifier("modifier_kaneki_feeling_v") then
stack = stack + 1
end
end
self:SetStackCount(stack)
end


function modifier_kaneki_feeling:GetAuraRadius()
return 999999
end

function modifier_kaneki_feeling:GetAuraSearchTeam()
return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_kaneki_feeling:GetAuraSearchType()
return DOTA_UNIT_TARGET_HERO
end

function modifier_kaneki_feeling:IsAura()
return true
end

function modifier_kaneki_feeling:GetModifierAura()
return "modifier_kaneki_feeling_debuff"
end

function modifier_kaneki_feeling_debuff:OnCreated()
self.caster = self:GetCaster()
self.target = self:GetParent()
self.hpneed = self:GetAbility():GetSpecialValueFor("hp_need")
self:StartIntervalThink(0.1)
end

function modifier_kaneki_feeling_debuff:IsHidden()
return true
end

function modifier_kaneki_feeling_debuff:OnIntervalThink()
local hp = self.target:GetHealth() / self.target:GetMaxHealth() * 100 <= self.hpneed
if hp and not self.target:HasModifier("modifier_kaneki_feeling_v") then
self.target:AddNewModifier(self.caster, self:GetAbility(), "modifier_kaneki_feeling_v", {})
end
end

function modifier_kaneki_feeling_v:OnCreated()
self.caster = self:GetCaster()
self.target = self:GetParent()
self.hpneed = self:GetAbility():GetSpecialValueFor("hp_need")
self:StartIntervalThink(0.1)
end

function modifier_kaneki_feeling_v:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
	}
	return funcs

end

function modifier_kaneki_feeling_v:OnIntervalThink()
local hp = self.target:GetHealth() / self.target:GetMaxHealth() * 100 <= self.hpneed 
AddFOWViewer(self:GetCaster():GetTeam(), self.target:GetAbsOrigin(), 10, 0.01, false)
if not hp then
self:Destroy()
end
end

function modifier_kaneki_feeling_v:CheckState()
return {[MODIFIER_STATE_INVISIBLE] = false,}
end

function modifier_kaneki_feeling_v:GetEffectName()
return "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf"
end


-----------
-- Kaneki : Rage
-----------

kaneki_rage = class({})
modifier_kaneki_rage = class({})

function kaneki_rage:OnAbilityPhaseStart()
self:GetCaster():EmitSound("kanekiunravel")
return true
end

function kaneki_rage:OnAbilityPhaseInterrupted()
self:GetCaster():StopSound("kanekiunravel")
end

function kaneki_rage:OnSpellStart()
self.duration = self:GetSpecialValueFor("duration")
--particles/econ/items/earthshaker/egteam_set/hero_earthshaker_egset/earthshaker_echoslam_start_innerring_egset.vpcf
local nCasterFX = ParticleManager:CreateParticle( "particles/econ/events/ti4/teleport_end_ground_flash_ti4.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:SetParticleControlEnt( nCasterFX, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), false )
ParticleManager:ReleaseParticleIndex( nCasterFX )
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_kaneki_rage", {duration = self.duration})
end

function modifier_kaneki_rage:OnCreated()
self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.chance = self.ability:GetSpecialValueFor("chance")
self.attackspeed = 10
self.armor = self.ability:GetSpecialValueFor("armor")
self.radius = self.ability:GetSpecialValueFor("radius")
self.damage = self.ability:GetSpecialValueFor("damage")
self:StartIntervalThink(0.1)
end

function modifier_kaneki_rage:IsPurgable()
return false
end

function modifier_kaneki_rage:OnIntervalThink()
local prhp = 100 - ( self.caster:GetHealth() / self.caster:GetMaxHealth() * 100 )
self:SetStackCount(prhp)
end

function modifier_kaneki_rage:DeclareFunctions()
return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, MODIFIER_EVENT_ON_ATTACK_START }
end

function modifier_kaneki_rage:GetModifierPhysicalArmorBonus()
return  self.armor * self:GetStackCount()
end

function modifier_kaneki_rage:GetModifierAttackSpeedBonus_Constant()
return 10 * self:GetStackCount()
end

function modifier_kaneki_rage:OnAttackStart(inf)
if inf.attacker ~= self:GetCaster() then return end
local kaneki = inf.attacker
if RandomInt(1,100) <= self.chance then
kaneki:Stop()
kaneki:StartGesture(ACT_DOTA_CAST_ABILITY_1)
local nCasterFX = ParticleManager:CreateParticle( "particles/kaneki_helix.vpcf", PATTACH_ABSORIGIN_FOLLOW, kaneki )
ParticleManager:SetParticleControlEnt( nCasterFX, 1, kaneki, PATTACH_ABSORIGIN_FOLLOW, nil, kaneki:GetOrigin(), false )
ParticleManager:ReleaseParticleIndex( nCasterFX )
local units = FindUnitsInRadius( self:GetCaster():GetTeam(), self.caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false )
for _,ent in pairs (units) do
ApplyDamage({attacker = kaneki, victim = ent, damage = self.damage, damage_type = DAMAGE_TYPE_PURE})
end
end

end

function modifier_kaneki_rage:OnDestroy()
self:GetCaster():StopSound("kanekiunravel")
end