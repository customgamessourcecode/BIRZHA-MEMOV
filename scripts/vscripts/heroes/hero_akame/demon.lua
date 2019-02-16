function Demon( keys )
	local caster = keys.caster
	local ability = keys.ability
	
	if caster:IsIllusion() == false then
		ability.caster_hp_old = ability.caster_hp_old or caster:GetMaxHealth()
		ability.caster_hp = ability.caster_hp or caster:GetMaxHealth()

		ability.caster_hp_old = ability.caster_hp
		ability.caster_hp = caster:GetHealth()
	end
end

function Demon2( keys )
	local caster = keys.caster
	local ability = keys.ability

	if caster:IsIllusion() == false then
		caster:SetHealth(ability.caster_hp_old)
	end
end