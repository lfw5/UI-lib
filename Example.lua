-- ============================================================
--   KrixUI - Example Script
--   Replace YOUR_USERNAME with your GitHub username
-- ============================================================

local KrixUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/YOUR_USERNAME/KrixUI/main/UILib.lua",
    true
))()

-- ── Create Window ─────────────────────────────────────────
local Window = KrixUI:CreateWindow({
    Title    = "KrixUI",
    Subtitle = "Example Script",
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

local targetDrop = MainSection:AddDropdown({
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
        local cur = aimbotToggle:Get()
        aimbotToggle:Set(not cur)
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
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end,
})

MiscSection:AddButton({
    Name     = "Copy Player Name",
    Callback = function()
        setclipboard(game.Players.LocalPlayer.Name)
        Window:Notify({
            Title       = "Copied!",
            Description = "Player name copied to clipboard.",
            Type        = "Success",
            Duration    = 3,
        })
    end,
})

MiscSection:AddSeparator()

MiscSection:AddLabel({ Text = "KrixUI v1.0.0 — Made by Krix" })

local ScriptSection = MiscTab:AddSection("Script Input")

local scriptBox = ScriptSection:AddTextBox({
    Name        = "Execute Lua",
    Placeholder = "Enter script here...",
    Callback    = function(text)
        local fn, err = loadstring(text)
        if fn then
            fn()
        else
            Window:Notify({
                Title       = "Error",
                Description = err,
                Type        = "Error",
                Duration    = 5,
            })
        end
    end,
})

-- ── Welcome notification ───────────────────────────────────
task.wait(1)
Window:Notify({
    Title       = "KrixUI Loaded",
    Description = "Welcome! Script injected successfully.",
    Type        = "Success",
    Duration    = 4,
})
