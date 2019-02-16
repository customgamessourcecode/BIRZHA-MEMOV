function NeverStupid( keys )
	local ability = keys.ability
	local caster = keys.caster
	local agility = caster:GetAgility()
	local target = keys.target
	local summon_damage = ability:GetLevelSpecialValueFor("illusion_damage", (ability:GetLevel() -1))
	local extra_damage = ability:GetLevelSpecialValueFor("mana_pool_damage_pct", (ability:GetLevel() -1)) / 100

	

	local damage_table = {}

	damage_table.attacker = caster
	damage_table.damage_type = ability:GetAbilityDamageType()
	damage_table.ability = ability
	damage_table.victim = target


	if not target:IsRealHero() or target:IsSummoned() then
		damage_table.damage = agility * extra_damage + summon_damage
	else
		damage_table.damage = agility * extra_damage
	end 

	ApplyDamage(damage_table)
end

function AddStacks(keys)
	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	local int_steal_modifier = "modifier_steal_caster"
	local int_steal_modifier_target = "modifier_steal_target"
	local int_steal = ability:GetLevelSpecialValueFor("int_gain", (ability:GetLevel() -1))
	local duration = ability:GetLevelSpecialValueFor("steal_duration", (ability:GetLevel() -1))
	
	if(caster:HasModifier(int_steal_modifier)) then
		local stacks = caster:GetModifierStackCount( int_steal_modifier, ability )
		
		ability:ApplyDataDrivenModifier(caster, caster, int_steal_modifier, {Duration = duration})
		caster:SetModifierStackCount( int_steal_modifier, ability, stacks + int_steal )
		ability:ApplyDataDrivenModifier(caster, target, int_steal_modifier_target, {Duration = duration})
		target:SetModifierStackCount( int_steal_modifier_target, ability, stacks + int_steal )
	else
		ability:ApplyDataDrivenModifier(caster, caster, int_steal_modifier, {Duration = duration})
		caster:SetModifierStackCount( int_steal_modifier, ability, int_steal )
		ability:ApplyDataDrivenModifier(caster, target, int_steal_modifier_target, {Duration = duration})
		target:SetModifierStackCount( int_steal_modifier_target, ability, int_steal )
	end
end

function RemoveStacks(keys)
	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	local int_steal_modifier = "modifier_steal_caster"
	local int_steal_modifier_target = "modifier_steal_target"
	local duration = ability:GetLevelSpecialValueFor("steal_duration", (ability:GetLevel() -1))
	local levels_since_start = 0
	local game_time = GameRules:GetGameTime()
	
	if ability.level_four_time ~= null then
		if ability.level_four_time > game_time - duration then
			levels_since_start = levels_since_start + 1
		end
	end
	if ability.level_three_time ~= null then
		if ability.level_three_time > game_time - duration then
			levels_since_start = levels_since_start + 1
		end
	end
	if ability.level_two_time ~= null then
		if ability.level_two_time > game_time - duration then
			levels_since_start = levels_since_start + 1
		end
	end
	
	local int_steal = ability:GetLevelSpecialValueFor("int_gain", (ability:GetLevel() - levels_since_start -1))
	
	local stacks = caster:GetModifierStackCount( int_steal_modifier, ability )
	caster:SetModifierStackCount( int_steal_modifier, ability, stacks - int_steal )
	target:SetModifierStackCount( int_steal_modifier_target, ability, stacks - int_steal )
end

function LevelTime(keys)
	local ability = keys.ability
	
	if ability:GetLevel() == 2 then
		ability.level_two_time = GameRules:GetGameTime()
	elseif ability:GetLevel() == 3 then
		ability.level_three_time = GameRules:GetGameTime()
	elseif ability:GetLevel() == 4 then
		ability.level_four_time = GameRules:GetGameTime()
	end
end