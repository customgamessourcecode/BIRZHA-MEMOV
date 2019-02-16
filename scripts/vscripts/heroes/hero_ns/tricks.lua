function Tricks (keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local Chance = RandomInt(1,12)
	
	if target:TriggerSpellAbsorb(ability) then return end
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_rubick_2")
	
	if Talent:GetLevel() == 1 then
		caster = keys.target
	end
	
	if Chance == 1 then
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_ns_disarmed", { Duration = 5 })
	elseif Chance == 2 then
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_ns_silenced", { Duration = 5 })
	elseif Chance == 3 then
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_ns_damage", { Duration = 5 })
	elseif Chance == 4 then
		caster:AddNewModifier( caster, self, "modifier_stunned", { duration = 5 } )	
	elseif Chance == 5 then
		caster:AddNewModifier( caster, self, "modifier_shadow_shaman_voodoo", { duration = 5 } )
	elseif Chance == 6 then
		ability:ApplyDataDrivenModifier( target, target, "modifier_ns_disarmed", { Duration = 5 })
	elseif Chance == 7 then
		ability:ApplyDataDrivenModifier( target, target, "modifier_ns_silenced", { Duration = 5 })
	elseif Chance == 8 then
		ability:ApplyDataDrivenModifier( target, target, "modifier_ns_damage", { Duration = 5 })
	elseif Chance == 9 then
		target:AddNewModifier( target, self, "modifier_stunned", { duration = 5 } )	
	elseif Chance == 10 then
		target:AddNewModifier( target, self, "modifier_shadow_shaman_voodoo", { duration = 5 } )
	elseif Chance == 11 then
		ApplyDamage({victim = caster, attacker = caster, damage = 99999999, damage_type = DAMAGE_TYPE_PURE, ability = ability})
	elseif Chance == 12 then
		ApplyDamage({victim = target, attacker = caster, damage = 99999999, damage_type = DAMAGE_TYPE_PURE, ability = ability})
	end
end

