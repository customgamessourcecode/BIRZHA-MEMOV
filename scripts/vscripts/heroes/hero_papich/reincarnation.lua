Papich_reincarnation = Papich_reincarnation or class({})
LinkLuaModifier("modifier_papich_reincarnation", "heroes/hero_papich/reincarnation.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_papich_reincarnation_wraith_form_buff", "heroes/hero_papich/reincarnation.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_papich_reincarnation_wraith_form", "heroes/hero_papich/reincarnation.lua", LUA_MODIFIER_MOTION_NONE)

function Papich_reincarnation:GetAbilityTextureName()
   return "Papich/Reincarnation"
end

function Papich_reincarnation:GetManaCost(level)
	local caster = self:GetCaster()
	local ability = self    
	local reincarnate_mana_cost = ability:GetSpecialValueFor("reincarnate_mana_cost")

	return reincarnate_mana_cost
end

function Papich_reincarnation:OnAbilityPhaseStart() return false end

function Papich_reincarnation:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_PASSIVE
end

function Papich_reincarnation:GetIntrinsicModifierName()
	return "modifier_papich_reincarnation"
end

function Papich_reincarnation:TheWillOfTheKing( OnDeathKeys, BuffInfo )
	local unit = OnDeathKeys.unit
	local reincarnate = OnDeathKeys.reincarnate
	-- Check if it was a reincarnation death
	if reincarnate and (not BuffInfo.caster:HasModifier("modifier_item_imba_aegis")) then
		BuffInfo.reincarnation_death = true

		-- Use the Reincarnation's ability cooldown
		BuffInfo.ability:UseResources(false, false, true)

		-- Play reincarnate sound
		if BuffInfo.caster == unit then
			local heroes = FindUnitsInRadius(
				BuffInfo.caster:GetTeamNumber(),
				BuffInfo.caster:GetAbsOrigin(),
				nil,
				BuffInfo.slow_radius,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS,
				FIND_ANY_ORDER,
				false
			)

			if USE_MEME_SOUNDS and #heroes >= PlayerResource:GetPlayerCount() * 0.35 then
				BuffInfo.caster:EmitSound(BuffInfo.sound_be_back)
			else
				BuffInfo.caster:EmitSound(BuffInfo.sound_death)
			end
		end

		-- Add particle effects
		local particle_death_fx = ParticleManager:CreateParticle(BuffInfo.particle_death, PATTACH_CUSTOMORIGIN, OnDeathKeys.unit)
		ParticleManager:SetParticleAlwaysSimulate(particle_death_fx)
		ParticleManager:SetParticleControl(particle_death_fx, 0, OnDeathKeys.unit:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_death_fx, 1, Vector(BuffInfo.reincarnate_delay, 0, 0))
		ParticleManager:SetParticleControl(particle_death_fx, 11, Vector(200, 0, 0))
		ParticleManager:ReleaseParticleIndex(particle_death_fx)

		-- Wait for the caster to reincarnate, then play its sound
		--Timers:CreateTimer(BuffInfo.reincarnate_delay, function()
		--    EmitSoundOn(BuffInfo.sound_reincarnation, BuffInfo.caster) 
		--end)                
		
	else                
		BuffInfo.reincarnation_death = false     
	end
end

-- Reicarnation modifier
modifier_papich_reincarnation = modifier_papich_reincarnation or class({})

function modifier_papich_reincarnation:OnCreated()    
		-- Ability properties
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()    
		self.particle_death = "particles/units/heroes/hero_skeletonking/wraith_king_reincarnate.vpcf"
		self.sound_death = "PapichReincarnate"
		self.sound_reincarnation = "Hero_SkeletonKing.Reincarnate.Stinger"
		self.sound_be_back = "Hero_WraithKing.IllBeBack"
		self.modifier_wraith = "modifier_papich_reincarnation_wraith_form"

		-- Ability specials
		self.reincarnate_delay = self.ability:GetSpecialValueFor("reincarnate_delay")
		self.passive_respawn_haste = self.ability:GetSpecialValueFor("passive_respawn_haste")        
		self.slow_radius = self.ability:GetSpecialValueFor("slow_radius")
		self.slow_duration = self.ability:GetSpecialValueFor("slow_duration")
		self.scepter_wraith_form_radius = self.ability:GetSpecialValueFor("scepter_wraith_form_radius")        

	if IsServer() then
		-- Set WK as immortal!
		self.can_die = false

		-- Start interval think
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_papich_reincarnation:IsHidden() 
	if self:GetParent() == self.caster then
		return true
	else
		return false
	end
end
function modifier_papich_reincarnation:IsPurgable() return false end
function modifier_papich_reincarnation:IsDebuff() return false end

function modifier_papich_reincarnation:OnIntervalThink()
	-- If caster has sufficent mana and the ability is ready, apply
	if (self.caster:GetMana() >= self.ability:GetManaCost(-1)) and (self.ability:IsCooldownReady()) then
		self.can_die = false
	else
		self.can_die = true
	end
end

function modifier_papich_reincarnation:OnRefresh()
	self:OnCreated()
end

function modifier_papich_reincarnation:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_REINCARNATION,                      
					  MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
					  MODIFIER_EVENT_ON_DEATH}

	return decFuncs
end

function modifier_papich_reincarnation:ReincarnateTime()
	if IsServer() then  
		if not self.can_die and self.caster:IsRealHero() then
			return self.reincarnate_delay
		end

		return nil
	end
end

function modifier_papich_reincarnation:GetActivityTranslationModifiers()
	if self.reincarnation_death then
		return "reincarnate"
	end

	return nil
end

function modifier_papich_reincarnation:OnDeath(keys)
	if IsServer() then
		local unit = keys.unit
		local reincarnate = keys.reincarnate

		-- Only apply if the caster is the unit that died
		if self:GetParent() == unit then            
			Papich_reincarnation:TheWillOfTheKing( keys, self )
			
		end
	end
end


-- WRAITH FORM AURA FUNCTIONS
function modifier_papich_reincarnation:GetAuraRadius()
	return self.scepter_wraith_form_radius
end

function modifier_papich_reincarnation:GetAuraEntityReject(target)
	-- Aura ignores everyone that are already under the effects of Wraith Form 
	if target:HasModifier(self.modifier_wraith) then
		return true 
	end

	return false    
end

function modifier_papich_reincarnation:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO
end

function modifier_papich_reincarnation:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_papich_reincarnation:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_papich_reincarnation:GetModifierAura()
	return "modifier_papich_reincarnation_wraith_form_buff"
end

function modifier_papich_reincarnation:IsAura()
	if self.caster:IsRealHero() and self.caster:HasScepter() and self.caster == self:GetParent() then
		return true        
	end

	return false
end


-- Wraith Form modifier (given from aura, not yet Wraith Form)
modifier_papich_reincarnation_wraith_form_buff = modifier_papich_reincarnation_wraith_form_buff or class({})

function modifier_papich_reincarnation_wraith_form_buff:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.modifier_wraith_form = "modifier_papich_reincarnation_wraith_form"

	-- Ability specials    
	self.scepter_wraith_form_duration = self.ability:GetSpecialValueFor("scepter_wraith_form_duration")
	self.max_wraith_form_heroes = self.ability:GetSpecialValueFor("max_wraith_form_heroes")
end

function modifier_papich_reincarnation_wraith_form_buff:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_MIN_HEALTH,
					  MODIFIER_EVENT_ON_TAKEDAMAGE}

	return decFuncs
end

function modifier_papich_reincarnation_wraith_form_buff:GetMinHealth()
	return 1
end

function modifier_papich_reincarnation_wraith_form_buff:OnTakeDamage(keys)
	if IsServer() then
		local attacker = keys.attacker
		local target = keys.unit 
		local damage = keys.damage

		-- Only apply if the unit taking damage is the parent
		if self.parent == target then
			
			-- Check if the damage is fatal 
			if damage >= self.parent:GetHealth() then

				-- Check for Shallow Grave: nothing happens
				if self.parent:HasModifier("modifier_imba_dazzle_shallow_grave") or self.parent:HasModifier("modifier_imba_dazzle_nothl_protection") then
					return nil
				end

				-- Check for Aegis: kill the unit normally
				if self.parent:HasModifier("modifier_item_imba_aegis") then
					self:Destroy()
					self.parent:Kill(self.ability, attacker)
					return nil
				end

				-- Check if this unit has Reincarnation and it is ready: if so, kill the unit normally
				if self.parent:HasAbility(self.ability:GetAbilityName()) then
					local reincarnation_ability = self.parent:FindAbilityByName(self.ability:GetAbilityName())
					if reincarnation_ability then
						if self.parent:GetMana() >= reincarnation_ability:GetManaCost(-1) and reincarnation_ability:IsCooldownReady() then
							self:Destroy()
							self.parent:Kill(self.ability, attacker)
							return nil
						end
					end
				end

				-- Assign the killer to the modifier, which would actually kill the hero later
				local wraith_form_modifier_handler = self.parent:AddNewModifier(self.caster, self.ability, self.modifier_wraith_form, {duration = self.scepter_wraith_form_duration})
				if wraith_form_modifier_handler then
					wraith_form_modifier_handler.original_killer = attacker
					wraith_form_modifier_handler.ability_killer = keys.inflictor
					if keys.inflictor then
						if keys.inflictor:GetName() == "imba_necrolyte_reapers_scythe" then
							keys.inflictor.ghost_death = true
						end
					end
				end                
			end
		end
	end
end


-- Wraith Form (actual Wraith Form)
modifier_papich_reincarnation_wraith_form = modifier_papich_reincarnation_wraith_form or class({})

function modifier_papich_reincarnation_wraith_form:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	if IsServer() then
		self.damage_pool = 0
		self.max_hp = self.parent:GetMaxHealth()
		self.threhold_hp = self.ability:GetSpecialValueFor("scepter_hp_pct_threhold") * 0.01 * self.max_hp
		self:StartIntervalThink(0.1)
		
		for i = 0, 8 do
			self.parent.item = self.parent:GetItemInSlot(i) 
			if self.parent.item then
				if self.parent.item:IsSellable() then
					self.parent.item:SetSellable(false)
				end
				if self.parent.item:IsDroppable() then
					self.parent.item:SetDroppable(false)
				end
			end
		end
	end
	self:SetStackCount(math.floor(self:GetDuration() + 0.5))
end

function modifier_papich_reincarnation_wraith_form:IsHidden() return false end
function modifier_papich_reincarnation_wraith_form:IsDebuff() return false end
function modifier_papich_reincarnation_wraith_form:IsPurgable() return false end

function modifier_papich_reincarnation_wraith_form:DeclareFunctions()
	local decFuncs = {MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
					  MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
					  MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
					  MODIFIER_PROPERTY_DISABLE_HEALING,
					  MODIFIER_EVENT_ON_TAKEDAMAGE,
					}

	return decFuncs
end

function modifier_papich_reincarnation_wraith_form:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_papich_reincarnation_wraith_form:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_papich_reincarnation_wraith_form:GetAbsoluteNoDamagePure()
	return 1
end

function modifier_papich_reincarnation_wraith_form:GetDisableHealing()
	return 1
end

function modifier_papich_reincarnation_wraith_form:OnIntervalThink()
	if not IsServer() then
		return
	end
	self:SetStackCount(math.floor(self:GetRemainingTime() + 0.5))
end

function modifier_papich_reincarnation_wraith_form:OnTakeDamage( keys )
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent() then
		return
	end

	if keys.damage_type == DAMAGE_TYPE_PHYSICAL then
		local source_dmg = keys.original_damage
		local armor = keys.unit:GetPhysicalArmorValue()
		local multiplier = 1 - (0.06 * armor) / (1 + 0.06 * math.abs(armor))
		local actually_dmg = source_dmg * multiplier
		self.damage_pool = self.damage_pool + actually_dmg
	elseif keys.damage_type == DAMAGE_TYPE_MAGICAL then
		local source_dmg = keys.original_damage
		local multiplier = 1 - self:GetParent():GetMagicalArmorValue()
		local actually_dmg = source_dmg * multiplier
		self.damage_pool = self.damage_pool + actually_dmg
	elseif keys.damage_type ~= DAMAGE_TYPE_PHYSICAL and keys.damage_type ~= DAMAGE_TYPE_MAGICAL then
		local actually_dmg = keys.original_damage
		self.damage_pool = self.damage_pool + actually_dmg
	end

	if self.damage_pool > self.threhold_hp then
		local duration_reduce = math.floor(self.damage_pool / self.threhold_hp)
		local duration_ori = self:GetRemainingTime()
		self.damage_pool = self.damage_pool - self.threhold_hp * duration_reduce
		if duration_ori > duration_reduce then
			self:SetDuration((duration_ori - duration_reduce), true)
			self:SetStackCount(math.floor(self:GetDuration() + 0.5))
		else
			self:Destroy()
		end
	end
end

function modifier_papich_reincarnation_wraith_form:CheckState()
	local state = {[MODIFIER_STATE_NO_HEALTH_BAR] = true,
				   [MODIFIER_STATE_INVULNERABLE] = true,
				   [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
				   [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true}
	return state
end

function modifier_papich_reincarnation_wraith_form:OnDestroy()
	if IsServer() then
		if self.parent:IsAlive() then
			self.parent:Kill(self.ability_killer, self.original_killer)
		end
		if self.parent:IsAlive() then
			local damageTable = {
			victim = self.parent,
			attacker = self.original_killer,
			damage = 100000000,
			damage_type = DAMAGE_TYPE_PURE,
			ability = self.ability_killer,
			damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_BYPASSES_BLOCK + DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_REFLECTION,
			}
			ApplyDamage(damageTable)
		end
		
		for i = 0, 8 do
			self.parent.item = self.parent:GetItemInSlot(i) 
			if self.parent.item then
				if not self.parent.item:IsSellable() then
					self.parent.item:SetSellable(true)
				end
				if not self.parent.item:IsDroppable() then
					self.parent.item:SetDroppable(true)
				end
			end
		end

		self.damage_pool = nil
		self.max_hp = nil
		self.threhold_hp = nil
	end
	self.caster = nil
	self.ability = nil
	self.parent = nil
end

function modifier_papich_reincarnation_wraith_form:GetStatusEffectName()
	return "particles/status_fx/status_effect_wraithking_ghosts.vpcf"
end
