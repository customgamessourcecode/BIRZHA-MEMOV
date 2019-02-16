LinkLuaModifier( "modifier_Bukin_Rage" , "heroes/hero_bukin/modifier_Bukin_Rage.lua" , LUA_MODIFIER_MOTION_NONE )

function ApplyLuaModifier( keys )
    local caster = keys.caster
    local ability = keys.ability
    local modifiername = keys.ModifierName

    caster:AddNewModifier(caster, ability, modifiername, {})
end