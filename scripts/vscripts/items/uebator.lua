function uebatoractive(keys)
	local player = keys.caster:GetPlayerID()
	
	if IsUnlockedInPass(player, "reward35") then
		keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_item_uebator_berserk_donate", nil)
	else
		keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_item_uebator_berserk", nil)
	end
	
	keys.caster:EmitSound("itemrap")
end
