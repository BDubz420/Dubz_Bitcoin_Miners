include("autorun/dubz_miners_config.lua")

local defaults = Dubz.MinerDefaults or {}
local minerCfg = Dubz.Miners and Dubz.Miners["dubz_s9_miner"] or {}

ENT.Type                        = "anim"
ENT.Base                        = "base_gmodentity"
ENT.PrintName                   = minerCfg.DisplayName or "S9 Miner"
ENT.Category                    = minerCfg.Category or defaults.Category or "Dubz Bitcoin Mining"
ENT.Author                      = minerCfg.Author or defaults.Author or "BDubz420"
ENT.Spawnable                   = minerCfg.Spawnable ~= false
ENT.AdminSpawnable              = minerCfg.AdminSpawnable ~= false
ENT.Model                       = minerCfg.Model or defaults.Model

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
