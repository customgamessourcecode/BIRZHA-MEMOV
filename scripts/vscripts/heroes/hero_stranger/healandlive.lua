function HealAndLive(keys)
	local caster = keys.caster
	local ability = keys.ability
	local caster_hp = caster:GetHealth() / caster:GetMaxHealth()
	local min_hp = 40 / 100
	local dur = 5
	
	if caster_hp <= min_hp and ability:GetCooldownTimeRemaining() == 0 then
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_Stranger_HealAndLive_buff", { duration = dur})
		ability:StartCooldown(24)
	else
		return nil
	end
end