-- ============================================================
--   KrixUI - Roblox UI Library
--   Author  : Krix
--   Version : 1.0.0
--   GitHub  : https://github.com/krix/KrixUI
-- ============================================================

local KrixUI = {}
KrixUI.__index = KrixUI

-- ── Services ──────────────────────────────────────────────
local Players        = game:GetService("Players")
local TweenService   = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService     = game:GetService("RunService")
local CoreGui        = game:GetService("CoreGui")

local LocalPlayer    = Players.LocalPlayer
local Mouse          = LocalPlayer:GetMouse()

-- ── Utility ───────────────────────────────────────────────
local function Tween(obj, props, duration, style, dir)
    style    = style or Enum.EasingStyle.Quad
    dir      = dir   or Enum.EasingDirection.Out
    duration = duration or 0.25
    local info = TweenInfo.new(duration, style, dir)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function Create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then
            obj[k] = v
        end
    end
    if props.Parent then obj.Parent = props.Parent end
    return obj
end

local function MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragInput, dragStart, startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging  = true
            dragStart = input.Position
            startPos  = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ── Theme ─────────────────────────────────────────────────
local Theme = {
    Background       = Color3.fromRGB(15,  15,  20),
    TopBar           = Color3.fromRGB(20,  20,  28),
    TabBar           = Color3.fromRGB(18,  18,  24),
    TabActive        = Color3.fromRGB(98,  55, 220),
    TabInactive      = Color3.fromRGB(28,  28,  38),
    Section          = Color3.fromRGB(22,  22,  30),
    Element          = Color3.fromRGB(28,  28,  38),
    ElementHover     = Color3.fromRGB(38,  38,  52),
    Accent           = Color3.fromRGB(110, 65, 240),
    AccentDark       = Color3.fromRGB(75,  40, 170),
    TextPrimary      = Color3.fromRGB(240, 240, 255),
    TextSecondary    = Color3.fromRGB(155, 155, 175),
    TextDisabled     = Color3.fromRGB(90,  90, 110),
    ToggleOn         = Color3.fromRGB(110, 65, 240),
    ToggleOff        = Color3.fromRGB(50,  50,  65),
    SliderFill       = Color3.fromRGB(110, 65, 240),
    SliderBg         = Color3.fromRGB(40,  40,  55),
    InputBg          = Color3.fromRGB(12,  12,  18),
    Border           = Color3.fromRGB(40,  40,  55),
    Notification     = Color3.fromRGB(20,  20,  28),
    NotifSuccess     = Color3.fromRGB(60, 200, 100),
    NotifError       = Color3.fromRGB(220, 60,  60),
    NotifInfo        = Color3.fromRGB(60, 130, 220),
    Shadow           = Color3.fromRGB(0,    0,   0),
}

KrixUI.Theme = Theme

-- ══════════════════════════════════════════════════════════
--   Window
-- ══════════════════════════════════════════════════════════
function KrixUI:CreateWindow(options)
    options = options or {}
    local title    = options.Title    or "KrixUI"
    local subtitle = options.Subtitle or "v1.0"
    local size     = options.Size     or UDim2.new(0, 600, 0, 420)
    local pos      = options.Position or UDim2.new(0.5, -300, 0.5, -210)

    -- ── Root ScreenGui ─────────────────────────────────────
    local guiParent = CoreGui
    pcall(function()
        if gethui then
            guiParent = gethui()
        elseif syn and syn.protect_gui then
            local sg = Instance.new("ScreenGui")
            syn.protect_gui(sg)
            sg:Destroy()
            guiParent = CoreGui
        end
    end)

    local ScreenGui = Create("ScreenGui", {
        Name             = "KrixUI",
        ResetOnSpawn     = false,
        ZIndexBehavior   = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset   = true,
        Parent           = guiParent,
    })

    -- ── Drop shadow ────────────────────────────────────────
    local Shadow = Create("Frame", {
        Name            = "Shadow",
        Size            = UDim2.new(1, 20, 1, 20),
        Position        = UDim2.new(0, -10, 0, -10),
        BackgroundColor3= Theme.Shadow,
        BackgroundTransparency = 0.55,
        BorderSizePixel = 0,
        ZIndex          = 0,
        Parent          = ScreenGui,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 14), Parent = Shadow })

    -- ── Main Frame ─────────────────────────────────────────
    local Main = Create("Frame", {
        Name            = "Main",
        Size            = size,
        Position        = pos,
        BackgroundColor3= Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants= false,
        Parent          = ScreenGui,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = Main })
    Create("UIStroke", {
        Color           = Theme.Border,
        Thickness       = 1.2,
        Parent          = Main,
    })

    -- Reparent shadow
    Shadow.Parent = Main
    Shadow.ZIndex = 0

    -- ── Top Bar ────────────────────────────────────────────
    local TopBar = Create("Frame", {
        Name            = "TopBar",
        Size            = UDim2.new(1, 0, 0, 44),
        BackgroundColor3= Theme.TopBar,
        BorderSizePixel = 0,
        Parent          = Main,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = TopBar })
    -- Fill bottom corners
    Create("Frame", {
        Size            = UDim2.new(1, 0, 0, 10),
        Position        = UDim2.new(0, 0, 1, -10),
        BackgroundColor3= Theme.TopBar,
        BorderSizePixel = 0,
        Parent          = TopBar,
    })

    -- Accent line under topbar
    Create("Frame", {
        Size            = UDim2.new(1, 0, 0, 2),
        Position        = UDim2.new(0, 0, 1, -1),
        BackgroundColor3= Theme.Accent,
        BorderSizePixel = 0,
        Parent          = TopBar,
    })

    -- Logo dot
    Create("Frame", {
        Size            = UDim2.new(0, 10, 0, 10),
        Position        = UDim2.new(0, 14, 0.5, -5),
        BackgroundColor3= Theme.Accent,
        BorderSizePixel = 0,
        Parent          = TopBar,
    }):FindFirstChildWhichIsA("UICorner") or Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = TopBar:FindFirstChild("Frame") or TopBar })

    local dot = TopBar:FindFirstChild("Frame")
    if dot then Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = dot }) end

    -- Title label
    Create("TextLabel", {
        Name            = "Title",
        Size            = UDim2.new(0, 200, 1, 0),
        Position        = UDim2.new(0, 32, 0, 0),
        BackgroundTransparency = 1,
        Text            = title,
        Font            = Enum.Font.GothamBold,
        TextSize        = 15,
        TextColor3      = Theme.TextPrimary,
        TextXAlignment  = Enum.TextXAlignment.Left,
        Parent          = TopBar,
    })
    -- Subtitle
    Create("TextLabel", {
        Name            = "Subtitle",
        Size            = UDim2.new(0, 200, 1, 0),
        Position        = UDim2.new(0, 32 + 90, 0, 0),
        BackgroundTransparency = 1,
        Text            = subtitle,
        Font            = Enum.Font.Gotham,
        TextSize        = 12,
        TextColor3      = Theme.TextSecondary,
        TextXAlignment  = Enum.TextXAlignment.Left,
        Parent          = TopBar,
    })

    -- Close button
    local CloseBtn = Create("TextButton", {
        Name            = "Close",
        Size            = UDim2.new(0, 28, 0, 28),
        Position        = UDim2.new(1, -36, 0.5, -14),
        BackgroundColor3= Color3.fromRGB(200, 55, 55),
        Text            = "✕",
        Font            = Enum.Font.GothamBold,
        TextSize        = 13,
        TextColor3      = Color3.fromRGB(255,255,255),
        BorderSizePixel = 0,
        Parent          = TopBar,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = CloseBtn })

    CloseBtn.MouseButton1Click:Connect(function()
        Tween(Main, { Size = UDim2.new(0, size.X.Offset, 0, 0) }, 0.25)
        task.wait(0.25)
        ScreenGui:Destroy()
    end)

    -- Minimize button
    local MinBtn = Create("TextButton", {
        Name            = "Minimize",
        Size            = UDim2.new(0, 28, 0, 28),
        Position        = UDim2.new(1, -70, 0.5, -14),
        BackgroundColor3= Theme.TabInactive,
        Text            = "─",
        Font            = Enum.Font.GothamBold,
        TextSize        = 13,
        TextColor3      = Theme.TextSecondary,
        BorderSizePixel = 0,
        Parent          = TopBar,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = MinBtn })

    local minimized  = false
    local fullHeight = size.Y.Offset

    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Tween(Main, { Size = UDim2.new(0, size.X.Offset, 0, 44) }, 0.3)
        else
            Tween(Main, { Size = UDim2.new(0, size.X.Offset, 0, fullHeight) }, 0.3)
        end
    end)

    MakeDraggable(Main, TopBar)

    -- ── Tab Bar ────────────────────────────────────────────
    local TabBar = Create("Frame", {
        Name            = "TabBar",
        Size            = UDim2.new(0, 130, 1, -44),
        Position        = UDim2.new(0, 0, 0, 44),
        BackgroundColor3= Theme.TabBar,
        BorderSizePixel = 0,
        ClipsDescendants= true,
        Parent          = Main,
    })
    -- round bottom-left
    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = TabBar })
    Create("Frame", {
        Size            = UDim2.new(1, 0, 0, 10),
        BackgroundColor3= Theme.TabBar,
        BorderSizePixel = 0,
        Parent          = TabBar,
    })
    Create("Frame", {
        Size            = UDim2.new(0, 10, 1, 0),
        Position        = UDim2.new(1, -10, 0, 0),
        BackgroundColor3= Theme.TabBar,
        BorderSizePixel = 0,
        Parent          = TabBar,
    })

    local TabList = Create("ScrollingFrame", {
        Name             = "TabList",
        Size             = UDim2.new(1, 0, 1, -10),
        Position         = UDim2.new(0, 0, 0, 10),
        BackgroundTransparency = 1,
        BorderSizePixel  = 0,
        ScrollBarThickness = 0,
        CanvasSize       = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize= Enum.AutomaticSize.Y,
        Parent           = TabBar,
    })
    Create("UIListLayout", {
        Padding         = UDim.new(0, 4),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Parent          = TabList,
    })
    Create("UIPadding", {
        PaddingTop      = UDim.new(0, 6),
        PaddingLeft     = UDim.new(0, 6),
        PaddingRight    = UDim.new(0, 6),
        Parent          = TabList,
    })

    -- ── Content Area ───────────────────────────────────────
    local ContentArea = Create("Frame", {
        Name            = "ContentArea",
        Size            = UDim2.new(1, -130, 1, -44),
        Position        = UDim2.new(0, 130, 0, 44),
        BackgroundColor3= Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants= true,
        Parent          = Main,
    })

    -- Intro animation
    Main.Size = UDim2.new(0, size.X.Offset, 0, 0)
    Main.BackgroundTransparency = 1
    Tween(Main, { Size = size, BackgroundTransparency = 0 }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    -- ── Window Object ──────────────────────────────────────
    local Window = {
        ScreenGui   = ScreenGui,
        Main        = Main,
        TabList     = TabList,
        ContentArea = ContentArea,
        Tabs        = {},
        ActiveTab   = nil,
    }

    -- ── Notification system ────────────────────────────────
    local notifContainer = Create("Frame", {
        Name            = "Notifications",
        Size            = UDim2.new(0, 280, 1, 0),
        Position        = UDim2.new(1, -290, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent          = ScreenGui,
    })
    Create("UIListLayout", {
        VerticalAlignment   = Enum.VerticalAlignment.Bottom,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding             = UDim.new(0, 6),
        Parent              = notifContainer,
    })
    Create("UIPadding", {
        PaddingBottom = UDim.new(0, 16),
        PaddingRight  = UDim.new(0, 0),
        Parent        = notifContainer,
    })

    function Window:Notify(opts)
        opts = opts or {}
        local nTitle   = opts.Title   or "KrixUI"
        local nDesc    = opts.Description or ""
        local nType    = opts.Type    or "Info"   -- Info | Success | Error
        local nDur     = opts.Duration or 4

        local accentCol = Theme.NotifInfo
        if nType == "Success" then accentCol = Theme.NotifSuccess
        elseif nType == "Error" then accentCol = Theme.NotifError end

        local card = Create("Frame", {
            Name            = "Notif",
            Size            = UDim2.new(1, 0, 0, 70),
            BackgroundColor3= Theme.Notification,
            BorderSizePixel = 0,
            ClipsDescendants= true,
            Parent          = notifContainer,
        })
        Create("UICorner",  { CornerRadius = UDim.new(0, 8), Parent = card })
        Create("UIStroke",  { Color = Theme.Border, Thickness = 1, Parent = card })

        -- Accent stripe
        Create("Frame", {
            Size            = UDim2.new(0, 4, 1, 0),
            BackgroundColor3= accentCol,
            BorderSizePixel = 0,
            Parent          = card,
        })

        Create("TextLabel", {
            Size            = UDim2.new(1, -18, 0, 22),
            Position        = UDim2.new(0, 14, 0, 8),
            BackgroundTransparency = 1,
            Text            = nTitle,
            Font            = Enum.Font.GothamBold,
            TextSize        = 13,
            TextColor3      = Theme.TextPrimary,
            TextXAlignment  = Enum.TextXAlignment.Left,
            Parent          = card,
        })
        Create("TextLabel", {
            Size            = UDim2.new(1, -18, 0, 32),
            Position        = UDim2.new(0, 14, 0, 30),
            BackgroundTransparency = 1,
            Text            = nDesc,
            Font            = Enum.Font.Gotham,
            TextSize        = 12,
            TextColor3      = Theme.TextSecondary,
            TextWrapped     = true,
            TextXAlignment  = Enum.TextXAlignment.Left,
            Parent          = card,
        })

        -- Progress bar
        local bar = Create("Frame", {
            Size            = UDim2.new(1, 0, 0, 3),
            Position        = UDim2.new(0, 0, 1, -3),
            BackgroundColor3= accentCol,
            BorderSizePixel = 0,
            Parent          = card,
        })
        Tween(bar, { Size = UDim2.new(0, 0, 0, 3) }, nDur, Enum.EasingStyle.Linear)

        task.delay(nDur, function()
            Tween(card, { BackgroundTransparency = 1 }, 0.4)
            task.wait(0.4)
            card:Destroy()
        end)
    end

    -- ── AddTab ─────────────────────────────────────────────
    function Window:AddTab(tabOptions)
        tabOptions = tabOptions or {}
        local tabName = tabOptions.Name or "Tab"
        local tabIcon = tabOptions.Icon or ""

        -- Tab button
        local btn = Create("TextButton", {
            Name            = tabName,
            Size            = UDim2.new(1, 0, 0, 34),
            BackgroundColor3= Theme.TabInactive,
            Text            = "",
            BorderSizePixel = 0,
            AutoButtonColor = false,
            Parent          = self.TabList,
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 7), Parent = btn })

        local btnLabel = Create("TextLabel", {
            Size            = UDim2.new(1, -10, 1, 0),
            Position        = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text            = (tabIcon ~= "" and tabIcon .. "  " or "") .. tabName,
            Font            = Enum.Font.Gotham,
            TextSize        = 13,
            TextColor3      = Theme.TextSecondary,
            TextXAlignment  = Enum.TextXAlignment.Left,
            Parent          = btn,
        })

        -- Tab page (scrolling)
        local page = Create("ScrollingFrame", {
            Name             = tabName .. "Page",
            Size             = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel  = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.Accent,
            CanvasSize       = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible          = false,
            Parent           = self.ContentArea,
        })
        Create("UIListLayout", {
            Padding         = UDim.new(0, 6),
            Parent          = page,
        })
        Create("UIPadding", {
            PaddingTop      = UDim.new(0, 10),
            PaddingLeft     = UDim.new(0, 10),
            PaddingRight    = UDim.new(0, 14),
            PaddingBottom   = UDim.new(0, 10),
            Parent          = page,
        })

        local Tab = { Button = btn, Page = page, Sections = {} }

        local function Activate()
            -- Deactivate others
            for _, t in pairs(self.Tabs) do
                Tween(t.Button, { BackgroundColor3 = Theme.TabInactive }, 0.15)
                t.Button:FindFirstChild("TextLabel").TextColor3 = Theme.TextSecondary
                t.Button:FindFirstChild("TextLabel").Font = Enum.Font.Gotham
                t.Page.Visible = false
            end
            -- Activate this
            Tween(btn, { BackgroundColor3 = Theme.TabActive }, 0.15)
            btnLabel.TextColor3 = Theme.TextPrimary
            btnLabel.Font       = Enum.Font.GothamBold
            page.Visible        = true
            self.ActiveTab      = Tab
        end

        btn.MouseButton1Click:Connect(Activate)
        btn.MouseEnter:Connect(function()
            if self.ActiveTab ~= Tab then
                Tween(btn, { BackgroundColor3 = Theme.ElementHover }, 0.1)
            end
        end)
        btn.MouseLeave:Connect(function()
            if self.ActiveTab ~= Tab then
                Tween(btn, { BackgroundColor3 = Theme.TabInactive }, 0.1)
            end
        end)

        table.insert(self.Tabs, Tab)
        if #self.Tabs == 1 then Activate() end

        -- ── AddSection ───────────────────────────────────
        function Tab:AddSection(sectionName)
            local section = Create("Frame", {
                Name            = sectionName,
                Size            = UDim2.new(1, 0, 0, 0),
                AutomaticSize   = Enum.AutomaticSize.Y,
                BackgroundColor3= Theme.Section,
                BorderSizePixel = 0,
                Parent          = page,
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = section })
            Create("UIStroke",  { Color = Theme.Border, Thickness = 1, Parent = section })

            -- Section header
            Create("TextLabel", {
                Name            = "Header",
                Size            = UDim2.new(1, -16, 0, 30),
                Position        = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text            = sectionName,
                Font            = Enum.Font.GothamBold,
                TextSize        = 12,
                TextColor3      = Theme.Accent,
                TextXAlignment  = Enum.TextXAlignment.Left,
                Parent          = section,
            })
            -- Separator
            Create("Frame", {
                Size            = UDim2.new(1, -20, 0, 1),
                Position        = UDim2.new(0, 10, 0, 30),
                BackgroundColor3= Theme.Border,
                BorderSizePixel = 0,
                Parent          = section,
            })

            local itemList = Create("Frame", {
                Name            = "Items",
                Size            = UDim2.new(1, 0, 0, 0),
                Position        = UDim2.new(0, 0, 0, 32),
                AutomaticSize   = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Parent          = section,
            })
            Create("UIListLayout", { Padding = UDim.new(0, 2), Parent = itemList })
            Create("UIPadding", {
                PaddingLeft  = UDim.new(0, 8),
                PaddingRight = UDim.new(0, 8),
                PaddingBottom= UDim.new(0, 8),
                Parent       = itemList,
            })

            local Section = {}

            -- ────────────────────────────────────────────────
            -- Button
            -- ────────────────────────────────────────────────
            function Section:AddButton(opts)
                opts = opts or {}
                local label    = opts.Name     or "Button"
                local desc     = opts.Description or ""
                local callback = opts.Callback or function() end

                local elem = Create("TextButton", {
                    Size            = UDim2.new(1, 0, 0, 38),
                    BackgroundColor3= Theme.Element,
                    Text            = "",
                    BorderSizePixel = 0,
                    AutoButtonColor = false,
                    Parent          = itemList,
                })
                Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = elem })

                Create("TextLabel", {
                    Size            = UDim2.new(1, -100, 1, 0),
                    Position        = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    Text            = label,
                    Font            = Enum.Font.Gotham,
                    TextSize        = 13,
                    TextColor3      = Theme.TextPrimary,
                    TextXAlignment  = Enum.TextXAlignment.Left,
                    Parent          = elem,
                })

                local execBtn = Create("TextButton", {
                    Size            = UDim2.new(0, 80, 0, 26),
                    Position        = UDim2.new(1, -88, 0.5, -13),
                    BackgroundColor3= Theme.Accent,
                    Text            = "Execute",
                    Font            = Enum.Font.GothamBold,
                    TextSize        = 12,
                    TextColor3      = Color3.fromRGB(255,255,255),
                    BorderSizePixel = 0,
                    Parent          = elem,
                })
                Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = execBtn })

                execBtn.MouseButton1Click:Connect(function()
                    Tween(execBtn, { BackgroundColor3 = Theme.AccentDark }, 0.1)
                    task.wait(0.1)
                    Tween(execBtn, { BackgroundColor3 = Theme.Accent }, 0.1)
                    callback()
                end)

                elem.MouseEnter:Connect(function()  Tween(elem, { BackgroundColor3 = Theme.ElementHover }, 0.1) end)
                elem.MouseLeave:Connect(function()  Tween(elem, { BackgroundColor3 = Theme.Element }, 0.1) end)

                return elem
            end

            -- ────────────────────────────────────────────────
            -- Toggle
            -- ────────────────────────────────────────────────
            function Section:AddToggle(opts)
                opts = opts or {}
                local label    = opts.Name     or "Toggle"
                local default  = opts.Default  or false
                local callback = opts.Callback or function() end

                local state = default

                local elem = Create("Frame", {
                    Size            = UDim2.new(1, 0, 0, 38),
                    BackgroundColor3= Theme.Element,
                    BorderSizePixel = 0,
                    Parent          = itemList,
                })
                Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = elem })

                Create("TextLabel", {
                    Size            = UDim2.new(1, -70, 1, 0),
                    Position        = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    Text            = label,
                    Font            = Enum.Font.Gotham,
                    TextSize        = 13,
                    TextColor3      = Theme.TextPrimary,
                    TextXAlignment  = Enum.TextXAlignment.Left,
                    Parent          = elem,
                })

                -- Track background
                local trackBg = Create("Frame", {
                    Size            = UDim2.new(0, 44, 0, 24),
                    Position        = UDim2.new(1, -54, 0.5, -12),
                    BackgroundColor3= state and Theme.ToggleOn or Theme.ToggleOff,
                    BorderSizePixel = 0,
                    Parent          = elem,
                })
                Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = trackBg })

                local knob = Create("Frame", {
                    Size            = UDim2.new(0, 18, 0, 18),
                    Position        = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
                    BackgroundColor3= Color3.fromRGB(255,255,255),
                    BorderSizePixel = 0,
                    Parent          = trackBg,
                })
                Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = knob })

                local clickArea = Create("TextButton", {
                    Size            = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text            = "",
                    Parent          = elem,
                })

                clickArea.MouseButton1Click:Connect(function()
                    state = not state
                    Tween(trackBg, { BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff }, 0.2)
                    Tween(knob,    { Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9) }, 0.2)
                    callback(state)
                end)

                elem.MouseEnter:Connect(function() Tween(elem, { BackgroundColor3 = Theme.ElementHover }, 0.1) end)
                elem.MouseLeave:Connect(function() Tween(elem, { BackgroundColor3 = Theme.Element }, 0.1) end)

                local ToggleObj = {}
                function ToggleObj:Set(val)
                    state = val
                    Tween(trackBg, { BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff }, 0.2)
                    Tween(knob,    { Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9) }, 0.2)
                    callback(state)
                end
                function ToggleObj:Get() return state end
                return ToggleObj
            end

            -- ────────────────────────────────────────────────
            -- Slider
            -- ────────────────────────────────────────────────
            function Section:AddSlider(opts)
                opts = opts or {}
                local label    = opts.Name    or "Slider"
                local min      = opts.Min     or 0
                local max      = opts.Max     or 100
                local default  = opts.Default or min
                local suffix   = opts.Suffix  or ""
                local callback = opts.Callback or function() end

                local value = math.clamp(default, min, max)

                local elem = Create("Frame", {
                    Size            = UDim2.new(1, 0, 0, 52),
                    BackgroundColor3= Theme.Element,
                    BorderSizePixel = 0,
                    Parent          = itemList,
                })
                Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = elem })

                Create("TextLabel", {
                    Size            = UDim2.new(0.6, 0, 0, 22),
                    Position        = UDim2.new(0, 10, 0, 6),
                    BackgroundTransparency = 1,
                    Text            = label,
                    Font            = Enum.Font.Gotham,
                    TextSize        = 13,
                    TextColor3      = Theme.TextPrimary,
                    TextXAlignment  = Enum.TextXAlignment.Left,
                    Parent          = elem,
                })

                local valLabel = Create("TextLabel", {
                    Size            = UDim2.new(0.4, -10, 0, 22),
                    Position        = UDim2.new(0.6, 0, 0, 6),
                    BackgroundTransparency = 1,
                    Text            = tostring(value) .. suffix,
                    Font            = Enum.Font.GothamBold,
                    TextSize        = 13,
                    TextColor3      = Theme.Accent,
                    TextXAlignment  = Enum.TextXAlignment.Right,
                    Parent          = elem,
                })

                local track = Create("Frame", {
                    Size            = UDim2.new(1, -20, 0, 6),
                    Position        = UDim2.new(0, 10, 0, 36),
                    BackgroundColor3= Theme.SliderBg,
                    BorderSizePixel = 0,
                    Parent          = elem,
                })
                Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = track })

                local fill = Create("Frame", {
                    Size            = UDim2.new((value - min) / (max - min), 0, 1, 0),
                    BackgroundColor3= Theme.SliderFill,
                    BorderSizePixel = 0,
                    Parent          = track,
                })
                Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = fill })

                -- Thumb
                local thumb = Create("Frame", {
                    Size            = UDim2.new(0, 14, 0, 14),
                    Position        = UDim2.new((value - min) / (max - min), -7, 0.5, -7),
                    BackgroundColor3= Color3.fromRGB(255,255,255),
                    BorderSizePixel = 0,
                    Parent          = track,
                })
                Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = thumb })

                local sliding = false
                track.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliding = true
                    end
                end)
                UserInputService.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliding = false
                    end
                end)
                UserInputService.InputChanged:Connect(function(inp)
                    if sliding and inp.UserInputType == Enum.UserInputType.MouseMovement then
                        local absPos  = track.AbsolutePosition.X
                        local absSize = track.AbsoluteSize.X
                        local rel = math.clamp((inp.Position.X - absPos) / absSize, 0, 1)
                        local stepped = math.floor(min + (max - min) * rel)
                        if stepped ~= value then
                            value = stepped
                            fill.Size   = UDim2.new(rel, 0, 1, 0)
                            thumb.Position = UDim2.new(rel, -7, 0.5, -7)
                            valLabel.Text = tostring(value) .. suffix
                            callback(value)
                        end
                    end
                end)

                elem.MouseEnter:Connect(function() Tween(elem, { BackgroundColor3 = Theme.ElementHover }, 0.1) end)
                elem.MouseLeave:Connect(function() Tween(elem, { BackgroundColor3 = Theme.Element }, 0.1) end)

                local SliderObj = {}
                function SliderObj:Set(v)
                    value = math.clamp(v, min, max)
                    local rel = (value - min) / (max - min)
                    fill.Size   = UDim2.new(rel, 0, 1, 0)
                    thumb.Position = UDim2.new(rel, -7, 0.5, -7)
                    valLabel.Text = tostring(value) .. suffix
                    callback(value)
                end
                function SliderObj:Get() return value end
                return SliderObj
            end

            -- ────────────────────────────────────────────────
            -- TextBox
            -- ────────────────────────────────────────────────
            function Section:AddTextBox(opts)
                opts = opts or {}
                local label       = opts.Name        or "Input"
                local placeholder = opts.Placeholder  or "Type here..."
                local default     = opts.Default      or ""
                local callback    = opts.Callback     or function() end

                local elem = Create("Frame", {
                    Size            = UDim2.new(1, 0, 0, 52),
                    BackgroundColor3= Theme.Element,
                    BorderSizePixel = 0,
                    Parent          = itemList,
                })
                Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = elem })

                Create("TextLabel", {
                    Size            = UDim2.new(1, -20, 0, 22),
                    Position        = UDim2.new(0, 10, 0, 4),
                    BackgroundTransparency = 1,
                    Text            = label,
                    Font            = Enum.Font.Gotham,
                    TextSize        = 12,
                    TextColor3      = Theme.TextSecondary,
                    TextXAlignment  = Enum.TextXAlignment.Left,
                    Parent          = elem,
                })

                local box = Create("TextBox", {
                    Size                 = UDim2.new(1, -20, 0, 22),
                    Position             = UDim2.new(0, 10, 0, 26),
                    BackgroundColor3     = Theme.InputBg,
                    Text                 = default,
                    PlaceholderText      = placeholder,
                    PlaceholderColor3    = Theme.TextDisabled,
                    Font                 = Enum.Font.Gotham,
                    TextSize             = 13,
                    TextColor3           = Theme.TextPrimary,
                    TextXAlignment       = Enum.TextXAlignment.Left,
                    ClearTextOnFocus     = false,
                    BorderSizePixel      = 0,
                    Parent               = elem,
                })
                Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = box })
                Create("UIPadding", { PaddingLeft = UDim.new(0, 6), Parent = box })

                box.FocusLost:Connect(function(enter)
                    if enter then callback(box.Text) end
                end)

                elem.MouseEnter:Connect(function() Tween(elem, { BackgroundColor3 = Theme.ElementHover }, 0.1) end)
                elem.MouseLeave:Connect(function() Tween(elem, { BackgroundColor3 = Theme.Element }, 0.1) end)

                local BoxObj = {}
                function BoxObj:Set(v) box.Text = v end
                function BoxObj:Get() return box.Text end
                return BoxObj
            end

            -- ────────────────────────────────────────────────
            -- Dropdown
            -- ────────────────────────────────────────────────
            function Section:AddDropdown(opts)
                opts = opts or {}
                local label    = opts.Name    or "Dropdown"
                local items    = opts.Items   or {}
                local default  = opts.Default or (items[1] or "Select")
                local callback = opts.Callback or function() end

                local selected = default
                local open     = false

                local elem = Create("Frame", {
                    Size            = UDim2.new(1, 0, 0, 38),
                    BackgroundColor3= Theme.Element,
                    BorderSizePixel = 0,
                    ClipsDescendants= false,
                    Parent          = itemList,
                })
                Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = elem })

                Create("TextLabel", {
                    Size            = UDim2.new(0.5, 0, 1, 0),
                    Position        = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    Text            = label,
                    Font            = Enum.Font.Gotham,
                    TextSize        = 13,
                    TextColor3      = Theme.TextPrimary,
                    TextXAlignment  = Enum.TextXAlignment.Left,
                    Parent          = elem,
                })

                local selLabel = Create("TextLabel", {
                    Size            = UDim2.new(0.5, -36, 1, 0),
                    Position        = UDim2.new(0.5, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Text            = selected,
                    Font            = Enum.Font.Gotham,
                    TextSize        = 13,
                    TextColor3      = Theme.Accent,
                    TextXAlignment  = Enum.TextXAlignment.Right,
                    Parent          = elem,
                })

                local arrow = Create("TextLabel", {
                    Size            = UDim2.new(0, 20, 1, 0),
                    Position        = UDim2.new(1, -24, 0, 0),
                    BackgroundTransparency = 1,
                    Text            = "▼",
                    Font            = Enum.Font.Gotham,
                    TextSize        = 10,
                    TextColor3      = Theme.TextSecondary,
                    Parent          = elem,
                })

                -- Dropdown list (renders above sibling frames via ZIndex)
                local dropList = Create("Frame", {
                    Size            = UDim2.new(1, 0, 0, 0),
                    Position        = UDim2.new(0, 0, 1, 4),
                    BackgroundColor3= Theme.Element,
                    BorderSizePixel = 0,
                    ClipsDescendants= true,
                    ZIndex          = 10,
                    Visible         = false,
                    Parent          = elem,
                })
                Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = dropList })
                Create("UIStroke",  { Color = Theme.Accent, Thickness = 1, Parent = dropList })

                local dropScroll = Create("ScrollingFrame", {
                    Size             = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    BorderSizePixel  = 0,
                    ScrollBarThickness = 2,
                    ScrollBarImageColor3 = Theme.Accent,
                    CanvasSize       = UDim2.new(0, 0, 0, 0),
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ZIndex           = 10,
                    Parent           = dropList,
                })
                Create("UIListLayout", { Padding = UDim.new(0, 2), Parent = dropScroll })
                Create("UIPadding", { PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4), PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4), Parent = dropScroll })

                local function BuildItems()
                    for _, child in pairs(dropScroll:GetChildren()) do
                        if child:IsA("TextButton") then child:Destroy() end
                    end
                    for _, item in ipairs(items) do
                        local btn = Create("TextButton", {
                            Size            = UDim2.new(1, 0, 0, 28),
                            BackgroundColor3= (item == selected) and Theme.Accent or Theme.TabInactive,
                            Text            = item,
                            Font            = Enum.Font.Gotham,
                            TextSize        = 13,
                            TextColor3      = Theme.TextPrimary,
                            BorderSizePixel = 0,
                            ZIndex          = 11,
                            Parent          = dropScroll,
                        })
                        Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = btn })
                        btn.MouseButton1Click:Connect(function()
                            selected = item
                            selLabel.Text = item
                            open = false
                            Tween(dropList, { Size = UDim2.new(1, 0, 0, 0) }, 0.2)
                            task.wait(0.2)
                            dropList.Visible = false
                            arrow.Text = "▼"
                            BuildItems()
                            callback(selected)
                        end)
                    end
                end
                BuildItems()

                local clickArea = Create("TextButton", {
                    Size            = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text            = "",
                    Parent          = elem,
                })
                clickArea.MouseButton1Click:Connect(function()
                    open = not open
                    if open then
                        local targetH = math.min(#items * 32 + 10, 160)
                        dropList.Visible = true
                        dropList.Size = UDim2.new(1, 0, 0, 0)
                        Tween(dropList, { Size = UDim2.new(1, 0, 0, targetH) }, 0.2)
                        arrow.Text = "▲"
                    else
                        Tween(dropList, { Size = UDim2.new(1, 0, 0, 0) }, 0.2)
                        task.delay(0.2, function() dropList.Visible = false end)
                        arrow.Text = "▼"
                    end
                end)

                elem.MouseEnter:Connect(function() Tween(elem, { BackgroundColor3 = Theme.ElementHover }, 0.1) end)
                elem.MouseLeave:Connect(function() Tween(elem, { BackgroundColor3 = Theme.Element }, 0.1) end)

                local DropObj = {}
                function DropObj:Set(v)
                    selected = v
                    selLabel.Text = v
                    BuildItems()
                    callback(v)
                end
                function DropObj:Get() return selected end
                function DropObj:Refresh(newItems)
                    items = newItems
                    BuildItems()
                end
                return DropObj
            end

            -- ────────────────────────────────────────────────
            -- Label
            -- ────────────────────────────────────────────────
            function Section:AddLabel(opts)
                opts = opts or {}
                local text = opts.Text or "Label"

                local lbl = Create("TextLabel", {
                    Size            = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency = 1,
                    Text            = text,
                    Font            = Enum.Font.Gotham,
                    TextSize        = 13,
                    TextColor3      = Theme.TextSecondary,
                    TextXAlignment  = Enum.TextXAlignment.Left,
                    Parent          = itemList,
                })
                Create("UIPadding", { PaddingLeft = UDim.new(0, 2), Parent = lbl })

                local LabelObj = {}
                function LabelObj:Set(v) lbl.Text = v end
                function LabelObj:Get() return lbl.Text end
                return LabelObj
            end

            -- ────────────────────────────────────────────────
            -- Separator
            -- ────────────────────────────────────────────────
            function Section:AddSeparator()
                Create("Frame", {
                    Size            = UDim2.new(1, 0, 0, 1),
                    BackgroundColor3= Theme.Border,
                    BorderSizePixel = 0,
                    Parent          = itemList,
                })
            end

            -- ────────────────────────────────────────────────
            -- Keybind
            -- ────────────────────────────────────────────────
            function Section:AddKeybind(opts)
                opts = opts or {}
                local label    = opts.Name     or "Keybind"
                local default  = opts.Default  or Enum.KeyCode.Unknown
                local callback = opts.Callback or function() end

                local current  = default
                local listening= false

                local elem = Create("Frame", {
                    Size            = UDim2.new(1, 0, 0, 38),
                    BackgroundColor3= Theme.Element,
                    BorderSizePixel = 0,
                    Parent          = itemList,
                })
                Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = elem })

                Create("TextLabel", {
                    Size            = UDim2.new(0.5, 0, 1, 0),
                    Position        = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    Text            = label,
                    Font            = Enum.Font.Gotham,
                    TextSize        = 13,
                    TextColor3      = Theme.TextPrimary,
                    TextXAlignment  = Enum.TextXAlignment.Left,
                    Parent          = elem,
                })

                local keyBtn = Create("TextButton", {
                    Size            = UDim2.new(0, 80, 0, 26),
                    Position        = UDim2.new(1, -88, 0.5, -13),
                    BackgroundColor3= Theme.TabInactive,
                    Text            = current.Name,
                    Font            = Enum.Font.GothamBold,
                    TextSize        = 12,
                    TextColor3      = Theme.Accent,
                    BorderSizePixel = 0,
                    Parent          = elem,
                })
                Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = keyBtn })

                keyBtn.MouseButton1Click:Connect(function()
                    listening   = true
                    keyBtn.Text = "..."
                    keyBtn.TextColor3 = Theme.TextSecondary
                end)

                UserInputService.InputBegan:Connect(function(inp, gpe)
                    if gpe then return end
                    if listening and inp.UserInputType == Enum.UserInputType.Keyboard then
                        current   = inp.KeyCode
                        listening = false
                        keyBtn.Text      = current.Name
                        keyBtn.TextColor3= Theme.Accent
                    elseif not listening and inp.KeyCode == current then
                        callback()
                    end
                end)

                elem.MouseEnter:Connect(function() Tween(elem, { BackgroundColor3 = Theme.ElementHover }, 0.1) end)
                elem.MouseLeave:Connect(function() Tween(elem, { BackgroundColor3 = Theme.Element }, 0.1) end)

                local KeyObj = {}
                function KeyObj:Set(k)
                    current = k
                    keyBtn.Text = k.Name
                end
                function KeyObj:Get() return current end
                return KeyObj
            end

            table.insert(self.Sections, Section)
            return Section
        end

        return Tab
    end

    return Window
end

-- ── ESP / Highlight helper (bonus) ────────────────────────
function KrixUI.Highlight(character, color, outlineColor, fillTransparency)
    color              = color            or Color3.fromRGB(255, 0, 0)
    outlineColor       = outlineColor     or Color3.fromRGB(255, 255, 255)
    fillTransparency   = fillTransparency or 0.6

    local hl = Instance.new("SelectionBox")
    hl.Color3               = color
    hl.LineThickness        = 0.05
    hl.SurfaceTransparency  = fillTransparency
    hl.SurfaceColor3        = color
    hl.Adornee              = character
    hl.Parent               = character
    return hl
end

return KrixUI
