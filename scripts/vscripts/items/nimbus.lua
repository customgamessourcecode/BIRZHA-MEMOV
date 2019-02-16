function NimbusInit( keys )
	keys.caster.carapaced_units = {}
	local caster = keys.caster
	local RemovePositiveBuffs = false
	local RemoveDebuffs = true
	local BuffsCreatedThisFrameOnly = false
	local RemoveStuns = true
	local RemoveExceptions = false
	caster:Purge( RemovePositiveBuffs, RemoveDebuffs, BuffsCreatedThisFrameOnly, RemoveStuns, RemoveExceptions)
end

function NimbusAttack( keys )
	local caster = keys.caster
	local attacker = keys.attacker
	local damageTaken = keys.DamageTaken
	
	if not caster.carapaced_units[ attacker:entindex() ] then
	if attacker:GetHealth() - damageTaken <= 0 then	
		ApplyDamage({victim = attacker, attacker = caster, damage = 99999, damage_type = DAMAGE_TYPE_PURE, ability = ability})
	else
		attacker:SetHealth( attacker:GetHealth() - damageTaken )
	end
		keys.ability:ApplyDataDrivenModifier( caster, attacker, "modifier_nimbus_debuff", { duration = 3 } )
		keys.ability:ApplyDataDrivenModifier( caster, caster, "modifier_nimbus_check", { } )
		caster:RemoveModifierByName("modifier_nimbus_buff")
		caster:SetHealth( caster:GetHealth() + damageTaken )
		caster.carapaced_units[ attacker:entindex() ] = attacker
	end
end

function NimbusRemove( keys )
	local caster = keys.caster
	local attacker = keys.attacker
	
	if caster:HasModifier("modifier_nimbus_check") == false then
		keys.ability:ApplyDataDrivenModifier( caster, caster, "modifier_nimbus_debuff", { duration = 0.5 } )
		caster:RemoveModifierByName("modifier_nimbus_check")
	end
end