-- ============================================================
--   KrixUI v3.0 - Example Script
--   Load the library from GitHub and create a demo UI
--   GitHub: https://github.com/lfw5/UI-lib
-- ============================================================

local KrixUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/lfw5/UI-lib/refs/heads/main/UILib.lua"))()

-- ── Key System (set Enabled = true to activate) ────────────
KrixUI:KeySystem({
    Enabled    = false,          -- Set to true to require a key
    Service    = "",          -- Your Junkie service name
    Identifier = "",      -- Your Junkie user ID
    Provider   = "",          -- Your provider name
    MaxAttempts = 5,             -- Max failed attempts
})

-- ── Create Window ──────────────────────────────────────────
local Window = KrixUI:CreateWindow({
    Title     = "KrixUI",
    Subtitle  = "v3.0",
    Size      = UDim2.new(0, 700, 0, 480),
    ToggleKey = Enum.KeyCode.RightControl,
})

-- ── Tab 1: Main ────────────────────────────────────────────
local MainTab = Window:AddTab({ Name = "Main" })
local GeneralSection = MainTab:AddSection("General")

GeneralSection:AddParagraph({
    Title = "Welcome",
    Content = "KrixUI v3.0 — A clean UI library for Roblox.\nUse the tabs to explore all available elements.",
})

local myToggle = GeneralSection:AddToggle({
    Name = "Enable Feature", Default = false,
    Callback = function(state) print("Toggle:", state) end,
})

GeneralSection:AddSlider({
    Name = "Value", Min = 0, Max = 100, Default = 50, Suffix = "%", Increment = 1,
    Callback = function(v) print("Slider:", v) end,
})

GeneralSection:AddSlider({
    Name = "Speed", Min = 1, Max = 50, Default = 10,
    Callback = function(v) print("Speed:", v) end,
})

GeneralSection:AddDropdown({
    Name = "Mode", Items = { "Option A", "Option B", "Option C", "Option D" },
    Default = "Option A", Callback = function(s) print("Dropdown:", s) end,
})

GeneralSection:AddSeparator()

GeneralSection:AddKeybind({
    Name = "Toggle Key", Default = Enum.KeyCode.E,
    Callback = function() myToggle:Set(not myToggle:Get()) end,
})

-- ── Tab 2: Settings ────────────────────────────────────────
local SettingsTab = Window:AddTab({ Name = "Settings" })
local DisplaySection = SettingsTab:AddSection("Display")
DisplaySection:AddToggle({ Name = "Option 1", Default = false, Callback = function(s) print("Opt1:", s) end })
DisplaySection:AddToggle({ Name = "Option 2", Default = true, Callback = function(s) print("Opt2:", s) end })
DisplaySection:AddToggle({ Name = "Option 3", Default = false, Callback = function(s) print("Opt3:", s) end })
DisplaySection:AddSlider({ Name = "Intensity", Min = 0, Max = 100, Default = 75, Suffix = "%", Callback = function(v) print("Intensity:", v) end })

local InputSection = SettingsTab:AddSection("Input")
InputSection:AddTextBox({
    Name = "Custom Value", Placeholder = "Enter something...",
    Callback = function(text) print("Input:", text) end,
})
InputSection:AddKeybind({
    Name = "Action Key", Default = Enum.KeyCode.F,
    Callback = function() print("Action triggered") end,
})

-- ── Tab 3: Tools ───────────────────────────────────────────
local ToolsTab = Window:AddTab({ Name = "Tools" })
local ActionsSection = ToolsTab:AddSection("Actions")
ActionsSection:AddButton({ Name = "Action 1", Callback = function() Window:Notify({ Title = "Done", Description = "Action 1 executed.", Type = "Success", Duration = 3 }) end })
ActionsSection:AddButton({ Name = "Action 2", Callback = function() Window:Notify({ Title = "Done", Description = "Action 2 executed.", Type = "Info", Duration = 3 }) end })
ActionsSection:AddSeparator()
ActionsSection:AddLabel({ Text = "Made by Krix" })
ActionsSection:AddParagraph({ Title = "KrixUI v3.0", Content = "Press Right Ctrl to toggle GUI." })

-- ── Welcome notification ───────────────────────────────────
task.wait(1)
Window:Notify({ Title = "KrixUI", Description = "UI loaded. Press RCtrl to toggle.", Type = "Success", Duration = 4 })
