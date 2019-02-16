function SlavaUkraine( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	if target:GetUnitName() == "npc_dota_uk_sniper_1" or target:GetUnitName() == "npc_dota_uk_sniper_2" or target:GetUnitName() == "npc_dota_uk_sniper_3" then
		ability:ApplyDataDrivenModifier( caster, target, "modifier_Poroshenko_slava_ukraine_sniper", { Duration = 10 })
	end
end