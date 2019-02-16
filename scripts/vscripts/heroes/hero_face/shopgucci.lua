LinkLuaModifier( "modifier_movespeed_cap", "modifiers/modifier_movespeed_cap.lua", LUA_MODIFIER_MOTION_NONE )

function ShopGucciFace( keys )
	local caster = keys.caster
	local model = keys.model
	local ability = keys.ability
	local ability_level = ability:GetLevel()
	
	local duration = 5
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_venomancer_4")
	
	if Talent:GetLevel() == 1 then
		duration = duration + 2
	end

	if caster.caster_model == nil then 
		caster.caster_model = caster:GetModelName()
	end

	caster:SetOriginalModel(model)
end

function ShopGucciEnd( keys )
	local caster = keys.caster

	caster:SetModel(caster.caster_model)
	caster:SetOriginalModel(caster.caster_model)
end

function ShopGucciModifier(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local duration = 5
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_venomancer_4")
	
	if Talent:GetLevel() == 1 then
		duration = duration + 2
	end
	
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_face_ShopGucci", {duration = duration })
end

function ShopGucciDamage(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = ability:GetSpecialValueFor("damage")
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_venomancer_5")
	
	if Talent:GetLevel() == 1 then
		damage = damage + 125
	end
	
	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
end