include("shared.lua")
include("autorun/dubz_miners_config.lua")

local defaultTheme = {
    Background = Color(18, 21, 30, 240),
    Header     = Color(28, 32, 46, 255),
    Accent     = Color(0, 195, 255, 255),
    Text       = Color(235, 240, 255, 255),
    SubText    = Color(150, 160, 180, 255)
}

local defaultFonts = {
    Title = { font = "Roboto Bold", size = 48, weight = 800, antialias = true },
    Subtitle = { font = "Roboto", size = 28, weight = 600, antialias = true },
    Text = { font = "Roboto", size = 22, weight = 500, antialias = true },
}

local fontsCreated = false
local function ensureFonts()
    if fontsCreated then return end

    local fonts = Dubz.MinerFonts or defaultFonts
    local title = fonts.Title or defaultFonts.Title
    local subtitle = fonts.Subtitle or defaultFonts.Subtitle
    local text = fonts.Text or defaultFonts.Text

    surface.CreateFont("DubzMiner_Title", title)
    surface.CreateFont("DubzMiner_Subtitle", subtitle)
    surface.CreateFont("DubzMiner_Text", text)

    fontsCreated = true
end

function ENT:Draw()
    self:DrawModel()
end

local function isMiner(ent)
    if not IsValid(ent) then return false end
    if not Dubz.Miners then return false end
    return Dubz.Miners[ent:GetClass()] ~= nil
end

local function getLookedAtMiner()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    local tr = ply:GetEyeTrace()
    if not tr.Hit or not IsValid(tr.Entity) or not isMiner(tr.Entity) then return end

    local ui = Dubz.MinerUI or {}
    local maxDist = ui.HudMaxDistance or 250
    local distSqr = tr.Entity:GetPos():DistToSqr(ply:GetShootPos())
    if distSqr > maxDist * maxDist then return end

    return tr.Entity
end

local function drawMinerHUD()
    ensureFonts()

    local ent = getLookedAtMiner()
    if not IsValid(ent) then return end

    local cfg = ent:GetMinerConfig() or {}
    local ui = Dubz.MinerUI or {}
    local theme = Dubz.MinerTheme or defaultTheme

    local storedDecimals = ui.StoredDecimals or 4
    local timeDecimals = ui.TimeDecimals or 1

    local stored = ent:GetStoredBTC()
    local nextPrint = ent:GetNextPrint()
    local printTime = ent:GetPrintTime()
    local timeLeft = math.max(0, nextPrint - CurTime())

    local formattedTime = string.format("%0." .. timeDecimals .. "f", timeLeft)
    local nextPrintLabel = string.format(ui.NextPrintLabel or "Next print in %ss", formattedTime)
    local storedLabel = string.format(ui.StoredLabel or "Stored Bitcoin: %s BTC", string.format("%0." .. storedDecimals .. "f", stored))
    local promptText = ui.PromptText or "Press E to collect & convert to DarkRP cash"

    local w = ui.HudWidth or 320
    local padding = ui.HudPadding or 14
    local lineSpacing = ui.HudLineSpacing or 6
    local x = (ScrW() - w) / 2
    local y = ScrH() - (ui.HudMarginY or 120)

    surface.SetFont("DubzMiner_Subtitle")
    local _, titleH = surface.GetTextSize(cfg.DisplayName or ent.PrintName or "Bitcoin Miner")
    surface.SetFont("DubzMiner_Text")
    local _, nextH = surface.GetTextSize(nextPrintLabel)
    local _, storedH = surface.GetTextSize(storedLabel)
    local _, promptH = surface.GetTextSize(promptText)

    local calculatedHeight = padding * 2 + titleH + nextH + storedH + promptH + (lineSpacing * 3)
    local h = math.max(ui.HudHeight or calculatedHeight, calculatedHeight)
    y = y - h

    draw.RoundedBox(10, x, y, w, h, theme.Background)
    draw.RoundedBox(10, x, y, w, 6, theme.Accent)

    local lineY = y + padding
    draw.SimpleText(cfg.DisplayName or ent.PrintName or "Bitcoin Miner", "DubzMiner_Subtitle", x + w / 2, lineY, theme.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    lineY = lineY + titleH + lineSpacing

    draw.SimpleText(nextPrintLabel, "DubzMiner_Text", x + w / 2, lineY, theme.SubText, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    lineY = lineY + nextH + lineSpacing

    draw.SimpleText(storedLabel, "DubzMiner_Text", x + w / 2, lineY, theme.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    lineY = lineY + storedH + lineSpacing

    draw.SimpleText(promptText, "DubzMiner_Text", x + w / 2, lineY, theme.Text, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
end

if not DubzMinerHUDHookAdded then
    DubzMinerHUDHookAdded = true
    hook.Add("HUDPaint", "DubzMiner_HUD", drawMinerHUD)
end
