modifier_JohnCena_Grab = class({})

--------------------------------------------------------------------------------

function modifier_JohnCena_Grab:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_JohnCena_Grab:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_JohnCena_Grab:OnCreated( kv )
	if IsServer() then
		self.grab_radius = self:GetAbility():GetSpecialValueFor( "grab_radius" )
		self.min_hold_time = self:GetAbility():GetSpecialValueFor( "min_hold_time" )
		self.max_hold_time = self:GetAbility():GetSpecialValueFor( "max_hold_time" )

		self:StartIntervalThink( kv["initial_delay"] )

		local nFXIndex = ParticleManager:CreateParticle( "particles/test_particle/generic_attack_crit_blur.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetParent():GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
	end
end

--------------------------------------------------------------------------------

function modifier_JohnCena_Grab:OnIntervalThink()
	if IsServer() then
		if self.hTarget == nil then
			return
		end

		local flDist = ( self.hTarget:GetOrigin() - self:GetParent():GetOrigin() ):Length2D()
		if flDist > 700 then
			return
		end
	
		local hBuff = self:GetCaster():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_JohnCena_Grabbed_buff", { duration = 15 } )
		if hBuff ~= nil then
			self:GetCaster().flThrowTimer = GameRules:GetGameTime() + RandomFloat( self.min_hold_time, self.max_hold_time )
			hBuff.hThrowObject = self.hTarget
			self.hTarget:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_JohnCena_Grabbed_debuff", {duration = 15} )		
		end
		self:Destroy()
		return
	end
end

function modifier_JohnCena_Grab:OnDestroy()
	if IsServer() then
		if hTarget ~= nil then
			return
		end

		EmitSoundOnLocationWithCaster( vLocation, "Ability.TossImpact", self:GetCaster() )
		EmitSoundOnLocationWithCaster( vLocation, "OgreTank.GroundSmash", self:GetCaster() )
		
		if self.hThrowTarget ~= nil then
			self.hThrowBuff:Destroy()
			if self.hThrowTarget:IsRealHero() then
				local damageInfo =
				{
					victim = self.hThrowTarget,
					attacker = self:GetCaster(),
					damage = self.knockback_damage / 1,
					damage_type = DAMAGE_TYPE_PURE,
					ability = self,
				}

				ApplyDamage( damageInfo )
				if self.hThrowTarget:IsAlive() == false then
					local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
					ParticleManager:SetParticleControlEnt( nFXIndex, 0, self.hThrowTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", self.hThrowTarget:GetOrigin(), true )
					ParticleManager:SetParticleControl( nFXIndex, 1, self.hThrowTarget:GetOrigin() )
					ParticleManager:SetParticleControlForward( nFXIndex, 1, -self:GetCaster():GetForwardVector() )
					ParticleManager:SetParticleControlEnt( nFXIndex, 10, self.hThrowTarget, PATTACH_ABSORIGIN_FOLLOW, nil, self.hThrowTarget:GetOrigin(), true )
					ParticleManager:ReleaseParticleIndex( nFXIndex )

					EmitSoundOn( "Dungeon.BloodSplatterImpact", self.hThrowTarget )
				else
					self.hThrowTarget:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self.stun_duration } )
				end
			end

			local nFXIndex = ParticleManager:CreateParticle( "particles/test_particle/ogre_melee_smash.vpcf", PATTACH_WORLDORIGIN, self:GetCaster()  )
			ParticleManager:SetParticleControl( nFXIndex, 0, GetGroundPosition( vLocation, self.hThrowTarget ) )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.impact_radius, self.impact_radius, self.impact_radius ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )

			local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), vLocation, self:GetCaster(), self.impact_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			for _,enemy in pairs( enemies ) do
				if enemy ~= nil and enemy:IsInvulnerable() == false and enemy ~= self.hThrowTarget then
					local damageInfo = 
					{
						victim = enemy,
						attacker = self:GetCaster(),
						damage = self.knockback_damage,
						damage_type = DAMAGE_TYPE_PURE,
						ability = self,
					}

					ApplyDamage( damageInfo )
					if enemy:IsAlive() == false then
						local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
						ParticleManager:SetParticleControlEnt( nFXIndex, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetOrigin(), true )
						ParticleManager:SetParticleControl( nFXIndex, 1, enemy:GetOrigin() )
						ParticleManager:SetParticleControlForward( nFXIndex, 1, -self:GetCaster():GetForwardVector() )
						ParticleManager:SetParticleControlEnt( nFXIndex, 10, enemy, PATTACH_ABSORIGIN_FOLLOW, nil, enemy:GetOrigin(), true )
						ParticleManager:ReleaseParticleIndex( nFXIndex )

						EmitSoundOn( "Dungeon.BloodSplatterImpact", enemy )
					else
						local kv =
						{
							center_x = vLocation.x,
							center_y = vLocation.y,
							center_z = vLocation.z,
							should_stun = true, 
							duration = self.knockback_duration,
							knockback_duration = self.knockback_duration,
							knockback_distance = self.knockback_distance,
							knockback_height = self.knockback_height,
						}
						enemy:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = self.knockback_duration } )
					end
					
				end
			end
		end
end
end