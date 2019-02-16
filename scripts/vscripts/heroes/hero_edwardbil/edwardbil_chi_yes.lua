EdwardBil_Chi_Yes = EdwardBil_Chi_Yes or class({})
LinkLuaModifier("modifier_EdwardBil_Chi_Yes_passive", "heroes/hero_edwardbil/EdwardBil_Chi_Yes.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_EdwardBil_Chi_Yes_slow", "heroes/hero_edwardbil/EdwardBil_Chi_Yes.lua", LUA_MODIFIER_MOTION_NONE)

function EdwardBil_Chi_Yes:GetAbilityTextureName()
	return "edwardbil/chida"
end

function EdwardBil_Chi_Yes:GetIntrinsicModifierName()
	return "modifier_EdwardBil_Chi_Yes_passive"
end

function EdwardBil_Chi_Yes:OnUpgrade()
	local caster = self:GetCaster()

	caster:RemoveModifierByName("modifier_EdwardBil_Chi_Yes_passive")
	caster:AddNewModifier(caster, self, "modifier_EdwardBil_Chi_Yes_passive", {})
end

modifier_EdwardBil_Chi_Yes_passive = modifier_EdwardBil_Chi_Yes_passive or class ({})

function modifier_EdwardBil_Chi_Yes_passive:OnCreated()
	self.proc_sound_hero = "Hero_Pangolier.HeartPiercer.Proc"
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	self.damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	if self:GetCaster():HasTalent("special_bonus_unique_bloodseeker_3") then
		self.damage = self.damage + 30
	end
end

function modifier_EdwardBil_Chi_Yes_passive:DeclareFunctions()
	local declfuncs = {MODIFIER_EVENT_ON_ATTACK_LANDED}

	return declfuncs
end

function modifier_EdwardBil_Chi_Yes_passive:IsHidden()
	return true
end

function modifier_EdwardBil_Chi_Yes_passive:OnAttackLanded(kv)
	if IsServer() then
		local attacker = kv.attacker
		local target = kv.target
		local chanceproc = self:GetAbility():GetSpecialValueFor("chance")
		local chance = RandomInt(1, 100)
		
		if self:GetCaster():HasTalent("special_bonus_unique_abaddon_2") then
			chanceproc = chanceproc + 5
		end

		if self:GetParent() == attacker then
			if target:IsBuilding() then
				return nil
			end

			if self:GetParent():PassivesDisabled() then
				return nil
			end
			
			if target:IsAncient() then
				return nil
			end
			
			if attacker:IsIllusion() then
				return nil
			end

			if chance <= chanceproc then
				target:AddNewModifier( attacker, self, "modifier_EdwardBil_Chi_Yes_slow", {duration = self.duration})
				ApplyDamage({victim = target, attacker = attacker, damage = self.damage, damage_type = DAMAGE_TYPE_PHYSICAL})
				if chance < 10 then
					attacker:EmitSound("edwardchidadouble")
				else
					attacker:EmitSound("edwardchida")
				end
			end
		end
	end
end

modifier_EdwardBil_Chi_Yes_slow = class({})

function modifier_EdwardBil_Chi_Yes_slow:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_EdwardBil_Chi_Yes_slow:GetModifierMoveSpeedBonus_Percentage( params )
	return -100
end

function modifier_EdwardBil_Chi_Yes_slow:GetModifierAttackSpeedBonus_Constant( params )
	return -100
end