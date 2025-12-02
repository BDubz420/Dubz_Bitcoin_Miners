include("shared.lua")
include("autorun/dubz_miners_config.lua")

local theme = Dubz.MinerTheme or {
    Background = Color(18, 21, 30, 240),
    Header     = Color(28, 32, 46, 255),
    Accent     = Color(0, 195, 255, 255),
    Text       = Color(235, 240, 255, 255),
    SubText    = Color(150, 160, 180, 255)
}

local fonts = Dubz.MinerFonts or {
    Title = { font = "Roboto Bold", size = 64, weight = 800, antialias = true },
    Subtitle = { font = "Roboto", size = 32, weight = 600, antialias = true },
    Text = { font = "Roboto", size = 26, weight = 500, antialias = true },
}

local function createFonts()
    local title = fonts.Title or { font = "Roboto Bold", size = 64, weight = 800, antialias = true }
    local subtitle = fonts.Subtitle or { font = "Roboto", size = 32, weight = 600, antialias = true }
    local text = fonts.Text or { font = "Roboto", size = 26, weight = 500, antialias = true }

    surface.CreateFont("DubzMiner_Title", title)
    surface.CreateFont("DubzMiner_Subtitle", subtitle)
    surface.CreateFont("DubzMiner_Text", text)
end

createFonts()

function ENT:Draw()
    self:DrawModel()
    self:DrawDisplay()
end

function ENT:DrawDisplay()
    local cfg = self:GetMinerConfig()
    if not cfg then return end

    local pos = self:GetPos()
    local ang = self:GetAngles()
    local ui = Dubz.MinerUI or {}
    local offset = self:GetUp() * (ui.OffsetUp or 12) + self:GetForward() * (ui.OffsetForward or 12)
    ang:RotateAroundAxis(ang:Up(), 90)
    ang:RotateAroundAxis(ang:Forward(), 90)

    local panelW, panelH = ui.PanelWidth or 520, ui.PanelHeight or 320
    local scale = ui.PanelScale or 0.05
    local styleLabel = ui.StyleLabel or "Dubz Style 2"
    local storedDecimals = ui.StoredDecimals or 4
    local timeDecimals = ui.TimeDecimals or 1

    cam.Start3D2D(pos + offset, ang, scale)
        draw.RoundedBox(8, -panelW / 2, -panelH, panelW, panelH, theme.Background)

        draw.RoundedBox(8, -panelW / 2, -panelH, panelW, 70, theme.Header)
        draw.SimpleText(cfg.DisplayName or self.PrintName, "DubzMiner_Title", 0, -panelH + 40, theme.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(styleLabel, "DubzMiner_Subtitle", 0, -panelH + 78, theme.SubText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        local stored = self:GetStoredBTC()
        local price = self:GetBitcoinPrice()
        local nextPrint = self:GetNextPrint()
        local printTime = self:GetPrintTime()
        local timeLeft = math.max(0, nextPrint - CurTime())
        local progress = math.Clamp(1 - (timeLeft / math.max(printTime, 0.001)), 0, 1)
        local formattedTime = string.format("%0." .. timeDecimals .. "f", timeLeft)
        local nextPrintLabel = string.format(ui.NextPrintLabel or "Next print in %ss", formattedTime)
        local storedLabel = string.format(ui.StoredLabel or "Stored Bitcoin: %s BTC", string.format("%0." .. storedDecimals .. "f", stored))
        local cashoutLabel = string.format(ui.CashoutRateLabel or "Cashout Rate: $%s / BTC", (string.Comma and string.Comma(math.Round(price))) or math.Round(price))
        local storageLabel = string.format(ui.StorageLabel or "Storage Limit: %s BTC", string.format("%0." .. storedDecimals .. "f", self:GetMaxStorage()))
        local promptText = ui.PromptText or "Press E to collect & convert to DarkRP cash"

        draw.RoundedBox(6, -panelW / 2 + 20, -panelH + 110, panelW - 40, 6, theme.Header)
        draw.RoundedBox(6, -panelW / 2 + 20, -panelH + 110, (panelW - 40) * progress, 6, theme.Accent)
        draw.SimpleText(nextPrintLabel, "DubzMiner_Text", 0, -panelH + 130, theme.SubText, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

        draw.SimpleText(storedLabel, "DubzMiner_Text", 0, -panelH + 175, theme.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        draw.SimpleText(cashoutLabel, "DubzMiner_Text", 0, -panelH + 205, theme.SubText, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        draw.SimpleText(storageLabel, "DubzMiner_Text", 0, -panelH + 235, theme.SubText, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

        draw.RoundedBox(6, -panelW / 2 + 20, -panelH + 260, panelW - 40, 40, theme.Header)
        draw.SimpleText(promptText, "DubzMiner_Text", 0, -panelH + 280, theme.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    cam.End3D2D()
end
