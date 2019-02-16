LinkLuaModifier( "modifier_vortex_silence_2", "heroes/hero_navat/VortexSilenceNew", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_vortex_silence", "heroes/hero_navat/VortexSilenceNew", LUA_MODIFIER_MOTION_NONE )

Daniil_VortexSilence = class({})
modifier_vortex_silence = class({})
modifier_vortex_silence_2 = class({})		

function Daniil_VortexSilence:OnSpellStart()
	self.caster = self:GetCaster()
	self.target = self:GetCursorTarget()
	if self.target:GetTeamNumber() ~= self.caster:GetTeamNumber() then
		self.target:AddNewModifier(self.caster, self, "modifier_vortex_silence", {duration = self:GetSpecialValueFor("duration")})
	end
	self.target:AddNewModifier(self.caster, self, "modifier_vortex_silence_2", {duration = self:GetSpecialValueFor("duration")})
end

function modifier_vortex_silence:CheckState() 
  local state =
      {
		[MODIFIER_STATE_SILENCED] = true
      }
  return state
end

function modifier_vortex_silence:GetEffectName()
	return "particles/navat/vortexsilence_debuff.vpcf"
end

function modifier_vortex_silence_2:IsHidden()
    return true
end

function modifier_vortex_silence_2:OnCreated()
	self.damage = self:GetAbility():GetSpecialValueFor("damage")
	self.interval = self:GetAbility():GetSpecialValueFor("interval")
	self.luchi = self:GetAbility():GetSpecialValueFor("max_luchi")
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.bounceTable = {}
	self:StartIntervalThink(self.interval)
	
	local Talent = self:GetCaster():FindAbilityByName("special_bonus_unique_zeus_3")

	if Talent:GetLevel() == 1 then
		self.damage = self.damage + 50
	end
end

function modifier_vortex_silence_2:OnIntervalThink()
	
	local units = FindUnitsInRadius( self:GetCaster():GetTeam(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )

	self.target = nil
	for k, unit in pairs(units) do
		if self.bounceTable[unit] == nil or self.bounceTable[unit] then
			self.target = unit
			break
		end
	end
	
	if self.target ~= nil then
		ApplyDamage({victim = self.target, attacker = self:GetCaster(), damage = self.damage, damage_type = DAMAGE_TYPE_PURE,})
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, self.target)
		ParticleManager:SetParticleControl(particle, 0, Vector(self.target:GetAbsOrigin().x, self.target:GetAbsOrigin().y, self.target:GetAbsOrigin().z))
		ParticleManager:SetParticleControl(particle, 1, Vector(self.target:GetAbsOrigin().x, self.target:GetAbsOrigin().y, 2000))
		ParticleManager:SetParticleControl(particle, 2, Vector(self.target:GetAbsOrigin().x, self.target:GetAbsOrigin().y, self.target:GetAbsOrigin().z))
		self.target:EmitSound("Hero_Zuus.LightningBolt")
		self.luchi = self.luchi - 1
		self.bounceTable[self.target] = ((self.bounceTable[self.target] or 0) + 1)
			if self.luchi < 1 then
				self:Destroy()
			end
		return
	end
end