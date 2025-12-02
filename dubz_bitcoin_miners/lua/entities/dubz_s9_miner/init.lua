AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
include("autorun/dubz_miners_config.lua")

function ENT:Initialize()
    local cfg = self:GetMinerConfig()
    local defaults = Dubz.MinerDefaults or {}

    self:SetModel(cfg.Model or defaults.Model or "models/props_c17/consolebox01a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(cfg.UseType or defaults.UseType or SIMPLE_USE)

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
    end

    self.PrintName = cfg.DisplayName or self.PrintName

    local health = cfg.Health or defaults.Health or 100
    self:SetMaxHealth(health)
    self:SetHealth(health)

    local printTime = cfg.PrintTime or defaults.PrintTime or 60
    self:SetPrintTime(printTime)

    local printAmount = cfg.PrintAmount or defaults.PrintAmount or 0
    self:SetPrintAmount(printAmount)

    local maxStorage = cfg.MaxStorage
    if not maxStorage then
        local multiplier = cfg.MaxStorageMultiplier or defaults.MaxStorageMultiplier or 5
        maxStorage = math.max(printAmount * multiplier, 0)
    end

    self:SetMaxStorage(maxStorage)
    self:SetBitcoinPrice(cfg.BitcoinPrice or Dubz.BitcoinPrice or defaults.BitcoinPrice or 1000)
    self:SetStoredBTC(0)
    self:SetNextPrint(CurTime() + self:GetPrintTime())
end

function ENT:Think()
    local cfg = self:GetMinerConfig()
    if not cfg then return end

    local now = CurTime()
    if now >= self:GetNextPrint() then
        local stored = self:GetStoredBTC()
        local maxStorage = self:GetMaxStorage()

        if stored < maxStorage then
            local added = self:GetPrintAmount()
            self:SetStoredBTC(math.min(maxStorage, stored + added))
        end

        self:SetNextPrint(now + self:GetPrintTime())
    end

    self:NextThink(now + 0.1)
    return true
end

function ENT:Use(activator)
    if not IsValid(activator) or not activator:IsPlayer() then return end

    local stored = self:GetStoredBTC()
    if stored <= 0 then
        if activator.ChatPrint then
            activator:ChatPrint((Dubz.MinerMessages and Dubz.MinerMessages.Empty) or "This miner has no bitcoin ready to cash out yet.")
        end
        return
    end

    local payout = math.Round(stored * self:GetBitcoinPrice())
    self:SetStoredBTC(0)

    if payout > 0 then
        if activator.addMoney then
            activator:addMoney(payout)
        elseif activator.GiveMoney then
            activator:GiveMoney(payout)
        end
    end

    if activator.ChatPrint then
        local decimals = (Dubz.MinerUI and Dubz.MinerUI.StoredDecimals) or 4
        local storedText = string.format("%0." .. decimals .. "f", stored)
        local payoutText = (string.Comma and string.Comma(payout)) or tostring(payout)
        activator:ChatPrint(string.format((Dubz.MinerMessages and Dubz.MinerMessages.Cashout) or "Cashed out %s BTC for $%s.", storedText, payoutText))
    end
end

function PlayerPickupObject(ply, obj)
    if obj:IsPlayerHolding() then return end
    ply:PickupObject(obj)
end
