modifier_ExplosionMagic = class({})

-----------------------------------------------------------------------------

function modifier_ExplosionMagic:OnCreated( kv )
	if IsServer() then
		self.delay = self:GetAbility():GetSpecialValueFor( "delay" )
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
		self.blast_damage = self:GetAbility():GetSpecialValueFor( "blast_damage" )
		
		self:StartIntervalThink( self.delay )

		local nFXIndex = ParticleManager:CreateParticle( "particles/booom/1.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.radius, self.delay, 1.0 ) )
		ParticleManager:SetParticleControl( nFXIndex, 15, Vector( 175, 238, 238 ) )
		ParticleManager:SetParticleControl( nFXIndex, 16, Vector( 1, 0, 0 ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
	end
end

-----------------------------------------------------------------------------

function modifier_ExplosionMagic:OnIntervalThink()
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_techies/techies_blast_off.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector ( self.radius, self.radius, self.radius ) )
		ParticleManager:SetParticleControl( nFXIndex, 15, Vector( 175, 238, 238 ) )
		ParticleManager:SetParticleControl( nFXIndex, 16, Vector( 1, 0, 0 ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		EmitSoundOn( "Hero_Techies.Suicide", self:GetParent() )
		local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
		
		for _,enemy in pairs( enemies ) do
			if enemy ~= nil and enemy:IsInvulnerable() == false then
				local damageInfo =
				{
					victim = enemy,
					attacker = self:GetCaster(),
					damage = self.blast_damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self:GetAbility(),
				}
				
				ApplyDamage( damageInfo )
				local knockbackProperties =
				{
					center_x = 0,
					center_y = 0,
					center_z = 0,
					duration = 0.5,
					knockback_duration = 1,
					knockback_distance = 350,
					knockback_height = 250
				}
				if not enemy:HasModifier("modifier_knockback") then
					enemy:AddNewModifier( enemy, nil, "modifier_knockback", knockbackProperties )
				end
			end
		end

		UTIL_Remove( self:GetParent() )
	end
end

-----------------------------------------------------------------------------
