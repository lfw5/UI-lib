# KrixUI — Roblox UI Library

![Version](https://img.shields.io/badge/version-1.0.0-blueviolet)
![Lua](https://img.shields.io/badge/language-Lua-blue)
![Platform](https://img.shields.io/badge/platform-Roblox-red)

A clean, modern, dark-themed Roblox exploit UI library with smooth animations, draggable windows, notifications, and a full set of UI elements.

---

## 📦 Loadstring (GitHub Raw)

```lua
local KrixUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/YOUR_USERNAME/KrixUI/main/UILib.lua",
    true
))()
```

> Replace `YOUR_USERNAME` with your actual GitHub username after uploading.

---

## 🚀 Quick Start

```lua
local KrixUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/YOUR_USERNAME/KrixUI/main/UILib.lua", true
))()

local Window = KrixUI:CreateWindow({
    Title    = "MyScript",
    Subtitle = "v1.0",
    Size     = UDim2.new(0, 620, 0, 440),
})

local Tab = Window:AddTab({ Name = "Main", Icon = "⚔️" })
local Section = Tab:AddSection("Combat")

Section:AddToggle({
    Name     = "Aimbot",
    Default  = false,
    Callback = function(state)
        print("Aimbot:", state)
    end,
})
```

---

## 📋 API Reference

### `KrixUI:CreateWindow(options)`

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `Title` | string | `"KrixUI"` | Window title |
| `Subtitle` | string | `"v1.0"` | Subtitle next to title |
| `Size` | UDim2 | `600×420` | Window size |
| `Position` | UDim2 | centered | Initial position |

Returns a **Window** object.

---

### `Window:AddTab(options)`

| Option | Type | Description |
|--------|------|-------------|
| `Name` | string | Tab label |
| `Icon` | string | Emoji icon (optional) |

Returns a **Tab** object.

---

### `Tab:AddSection(name)`

Returns a **Section** object.

---

### `Section:AddButton(options)`

| Option | Type | Description |
|--------|------|-------------|
| `Name` | string | Button label |
| `Description` | string | Sub-text (optional) |
| `Callback` | function | Fires on click |

---

### `Section:AddToggle(options)`

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `Name` | string | — | Label |
| `Default` | bool | `false` | Initial state |
| `Callback` | function(bool) | — | Fires on change |

**Methods:** `:Set(bool)`, `:Get()` → bool

---

### `Section:AddSlider(options)`

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `Name` | string | — | Label |
| `Min` | number | `0` | Minimum value |
| `Max` | number | `100` | Maximum value |
| `Default` | number | `Min` | Initial value |
| `Suffix` | string | `""` | Value suffix (e.g. `" px"`) |
| `Callback` | function(number) | — | Fires on change |

**Methods:** `:Set(number)`, `:Get()` → number

---

### `Section:AddDropdown(options)`

| Option | Type | Description |
|--------|------|-------------|
| `Name` | string | Label |
| `Items` | table | List of strings |
| `Default` | string | Initially selected item |
| `Callback` | function(string) | Fires on selection |

**Methods:** `:Set(string)`, `:Get()` → string, `:Refresh(table)`

---

### `Section:AddTextBox(options)`

| Option | Type | Description |
|--------|------|-------------|
| `Name` | string | Label |
| `Placeholder` | string | Placeholder text |
| `Default` | string | Default value |
| `Callback` | function(string) | Fires on Enter |

**Methods:** `:Set(string)`, `:Get()` → string

---

### `Section:AddKeybind(options)`

| Option | Type | Description |
|--------|------|-------------|
| `Name` | string | Label |
| `Default` | KeyCode | Default key |
| `Callback` | function | Fires when key is pressed |

**Methods:** `:Set(KeyCode)`, `:Get()` → KeyCode

---

### `Section:AddLabel(options)`

| Option | Type | Description |
|--------|------|-------------|
| `Text` | string | Label text |

**Methods:** `:Set(string)`, `:Get()` → string

---

### `Section:AddSeparator()`

Adds a thin horizontal separator line.

---

### `Window:Notify(options)`

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `Title` | string | `"KrixUI"` | Notification title |
| `Description` | string | `""` | Body text |
| `Type` | string | `"Info"` | `"Info"` \| `"Success"` \| `"Error"` |
| `Duration` | number | `4` | Seconds before auto-dismiss |

---

## 🎨 Theme

The theme is defined in `KrixUI.Theme` and can be modified before creating a window:

```lua
KrixUI.Theme.Accent = Color3.fromRGB(0, 170, 255)
```

---

## 📁 Files

| File | Description |
|------|-------------|
| `UILib.lua` | Main library source |
| `Load.lua` | Minimal loadstring loader |
| `Example.lua` | Full featured usage example |

---

## ⚠️ Disclaimer

This library is intended for **educational purposes** only. Use responsibly and respect Roblox's Terms of Service.
