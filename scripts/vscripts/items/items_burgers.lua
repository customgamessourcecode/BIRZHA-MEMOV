function AddStat(keys)
	local caster = keys.caster
	if not caster:IsHero() then
		return
	end
	local ability = keys.ability
	local str = keys.str
	local agi = keys.agi
	local int = keys.int
	if str then
		caster:ModifyStrength(str)
		caster.Additional_str = (caster.Additional_str or 0) + str
	end
	if agi then
		caster:ModifyAgility(agi)
		caster.Additional_agi = (caster.Additional_agi or 0) + agi
	end
	if int then
		caster:ModifyIntellect(int)
		caster.Additional_int = (caster.Additional_int or 0) + int
	end
end