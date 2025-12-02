include("autorun/dubz_miners_config.lua")

ENT.Type                        = "anim"
ENT.Base                        = "base_gmodentity"
ENT.PrintName                   = (Dubz.Miners and Dubz.Miners["Dubz_S9_Miner"] and Dubz.Miners["Dubz_S9_Miner"].DisplayName) or "S9 Miner"
ENT.Category                    = "Dubz Bitcoin Mining"
ENT.Author                      = "BDubz420"
ENT.Spawnable                   = true
ENT.AdminSpawnable              = true

function ENT:GetMinerConfig()
    return Dubz.Miners and Dubz.Miners[self:GetClass()] or {}
end

function ENT:SetupDataTables()
    self:NetworkVar("Float", 0, "StoredBTC")
    self:NetworkVar("Float", 1, "NextPrint")
    self:NetworkVar("Float", 2, "PrintTime")
    self:NetworkVar("Float", 3, "PrintAmount")
    self:NetworkVar("Float", 4, "BitcoinPrice")
    self:NetworkVar("Float", 5, "MaxStorage")
end
