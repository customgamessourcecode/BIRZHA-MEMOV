function Wry( keys )
	local caster = keys.caster
	local target = keys.target
	
	
	local targets = FindUnitsInRadius(caster:GetTeamNumber(),
	caster:GetAbsOrigin(),
	nil,
	600,
	DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO,
	DOTA_UNIT_TARGET_FLAG_NONE,
	FIND_ANY_ORDER,
	false)
	
	for _,unit in pairs(targets) do
	
		local current_mana = unit:GetMana()
		local current_int = unit:GetIntellect()
		local multiplier = keys.ability:GetLevelSpecialValueFor( "float_multiplier", keys.ability:GetLevel() - 1 )
		local basicdamage = keys.ability:GetLevelSpecialValueFor( "damage", keys.ability:GetLevel() - 1 )
		local number_particle_name = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn_msg.vpcf"
		local burn_particle_name = "particles/dio/dio_wry_debuff.vpcf"
		local damageType = keys.ability:GetAbilityDamageType()
		local Talent = caster:FindAbilityByName("special_bonus_unique_faceless_void")
		
		if unit:TriggerSpellAbsorb(keys.ability) then return end
		
		if Talent:GetLevel() == 1 then
			multiplier = multiplier + 1
		end
		
		local mana_to_burn = math.min( current_mana, current_int * multiplier )
		local life_time = 2.0
		local digits = string.len( math.floor( mana_to_burn ) ) + 1
	
		if unit:IsMagicImmune() then
			mana_to_burn = 0
		end
		
		unit:ReduceMana( mana_to_burn )
		local damageTable = {
			victim = unit,
			attacker = caster,
			damage = mana_to_burn + basicdamage,
			damage_type = damageType
		}
		ApplyDamage( damageTable )
		local numberIndex = ParticleManager:CreateParticle( number_particle_name, PATTACH_OVERHEAD_FOLLOW, unit )
		ParticleManager:SetParticleControl( numberIndex, 1, Vector( 1, mana_to_burn, 0 ) )
		ParticleManager:SetParticleControl( numberIndex, 2, Vector( life_time, digits, 0 ) )
		local burnIndex = ParticleManager:CreateParticle( burn_particle_name, PATTACH_ABSORIGIN, unit )
	end
	
	Timers:CreateTimer( life_time, function()
			ParticleManager:DestroyParticle( numberIndex, false )
			ParticleManager:DestroyParticle( burnIndex, false)
			return nil
		end
	)
end