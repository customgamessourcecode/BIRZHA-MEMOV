function ApplyModifier(keys)
	local caster = keys.caster
	local ability = keys.ability
	local stacks = ability:GetLevelSpecialValueFor( "max_attacks", ability:GetLevel() - 1 )
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_sniper_3")
	
	if Talent:GetLevel() == 1 then
		stacks = stacks + 3
	end
	
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_Ranger_ShotGun_buff", {})
	caster:SetModifierStackCount("modifier_Ranger_ShotGun_buff", ability, stacks)
end

function DealDamage(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = caster:GetAttackDamage()
	
	if target ~= ability.main_target then
		ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = ability:GetAbilityDamageType()})
	end
end

function GetMainTarget(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local stacks = caster:GetModifierStackCount("modifier_Ranger_ShotGun_buff", ability)
	
	if stacks == 1 then
		caster:RemoveModifierByName("modifier_Ranger_ShotGun_buff")
	else
		caster:SetModifierStackCount("modifier_Ranger_ShotGun_buff", ability, stacks - 1)
	end
	ability.main_target = target
end