function UpgradeStats(keys)
	local caster = keys.caster
	local ability = keys.ability
	
	if not ability.currentStacks then
	    ability.currentStacks = 0 
	end

	ability.currentStacks = ability.currentStacks+1

	caster:ModifyStrength(ability:GetSpecialValueFor("str"))
	caster:ModifyAgility(ability:GetSpecialValueFor("agi"))
	caster:ModifyIntellect(ability:GetSpecialValueFor("int"))
	caster:CalculateStatBonus()

	caster:SetModifierStackCount("modifier_bogdan_job", ability, ability.currentStacks)
	
end

function LoseStats(keys)
    local caster = keys.caster
    local ability = keys.ability
	local chance = RandomInt(1, 100)

    if ability.currentStacks > 0 then

		if chance <=50 then
			ability.currentStacks = ability.currentStacks-1

			caster:ModifyStrength(ability:GetSpecialValueFor("str2"))
			caster:ModifyAgility(ability:GetSpecialValueFor("agi2"))
			caster:ModifyIntellect(ability:GetSpecialValueFor("int2"))
			caster:CalculateStatBonus()

			caster:SetModifierStackCount("modifier_bogdan_job", ability, ability.currentStacks)
		end
    end
end

function StatsRespawn(keys)
	local caster = keys.caster
	local ability = keys.ability
	
	if not ability.currentStacks then
	    ability.currentStacks = 0 
	end
	
	ability.currentStacks = ability.currentStacks
	
	caster:SetModifierStackCount("modifier_bogdan_job", ability, ability.currentStacks)
end
