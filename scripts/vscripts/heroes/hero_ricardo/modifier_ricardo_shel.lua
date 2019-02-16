modifier_Ricardo_shel = class({})

--------------------------------------------------------------------------------

function modifier_Ricardo_shel:IsPurgable()
	return false;
end

--------------------------------------------------------------------------------

function modifier_Ricardo_shel:IsHidden()
	return true;
end

--------------------------------------------------------------------------------

function modifier_Ricardo_shel:OnCreated( kv )
	self.radius = 450
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
end

--------------------------------------------------------------------------------

function modifier_Ricardo_shel:OnRefresh( kv )
	self.radius = 450
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
end

--------------------------------------------------------------------------------

function modifier_Ricardo_shel:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,

	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_Ricardo_shel:OnAbilityExecuted( params )
	if IsServer() then
		local hAbility = params.ability
		if hAbility == nil or not ( hAbility:GetCaster() == self:GetParent() ) then
			return 0
		end

		if hAbility:IsToggle() or hAbility:IsItem() then
			return 0
		end

		local damage = self.damage
		local hTalent = self:GetParent():FindAbilityByName( "special_bonus_unique_enigma_2" )
		if hTalent and hTalent:GetLevel() > 0 then
			damage = damage + 20
		end
		
		local duration = self.duration
		local hTalent2 = self:GetParent():FindAbilityByName( "special_bonus_unique_enigma_3" )
		if hTalent2 and hTalent2:GetLevel() > 0 then
			duration = duration + 0.5
		end

		local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, 0, false )
		if #enemies > 0 then
			for _,enemy in pairs( enemies ) do
				ability_kokos = self:GetParent():FindAbilityByName("Ricardo_KokosMaslo")
				if ability_kokos ~= nil then
					self.damagekokos = ability_kokos:GetSpecialValueFor("bonus_damage")
				end

				enemy:AddNewModifier( self:GetParent(), self, "modifier_stunned", {duration = duration})
				ApplyDamage({victim = enemy, attacker = self:GetParent(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
				enemy:EmitSound("Hero_Batrider.Projection")
				print(duration)
				print(damage)
				if enemy:HasModifier("modifier_Ricardo_KokosMaslo_debuff") then
					local modif = enemy:FindModifierByName("modifier_Ricardo_KokosMaslo_debuff")
					local fulldamagekokos = modif:GetStackCount() * self.damagekokos
					ApplyDamage({victim = enemy, attacker = self:GetParent(), damage = fulldamagekokos, damage_type = DAMAGE_TYPE_MAGICAL, ability = self})
				end
			end
		end
	end

	return 0
end