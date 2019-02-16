function TrahTibidohstack (keys)
	local caster = keys.caster	
	local ability = keys.ability
	local persentage = ability:GetLevelSpecialValueFor( "healpersentage", ( ability:GetLevel() - 1 ) )
	local healbasic = ability:GetLevelSpecialValueFor( "heal", ( ability:GetLevel() - 1 ) )
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_ursa_2")
	
	if Talent:GetLevel() == 1 then
		persentage = persentage + 10
	end
	
	local heal = caster:GetMaxHealth() / 100 * persentage
	local fullheal = healbasic + heal
	
	if not ability.currentStacks then
	    ability.currentStacks = 1
	end
	
	if caster:IsIllusion() == false then
		if ability:GetCooldownTimeRemaining() == 0 then
			if caster:HasModifier("modifier_pistoletov_TrahTibidoh_armor") then
				ability.currentStacks = ability.currentStacks+1
				caster:SetModifierStackCount("modifier_pistoletov_TrahTibidoh_armor", ability, ability.currentStacks)
				caster:Heal(fullheal, caster)
				ability:StartCooldown(4)
				caster:EmitSound("PistoletovTrah")
			else
				ability:ApplyDataDrivenModifier( caster, caster, "modifier_pistoletov_TrahTibidoh_armor", {})
				ability.currentStacks = 1
				caster:SetModifierStackCount("modifier_pistoletov_TrahTibidoh_armor", ability, ability.currentStacks)
				caster:Heal(fullheal, caster)
				ability:StartCooldown(4)
				caster:EmitSound("PistoletovTrah")
			end
		end
	end
end

function TrahTibidohremove(keys)
	local ability = keys.ability
	local caster = keys.caster
	
	ability.currentStacks = ability.currentStacks - 1
	caster:SetModifierStackCount("modifier_pistoletov_TrahTibidoh_armor", ability, ability.currentStacks)
	
	if ability.currentStacks <= 0 then
		caster:RemoveModifierByName("modifier_pistoletov_TrahTibidoh_armor")
	end
end

