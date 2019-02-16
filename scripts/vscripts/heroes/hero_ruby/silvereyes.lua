function SilverEyesStart( keys )
	local caster = keys.caster

	caster.stone_gaze_table = {}
end

function SilverEyesSlow( keys )
	local caster = keys.caster
	local target = keys.target
	
	local modifier_caster = keys.modifier_caster
	local modifier_target = keys.modifier_target

	if not caster:HasModifier(modifier_caster) then
		target:RemoveModifierByNameAndCaster(modifier_target, caster)
	end
end

function SilverEyes( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	local modifier_slow = keys.modifier_slow
	local modifier_facing = keys.modifier_facing
	local modifier_damage = keys.modifier_damage

	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
	local vision_cone = ability:GetLevelSpecialValueFor("vision_cone", ability_level)

	local caster_location = caster:GetAbsOrigin()
	local target_location = target:GetAbsOrigin()	

	local direction = (caster_location - target_location):Normalized()
	local forward_vector = target:GetForwardVector()
	local angle = math.abs(RotationDelta((VectorToAngles(direction)), VectorToAngles(forward_vector)).y)

	if angle <= vision_cone/2 then
		local check = false
		for _,v in ipairs(caster.stone_gaze_table) do
			if v == target then
				check = true
			end
		end

		if check then
			ability:ApplyDataDrivenModifier(caster, target, modifier_facing, {Duration = 0.06})
		else
			table.insert(caster.stone_gaze_table, target)
			target.stone_gaze_look = 0
			target.stone_gaze_stoned = false

			ability:ApplyDataDrivenModifier(caster, target, modifier_slow, {Duration = duration})
			ability:ApplyDataDrivenModifier(caster, target, modifier_facing, {Duration = 0.06})
		end
	end
end

function SilverEyesFacing( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	local face_duration = ability:GetLevelSpecialValueFor("face_duration", ability_level)
	local stone_duration = ability:GetLevelSpecialValueFor("stone_duration", ability_level)
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local modifier_stone = keys.modifier_stone
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_spectre")
	
	if Talent:GetLevel() == 1 then
		damage = damage + 10
	end

	target.stone_gaze_look = target.stone_gaze_look + 0.03
	ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })

	if target.stone_gaze_look >= face_duration and not target.stone_gaze_stoned then
		ability:ApplyDataDrivenModifier(caster, target, modifier_stone, {Duration = stone_duration})
		target.stone_gaze_stoned = true
	end
end