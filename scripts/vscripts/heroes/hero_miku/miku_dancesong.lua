function StartSinging( event )
	local caster = event.caster
	local ability = event.ability

	local sub_ability_name = event.sub_ability_name
	local main_ability_name = ability:GetAbilityName()

	caster:SwapAbilities( main_ability_name, sub_ability_name, false, true )

	sub_ability = caster:FindAbilityByName( sub_ability_name )
	local cooldown = sub_ability:GetCooldown( sub_ability:GetLevel() - 1 )

	sub_ability:EndCooldown()
	sub_ability:StartCooldown( cooldown )

	caster:EmitSound( "MikuUltimate" )
end

function CancelSinging( event )
	local caster = event.caster
	
	caster:StopSound( "MikuUltimate" )
end

function EndSinging( event )
	local caster = event.caster
	local ability = event.ability

	local main_ability_name = ability:GetAbilityName()
	local sub_ability_name = event.sub_ability_name

	caster:SwapAbilities( main_ability_name, sub_ability_name, true, false )
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

function Modifier (keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))
	local buff = "modifier_Miku_DanceSong_aura"
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_enchantress_2")
	
	if Talent:GetLevel() == 1 then
		buff = "modifier_Miku_DanceSong_aura_talent"
	end
	
	ability:ApplyDataDrivenModifier( caster, caster, buff, { Duration = duration })
end