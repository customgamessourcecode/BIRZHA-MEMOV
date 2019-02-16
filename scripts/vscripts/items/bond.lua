function bond(keys)
	local caster = keys.caster
	local manafromintellect = caster:GetIntellect() * 0.5
	local mana = caster:GetMana() + 150 + manafromintellect
	
	caster:SetMana(mana)
end

function vape(keys)
	local caster = keys.caster
	local manafromintellect = caster:GetIntellect() * 1
	local mana = caster:GetMana() + 350 + manafromintellect
	
	caster:SetMana(mana)
end