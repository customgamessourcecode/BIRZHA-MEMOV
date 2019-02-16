modifier_limit_move = class({})

function modifier_limit_move:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN
    }
    return funcs
end

function modifier_limit_move:GetModifierIgnoreMovespeedLimit( params )
    return 1
end

function modifier_limit_move:IsHidden()
    return false
end

function modifier_limit_move:GetModifierMoveSpeed_AbsoluteMin( params )
	return 1000
end