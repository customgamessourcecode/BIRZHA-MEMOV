function butteractive(keys)
	local player = keys.caster:GetPlayerID()
	
	if IsUnlockedInPass(player, "reward25") then
		keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_bf2_active_donate", nil)
	else
		keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_bf2_active", nil)
	end
	
	keys.caster:EmitSound("DOTA_Item.Butterfly")
end
