if Gorin_rabies == nil then Gorin_rabies = class({}) end
LinkLuaModifier( "modifier_Gorin_rabies_primary", "heroes/hero_gorin/Gorin_rabies.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Gorin_rabies_secondary", "heroes/hero_gorin/Gorin_rabies.lua", LUA_MODIFIER_MOTION_NONE )

function Gorin_rabies:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
end

function Gorin_rabies:GetChannelTime()
	if self:GetCaster():FindAbilityByName("special_bonus_unique_troll_warlord_2"):GetLevel() == 1 then
		return self:GetSpecialValueFor("channel_duration_talent")
	else
		return self:GetSpecialValueFor("channel_duration")
	end
end

function Gorin_rabies:GetAOERadius()
	if self:GetCaster():FindAbilityByName("special_bonus_unique_troll_warlord"):GetLevel() == 1 then
		return self:GetSpecialValueFor("area_of_effect_talent")
	else
		return self:GetSpecialValueFor("area_of_effect")
	end
end

function Gorin_rabies:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local origin = caster:GetAbsOrigin()
		local aoe = self:GetSpecialValueFor("area_of_effect")
		local target = self:GetCursorTarget()
		
		if self:GetCaster():FindAbilityByName("special_bonus_unique_troll_warlord"):GetLevel() == 1 then
			aoe = self:GetSpecialValueFor("area_of_effect_talent")
		end

		self.channel_start_time = GameRules:GetGameTime()

		caster:AddNewModifier(caster, self, "modifier_Gorin_rabies_primary", {})
		caster:AddNewModifier(caster, self, "modifier_Gorin_rabies_secondary", {})

		local cast_particle = "particles/units/heroes/hero_riki/riki_tricks_cast.vpcf"
		local tricks_particle = "particles/gorin/gorin_rabits.vpcf"
		local cast_sound = "gorinult"
		local continuos_sound = "Hero_Riki.TricksOfTheTrade"

		EmitSoundOnLocationWithCaster(origin, cast_sound, caster)
		EmitSoundOn(continuos_sound, caster)

		local caster_loc = caster:GetAbsOrigin()

		self.TricksParticle = ParticleManager:CreateParticle(tricks_particle, PATTACH_WORLDORIGIN, caster)
		ParticleManager:CreateParticle(cast_particle, PATTACH_WORLDORIGIN, nil)

		ParticleManager:SetParticleControl(self.TricksParticle, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(self.TricksParticle, 1, Vector(aoe, 0, aoe))
		ParticleManager:SetParticleControl(self.TricksParticle, 2, Vector(aoe, 0, aoe))

		caster:AddNoDraw()
	end
end

function Gorin_rabies:OnChannelThink()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()
	end
end

function Gorin_rabies:OnChannelFinish()
	if IsServer() then
		local caster = self:GetCaster()
		FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
		caster:RemoveModifierByName("modifier_Gorin_rabies_primary")
		caster:RemoveModifierByName("modifier_Gorin_rabies_secondary")

		StopSoundEvent("gorinult", caster)
		ParticleManager:DestroyParticle(self.TricksParticle, false)
		ParticleManager:ReleaseParticleIndex(self.TricksParticle)
		self.TricksParticle = nil

		local target = self:GetCursorTarget()
		caster:RemoveNoDraw()
		local end_particle = "particles/units/heroes/hero_riki/riki_tricks_end.vpcf"
		local particle = ParticleManager:CreateParticle(end_particle, PATTACH_ABSORIGIN, caster)
		ParticleManager:ReleaseParticleIndex(particle)
	end
end

if modifier_Gorin_rabies_primary == nil then modifier_Gorin_rabies_primary = class({}) end
function modifier_Gorin_rabies_primary:IsPurgable() return false end
function modifier_Gorin_rabies_primary:IsDebuff() return false end
function modifier_Gorin_rabies_primary:IsHidden() return false end

function modifier_Gorin_rabies_primary:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_ATTACK_RANGE_BONUS, }
	return funcs
end

function modifier_Gorin_rabies_primary:GetModifierAttackRangeBonus()
	local ability = self:GetAbility()
	local aoe = ability:GetSpecialValueFor("area_of_effect")
	if self:GetCaster():FindAbilityByName("special_bonus_unique_troll_warlord"):GetLevel() == 1 then
		aoe = self:GetSpecialValueFor("area_of_effect_talent")
	end
	return aoe
end

function modifier_Gorin_rabies_primary:CheckState()
	if IsServer() then
		local state

			state = {	[MODIFIER_STATE_INVULNERABLE] = true,
				[MODIFIER_STATE_UNSELECTABLE] = true,
				[MODIFIER_STATE_OUT_OF_GAME] = true,
				[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
				[MODIFIER_STATE_NO_UNIT_COLLISION] = true,}

		return state
	end
end

function modifier_Gorin_rabies_primary:OnCreated()
	if IsServer() then
		local ability = self:GetAbility()
		local interval = ability:GetSpecialValueFor("attack_interval")
		self:StartIntervalThink(interval)
	end
end

function modifier_Gorin_rabies_primary:OnIntervalThink()
	if IsServer() then
		local ability = self:GetAbility()
		local caster = ability:GetCaster()
		local origin = caster:GetAbsOrigin()

		local aoe = ability:GetSpecialValueFor("area_of_effect")
		
		if self:GetCaster():FindAbilityByName("special_bonus_unique_troll_warlord"):GetLevel() == 1 then
			aoe = 1000
		end

		local targets = FindUnitsInRadius(caster:GetTeamNumber(), origin, nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY , DOTA_UNIT_TARGET_HERO , DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER , false)
		for _,unit in pairs(targets) do
			if unit:IsAlive() and not unit:IsAttackImmune() then
				caster:PerformAttack(target, true, true, true, false, false, false, false)
			end
		end
	end
end

if modifier_Gorin_rabies_secondary == nil then modifier_Gorin_rabies_secondary = class({}) end
function modifier_Gorin_rabies_secondary:IsPurgable() return false end
function modifier_Gorin_rabies_secondary:IsDebuff() return false end
function modifier_Gorin_rabies_secondary:IsHidden() return true end

function modifier_Gorin_rabies_secondary:OnCreated()
	if IsServer() then
		local parent = self:GetParent()
		local aps = parent:GetAttacksPerSecond()
		self:StartIntervalThink(1/aps)
	end
end

function modifier_Gorin_rabies_secondary:OnIntervalThink()
	if IsServer() then
		local ability = self:GetAbility()
		local caster = ability:GetCaster()
		local origin = caster:GetAbsOrigin()

		local aoe = ability:GetSpecialValueFor("area_of_effect")
		
		if self:GetCaster():FindAbilityByName("special_bonus_unique_troll_warlord"):GetLevel() == 1 then
			aoe = 1000
		end

		local backstab_ability = caster:FindAbilityByName("imba_riki_cloak_and_dagger")
		local backstab_particle = "particles/units/heroes/hero_riki/riki_backstab.vpcf"
		local backstab_sound = "Hero_Riki.Backstab"

		local targets = FindUnitsInRadius(caster:GetTeamNumber(), origin, nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY , DOTA_UNIT_TARGET_HERO , DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER , false)

		for _,unit in pairs(targets) do
			if unit:IsAlive() and not unit:IsAttackImmune() then
				self:ProcTricks(caster,ability,unit,backstab_ability,backstab_particle,backstab_sound,("duration"))

				local caster = self:GetParent()
				local aps = caster:GetAttacksPerSecond()
				self:StartIntervalThink(1/aps)
				return
			end
		end
	end
end

function modifier_Gorin_rabies_secondary:ProcTricks(caster,ability,target,backstab_ability,backstab_particle,backstab_sound,talent_duration)
	caster:PerformAttack(target, true, true, true, false, false, false, false)
end