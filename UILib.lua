-- ============================================================
--   KrixUI v3.0 - Modern Roblox UI Library
--   Author  : Krix
--   Theme   : Refined Dark Red
--   Clean, mature, minimal design
--   GitHub  : https://github.com/lfw5/UI-lib
-- ============================================================

local lib = {}
lib.__index = lib

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local CoreGui          = game:GetService("CoreGui")
local LocalPlayer      = Players.LocalPlayer

local function Tween(obj, props, dur, style, dir)
    dur   = dur   or 0.3
    style = style or Enum.EasingStyle.Quint
    dir   = dir   or Enum.EasingDirection.Out
    local t = TweenService:Create(obj, TweenInfo.new(dur, style, dir), props)
    t:Play()
    return t
end

local function Create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then obj[k] = v end
    end
    if props.Parent then obj.Parent = props.Parent end
    return obj
end

local function MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = input.Position
            startPos  = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ── Theme: Refined Dark ────────────────────────────────────
local Theme = {
    Background       = Color3.fromRGB(13, 13, 15),
    TopBar           = Color3.fromRGB(17, 17, 20),
    TabBar           = Color3.fromRGB(15, 15, 17),
    TabActive        = Color3.fromRGB(175, 30, 35),
    TabHover         = Color3.fromRGB(24, 20, 22),
    TabInactive      = Color3.fromRGB(17, 17, 20),
    Section          = Color3.fromRGB(17, 17, 20),
    SectionHeader    = Color3.fromRGB(14, 14, 16),
    Element          = Color3.fromRGB(21, 21, 24),
    ElementHover     = Color3.fromRGB(28, 24, 26),
    Accent           = Color3.fromRGB(185, 35, 35),
    AccentLight      = Color3.fromRGB(220, 55, 50),
    AccentDark       = Color3.fromRGB(100, 18, 18),
    TextPrimary      = Color3.fromRGB(220, 220, 225),
    TextSecondary    = Color3.fromRGB(120, 120, 130),
    TextMuted        = Color3.fromRGB(65, 65, 72),
    TextAccent       = Color3.fromRGB(210, 65, 55),
    ToggleOn         = Color3.fromRGB(185, 35, 35),
    ToggleOff        = Color3.fromRGB(38, 38, 42),
    SliderFill       = Color3.fromRGB(185, 35, 35),
    SliderBg         = Color3.fromRGB(28, 28, 32),
    InputBg          = Color3.fromRGB(10, 10, 12),
    InputBorder      = Color3.fromRGB(36, 28, 30),
    Border           = Color3.fromRGB(28, 22, 24),
    BorderAccent     = Color3.fromRGB(60, 22, 24),
    Divider          = Color3.fromRGB(28, 24, 26),
    Success          = Color3.fromRGB(45, 185, 70),
    Warning          = Color3.fromRGB(230, 170, 30),
    Error            = Color3.fromRGB(220, 50, 50),
    Info             = Color3.fromRGB(55, 125, 220),
}
lib.Theme = Theme

pcall(function()
    local old = CoreGui:FindFirstChild("KrixUI_v3")
    if old then old:Destroy() end
end)

function lib:CreateWindow(options)
    options = options or {}
    local title    = options.Title    or "KrixUI"
    local subtitle = options.Subtitle or "v3.0"
    local size     = options.Size     or UDim2.new(0, 700, 0, 480)
    local pos      = options.Position or UDim2.new(0.5, -350, 0.5, -240)
    local key      = options.ToggleKey or Enum.KeyCode.RightControl

    local guiParent = CoreGui
    pcall(function() if gethui then guiParent = gethui() end end)

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name           = "KrixUI_v3"
    ScreenGui.ResetOnSpawn   = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.IgnoreGuiInset = true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end end)
    ScreenGui.Parent = guiParent

    -- Outer frame
    local StrokeFrame = Create("Frame", {
        Name = "Main", Size = size, Position = pos,
        BackgroundTransparency = 1, BorderSizePixel = 0,
        ClipsDescendants = false, Parent = ScreenGui,
    })
    Create("UIStroke", { Color = Theme.BorderAccent, Thickness = 1, Transparency = 0.4, Parent = StrokeFrame })

    -- Main frame
    local Main = Create("Frame", {
        Name = "MainInner", Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Theme.Background, BorderSizePixel = 0,
        ClipsDescendants = true, ZIndex = 1, Parent = StrokeFrame,
    })
    local ClipFrame = Main

    -- ── Top Bar ───────────────────────────────────────────
    local TopBar = Create("Frame", {
        Name = "TopBar", Size = UDim2.new(1, 0, 0, 48),
        BackgroundColor3 = Theme.TopBar, BorderSizePixel = 0,
        ZIndex = 5, Parent = ClipFrame,
    })

    -- Thin accent line at the very top
    Create("Frame", {
        Size = UDim2.new(1, 0, 0, 2), Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Theme.Accent, BorderSizePixel = 0,
        ZIndex = 10, Parent = TopBar,
    })

    -- Bottom border
    Create("Frame", {
        Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = Theme.Border, BorderSizePixel = 0,
        ZIndex = 6, Parent = TopBar,
    })

    -- Logo block
    local logoBg = Create("Frame", {
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(0, 14, 0, 12),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0, ZIndex = 6, Parent = TopBar,
    })
    Create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
        Text = "K", Font = Enum.Font.GothamBold, TextSize = 14,
        TextColor3 = Color3.fromRGB(255,255,255), ZIndex = 7, Parent = logoBg,
    })

    -- Title
    Create("TextLabel", {
        Size = UDim2.new(0, 200, 0, 18), Position = UDim2.new(0, 50, 0, 10),
        BackgroundTransparency = 1, Text = title,
        Font = Enum.Font.GothamBold, TextSize = 15,
        TextColor3 = Theme.TextPrimary, TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 6, Parent = TopBar,
    })
    Create("TextLabel", {
        Size = UDim2.new(0, 200, 0, 14), Position = UDim2.new(0, 50, 0, 28),
        BackgroundTransparency = 1, Text = subtitle,
        Font = Enum.Font.Gotham, TextSize = 11,
        TextColor3 = Theme.TextMuted, TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 6, Parent = TopBar,
    })

    -- Close
    local CloseBtn = Create("TextButton", {
        Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(1, -40, 0.5, -14),
        BackgroundColor3 = Theme.Element, BackgroundTransparency = 1,
        Text = "X", Font = Enum.Font.GothamBold, TextSize = 12,
        TextColor3 = Theme.TextMuted, BorderSizePixel = 0, ZIndex = 6, Parent = TopBar,
    })
    CloseBtn.MouseEnter:Connect(function()
        Tween(CloseBtn, { BackgroundTransparency = 0, BackgroundColor3 = Theme.Accent, TextColor3 = Color3.fromRGB(255,255,255) }, 0.2)
    end)
    CloseBtn.MouseLeave:Connect(function()
        Tween(CloseBtn, { BackgroundTransparency = 1, TextColor3 = Theme.TextMuted }, 0.2)
    end)
    CloseBtn.MouseButton1Click:Connect(function()
        Tween(StrokeFrame, { Size = UDim2.new(0, size.X.Offset, 0, 0), BackgroundTransparency = 1 }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.35)
        ScreenGui:Destroy()
    end)

    -- Minimize
    local MinBtn = Create("TextButton", {
        Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(1, -72, 0.5, -14),
        BackgroundColor3 = Theme.Element, BackgroundTransparency = 1,
        Text = "-", Font = Enum.Font.GothamBold, TextSize = 16,
        TextColor3 = Theme.TextMuted, BorderSizePixel = 0, ZIndex = 6, Parent = TopBar,
    })
    MinBtn.MouseEnter:Connect(function()
        Tween(MinBtn, { BackgroundTransparency = 0, TextColor3 = Theme.TextPrimary }, 0.2)
    end)
    MinBtn.MouseLeave:Connect(function()
        Tween(MinBtn, { BackgroundTransparency = 1, TextColor3 = Theme.TextMuted }, 0.2)
    end)

    local minimized = false
    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Tween(StrokeFrame, { Size = UDim2.new(0, size.X.Offset, 0, 48) }, 0.35, Enum.EasingStyle.Back)
        else
            Tween(StrokeFrame, { Size = size }, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        end
    end)

    MakeDraggable(StrokeFrame, TopBar)

    -- Toggle key
    local guiVisible = true
    UserInputService.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.KeyCode == key then
            guiVisible = not guiVisible
            StrokeFrame.Visible = guiVisible
        end
    end)

    -- ── Sidebar ───────────────────────────────────────────
    local Sidebar = Create("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 150, 1, -48),
        Position = UDim2.new(0, 0, 0, 48),
        BackgroundColor3 = Theme.TabBar,
        BorderSizePixel = 0, ZIndex = 3, Parent = ClipFrame,
    })

    -- Sidebar right border
    Create("Frame", {
        Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = Theme.Border, BorderSizePixel = 0,
        ZIndex = 4, Parent = Sidebar,
    })

    -- User info at bottom
    local userInfo = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 50), Position = UDim2.new(0, 0, 1, -50),
        BackgroundColor3 = Theme.SectionHeader, BackgroundTransparency = 0.3,
        BorderSizePixel = 0, ZIndex = 4, Parent = Sidebar,
    })
    Create("Frame", {
        Size = UDim2.new(1, -16, 0, 1), Position = UDim2.new(0, 8, 0, 0),
        BackgroundColor3 = Theme.Border, BorderSizePixel = 0, ZIndex = 4, Parent = userInfo,
    })

    local avatar = Create("Frame", {
        Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(0, 10, 0, 12),
        BackgroundColor3 = Theme.Accent, BorderSizePixel = 0, ZIndex = 5, Parent = userInfo,
    })
    pcall(function()
        Create("ImageLabel", {
            Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
            Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=48&h=48",
            ZIndex = 6, Parent = avatar,
        })
    end)
    Create("TextLabel", {
        Size = UDim2.new(1, -48, 0, 14), Position = UDim2.new(0, 44, 0, 12),
        BackgroundTransparency = 1, Text = LocalPlayer.Name,
        Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = Theme.TextPrimary,
        TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 5, Parent = userInfo,
    })
    Create("TextLabel", {
        Size = UDim2.new(1, -48, 0, 12), Position = UDim2.new(0, 44, 0, 26),
        BackgroundTransparency = 1, Text = "Online",
        Font = Enum.Font.Gotham, TextSize = 9, TextColor3 = Theme.Success,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 5, Parent = userInfo,
    })

    local TabList = Create("ScrollingFrame", {
        Name = "TabList", Size = UDim2.new(1, 0, 1, -56),
        Position = UDim2.new(0, 0, 0, 6),
        BackgroundTransparency = 1, BorderSizePixel = 0,
        ScrollBarThickness = 0, CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = 4, Parent = Sidebar,
    })
    Create("UIListLayout", { Padding = UDim.new(0, 1), HorizontalAlignment = Enum.HorizontalAlignment.Center, Parent = TabList })
    Create("UIPadding", { PaddingTop = UDim.new(0, 4), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), Parent = TabList })

    -- ── Content Area ──────────────────────────────────────
    local ContentArea = Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -150, 1, -48),
        Position = UDim2.new(0, 150, 0, 48),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0, ClipsDescendants = false,
        ZIndex = 2, Parent = ClipFrame,
    })

    -- Open animation
    StrokeFrame.Size = UDim2.new(0, 0, 0, 0)
    StrokeFrame.BackgroundTransparency = 1
    StrokeFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    Tween(StrokeFrame, { Size = size, Position = pos, BackgroundTransparency = 0 }, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    local Window = {
        ScreenGui = ScreenGui, Main = StrokeFrame,
        TabList = TabList, ContentArea = ContentArea,
        Tabs = {}, ActiveTab = nil,
    }

    -- ── Notifications ─────────────────────────────────────
    local notifContainer = Create("Frame", {
        Name = "Notifs", Size = UDim2.new(0, 300, 1, 0),
        Position = UDim2.new(1, -310, 0, 0),
        BackgroundTransparency = 1, BorderSizePixel = 0,
        ZIndex = 50, Parent = ScreenGui,
    })
    Create("UIListLayout", { VerticalAlignment = Enum.VerticalAlignment.Bottom, HorizontalAlignment = Enum.HorizontalAlignment.Right, Padding = UDim.new(0, 6), Parent = notifContainer })
    Create("UIPadding", { PaddingBottom = UDim.new(0, 20), Parent = notifContainer })

    function Window:Notify(opts)
        opts = opts or {}
        local nTitle = opts.Title or "KrixUI"
        local nDesc  = opts.Description or ""
        local nType  = opts.Type or "Info"
        local nDur   = opts.Duration or 4

        local col = Theme.Info
        if nType == "Success" then col = Theme.Success end
        if nType == "Error" then col = Theme.Error end
        if nType == "Warning" then col = Theme.Warning end

        local card = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 72),
            BackgroundTransparency = 1,
            BorderSizePixel = 0, ClipsDescendants = false,
            ZIndex = 51, Parent = notifContainer,
        })

        local cardInner = Create("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = Theme.TopBar,
            BorderSizePixel = 0, ClipsDescendants = true,
            ZIndex = 51, Parent = card,
        })
        Create("UIStroke", { Color = Theme.Border, Thickness = 1, Transparency = 0.3, Parent = cardInner })

        -- Left accent bar
        Create("Frame", {
            Size = UDim2.new(0, 3, 1, 0),
            BackgroundColor3 = col, BorderSizePixel = 0,
            ZIndex = 53, Parent = cardInner,
        })

        Create("TextLabel", {
            Size = UDim2.new(1, -20, 0, 16), Position = UDim2.new(0, 14, 0, 10),
            BackgroundTransparency = 1, Text = nTitle,
            Font = Enum.Font.GothamBold, TextSize = 12,
            TextColor3 = Theme.TextPrimary, TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 52, Parent = cardInner,
        })
        Create("TextLabel", {
            Size = UDim2.new(1, -20, 0, 28), Position = UDim2.new(0, 14, 0, 28),
            BackgroundTransparency = 1, Text = nDesc,
            Font = Enum.Font.Gotham, TextSize = 11,
            TextColor3 = Theme.TextSecondary, TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 52, Parent = cardInner,
        })

        -- Progress bar
        local progressBg = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 2), Position = UDim2.new(0, 0, 1, -2),
            BackgroundColor3 = Theme.Divider, BorderSizePixel = 0, ZIndex = 52, Parent = cardInner,
        })
        local progressFill = Create("Frame", {
            Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = col,
            BorderSizePixel = 0, ZIndex = 53, Parent = progressBg,
        })

        card.Position = UDim2.new(1, 50, 0, 0)
        Tween(card, { Position = UDim2.new(0, 0, 0, 0) }, 0.4, Enum.EasingStyle.Quint)
        Tween(progressFill, { Size = UDim2.new(0, 0, 1, 0) }, nDur, Enum.EasingStyle.Linear)

        task.delay(nDur, function()
            Tween(card, { Position = UDim2.new(1, 50, 0, 0) }, 0.35)
            task.wait(0.4)
            if card then card:Destroy() end
        end)
    end

    -- ── AddTab ────────────────────────────────────────────
    function Window:AddTab(tabOptions)
        tabOptions = tabOptions or {}
        local tabName = tabOptions.Name or "Tab"
        local tabIcon = tabOptions.Icon or ""
        local displayText = tabName
        if tabIcon ~= "" then displayText = tabIcon .. "  " .. tabName end

        local btnContainer = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1,
            BorderSizePixel = 0, ZIndex = 5, Parent = self.TabList,
        })

        -- Left indicator
        local indicator = Create("Frame", {
            Size = UDim2.new(0, 2, 0, 0),
            Position = UDim2.new(0, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = Theme.Accent,
            BorderSizePixel = 0, ZIndex = 7, Parent = btnContainer,
        })

        local btn = Create("TextButton", {
            Name = tabName, Size = UDim2.new(1, -4, 1, 0),
            Position = UDim2.new(0, 4, 0, 0),
            BackgroundColor3 = Theme.TabInactive, BackgroundTransparency = 1,
            Text = "", BorderSizePixel = 0, AutoButtonColor = false,
            ZIndex = 6, Parent = btnContainer,
        })

        local btnLabel = Create("TextLabel", {
            Size = UDim2.new(1, -14, 1, 0), Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1, Text = displayText,
            Font = Enum.Font.Gotham, TextSize = 12,
            TextColor3 = Theme.TextSecondary, TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 7, Parent = btn,
        })

        local page = Create("ScrollingFrame", {
            Name = tabName .. "Page", Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1, BorderSizePixel = 0,
            ScrollBarThickness = 2, ScrollBarImageColor3 = Theme.Accent,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false, ZIndex = 4, Parent = self.ContentArea,
        })
        Create("UIListLayout", { Padding = UDim.new(0, 8), Parent = page })
        Create("UIPadding", { PaddingTop = UDim.new(0, 12), PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12), Parent = page })

        local Tab = { Button = btn, Container = btnContainer, Indicator = indicator, Label = btnLabel, Page = page, Sections = {} }

        local function Activate()
            for _, t in pairs(self.Tabs) do
                Tween(t.Button, { BackgroundTransparency = 1 }, 0.2)
                t.Label.TextColor3 = Theme.TextSecondary
                t.Label.Font = Enum.Font.Gotham
                Tween(t.Indicator, { Size = UDim2.new(0, 2, 0, 0) }, 0.2)
                t.Page.Visible = false
            end
            Tween(btn, { BackgroundTransparency = 0.9, BackgroundColor3 = Theme.Accent }, 0.2)
            btnLabel.TextColor3 = Theme.TextPrimary
            btnLabel.Font = Enum.Font.GothamBold
            Tween(indicator, { Size = UDim2.new(0, 2, 0, 16) }, 0.25, Enum.EasingStyle.Back)
            page.Visible = true
            self.ActiveTab = Tab
        end

        btn.MouseButton1Click:Connect(Activate)
        btn.MouseEnter:Connect(function()
            if self.ActiveTab ~= Tab then Tween(btn, { BackgroundTransparency = 0.92, BackgroundColor3 = Theme.TabHover }, 0.15) end
        end)
        btn.MouseLeave:Connect(function()
            if self.ActiveTab ~= Tab then Tween(btn, { BackgroundTransparency = 1 }, 0.15) end
        end)

        table.insert(self.Tabs, Tab)
        if #self.Tabs == 1 then Activate() end

        -- ── AddSection ────────────────────────────────────
        function Tab:AddSection(sectionName)
            local sectionOuter = Create("Frame", {
                Name = sectionName, Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                BorderSizePixel = 0, ZIndex = 3, Parent = page,
            })
            Create("UIStroke", { Color = Theme.Border, Thickness = 1, Transparency = 0.4, Parent = sectionOuter })

            local section = Create("Frame", {
                Size = UDim2.new(1, 0, 1, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = Theme.Section,
                BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 3, Parent = sectionOuter,
            })

            -- Header
            local headerFrame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundColor3 = Theme.SectionHeader, BackgroundTransparency = 0.2,
                BorderSizePixel = 0, ZIndex = 4, Parent = section,
            })
            -- Header bottom line
            Create("Frame", {
                Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1),
                BackgroundColor3 = Theme.Border, BorderSizePixel = 0, ZIndex = 5, Parent = headerFrame,
            })
            -- Left accent on header
            Create("Frame", {
                Size = UDim2.new(0, 2, 0, 14), Position = UDim2.new(0, 8, 0.5, -7),
                BackgroundColor3 = Theme.Accent, BorderSizePixel = 0,
                ZIndex = 5, Parent = headerFrame,
            })

            Create("TextLabel", {
                Size = UDim2.new(1, -24, 1, 0), Position = UDim2.new(0, 18, 0, 0),
                BackgroundTransparency = 1, Text = string.upper(sectionName),
                Font = Enum.Font.GothamBold, TextSize = 10,
                TextColor3 = Theme.TextAccent, TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 5, Parent = headerFrame,
            })

            local itemList = Create("Frame", {
                Name = "Items", Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 0, 34),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1, ZIndex = 4, Parent = section,
            })
            Create("UIListLayout", { Padding = UDim.new(0, 2), Parent = itemList })
            Create("UIPadding", { PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6), Parent = itemList })

            local Section = {}

            function Section:AddButton(opts)
                opts = opts or {}
                local callback = opts.Callback or function() end
                local elem = Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = Theme.Element,
                    Text = "", BorderSizePixel = 0, AutoButtonColor = false,
                    ClipsDescendants = true, ZIndex = 5, Parent = itemList,
                })
                Create("TextLabel", {
                    Size = UDim2.new(1, -100, 1, 0), Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1, Text = opts.Name or "Button",
                    Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = Theme.TextPrimary,
                    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6, Parent = elem,
                })
                local execBtn = Create("TextButton", {
                    Size = UDim2.new(0, 80, 0, 26), Position = UDim2.new(1, -88, 0.5, -13),
                    BackgroundColor3 = Theme.Accent, Text = "Run",
                    Font = Enum.Font.GothamBold, TextSize = 11,
                    TextColor3 = Color3.fromRGB(255,255,255), BorderSizePixel = 0,
                    ZIndex = 7, Parent = elem,
                })
                execBtn.MouseButton1Click:Connect(function()
                    Tween(execBtn, { BackgroundTransparency = 0.3 }, 0.08)
                    task.wait(0.08)
                    Tween(execBtn, { BackgroundTransparency = 0 }, 0.1)
                    callback()
                end)
                elem.MouseEnter:Connect(function() Tween(elem, { BackgroundColor3 = Theme.ElementHover }, 0.15) end)
                elem.MouseLeave:Connect(function() Tween(elem, { BackgroundColor3 = Theme.Element }, 0.15) end)
                return elem
            end

            function Section:AddToggle(opts)
                opts = opts or {}
                local state = opts.Default or false
                local callback = opts.Callback or function() end
                local elem = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = Theme.Element,
                    BorderSizePixel = 0, ZIndex = 5, Parent = itemList,
                })
                Create("TextLabel", {
                    Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1, Text = opts.Name or "Toggle",
                    Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = Theme.TextPrimary,
                    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6, Parent = elem,
                })
                local onCol = Theme.ToggleOn
                local offCol = Theme.ToggleOff
                local onPos = UDim2.new(1, -18, 0.5, -7)
                local offPos = UDim2.new(0, 3, 0.5, -7)
                local initCol = state and onCol or offCol
                local initPos = state and onPos or offPos

                local trackBg = Create("Frame", {
                    Size = UDim2.new(0, 38, 0, 20), Position = UDim2.new(1, -48, 0.5, -10),
                    BackgroundColor3 = initCol, BorderSizePixel = 0, ZIndex = 6, Parent = elem,
                })
                local knob = Create("Frame", {
                    Size = UDim2.new(0, 14, 0, 14), Position = initPos,
                    BackgroundColor3 = Color3.fromRGB(255,255,255),
                    BorderSizePixel = 0, ZIndex = 7, Parent = trackBg,
                })

                local function UpdateToggle()
                    Tween(trackBg, { BackgroundColor3 = state and onCol or offCol }, 0.25)
                    Tween(knob, { Position = state and onPos or offPos }, 0.25, Enum.EasingStyle.Quint)
                end

                local clickArea = Create("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
                    Text = "", ZIndex = 8, Parent = elem,
                })
                clickArea.MouseButton1Click:Connect(function() state = not state; UpdateToggle(); callback(state) end)
                elem.MouseEnter:Connect(function() Tween(elem, { BackgroundColor3 = Theme.ElementHover }, 0.15) end)
                elem.MouseLeave:Connect(function() Tween(elem, { BackgroundColor3 = Theme.Element }, 0.15) end)
                local ToggleObj = {}
                function ToggleObj:Set(v) state = v; UpdateToggle(); callback(state) end
                function ToggleObj:Get() return state end
                return ToggleObj
            end

            function Section:AddSlider(opts)
                opts = opts or {}
                local min = opts.Min or 0
                local max = opts.Max or 100
                local value = math.clamp(opts.Default or min, min, max)
                local suffix = opts.Suffix or ""
                local increment = opts.Increment or 1
                local callback = opts.Callback or function() end
                local elem = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 50), BackgroundColor3 = Theme.Element,
                    BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 5, Parent = itemList,
                })
                Create("TextLabel", {
                    Size = UDim2.new(0.6, 0, 0, 18), Position = UDim2.new(0, 10, 0, 5),
                    BackgroundTransparency = 1, Text = opts.Name or "Slider",
                    Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = Theme.TextPrimary,
                    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6, Parent = elem,
                })
                local valLabel = Create("TextLabel", {
                    Size = UDim2.new(0.4, -12, 0, 18), Position = UDim2.new(0.6, 0, 0, 5),
                    BackgroundTransparency = 1, Text = tostring(value) .. suffix,
                    Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Theme.TextAccent,
                    TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 6, Parent = elem,
                })
                local trackContainer = Create("Frame", {
                    Size = UDim2.new(1, -20, 0, 16), Position = UDim2.new(0, 10, 0, 28),
                    BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 6, Parent = elem,
                })
                local track = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 4), Position = UDim2.new(0, 0, 0.5, -2),
                    BackgroundColor3 = Theme.SliderBg, BorderSizePixel = 0, ZIndex = 6, Parent = trackContainer,
                })
                local initRel = (value - min) / (max - min)
                local fill = Create("Frame", {
                    Size = UDim2.new(initRel, 0, 1, 0), BackgroundColor3 = Theme.SliderFill,
                    BorderSizePixel = 0, ZIndex = 7, Parent = track,
                })
                local thumb = Create("Frame", {
                    Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(initRel, -6, 0.5, -6),
                    BackgroundColor3 = Color3.fromRGB(255,255,255),
                    BorderSizePixel = 0, ZIndex = 8, Parent = trackContainer,
                })
                Create("UIStroke", { Color = Theme.Accent, Thickness = 1.5, Parent = thumb })
                local sliding = false
                trackContainer.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true end end)
                UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end end)
                UserInputService.InputChanged:Connect(function(inp)
                    if sliding and inp.UserInputType == Enum.UserInputType.MouseMovement then
                        local rel = math.clamp((inp.Position.X - trackContainer.AbsolutePosition.X) / trackContainer.AbsoluteSize.X, 0, 1)
                        local raw = min + (max - min) * rel
                        local stepped = math.floor(raw / increment + 0.5) * increment
                        stepped = math.clamp(stepped, min, max)
                        if stepped ~= value then
                            value = stepped
                            local actualRel = (value - min) / (max - min)
                            fill.Size = UDim2.new(actualRel, 0, 1, 0)
                            thumb.Position = UDim2.new(actualRel, -6, 0.5, -6)
                            valLabel.Text = tostring(value) .. suffix
                            callback(value)
                        end
                    end
                end)
                elem.MouseEnter:Connect(function() Tween(elem, { BackgroundColor3 = Theme.ElementHover }, 0.15) end)
                elem.MouseLeave:Connect(function() Tween(elem, { BackgroundColor3 = Theme.Element }, 0.15) end)
                local SliderObj = {}
                function SliderObj:Set(v) value = math.clamp(v, min, max); local r = (value-min)/(max-min); fill.Size = UDim2.new(r,0,1,0); thumb.Position = UDim2.new(r,-6,0.5,-6); valLabel.Text = tostring(value)..suffix; callback(value) end
                function SliderObj:Get() return value end
                return SliderObj
            end

            function Section:AddDropdown(opts)
                opts = opts or {}
                local items = opts.Items or {}
                local selected = opts.Default or (items[1] or "Select")
                local callback = opts.Callback or function() end
                local open = false
                local elem = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = Theme.Element,
                    BorderSizePixel = 0, ClipsDescendants = false, ZIndex = 5, Parent = itemList,
                })
                Create("TextLabel", {
                    Size = UDim2.new(0.45, 0, 1, 0), Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1, Text = opts.Name or "Dropdown",
                    Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = Theme.TextPrimary,
                    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6, Parent = elem,
                })
                local selBtn = Create("TextButton", {
                    Size = UDim2.new(0.55, -12, 0, 26), Position = UDim2.new(0.45, 0, 0.5, -13),
                    BackgroundColor3 = Theme.InputBg, Text = "", BorderSizePixel = 0, ZIndex = 6, Parent = elem,
                })
                Create("UIStroke", { Color = Theme.InputBorder, Thickness = 1, Parent = selBtn })
                local selLabel = Create("TextLabel", {
                    Size = UDim2.new(1, -24, 1, 0), Position = UDim2.new(0, 8, 0, 0),
                    BackgroundTransparency = 1, Text = selected,
                    Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = Theme.TextAccent,
                    TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
                    ZIndex = 7, Parent = selBtn,
                })
                local arrow = Create("TextLabel", {
                    Size = UDim2.new(0, 14, 1, 0), Position = UDim2.new(1, -16, 0, 0),
                    BackgroundTransparency = 1, Text = "v", Font = Enum.Font.GothamBold,
                    TextSize = 10, TextColor3 = Theme.TextMuted, ZIndex = 7, Parent = selBtn,
                })

                -- dropFrame parented to ContentArea so it renders above everything
                local dropFrame = Create("Frame", {
                    Size = UDim2.new(0, 0, 0, 0),
                    BackgroundColor3 = Theme.InputBg, BorderSizePixel = 0,
                    ClipsDescendants = true, ZIndex = 100, Visible = false,
                    Parent = ContentArea,
                })
                Create("UIStroke", { Color = Theme.Accent, Thickness = 1, Transparency = 0.5, Parent = dropFrame })
                local dropScroll = Create("ScrollingFrame", {
                    Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
                    BorderSizePixel = 0, ScrollBarThickness = 2, ScrollBarImageColor3 = Theme.Accent,
                    CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ZIndex = 101, Parent = dropFrame,
                })
                Create("UIListLayout", { Padding = UDim.new(0, 1), Parent = dropScroll })
                Create("UIPadding", { PaddingTop = UDim.new(0, 3), PaddingBottom = UDim.new(0, 3), PaddingLeft = UDim.new(0, 3), PaddingRight = UDim.new(0, 3), Parent = dropScroll })

                local function BuildItems()
                    for _, c in pairs(dropScroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
                    for _, item in ipairs(items) do
                        local isS = (item == selected)
                        local iBtn = Create("TextButton", {
                            Size = UDim2.new(1, 0, 0, 26),
                            BackgroundColor3 = isS and Theme.Accent or Theme.TabInactive,
                            BackgroundTransparency = isS and 0.3 or 0.7,
                            Text = item, Font = Enum.Font.Gotham, TextSize = 11,
                            TextColor3 = isS and Theme.TextPrimary or Theme.TextSecondary,
                            BorderSizePixel = 0, ZIndex = 102, Parent = dropScroll,
                        })
                        iBtn.MouseEnter:Connect(function()
                            if not isS then Tween(iBtn, { BackgroundTransparency = 0.4 }, 0.1) end
                        end)
                        iBtn.MouseLeave:Connect(function()
                            if not isS then Tween(iBtn, { BackgroundTransparency = 0.7 }, 0.1) end
                        end)
                        iBtn.MouseButton1Click:Connect(function()
                            selected = item; selLabel.Text = item; open = false
                            Tween(dropFrame, { Size = UDim2.new(0, dropFrame.AbsoluteSize.X, 0, 0) }, 0.2)
                            task.delay(0.2, function() dropFrame.Visible = false end)
                            arrow.Text = "v"; BuildItems(); callback(selected)
                        end)
                    end
                end
                BuildItems()

                local function OpenDrop()
                    local caPos  = ContentArea.AbsolutePosition
                    local btnPos = selBtn.AbsolutePosition
                    local btnSize = selBtn.AbsoluteSize
                    local w = btnSize.X
                    local h = math.min(#items * 28 + 8, 150)
                    local x = btnPos.X - caPos.X
                    local y = btnPos.Y - caPos.Y + btnSize.Y + 3
                    dropFrame.Position = UDim2.new(0, x, 0, y)
                    dropFrame.Size = UDim2.new(0, w, 0, 0)
                    dropFrame.Visible = true
                    Tween(dropFrame, { Size = UDim2.new(0, w, 0, h) }, 0.25, Enum.EasingStyle.Quint)
                    arrow.Text = "^"
                end

                local function CloseDrop()
                    Tween(dropFrame, { Size = UDim2.new(0, dropFrame.AbsoluteSize.X, 0, 0) }, 0.2)
                    task.delay(0.2, function() dropFrame.Visible = false end)
                    arrow.Text = "v"
                end

                selBtn.MouseButton1Click:Connect(function()
                    open = not open
                    if open then OpenDrop() else CloseDrop() end
                end)
                elem.MouseEnter:Connect(function() Tween(elem, { BackgroundColor3 = Theme.ElementHover }, 0.15) end)
                elem.MouseLeave:Connect(function() Tween(elem, { BackgroundColor3 = Theme.Element }, 0.15) end)
                local DropObj = {}
                function DropObj:Set(v) selected = v; selLabel.Text = v; BuildItems(); callback(v) end
                function DropObj:Get() return selected end
                function DropObj:Refresh(n) items = n; BuildItems() end
                return DropObj
            end

            function Section:AddTextBox(opts)
                opts = opts or {}
                local callback = opts.Callback or function() end
                local elem = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 52), BackgroundColor3 = Theme.Element,
                    BorderSizePixel = 0, ZIndex = 5, Parent = itemList,
                })
                Create("TextLabel", {
                    Size = UDim2.new(1, -16, 0, 18), Position = UDim2.new(0, 10, 0, 4),
                    BackgroundTransparency = 1, Text = opts.Name or "Input",
                    Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = Theme.TextSecondary,
                    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6, Parent = elem,
                })
                local boxBg = Create("Frame", {
                    Size = UDim2.new(1, -16, 0, 22), Position = UDim2.new(0, 8, 0, 24),
                    BackgroundColor3 = Theme.InputBg, BorderSizePixel = 0, ZIndex = 6, Parent = elem,
                })
                local boxStroke = Create("UIStroke", { Color = Theme.InputBorder, Thickness = 1, Parent = boxBg })
                local box = Create("TextBox", {
                    Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 5, 0, 0),
                    BackgroundTransparency = 1, Text = opts.Default or "",
                    PlaceholderText = opts.Placeholder or "Type here...",
                    PlaceholderColor3 = Theme.TextMuted, Font = Enum.Font.Gotham,
                    TextSize = 11, TextColor3 = Theme.TextPrimary,
                    TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false,
                    BorderSizePixel = 0, ZIndex = 7, Parent = boxBg,
                })
                box.Focused:Connect(function() Tween(boxStroke, { Color = Theme.Accent }, 0.2) end)
                box.FocusLost:Connect(function(enter) Tween(boxStroke, { Color = Theme.InputBorder }, 0.2); if enter then callback(box.Text) end end)
                elem.MouseEnter:Connect(function() Tween(elem, { BackgroundColor3 = Theme.ElementHover }, 0.15) end)
                elem.MouseLeave:Connect(function() Tween(elem, { BackgroundColor3 = Theme.Element }, 0.15) end)
                local BoxObj = {}
                function BoxObj:Set(v) box.Text = v end
                function BoxObj:Get() return box.Text end
                return BoxObj
            end

            function Section:AddKeybind(opts)
                opts = opts or {}
                local current = opts.Default or Enum.KeyCode.Unknown
                local callback = opts.Callback or function() end
                local listening = false
                local elem = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = Theme.Element,
                    BorderSizePixel = 0, ZIndex = 5, Parent = itemList,
                })
                Create("TextLabel", {
                    Size = UDim2.new(0.5, 0, 1, 0), Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1, Text = opts.Name or "Keybind",
                    Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = Theme.TextPrimary,
                    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6, Parent = elem,
                })
                local keyBtn = Create("TextButton", {
                    Size = UDim2.new(0, 80, 0, 26), Position = UDim2.new(1, -88, 0.5, -13),
                    BackgroundColor3 = Theme.InputBg, Text = current.Name,
                    Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = Theme.TextAccent,
                    BorderSizePixel = 0, ZIndex = 7, Parent = elem,
                })
                Create("UIStroke", { Color = Theme.InputBorder, Thickness = 1, Parent = keyBtn })
                keyBtn.MouseButton1Click:Connect(function()
                    listening = true; keyBtn.Text = "..."; keyBtn.TextColor3 = Theme.Warning
                    Tween(keyBtn, { BackgroundColor3 = Theme.AccentDark }, 0.15)
                end)
                UserInputService.InputBegan:Connect(function(inp, gpe)
                    if gpe then return end
                    if listening and inp.UserInputType == Enum.UserInputType.Keyboard then
                        current = inp.KeyCode; listening = false
                        keyBtn.Text = current.Name; keyBtn.TextColor3 = Theme.TextAccent
                        Tween(keyBtn, { BackgroundColor3 = Theme.InputBg }, 0.15)
                    elseif not listening and inp.KeyCode == current then
                        callback()
                    end
                end)
                elem.MouseEnter:Connect(function() Tween(elem, { BackgroundColor3 = Theme.ElementHover }, 0.15) end)
                elem.MouseLeave:Connect(function() Tween(elem, { BackgroundColor3 = Theme.Element }, 0.15) end)
                local KeyObj = {}
                function KeyObj:Set(k) current = k; keyBtn.Text = k.Name end
                function KeyObj:Get() return current end
                return KeyObj
            end

            function Section:AddLabel(opts)
                opts = opts or {}
                local lbl = Create("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1,
                    Text = opts.Text or "Label", Font = Enum.Font.Gotham, TextSize = 12,
                    TextColor3 = Theme.TextSecondary, TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 6, Parent = itemList,
                })
                Create("UIPadding", { PaddingLeft = UDim.new(0, 4), Parent = lbl })
                local LabelObj = {}
                function LabelObj:Set(v) lbl.Text = v end
                function LabelObj:Get() return lbl.Text end
                return LabelObj
            end

            function Section:AddSeparator()
                Create("Frame", {
                    Size = UDim2.new(1, -8, 0, 1), BackgroundColor3 = Theme.Divider,
                    BorderSizePixel = 0, ZIndex = 5, Parent = itemList,
                })
            end

            function Section:AddParagraph(opts)
                opts = opts or {}
                local pTitle = opts.Title or ""
                local pContent = opts.Content or ""
                local elem = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Theme.InputBg, BorderSizePixel = 0,
                    ZIndex = 5, Parent = itemList,
                })
                Create("UIStroke", { Color = Theme.Border, Thickness = 1, Transparency = 0.5, Parent = elem })
                -- Left accent
                Create("Frame", {
                    Size = UDim2.new(0, 2, 1, -4), Position = UDim2.new(0, 3, 0, 2),
                    BackgroundColor3 = Theme.Accent, BorderSizePixel = 0, ZIndex = 6, Parent = elem,
                })
                if pTitle ~= "" then
                    Create("TextLabel", {
                        Size = UDim2.new(1, -18, 0, 16), Position = UDim2.new(0, 12, 0, 5),
                        BackgroundTransparency = 1, Text = pTitle,
                        Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Theme.TextPrimary,
                        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6, Parent = elem,
                    })
                end
                Create("TextLabel", {
                    Size = UDim2.new(1, -18, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                    Position = UDim2.new(0, 12, 0, pTitle ~= "" and 22 or 6),
                    BackgroundTransparency = 1, Text = pContent,
                    Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = Theme.TextSecondary,
                    TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 6, Parent = elem,
                })
                Create("UIPadding", { PaddingBottom = UDim.new(0, 8), Parent = elem })
            end

            table.insert(self.Sections, Section)
            return Section
        end

        return Tab
    end

    return Window
end

return lib
