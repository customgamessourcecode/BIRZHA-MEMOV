require('timers')

function Megumin_armageddon( keys )
	keys.ability.target_cast_point = keys.target_points[1]

	bvo_megumin_skill_4_refresh( keys.ability, keys.caster )
end

function bvo_megumin_skill_3_cast( keys )
	local caster = keys.caster
	local ability = keys.ability
	local point = ability.target_cast_point
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1 )
	local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1 )
	local multi = ability:GetLevelSpecialValueFor("int_multi", ability:GetLevel() - 1 )
	local target_radius = ability:GetLevelSpecialValueFor("target_radius", ability:GetLevel() - 1 )

	local max_offset = target_radius - radius
	local _x = RandomInt(-max_offset, max_offset)
	local _y = RandomInt(-max_offset, max_offset)

	point = point + Vector(_x, _y, 0)

	local particle = ParticleManager:CreateParticle("particles/booom/megumin/bolt.vpcf", PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 0, point)
	ParticleManager:SetParticleControl(particle, 1, Vector(radius, radius, radius))

	local localUnits = FindUnitsInRadius(caster:GetTeamNumber(),
	            point,
	            nil,
	            radius,
	            DOTA_UNIT_TARGET_TEAM_ENEMY,
	            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	            DOTA_UNIT_TARGET_FLAG_NONE,
	            FIND_ANY_ORDER,
	            false)

	for _,unit in pairs(localUnits) do
		local damageTable = {
			victim = unit,
			attacker = caster,
			damage = damage + caster:GetIntellect() * multi,
			damage_type = DAMAGE_TYPE_MAGICAL,
		}
		ApplyDamage(damageTable)
	end

	local dummy = CreateUnitByName("npc_dota_thinker", point, false, nil, nil, caster:GetTeam())
	dummy:AddAbility("dota_ability_dummy_megumin")
	local abl = dummy:FindAbilityByName("dota_ability_dummy_megumin")
	if abl ~= nil then abl:SetLevel(1) end
	dummy:EmitSound("Hero_Invoker.SunStrike.Ignite.Apex")
	Timers:CreateTimer(3.0, function ()
		dummy:RemoveSelf()
	end)
end

function Armageddon_interval( keys )
	local caster = keys.caster
	local ability = keys.ability
	local blasts = ability:GetLevelSpecialValueFor("blasts", ability:GetLevel() - 1 )
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_templar_assassin_2")
	if Talent:GetLevel() == 1 then
		blasts = blasts + 6
	end

	local intervals = 4 / blasts

	Timers:CreateTimer(intervals + 0.1, function ()
		if not caster:HasModifier("modifier_megumin_Armageddon") then return nil end

		bvo_megumin_skill_3_cast( keys )

		return intervals
	end)
end

function bvo_megumin_skill_4_refresh( ability, caster )
	if caster:HasModifier("bvo_megumin_skill_4_modifier") then
		caster:RemoveModifierByName("bvo_megumin_skill_4_modifier")
		ability:EndCooldown()
	end
end