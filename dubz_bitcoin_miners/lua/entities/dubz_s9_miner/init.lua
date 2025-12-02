AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
include("autorun/dubz_miners_config.lua")

function ENT:Initialize()
    local cfg = self:GetMinerConfig()

    self:SetModel(cfg.Model or "models/props_c17/consolebox01a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
    end

    self.PrintName = cfg.DisplayName or self.PrintName

    self:SetMaxHealth(cfg.Health or 100)
    self:SetHealth(cfg.Health or 100)

    self:SetPrintTime(cfg.PrintTime or 60)
    self:SetPrintAmount(cfg.PrintAmount or 0)
    self:SetMaxStorage(cfg.MaxStorage or math.max((cfg.PrintAmount or 0) * 5, 0))
    self:SetBitcoinPrice(Dubz.BitcoinPrice or 1000)
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
            activator:ChatPrint("This miner has no bitcoin ready to cash out yet.")
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
        activator:ChatPrint(string.format("Cashed out %.4f BTC for $%s.", stored, payout))
    end
end

function PlayerPickupObject(ply, obj)
    if obj:IsPlayerHolding() then return end
    ply:PickupObject(obj)
end
