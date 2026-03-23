# KrixUI v3.0

> A clean, modern Roblox UI library with a refined dark red theme.  
> Sharp corners, smooth Quint animations, sidebar navigation, notifications.

![Theme](https://img.shields.io/badge/Theme-Refined%20Dark%20Red-B92323?style=flat-square)
![Version](https://img.shields.io/badge/Version-3.0-333?style=flat-square)

---

## Installation

Paste this into your executor:

```lua
local KrixUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/lfw5/UI-lib/refs/heads/main/UILib.lua"))()
```

---

## Key System (Junkie)

KrixUI has a built-in key validation system powered by Junkie. Just call `KeySystem()` before `CreateWindow()`.

```lua
local KrixUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/lfw5/UI-lib/refs/heads/main/UILib.lua"))()

-- Enable key system (blocks until validated)
KrixUI:KeySystem({
    Enabled    = true,           -- true to enable, false to skip
    Service    = "key",          -- Your Junkie service name
    Identifier = "1058257",      -- Your Junkie user ID
    Provider   = "key",          -- Your provider name
    MaxAttempts = 5,             -- Max failed attempts (optional, default: 5)
})

-- Only runs after key is validated
local Window = KrixUI:CreateWindow({ Title = "My Script" })
```

### KeySystem Options

| Option        | Type      | Default | Description                                |
|---------------|-----------|---------|--------------------------------------------|
| `Enabled`     | `boolean` | `true`  | Set to `false` to skip key validation      |
| `Service`     | `string`  | `"key"` | Your Junkie service name                   |
| `Identifier`  | `string`  | `"0"`   | Your Junkie user ID                        |
| `Provider`    | `string`  | `"key"` | Your provider name                         |
| `MaxAttempts` | `number`  | `5`     | Max failed key attempts before auto-close  |

### Disabling the Key System

To temporarily disable key validation during development:

```lua
KrixUI:KeySystem({
    Enabled = false,   -- Skips the key UI entirely
})
```

---

## Quick Start

```lua
local KrixUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/lfw5/UI-lib/refs/heads/main/UILib.lua"))()

local Window = KrixUI:CreateWindow({
    Title     = "My Script",
    Subtitle  = "v1.0",
    Size      = UDim2.new(0, 700, 0, 480),
    ToggleKey = Enum.KeyCode.RightControl,
})

local Tab = Window:AddTab({ Name = "Main" })
local Section = Tab:AddSection("General")

Section:AddButton({
    Name = "Click Me",
    Callback = function()
        Window:Notify({ Title = "Hello", Description = "Button clicked!", Type = "Success" })
    end,
})
```

---

## API Reference

### `KrixUI:CreateWindow(options)`

| Option      | Type        | Default                | Description                    |
|-------------|-------------|------------------------|--------------------------------|
| `Title`     | `string`    | `"KrixUI"`             | Window title                   |
| `Subtitle`  | `string`    | `"v3.0"`               | Subtitle under title           |
| `Size`      | `UDim2`     | `700x480`              | Window size                    |
| `Position`  | `UDim2`     | Centered               | Window position                |
| `ToggleKey` | `KeyCode`   | `RightControl`         | Key to show/hide the UI        |

Returns a `Window` object.

---

### `Window:AddTab(options)`

| Option  | Type     | Default | Description       |
|---------|----------|---------|-------------------|
| `Name`  | `string` | `"Tab"` | Tab display name  |
| `Icon`  | `string` | `""`    | Optional icon text |

Returns a `Tab` object.

---

### `Tab:AddSection(name)`

Creates a collapsible section with a header. Returns a `Section` object.

---

### Section Elements

#### `Section:AddButton(options)`

```lua
Section:AddButton({
    Name = "Run Script",
    Callback = function() print("Clicked") end,
})
```

#### `Section:AddToggle(options)`

```lua
local toggle = Section:AddToggle({
    Name = "Enable Feature",
    Default = false,
    Callback = function(state) print("Toggle:", state) end,
})
-- toggle:Set(true)  toggle:Get()
```

#### `Section:AddSlider(options)`

```lua
local slider = Section:AddSlider({
    Name = "Speed",
    Min = 0, Max = 100,
    Default = 50,
    Suffix = "%",
    Increment = 1,
    Callback = function(value) print("Value:", value) end,
})
-- slider:Set(75)  slider:Get()
```

#### `Section:AddDropdown(options)`

```lua
local dropdown = Section:AddDropdown({
    Name = "Mode",
    Items = { "Option A", "Option B", "Option C" },
    Default = "Option A",
    Callback = function(selected) print("Selected:", selected) end,
})
-- dropdown:Set("Option B")  dropdown:Get()  dropdown:Refresh(newItems)
```

#### `Section:AddTextBox(options)`

```lua
local textbox = Section:AddTextBox({
    Name = "Player Name",
    Default = "",
    Placeholder = "Enter name...",
    Callback = function(text) print("Input:", text) end,
})
-- textbox:Set("value")  textbox:Get()
```

#### `Section:AddKeybind(options)`

```lua
local keybind = Section:AddKeybind({
    Name = "Toggle Key",
    Default = Enum.KeyCode.E,
    Callback = function() print("Key pressed") end,
})
-- keybind:Set(Enum.KeyCode.F)  keybind:Get()
```

#### `Section:AddLabel(options)`

```lua
local label = Section:AddLabel({ Text = "Status: Ready" })
-- label:Set("Status: Running")  label:Get()
```

#### `Section:AddSeparator()`

```lua
Section:AddSeparator()
```

#### `Section:AddParagraph(options)`

```lua
Section:AddParagraph({
    Title = "Info",
    Content = "This is a paragraph block with wrapped text.",
})
```

---

### `Window:Notify(options)`

```lua
Window:Notify({
    Title = "KrixUI",
    Description = "Operation complete.",
    Type = "Success",   -- "Success" | "Error" | "Warning" | "Info"
    Duration = 4,
})
```

---

## Theme

KrixUI v3.0 uses a **Refined Dark Red** theme:

- **Background**: Near-black (`13, 13, 15`)
- **Accent**: Deep red (`185, 35, 35`)
- **No rounded corners** — all sharp edges
- **Smooth Quint easing** animations
- **Sidebar** with avatar and player name
- **UIStroke** borders for clean outlines

---

## Files

| File             | Description                                          |
|------------------|------------------------------------------------------|
| `UILib.lua`      | Main library — host on GitHub, load via `loadstring`  |
| `Example.lua`    | Full demo with all elements (uses `loadstring`)       |
| `Load.lua`       | Minimal one-liner loader                              |
| `TestDirect.lua` | Library + demo inlined for local testing              |

---

## Features

- Draggable window
- Minimize / Close buttons
- Toggle key (default: Right Ctrl)
- Sidebar navigation with active indicator
- Player avatar + username display
- Animated notifications with progress bar
- Button, Toggle, Slider, Dropdown, TextBox, Keybind, Label, Separator, Paragraph
- Smooth open/close animations
- Executor compatible (`gethui`, `syn.protect_gui`)

---

**Made by Krix**
