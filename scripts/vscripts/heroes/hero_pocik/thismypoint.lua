function ThisMyPointModifier( keys )
	local caster = keys.caster
	local target = keys.target
	local targetLoc = keys.target:GetAbsOrigin()
	local x_marks_return_name = "ThisMyPoint_return"
	
	caster.x_marks_target = target
	caster.x_marks_origin = targetLoc
	
	caster:SwapAbilities( keys.ability:GetAbilityName(), x_marks_return_name, false, true )
end

function ThisMyPoint_return_kek( keys )
	local caster = keys.caster
	local modifierName = "modifier_ThisMyPoint_debuff"
	caster.x_marks_target:RemoveModifierByName( modifierName )
end

function ThisMyPoint_return( keys )
	local caster = keys.caster
	local x_marks = "Pocik_ThisMyPoint"
	local x_marks_return = "ThisMyPoint_return"
	local modifierName = "modifier_ThisMyPoint_debuff"
	
	if caster.x_marks_target ~= nil and caster.x_marks_origin ~= nil then
		FindClearSpaceForUnit( caster.x_marks_target, caster.x_marks_origin, true )
		caster.x_marks_target = nil
		caster.x_marks_origin = nil
	end
	
	caster:SwapAbilities( x_marks, x_marks_return, true, false )
	ThisMyPoint_cooldown( keys )
end

function ThisMyPoint_cooldown( keys )
  -- Name of both abilities
	local x_marks = "Pocik_ThisMyPoint"
	local x_marks_return = "ThisMyPoint_return"

  -- Loop to reset cooldown
	for i = 0, keys.caster:GetAbilityCount() - 1 do
		local currentAbility = keys.caster:GetAbilityByIndex( i )
		if currentAbility ~= nil and ( currentAbility:GetAbilityName() == x_marks or currentAbility:GetAbilityName() == x_marks_return ) then
			currentAbility:EndCooldown()
			currentAbility:StartCooldown( currentAbility:GetCooldown( currentAbility:GetLevel() - 1 ) )
		end
	end
end

function LevelUpAbility( event )
	local caster = event.caster
	local this_ability = event.ability		
	local this_abilityName = this_ability:GetAbilityName()
	local this_abilityLevel = this_ability:GetLevel()

	local ability_name = event.ability_name
	local ability_handle = caster:FindAbilityByName(ability_name)	
	local ability_level = ability_handle:GetLevel()

	if ability_level ~= this_abilityLevel then
		ability_handle:SetLevel(this_abilityLevel)
	end
end