function item_baldezh_start(keys)
	local player = keys.caster:GetPlayerID()
	local caster = keys.caster
	local ability = keys.ability
	
	if caster:HasModifier("modifier_baldezh_active") or caster:HasModifier("modifier_baldezh_donate_active") then return end
	
	if IsUnlockedInPass(player, "reward5") then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_baldezh_donate_active", nil)
	else
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_baldezh_active", nil)
	end
	
	caster:EmitSound("bkbitem")
end

function item_baldezh_start2(keys)
	local player = keys.caster:GetPlayerID()
	local caster = keys.caster
	local ability = keys.ability
	
	if caster:HasModifier("modifier_baldezh_active") or caster:HasModifier("modifier_baldezh_donate_active") then return end
	
	if IsUnlockedInPass(player, "reward5") then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_baldezh_donate_active", nil)
	else
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_baldezh_active", nil)
	end
	
	caster:EmitSound("cosmobaldezh")
end

function item_baldezh_start3(keys)
	local player = keys.caster:GetPlayerID()
	local caster = keys.caster
	local ability = keys.ability
	
	if caster:HasModifier("modifier_baldezh_active") or caster:HasModifier("modifier_baldezh_donate_active") then return end
	
	if IsUnlockedInPass(player, "reward5") then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_baldezh_donate_active", nil)
	else
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_baldezh_active", nil)
	end
	
	caster:EmitSound("vapebaldezh")
end

	

	
	