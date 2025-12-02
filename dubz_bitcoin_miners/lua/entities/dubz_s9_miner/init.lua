AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
include("autorun/dubz_miners_config.lua")

function ENT:Initialize()
	self:SetModel("models/dubz_miners/dubz_s9_miner.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
    phys:Wake()

end

function PlayerPickupObject( ply, obj )
	if ( obj:IsPlayerHolding() ) then return end

	ply:PickupObject( obj )
end