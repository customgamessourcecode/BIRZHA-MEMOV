function Resourcefulness( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifierName = "modifier_Gorin_Resourcefulness_stack"
	local damageType = ability:GetAbilityDamageType()
	
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	local damage_per_stack = ability:GetLevelSpecialValueFor( "damage_per_stack", ability:GetLevel() - 1 )
	
	if target:IsAncient() then
		duration = 0
	end
	
	if caster:IsIllusion() == false then
		if target:HasModifier( modifierName ) then
			local current_stack = target:GetModifierStackCount( modifierName, ability )
			
			local damage_table = {
				victim = target,
				attacker = caster,
				damage = damage_per_stack * current_stack,
				damage_type = damageType
			}
			ApplyDamage( damage_table )
			
			ability:ApplyDataDrivenModifier( caster, target, modifierName, { Duration = duration } )
			target:SetModifierStackCount( modifierName, ability, current_stack + 1 )
		else
			ability:ApplyDataDrivenModifier( caster, target, modifierName, { Duration = duration } )
			target:SetModifierStackCount( modifierName, ability, 1 )
			
			local damage_table = {
				victim = target,
				attacker = caster,
				damage = damage_per_stack,
				damage_type = damageType
			}
			ApplyDamage( damage_table )
		end
	end
end