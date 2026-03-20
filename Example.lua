-- ============================================================
--   KrixUI - Example Script
--   Comment: Paste UILib.lua content above this, OR use loadstring
--   after uploading to GitHub with your real username.
--
--   Option A (GitHub raw, replace YOUR_USERNAME):
--     local KrixUI = loadstring(game:HttpGet(
--         "https://raw.githubusercontent.com/YOUR_USERNAME/KrixUI/main/UILib.lua", true
--     ))()
--
--   Option B (local test - paste UILib.lua source above this file,
--             then at bottom the library returns KrixUI, so do:)
--     local KrixUI = (paste UILib.lua here and it returns KrixUI)
-- ============================================================

-- ── For local testing: source UILib inline then run this block ──
-- If testing in an executor locally, paste the contents of UILib.lua
-- ABOVE this line and replace the line below with the return value.

-- !! REPLACE THIS LINE with your real GitHub raw URL !!
local KrixUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/lfw5/UI-lib/refs/heads/main/UILib.lua",
    true
))()

-- ── Create Window ─────────────────────────────────────────
local Window = KrixUI:CreateWindow({
    Title    = "KrixUI",
    Subtitle = "v1.0",
    Size     = UDim2.new(0, 620, 0, 440),
})

-- ── Tab 1: Combat ─────────────────────────────────────────
local CombatTab = Window:AddTab({ Name = "Combat", Icon = "⚔️" })
local MainSection = CombatTab:AddSection("Main")

local aimbotToggle = MainSection:AddToggle({
    Name     = "Aimbot",
    Default  = false,
    Callback = function(state)
        print("Aimbot:", state)
    end,
})

local fovSlider = MainSection:AddSlider({
    Name     = "FOV",
    Min      = 10,
    Max      = 500,
    Default  = 150,
    Suffix   = " px",
    Callback = function(value)
        print("FOV:", value)
    end,
})

MainSection:AddDropdown({
    Name     = "Target Part",
    Items    = { "Head", "HumanoidRootPart", "UpperTorso" },
    Default  = "Head",
    Callback = function(selected)
        print("Target:", selected)
    end,
})

local SettingsSection = CombatTab:AddSection("Settings")

SettingsSection:AddKeybind({
    Name     = "Toggle Aimbot",
    Default  = Enum.KeyCode.E,
    Callback = function()
        aimbotToggle:Set(not aimbotToggle:Get())
    end,
})

SettingsSection:AddSlider({
    Name     = "Smoothness",
    Min      = 1,
    Max      = 20,
    Default  = 5,
    Callback = function(value)
        print("Smoothness:", value)
    end,
})

-- ── Tab 2: Visual ─────────────────────────────────────────
local VisualTab = Window:AddTab({ Name = "Visual", Icon = "👁️" })
local ESPSection = VisualTab:AddSection("ESP")

ESPSection:AddToggle({
    Name     = "ESP Boxes",
    Default  = false,
    Callback = function(state)
        print("ESP Boxes:", state)
    end,
})

ESPSection:AddToggle({
    Name     = "ESP Names",
    Default  = false,
    Callback = function(state)
        print("ESP Names:", state)
    end,
})

ESPSection:AddSlider({
    Name     = "Max Distance",
    Min      = 50,
    Max      = 2000,
    Default  = 500,
    Suffix   = " studs",
    Callback = function(value)
        print("ESP Distance:", value)
    end,
})

-- ── Tab 3: Misc ───────────────────────────────────────────
local MiscTab = Window:AddTab({ Name = "Misc", Icon = "⚙️" })
local MiscSection = MiscTab:AddSection("Utilities")

MiscSection:AddButton({
    Name     = "Rejoin Server",
    Callback = function()
        local TP = game:GetService("TeleportService")
        TP:Teleport(game.PlaceId, game.Players.LocalPlayer)
    end,
})

MiscSection:AddButton({
    Name     = "Copy Player Name",
    Callback = function()
        local name = game.Players.LocalPlayer.Name
        if setclipboard then setclipboard(name) end
        Window:Notify({
            Title       = "Copié !",
            Description = name .. " copié dans le presse-papiers.",
            Type        = "Success",
            Duration    = 3,
        })
    end,
})

MiscSection:AddSeparator()
MiscSection:AddLabel({ Text = "KrixUI v1.0.0 — Made by Krix" })

local ScriptSection = MiscTab:AddSection("Script Input")

ScriptSection:AddTextBox({
    Name        = "Execute Lua",
    Placeholder = "Entrez votre script ici...",
    Callback    = function(text)
        if text == "" then return end
        local fn, err = loadstring(text)
        if fn then
            local ok, runErr = pcall(fn)
            if not ok then
                Window:Notify({ Title = "Runtime Error", Description = tostring(runErr), Type = "Error", Duration = 5 })
            end
        else
            Window:Notify({ Title = "Syntax Error", Description = tostring(err), Type = "Error", Duration = 5 })
        end
    end,
})

-- ── Welcome notification ───────────────────────────────────
task.wait(1)
Window:Notify({
    Title       = "KrixUI Chargé",
    Description = "Bienvenue ! Script injecté avec succès.",
    Type        = "Success",
    Duration    = 4,
})
