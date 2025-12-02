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
