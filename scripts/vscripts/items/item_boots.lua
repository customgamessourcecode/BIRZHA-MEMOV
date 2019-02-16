function HasteBoots( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local player = caster:GetPlayerID()
	local duration = ability:GetLevelSpecialValueFor("phase_duration", ability_level)

	if IsUnlockedInPass(player, "reward1") then
		local haste_pfx = ParticleManager:CreateParticle("particles/birzhapass/abibas_boots_new.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(haste_pfx, 0, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(haste_pfx)
	else
		local haste_pfx = ParticleManager:CreateParticle("particles/abibas/phase_abibas_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(haste_pfx, 0, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(haste_pfx)
	end

	ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_imba_phase_boots_2_move_speed", {})
	EmitSoundOnClient("DOTA_Item.PhaseBoots.Activate", PlayerResource:GetPlayer(caster:GetPlayerID()))
end