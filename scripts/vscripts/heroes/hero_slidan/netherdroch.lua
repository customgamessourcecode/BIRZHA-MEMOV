function NetherDrochPurge( keys )
	local target = keys.target

	local RemovePositiveBuffs = true
	local RemoveDebuffs = false
	local BuffsCreatedThisFrameOnly = false
	local RemoveStuns = false
	local RemoveExceptions = false
	target:Purge( RemovePositiveBuffs, RemoveDebuffs, BuffsCreatedThisFrameOnly, RemoveStuns, RemoveExceptions)
end

function StopSound( keys )
	local target = keys.target
	local sound = keys.sound

	StopSoundEvent(sound, target)
end

function Damage( keys )
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability
	
	local damage = ability:GetSpecialValueFor("per_damage")

	local Talent = caster:FindAbilityByName("special_bonus_unique_doom_2")
	
	if Talent:GetLevel() == 1 then
		damage = damage + 40
	end
	
	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
end


function Talent( keys )
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability
	local Talent = caster:FindAbilityByName("special_bonus_unique_doom_4")
	
	if Talent:GetLevel() == 1 then
		ability:ApplyDataDrivenModifier( caster, target, "modifier_slidan_NetherDroch_check_talent", { Duration = 5 })
	end
end