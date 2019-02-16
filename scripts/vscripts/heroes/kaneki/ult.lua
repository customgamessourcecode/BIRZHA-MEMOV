LinkLuaModifier( "modifier_kaneki_rage", "heroes/kaneki/ult", LUA_MODIFIER_MOTION_NONE )

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
self.armor = 1
self.radius = self.ability:GetSpecialValueFor("radius")
self.damage = self.ability:GetSpecialValueFor("damage")
self:StartIntervalThink(0.1)
end

function modifier_kaneki_rage:OnIntervalThink()
local prhp = 100 - ( self.caster:GetHealth() / self.caster:GetMaxHealth() * 100 )
self:SetStackCount(prhp)
end

function modifier_kaneki_rage:DeclareFunctions()
return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, MODIFIER_EVENT_ON_ATTACK_START }
end

function modifier_kaneki_rage:GetModifierPhysicalArmorBonus()
local Talent = self.caster:FindAbilityByName("kaneki_rage")
if Talent:GetLevel() == 1 then
	return 5555
end
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
local units = FindUnitsInRadius( self:GetCaster():GetTeam(), self.caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
for _,ent in pairs (units) do
ApplyDamage({attacker = kaneki, victim = ent, damage = self.damage, damage_type = DAMAGE_TYPE_PURE})
end
end

end

function modifier_kaneki_rage:OnDestroy()
	self:GetCaster():StopSound("kanekiunravel")
end