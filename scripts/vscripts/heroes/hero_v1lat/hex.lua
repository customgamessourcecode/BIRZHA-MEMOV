V1lat_Crab = class({})
LinkLuaModifier("modifier_V1lat_Crab", "heroes/hero_v1lat/hex.lua", LUA_MODIFIER_MOTION_NONE)

function V1lat_Crab:GetAbilityTextureName()
   return "V1lat/Crab"
end

function V1lat_Crab:IsHiddenWhenStolen()
	return false
end

function V1lat_Crab:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget()
	local sound_cast = "V1latRak"
	local particle_hex = "particles/units/heroes/hero_lion/lion_spell_voodoo.vpcf"
	local modifier_hex = "modifier_V1lat_Crab"
	
	if target:TriggerSpellAbsorb(ability) then return end
	target:TriggerSpellReflect(ability)

	local duration = ability:GetSpecialValueFor("duration")    

	EmitSoundOn(sound_cast, target)   

	local particle_hex_fx = ParticleManager:CreateParticle(particle_hex, PATTACH_CUSTOMORIGIN, target)     
	ParticleManager:SetParticleControl(particle_hex_fx, 0, target:GetAbsOrigin())      
	ParticleManager:ReleaseParticleIndex(particle_hex_fx)

	target:AddNewModifier(caster, ability, modifier_hex, {duration = duration})
end

modifier_V1lat_Crab = class({})

function modifier_V1lat_Crab:OnCreated()    
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.sound_cast = "Hero_Lion.Voodoo"
	self.particle_hex = "particles/units/heroes/hero_lion/lion_spell_voodoo.vpcf"
	self.modifier_hex = "modifier_V1lat_Crab"
	self.caster_team = self.caster:GetTeamNumber()

	self.duration = self.ability:GetSpecialValueFor("duration")
	self.bounce_interval = self.ability:GetSpecialValueFor("bounce_interval")
	self.move_speed = self.ability:GetSpecialValueFor("move_speed")
	self.hex_bounce_radius = self.ability:GetSpecialValueFor("hex_bounce_radius")
	self.maximum_hex_enemies = self.ability:GetSpecialValueFor("maximum_hex_enemies")

	self.maximum_hex_enemies = self.maximum_hex_enemies

	if self.parent:IsIllusion() then
		self.parent:Kill(self.ability, self.caster)
		return nil
	end
end

function modifier_V1lat_Crab:OnIntervalThink()
	if IsServer() then
		local hexed_enemies = 0        

		local enemies = FindUnitsInRadius(self.caster_team,
										  self.parent:GetAbsOrigin(),
										  nil,
										  self.hex_bounce_radius,
										  DOTA_UNIT_TARGET_TEAM_ENEMY,
										  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
										  DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
										  FIND_ANY_ORDER,
										  false)

		for _,enemy in pairs(enemies) do
			if self.parent ~= enemy and not enemy:HasModifier(self.modifier_hex) then

				EmitSoundOn(self.sound_cast, enemy)

				if enemy:GetTeam() ~= self.caster_team then
					if enemy:TriggerSpellAbsorb(self.ability) then                        
						return nil
					end
				end     

				self.particle_hex_fx = ParticleManager:CreateParticle(self.particle_hex, PATTACH_CUSTOMORIGIN, enemy)     
				ParticleManager:SetParticleControl(self.particle_hex_fx, 0, enemy:GetAbsOrigin())      
				ParticleManager:ReleaseParticleIndex(self.particle_hex_fx)

				enemy:AddNewModifier(self.caster, self.ability, self.modifier_hex, {duration = self.duration})                
				
				hexed_enemies = hexed_enemies + 1

				if hexed_enemies >= self.maximum_hex_enemies then
					break
				end
			end
		end
	end
end

function modifier_V1lat_Crab:IsHidden() return false end
function modifier_V1lat_Crab:IsPurgable() return true end
function modifier_V1lat_Crab:IsDebuff() return true end

function modifier_V1lat_Crab:CheckState()
	local state
	state = {[MODIFIER_STATE_HEXED] = true,
			 [MODIFIER_STATE_DISARMED] = true,
			 [MODIFIER_STATE_SILENCED] = true,
			 [MODIFIER_STATE_MUTED] = true}			   
	return state
end

function modifier_V1lat_Crab:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MODEL_CHANGE,
					  MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
					  MODIFIER_PROPERTY_MODEL_SCALE}
	return decFuncs
end

function modifier_V1lat_Crab:GetModifierModelChange()
	return "models/items/courier/hermit_crab/hermit_crab_aegis.vmdl"
end

function modifier_V1lat_Crab:GetModifierMoveSpeed_Absolute()
	return self.move_speed
end