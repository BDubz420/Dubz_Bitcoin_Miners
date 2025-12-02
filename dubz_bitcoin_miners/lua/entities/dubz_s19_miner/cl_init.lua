include("shared.lua")
include("autorun/dubz_miners_config.lua")

local theme = Dubz.MinerTheme or {
    Background = Color(18, 21, 30, 240),
    Header     = Color(28, 32, 46, 255),
    Accent     = Color(0, 195, 255, 255),
    Text       = Color(235, 240, 255, 255),
    SubText    = Color(150, 160, 180, 255)
}

surface.CreateFont("DubzMiner_Title", {
    font = "Roboto Bold",
    size = 64,
    weight = 800,
    antialias = true
})

surface.CreateFont("DubzMiner_Subtitle", {
    font = "Roboto",
    size = 32,
    weight = 600,
    antialias = true
})

surface.CreateFont("DubzMiner_Text", {
    font = "Roboto",
    size = 26,
    weight = 500,
    antialias = true
})

function ENT:Draw()
    self:DrawModel()
    self:DrawDisplay()
end

function ENT:DrawDisplay()
    local cfg = self:GetMinerConfig()
    if not cfg then return end

    local pos = self:GetPos()
    local ang = self:GetAngles()
    local offset = self:GetUp() * 12 + self:GetForward() * 12
    ang:RotateAroundAxis(ang:Up(), 90)
    ang:RotateAroundAxis(ang:Forward(), 90)

    cam.Start3D2D(pos + offset, ang, 0.05)
        local panelW, panelH = 520, 320
        draw.RoundedBox(8, -panelW / 2, -panelH, panelW, panelH, theme.Background)

        draw.RoundedBox(8, -panelW / 2, -panelH, panelW, 70, theme.Header)
        draw.SimpleText(cfg.DisplayName or self.PrintName, "DubzMiner_Title", 0, -panelH + 40, theme.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Dubz Style 2", "DubzMiner_Subtitle", 0, -panelH + 78, theme.SubText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        local stored = self:GetStoredBTC()
        local price = self:GetBitcoinPrice()
        local nextPrint = self:GetNextPrint()
        local printTime = self:GetPrintTime()
        local timeLeft = math.max(0, nextPrint - CurTime())
        local progress = math.Clamp(1 - (timeLeft / math.max(printTime, 0.001)), 0, 1)

        draw.RoundedBox(6, -panelW / 2 + 20, -panelH + 110, panelW - 40, 6, theme.Header)
        draw.RoundedBox(6, -panelW / 2 + 20, -panelH + 110, (panelW - 40) * progress, 6, theme.Accent)
        draw.SimpleText(string.format("Next print in %.1fs", timeLeft), "DubzMiner_Text", 0, -panelH + 130, theme.SubText, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

        draw.SimpleText(string.format("Stored Bitcoin: %.4f BTC", stored), "DubzMiner_Text", 0, -panelH + 175, theme.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        draw.SimpleText(string.format("Cashout Rate: $%s / BTC", math.Round(price)), "DubzMiner_Text", 0, -panelH + 205, theme.SubText, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        draw.SimpleText(string.format("Storage Limit: %.4f BTC", self:GetMaxStorage()), "DubzMiner_Text", 0, -panelH + 235, theme.SubText, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

        draw.RoundedBox(6, -panelW / 2 + 20, -panelH + 260, panelW - 40, 40, theme.Header)
        draw.SimpleText("Press E to collect & convert to DarkRP cash", "DubzMiner_Text", 0, -panelH + 280, theme.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    cam.End3D2D()
end
