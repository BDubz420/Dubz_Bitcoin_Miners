---------------------------------------
-- Dubz BITCOIN MINING SYSTEM CONFIG --
---------------------------------------
Dubz = Dubz or {}

Dubz.MinerTheme = {
    Background = Color(18, 21, 30, 240), -- Primary background for Dubz Style 2
    Header     = Color(28, 32, 46, 255), -- Header panel
    Accent     = Color(0, 195, 255, 255), -- Bright accent line
    Text       = Color(235, 240, 255, 255), -- Main text
    SubText    = Color(150, 160, 180, 255) -- Secondary text
}

Dubz.MinerFonts = {
    Title = { font = "Roboto Bold", size = 64, weight = 800, antialias = true },
    Subtitle = { font = "Roboto", size = 32, weight = 600, antialias = true },
    Text = { font = "Roboto", size = 26, weight = 500, antialias = true },
}

Dubz.MinerUI = {
    StyleLabel = "Dubz Style 2", -- Subtitle label shown under the miner name
    PanelWidth = 520,
    PanelHeight = 320,
    PanelScale = 0.05,
    OffsetUp = 12,
    OffsetForward = 12,
    StoredDecimals = 4,
    TimeDecimals = 1,
    StoredLabel = "Stored Bitcoin: %s BTC",
    PromptText = "Press E to collect & convert to DarkRP cash",
    NextPrintLabel = "Next print in %ss",
    StorageLabel = "Storage Limit: %s BTC",
    CashoutRateLabel = "Cashout Rate: $%s / BTC",
}

Dubz.MinerMessages = {
    Empty = "This miner has no bitcoin ready to cash out yet.",
    Cashout = "Cashed out %s BTC for $%s.",
}

Dubz.MinerDefaults = {
    Model = "models/props_c17/consolebox01a.mdl",
    PrintTime = 60,
    PrintAmount = 0,
    MaxStorageMultiplier = 5, -- Used only when MaxStorage is omitted
    Health = 100,
    BitcoinPrice = 1000,
    UseType = SIMPLE_USE,
}

Dubz.BitcoinPrice = 1000 -- DarkRP cash received per 1 BTC when cashed out

-- Each miner definition uses the entity classname as the key for easier lookup.
Dubz.Miners = {
    ["Dubz_S9_Miner"] = {
        DisplayName = "Dubz S9 Miner",
        Model = "models/dubz_miners/dubz_s9_miner.mdl",
        PrintTime = 100,            -- Seconds between each bitcoin print
        PrintAmount = 0.015,        -- BTC created per print
        MaxStorage = 0.45,          -- Maximum BTC stored before pausing prints
        Health = 100,               -- Max health
    },

    ["Dubz_S19_Miner"] = {
        DisplayName = "Dubz S19 Miner",
        Model = "models/dubz_miners/dubz_s19_miner.mdl",
        PrintTime = 30,             -- Seconds between each bitcoin print
        PrintAmount = 0.045,        -- BTC created per print
        MaxStorage = 1.35,          -- Maximum BTC stored before pausing prints
        Health = 150,               -- Max health
    },
}
