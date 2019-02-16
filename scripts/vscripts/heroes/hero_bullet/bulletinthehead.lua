Bullet_BulletInTheHead = class({})
LinkLuaModifier("modifier_Bullet_BulletInTheHead_cross", "heroes/hero_bullet/bulletinthehead.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Bullet_BulletInTheHead_ministun", "heroes/hero_bullet/bulletinthehead.lua", LUA_MODIFIER_MOTION_NONE)

function Bullet_BulletInTheHead:GetAbilityTextureName()
	return "Bullet/BulletInTheHead"
end

function Bullet_BulletInTheHead:IsHiddenWhenStolen()
	return false
end

function Bullet_BulletInTheHead:GetBehavior()
	local caster = self:GetCaster()
	local scepter = caster:HasScepter()

	if scepter then
		return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_NORMAL_WHEN_STOLEN + DOTA_ABILITY_BEHAVIOR_AOE
	else
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_NORMAL_WHEN_STOLEN
	end
end

function Bullet_BulletInTheHead:GetCastPoint()
	local cast_point = self.BaseClass.GetCastPoint(self)

	cast_point = cast_point
	return cast_point
end

function Bullet_BulletInTheHead:GetCastAnimation()
	return nil
end

function Bullet_BulletInTheHead:GetAOERadius()
	local caster = self:GetCaster()
	local ability = self
	local scepter = caster:HasScepter()
	local scepter_radius = ability:GetSpecialValueFor("scepter_radius")

	if scepter then
		return scepter_radius
	end

	return 0
end

function Bullet_BulletInTheHead:OnAbilityPhaseStart()
	local caster = self:GetCaster()
	local ability = self
	local cast_response = {"beastmaster_beas_ability_callwild_05", "beastmaster_beas_ability_animalsound_01", "beastmaster_beas_kill_04"}
	local modifier_cross = "modifier_Bullet_BulletInTheHead_cross"
	local scepter = caster:HasScepter()

	local sight_duration = ability:GetSpecialValueFor("sight_duration")
	local scepter_radius = ability:GetSpecialValueFor("scepter_radius")

	caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)

	if not self.enemy_table then
		self.enemy_table = {}
	end

	local targets = {}

	if not scepter then
		targets[1] = self:GetCursorTarget()
	else
		local target_point = self:GetCursorPosition()
		targets = FindUnitsInRadius(caster:GetTeamNumber(),
			target_point,
			nil,
			scepter_radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			FIND_ANY_ORDER,
			false)
	end

	EmitSoundOn(cast_response[math.random(1, #cast_response)], caster)

	for _,target in pairs(targets) do
		target:AddNewModifier(caster, ability, modifier_cross, {duration = sight_duration})

		table.insert(self.enemy_table, target)
	end

	return true
end

function Bullet_BulletInTheHead:OnAbilityPhaseInterrupted()
	local caster = self:GetCaster()
	local ability = self
	local modifier_cross = "modifier_Bullet_BulletInTheHead_cross"

	caster:FadeGesture(ACT_DOTA_CAST_ABILITY_1)
	caster:FadeGesture(ACT_DOTA_CAST_ABILITY_4)

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
		caster:GetAbsOrigin(),
		nil,
		25000,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
		FIND_ANY_ORDER,
		false)

	for _,enemy in pairs(enemies) do
		if enemy:HasModifier(modifier_cross) then
			enemy:RemoveModifierByName(modifier_cross)
		end
	end

	self.enemy_table = nil
end

function Bullet_BulletInTheHead:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self
	local scepter = caster:HasScepter()

	local scepter_radius = ability:GetSpecialValueFor("scepter_radius")
	local projectiles = ability:GetSpecialValueFor("projectiles")

	local targets = {}

	if not scepter then
		targets[1] = self:GetCursorTarget()
	else
		for _,enemy in pairs(self.enemy_table) do
			table.insert(targets, enemy)
		end

		self.enemy_table = nil
	end

	self.enemies_hit = {}

	self.enemy_died = false

	local projectiles_fired = 0
	Timers:CreateTimer(function()
		projectiles_fired = projectiles_fired + 1

		self:FireAssassinateProjectile(targets, projectiles_fired)

		if projectiles_fired < projectiles then
			local refire_delay = caster:FindTalentValue("special_bonus_unique_sniper_42", "refire_delay")
			return refire_delay
		end
	end)
end

function Bullet_BulletInTheHead:FireAssassinateProjectile(targets, projectile_num)
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self
		local particle_projectile = "particles/units/heroes/hero_sniper/sniper_assassinate.vpcf"
		local sound_assassinate = "Ability.Assassinate"
		local sound_assassinate_launch = "Hero_Sniper.AssassinateProjectile"

		EmitSoundOn(sound_assassinate, caster)

		EmitSoundOn(sound_assassinate_launch, caster)

		local travel_speed = ability:GetSpecialValueFor("travel_speed")

		for _,target in pairs(targets) do
			target.primary_assassination_target = true

			local assassinate_projectile
			assassinate_projectile = {Target = target,
				Source = caster,
				Ability = ability,
				EffectName = particle_projectile,
				iMoveSpeed = travel_speed,
				bDodgeable = true,
				bVisibleToEnemies = true,
				bReplaceExisting = false,
				bProvidesVision = false,
				ExtraData = {projectile_num = projectile_num}
			}

			ProjectileManager:CreateTrackingProjectile(assassinate_projectile)
		end
	end
end

function Bullet_BulletInTheHead:OnProjectileHit_ExtraData(target, location, extradata)
	if not target then
		return nil
	end

	local caster = self:GetCaster()
	local ability = self
	local almost_kill_responses = {"sniper_snip_ability_fail_02", "sniper_snip_ability_fail_04", "sniper_snip_ability_fail_05", "sniper_snip_ability_fail_06", "sniper_snip_ability_fail_07", "sniper_snip_ability_fail_08"}
	local modifier_cross = "modifier_Bullet_BulletInTheHead_cross"
	local modifier_ministun = "modifier_Bullet_BulletInTheHead_ministun"

	local projectile_num = extradata.projectile_num

	local damage = ability:GetSpecialValueFor("damage")
	local ministun_duration = ability:GetSpecialValueFor("ministun_duration")

	if target:HasModifier(modifier_cross) then
		target:RemoveModifierByName(modifier_cross)
	end

	self:AssassinateHit(target, projectile_num)

	Timers:CreateTimer(0.3, function()
		target.primary_assassination_target = false
	end)

	Timers:CreateTimer(0.1, function()
		if not self.enemy_died then
			local hp_pct = target:GetHealthPercent()
			if hp_pct <= 10 and target:IsAlive() then
				EmitSoundOn(almost_kill_responses[math.random(1, #almost_kill_responses)], caster)
			end
		end
	end)
end

function Bullet_BulletInTheHead:AssassinateHit(target, projectile_num)
	local caster = self:GetCaster()
	local ability = self
	local kill_responses = {"sniper_snip_ability_assass_03", "sniper_snip_ability_assass_04", "sniper_snip_ability_assass_05", "sniper_snip_ability_assass_03", "sniper_snip_kill_03", "sniper_snip_kill_08", "sniper_snip_kill_10", "sniper_snip_kill_13", "sniper_snip_tf2_01", "sniper_snip_tf2_01"}
	local particle_sparks = "particles/units/heroes/hero_sniper/sniper_assassinate_impact_sparks.vpcf"
	local particle_light = "particles/units/heroes/hero_sniper/sniper_assassinate_endpoint.vpcf"
	local particle_stun = "particles/hero/sniper/perfectshot_stun.vpcf"
	local modifier_ministun = "modifier_Bullet_BulletInTheHead_ministun"
	local scepter = caster:HasScepter()

	local damage = ability:GetSpecialValueFor("damage")
	local ministun_duration = ability:GetSpecialValueFor("ministun_duration")

	local target_key = target:entindex()..tostring(projectile_num)

	for _,enemy in pairs(self.enemies_hit) do
		if enemy == target_key then
			return nil
		end
	end

	table.insert(self.enemies_hit, target_key)

	if target.primary_assassination_target then

		if target:GetTeam() ~= caster:GetTeam() then
			if target:TriggerSpellAbsorb(ability) then
				return nil
			end
		end
	else
		local particle_sparks_fx = ParticleManager:CreateParticle(particle_sparks, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(particle_sparks_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(particle_sparks_fx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(particle_sparks_fx)

		local particle_light_fx = ParticleManager:CreateParticle(particle_light, PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(particle_light_fx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(particle_light_fx)
	end

	if not scepter then
		if not target:IsMagicImmune() then
		if target:HasModifier("Modifier_pistoletov_count_dolphin_active") then return end
			local damageTable = {victim = target,
				attacker = caster,
				damage = damage,
				damage_type = DAMAGE_TYPE_PURE,
				ability = ability
			}

			ApplyDamage(damageTable)

			target:AddNewModifier(caster, ability, modifier_ministun, {duration = ministun_duration})
		end
	else
		local hptargetfull = target:GetMaxHealth() / 100 * 50 
		local hptarget = target:GetHealth()

		if  hptarget < hptargetfull then
			if target:HasModifier("Modifier_pistoletov_count_dolphin_active") then return end

			local damageTable = {victim = target,
				attacker = caster,
				damage = 1000000,
				damage_type = DAMAGE_TYPE_PURE,
				ability = ability
			}

			ApplyDamage(damageTable)
			target:AddNewModifier(caster, ability, modifier_ministun, {duration = ministun_duration})

			SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL, target, damage, nil)
		end
		
		if  hptarget > hptargetfull then
			if target:HasModifier("Modifier_pistoletov_count_dolphin_active") then return end

			local damageTable = {victim = target,
				attacker = caster,
				damage = damage,
				damage_type = DAMAGE_TYPE_PURE,
				ability = ability
			}

			ApplyDamage(damageTable)
			target:AddNewModifier(caster, ability, modifier_ministun, {duration = ministun_duration})
		end
	end

		local knockbackProperties =
			{
				center_x = caster:GetAbsOrigin().x,
				center_y = caster:GetAbsOrigin().y,
				center_z = caster:GetAbsOrigin().z,
				duration = 0.2,
				knockback_duration = 0.2,
				knockback_distance = 350,
				knockback_height = 0
			}
	if not target:HasModifier("Modifier_pistoletov_count_dolphin_active") then
		target:RemoveModifierByName("modifier_knockback")
		target:AddNewModifier(target, nil, "modifier_knockback", knockbackProperties)
	end

	Timers:CreateTimer(FrameTime(), function()
		if not target:IsAlive() and not self.enemy_died then
			self.enemy_died = true

			if RollPercentage(50) then
				EmitSoundOn(kill_responses[math.random(1, #kill_responses)], caster)
			end
		end
	end)
end

function Bullet_BulletInTheHead:OnProjectileThink_ExtraData(location, extradata)
	local caster = self:GetCaster()
	local ability = self

	local projectile_num = extradata.projectile_num

	local bullet_radius = ability:GetSpecialValueFor("bullet_radius")

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
		location,
		nil,
		bullet_radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_ANY_ORDER,
		false)

	for _,enemy in pairs(enemies) do
		if not enemy.primary_assassination_target then
			self:AssassinateHit(enemy, projectile_num)
		end
	end
end

function Bullet_BulletInTheHead:GetCastRange()
	return self:GetSpecialValueFor("cast_range")
end

modifier_Bullet_BulletInTheHead_cross = class({})

function modifier_Bullet_BulletInTheHead_cross:OnCreated()
	if IsServer() then
		self.caster = self:GetCaster()
		self.parent = self:GetParent()
		self.particle_cross = "particles/units/heroes/hero_sniper/sniper_crosshair.vpcf"

		if self.parent:IsNeutralUnitType() then
			self.should_share_vision = false
		else
			self.should_share_vision = true
		end

		self.particle_cross_fx = ParticleManager:CreateParticleForTeam(self.particle_cross, PATTACH_OVERHEAD_FOLLOW, self.parent, self.caster:GetTeamNumber())
		ParticleManager:SetParticleControl(self.particle_cross_fx, 0, self.parent:GetAbsOrigin())
		self:AddParticle(self.particle_cross_fx, false, false, -1, false, true)
	end
end

function modifier_Bullet_BulletInTheHead_cross:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_Bullet_BulletInTheHead_cross:IsHidden() return false end
function modifier_Bullet_BulletInTheHead_cross:IsPurgable() return false end
function modifier_Bullet_BulletInTheHead_cross:IsDebuff() return true end

function modifier_Bullet_BulletInTheHead_cross:CheckState()
	local state = nil
	if self:GetParent():HasModifier("modifier_slark_shadow_dance") then
		state = {[MODIFIER_STATE_PROVIDES_VISION] = true}
	end

	if self.should_share_vision then
		state = {[MODIFIER_STATE_PROVIDES_VISION] = true,
			[MODIFIER_STATE_INVISIBLE] = false}
	end

	return state
end

function modifier_Bullet_BulletInTheHead_cross:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

modifier_Bullet_BulletInTheHead_ministun = class({})

function modifier_Bullet_BulletInTheHead_ministun:IsHidden() return false end
function modifier_Bullet_BulletInTheHead_ministun:IsPurgeException() return true end
function modifier_Bullet_BulletInTheHead_ministun:IsStunDebuff() return true end

function modifier_Bullet_BulletInTheHead_ministun:CheckState()
	local state = {[MODIFIER_STATE_STUNNED] = true}
	return state
end

function modifier_Bullet_BulletInTheHead_ministun:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_Bullet_BulletInTheHead_ministun:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end