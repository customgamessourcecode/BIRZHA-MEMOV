function HateModifier(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local duration = ability:GetLevelSpecialValueFor( "duration" , ability:GetLevel() - 1  )
	
	local Talent = caster:FindAbilityByName("special_bonus_unique_venomancer_6")
	
	if Talent:GetLevel() == 1 then
		duration = duration + 1
	end
	
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_face_hate_buff", {duration = duration })
	ability:ApplyDataDrivenModifier(caster, target, "modifier_face_hate_debuff", {duration = duration })
end

function Hate( keys )
	local caster = keys.caster
	local target = keys.target

	target:SetForceAttackTarget(nil)

	if caster:IsAlive() then
		local order =
		{
			UnitIndex = target:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = caster:entindex()
		}

		ExecuteOrderFromTable(order)
	else
		target:SetForceAttackTarget(nil)
	end

	target:SetForceAttackTarget(caster)

end

function Hate_end( keys )
	local target = keys.target

	target:SetForceAttackTarget(nil)
end

function heal( event )

	local damage = event.DamageTaken
	local caster = event.caster
	local ability = event.ability
	
	caster:Heal(damage*2, caster)
end