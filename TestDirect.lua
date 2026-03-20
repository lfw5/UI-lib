-- ============================================================
--   KrixUI - Test Direct (pas besoin de GitHub)
--   Colle ce fichier entier dans ton executor
--   Il contient la lib + l'exemple complet
-- ============================================================

-- ════════════════════════════════════════════════════════════
--   LIBRARY SOURCE (UILib.lua inliné)
-- ════════════════════════════════════════════════════════════

local KrixUI = (function()

local KrixUI = {}
KrixUI.__index = KrixUI

local Players           = game:GetService("Players")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local CoreGui           = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

local function Tween(obj, props, duration, style, dir)
    style    = style or Enum.EasingStyle.Quad
    dir      = dir   or Enum.EasingDirection.Out
    duration = duration or 0.25
    local t  = TweenService:Create(obj, TweenInfo.new(duration, style, dir), props)
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
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging  = true
            dragStart = input.Position
            startPos  = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
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

local Theme = {
    Background    = Color3.fromRGB(15,  15,  20),
    TopBar        = Color3.fromRGB(20,  20,  28),
    TabBar        = Color3.fromRGB(18,  18,  24),
    TabActive     = Color3.fromRGB(98,  55, 220),
    TabInactive   = Color3.fromRGB(28,  28,  38),
    Section       = Color3.fromRGB(22,  22,  30),
    Element       = Color3.fromRGB(28,  28,  38),
    ElementHover  = Color3.fromRGB(38,  38,  52),
    Accent        = Color3.fromRGB(110, 65, 240),
    AccentDark    = Color3.fromRGB(75,  40, 170),
    TextPrimary   = Color3.fromRGB(240, 240, 255),
    TextSecondary = Color3.fromRGB(155, 155, 175),
    TextDisabled  = Color3.fromRGB(90,  90, 110),
    ToggleOn      = Color3.fromRGB(110, 65, 240),
    ToggleOff     = Color3.fromRGB(50,  50,  65),
    SliderFill    = Color3.fromRGB(110, 65, 240),
    SliderBg      = Color3.fromRGB(40,  40,  55),
    InputBg       = Color3.fromRGB(12,  12,  18),
    Border        = Color3.fromRGB(40,  40,  55),
    Notification  = Color3.fromRGB(20,  20,  28),
    NotifSuccess  = Color3.fromRGB(60, 200, 100),
    NotifError    = Color3.fromRGB(220, 60,  60),
    NotifInfo     = Color3.fromRGB(60, 130, 220),
    Shadow        = Color3.fromRGB(0,    0,   0),
}
KrixUI.Theme = Theme

-- ── Destroy existing KrixUI if reinject ───────────────────
pcall(function()
    if CoreGui:FindFirstChild("KrixUI") then
        CoreGui:FindFirstChild("KrixUI"):Destroy()
    end
end)

function KrixUI:CreateWindow(options)
    options = options or {}
    local title    = options.Title    or "KrixUI"
    local subtitle = options.Subtitle or "v1.0"
    local size     = options.Size     or UDim2.new(0, 600, 0, 420)
    local pos      = options.Position or UDim2.new(0.5, -300, 0.5, -210)

    -- ── Safe GUI parent ────────────────────────────────────
    local guiParent = CoreGui
    pcall(function()
        if gethui then
            guiParent = gethui()
        end
    end)

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name           = "KrixUI"
    ScreenGui.ResetOnSpawn   = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.IgnoreGuiInset = true
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
    end)
    ScreenGui.Parent = guiParent

    local Main = Create("Frame", {
        Name = "Main", Size = size, Position = pos,
        BackgroundColor3 = Theme.Background, BorderSizePixel = 0,
        ClipsDescendants = false, Parent = ScreenGui,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = Main })
    Create("UIStroke", { Color = Theme.Border, Thickness = 1.2, Parent = Main })

    -- Shadow
    local Shadow = Create("Frame", {
        Size = UDim2.new(1, 20, 1, 20), Position = UDim2.new(0, -10, 0, -10),
        BackgroundColor3 = Theme.Shadow, BackgroundTransparency = 0.55,
        BorderSizePixel = 0, ZIndex = 0, Parent = Main,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 14), Parent = Shadow })

    -- TopBar
    local TopBar = Create("Frame", {
        Name = "TopBar", Size = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = Theme.TopBar, BorderSizePixel = 0, Parent = Main,
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = TopBar })
    Create("Frame", { Size = UDim2.new(1, 0, 0, 10), Position = UDim2.new(0, 0, 1, -10), BackgroundColor3 = Theme.TopBar, BorderSizePixel = 0, Parent = TopBar })
    Create("Frame", { Size = UDim2.new(1, 0, 0, 2), Position = UDim2.new(0, 0, 1, -1), BackgroundColor3 = Theme.Accent, BorderSizePixel = 0, Parent = TopBar })

    local dot = Create("Frame", { Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(0, 14, 0.5, -5), BackgroundColor3 = Theme.Accent, BorderSizePixel = 0, Parent = TopBar })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = dot })

    Create("TextLabel", { Name = "Title", Size = UDim2.new(0, 180, 1, 0), Position = UDim2.new(0, 32, 0, 0), BackgroundTransparency = 1, Text = title, Font = Enum.Font.GothamBold, TextSize = 15, TextColor3 = Theme.TextPrimary, TextXAlignment = Enum.TextXAlignment.Left, Parent = TopBar })
    Create("TextLabel", { Name = "Subtitle", Size = UDim2.new(0, 150, 1, 0), Position = UDim2.new(0, 122, 0, 0), BackgroundTransparency = 1, Text = subtitle, Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = Theme.TextSecondary, TextXAlignment = Enum.TextXAlignment.Left, Parent = TopBar })

    local CloseBtn = Create("TextButton", { Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(1, -36, 0.5, -14), BackgroundColor3 = Color3.fromRGB(200, 55, 55), Text = "✕", Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Color3.fromRGB(255,255,255), BorderSizePixel = 0, Parent = TopBar })
    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = CloseBtn })

    CloseBtn.MouseButton1Click:Connect(function()
        Tween(Main, { Size = UDim2.new(0, size.X.Offset, 0, 0) }, 0.25)
        task.wait(0.25)
        ScreenGui:Destroy()
    end)

    local MinBtn = Create("TextButton", { Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(1, -70, 0.5, -14), BackgroundColor3 = Theme.TabInactive, Text = "─", Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Theme.TextSecondary, BorderSizePixel = 0, Parent = TopBar })
    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = MinBtn })

    local minimized = false
    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        Tween(Main, { Size = minimized and UDim2.new(0, size.X.Offset, 0, 44) or size }, 0.3)
    end)

    MakeDraggable(Main, TopBar)

    -- TabBar
    local TabBar = Create("Frame", { Name = "TabBar", Size = UDim2.new(0, 130, 1, -44), Position = UDim2.new(0, 0, 0, 44), BackgroundColor3 = Theme.TabBar, BorderSizePixel = 0, ClipsDescendants = true, Parent = Main })
    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = TabBar })
    Create("Frame", { Size = UDim2.new(1, 0, 0, 10), BackgroundColor3 = Theme.TabBar, BorderSizePixel = 0, Parent = TabBar })
    Create("Frame", { Size = UDim2.new(0, 10, 1, 0), Position = UDim2.new(1, -10, 0, 0), BackgroundColor3 = Theme.TabBar, BorderSizePixel = 0, Parent = TabBar })

    local TabList = Create("ScrollingFrame", { Name = "TabList", Size = UDim2.new(1, 0, 1, -10), Position = UDim2.new(0, 0, 0, 10), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 0, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = TabBar })
    Create("UIListLayout", { Padding = UDim.new(0, 4), HorizontalAlignment = Enum.HorizontalAlignment.Center, Parent = TabList })
    Create("UIPadding", { PaddingTop = UDim.new(0, 6), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6), Parent = TabList })

    local ContentArea = Create("Frame", { Name = "ContentArea", Size = UDim2.new(1, -130, 1, -44), Position = UDim2.new(0, 130, 0, 44), BackgroundColor3 = Theme.Background, BorderSizePixel = 0, ClipsDescendants = true, Parent = Main })

    -- Open animation
    Main.Size = UDim2.new(0, size.X.Offset, 0, 0)
    Main.BackgroundTransparency = 1
    Tween(Main, { Size = size, BackgroundTransparency = 0 }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    local Window = { ScreenGui = ScreenGui, Main = Main, TabList = TabList, ContentArea = ContentArea, Tabs = {}, ActiveTab = nil }

    -- Notification container
    local notifContainer = Create("Frame", { Name = "Notifications", Size = UDim2.new(0, 280, 1, 0), Position = UDim2.new(1, -290, 0, 0), BackgroundTransparency = 1, BorderSizePixel = 0, Parent = ScreenGui })
    Create("UIListLayout", { VerticalAlignment = Enum.VerticalAlignment.Bottom, HorizontalAlignment = Enum.HorizontalAlignment.Right, Padding = UDim.new(0, 6), Parent = notifContainer })
    Create("UIPadding", { PaddingBottom = UDim.new(0, 16), Parent = notifContainer })

    function Window:Notify(opts)
        opts = opts or {}
        local nTitle = opts.Title or "KrixUI"
        local nDesc  = opts.Description or ""
        local nType  = opts.Type or "Info"
        local nDur   = opts.Duration or 4
        local col    = nType == "Success" and Theme.NotifSuccess or nType == "Error" and Theme.NotifError or Theme.NotifInfo

        local card = Create("Frame", { Size = UDim2.new(1, 0, 0, 70), BackgroundColor3 = Theme.Notification, BorderSizePixel = 0, ClipsDescendants = true, Parent = notifContainer })
        Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = card })
        Create("UIStroke", { Color = Theme.Border, Thickness = 1, Parent = card })
        Create("Frame", { Size = UDim2.new(0, 4, 1, 0), BackgroundColor3 = col, BorderSizePixel = 0, Parent = card })
        Create("TextLabel", { Size = UDim2.new(1, -18, 0, 22), Position = UDim2.new(0, 14, 0, 8), BackgroundTransparency = 1, Text = nTitle, Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Theme.TextPrimary, TextXAlignment = Enum.TextXAlignment.Left, Parent = card })
        Create("TextLabel", { Size = UDim2.new(1, -18, 0, 32), Position = UDim2.new(0, 14, 0, 30), BackgroundTransparency = 1, Text = nDesc, Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = Theme.TextSecondary, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, Parent = card })
        local bar = Create("Frame", { Size = UDim2.new(1, 0, 0, 3), Position = UDim2.new(0, 0, 1, -3), BackgroundColor3 = col, BorderSizePixel = 0, Parent = card })
        Tween(bar, { Size = UDim2.new(0, 0, 0, 3) }, nDur, Enum.EasingStyle.Linear)
        task.delay(nDur, function()
            Tween(card, { BackgroundTransparency = 1 }, 0.4)
            task.wait(0.4)
            card:Destroy()
        end)
    end

    function Window:AddTab(tabOptions)
        tabOptions = tabOptions or {}
        local tabName = tabOptions.Name or "Tab"
        local tabIcon = tabOptions.Icon or ""

        local btn = Create("TextButton", { Name = tabName, Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = Theme.TabInactive, Text = "", BorderSizePixel = 0, AutoButtonColor = false, Parent = self.TabList })
        Create("UICorner", { CornerRadius = UDim.new(0, 7), Parent = btn })
        local btnLabel = Create("TextLabel", { Size = UDim2.new(1, -10, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = (tabIcon ~= "" and tabIcon .. "  " or "") .. tabName, Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = Theme.TextSecondary, TextXAlignment = Enum.TextXAlignment.Left, Parent = btn })

        local page = Create("ScrollingFrame", { Name = tabName .. "Page", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.Accent, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false, Parent = self.ContentArea })
        Create("UIListLayout", { Padding = UDim.new(0, 6), Parent = page })
        Create("UIPadding", { PaddingTop = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 14), PaddingBottom = UDim.new(0, 10), Parent = page })

        local Tab = { Button = btn, Page = page, Sections = {} }

        local function Activate()
            for _, t in pairs(self.Tabs) do
                Tween(t.Button, { BackgroundColor3 = Theme.TabInactive }, 0.15)
                if t.Button:FindFirstChild("TextLabel") then
                    t.Button:FindFirstChild("TextLabel").TextColor3 = Theme.TextSecondary
                    t.Button:FindFirstChild("TextLabel").Font = Enum.Font.Gotham
                end
                t.Page.Visible = false
            end
            Tween(btn, { BackgroundColor3 = Theme.TabActive }, 0.15)
            btnLabel.TextColor3 = Theme.TextPrimary
            btnLabel.Font = Enum.Font.GothamBold
            page.Visible = true
            self.ActiveTab = Tab
        end

        btn.MouseButton1Click:Connect(Activate)
        btn.MouseEnter:Connect(function() if self.ActiveTab ~= Tab then Tween(btn, { BackgroundColor3 = Theme.ElementHover }, 0.1) end end)
        btn.MouseLeave:Connect(function() if self.ActiveTab ~= Tab then Tween(btn, { BackgroundColor3 = Theme.TabInactive }, 0.1) end end)
        table.insert(self.Tabs, Tab)
        if #self.Tabs == 1 then Activate() end

        function Tab:AddSection(sectionName)
            local section = Create("Frame", { Name = sectionName, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = Theme.Section, BorderSizePixel = 0, Parent = page })
            Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = section })
            Create("UIStroke", { Color = Theme.Border, Thickness = 1, Parent = section })
            Create("TextLabel", { Name = "Header", Size = UDim2.new(1, -16, 0, 30), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = sectionName, Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Theme.Accent, TextXAlignment = Enum.TextXAlignment.Left, Parent = section })
            Create("Frame", { Size = UDim2.new(1, -20, 0, 1), Position = UDim2.new(0, 10, 0, 30), BackgroundColor3 = Theme.Border, BorderSizePixel = 0, Parent = section })

            local itemList = Create("Frame", { Name = "Items", Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 0, 32), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = section })
            Create("UIListLayout", { Padding = UDim.new(0, 2), Parent = itemList })
            Create("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), Parent = itemList })

            local Section = {}

            function Section:AddButton(opts)
                opts = opts or {}
                local elem = Create("TextButton", { Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = Theme.Element, Text = "", BorderSizePixel = 0, AutoButtonColor = false, Parent = itemList })
                Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = elem })
                Create("TextLabel", { Size = UDim2.new(1, -100, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = opts.Name or "Button", Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = Theme.TextPrimary, TextXAlignment = Enum.TextXAlignment.Left, Parent = elem })
                local execBtn = Create("TextButton", { Size = UDim2.new(0, 80, 0, 26), Position = UDim2.new(1, -88, 0.5, -13), BackgroundColor3 = Theme.Accent, Text = "Execute", Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Color3.fromRGB(255,255,255), BorderSizePixel = 0, Parent = elem })
                Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = execBtn })
                execBtn.MouseButton1Click:Connect(function()
                    Tween(execBtn, { BackgroundColor3 = Theme.AccentDark }, 0.1)
                    task.wait(0.1)
                    Tween(execBtn, { BackgroundColor3 = Theme.Accent }, 0.1)
                    if opts.Callback then opts.Callback() end
                end)
                elem.MouseEnter:Connect(function() Tween(elem, { BackgroundColor3 = Theme.ElementHover }, 0.1) end)
                elem.MouseLeave:Connect(function() Tween(elem, { BackgroundColor3 = Theme.Element }, 0.1) end)
                return elem
            end

            function Section:AddToggle(opts)
                opts = opts or {}
                local state = opts.Default or false
                local elem = Create("Frame", { Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = Theme.Element, BorderSizePixel = 0, Parent = itemList })
                Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = elem })
                Create("TextLabel", { Size = UDim2.new(1, -70, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = opts.Name or "Toggle", Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = Theme.TextPrimary, TextXAlignment = Enum.TextXAlignment.Left, Parent = elem })
                local trackBg = Create("Frame", { Size = UDim2.new(0, 44, 0, 24), Position = UDim2.new(1, -54, 0.5, -12), BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff, BorderSizePixel = 0, Parent = elem })
                Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = trackBg })
                local knob = Create("Frame", { Size = UDim2.new(0, 18, 0, 18), Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9), BackgroundColor3 = Color3.fromRGB(255,255,255), BorderSizePixel = 0, Parent = trackBg })
                Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = knob })
                local clickArea = Create("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = elem })
                clickArea.MouseButton1Click:Connect(function()
                    state = not state
                    Tween(trackBg, { BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff }, 0.2)
                    Tween(knob, { Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9) }, 0.2)
                    if opts.Callback then opts.Callback(state) end
                end)
                elem.MouseEnter:Connect(function() Tween(elem, { BackgroundColor3 = Theme.ElementHover }, 0.1) end)
                elem.MouseLeave:Connect(function() Tween(elem, { BackgroundColor3 = Theme.Element }, 0.1) end)
                local ToggleObj = {}
                function ToggleObj:Set(v)
                    state = v
                    Tween(trackBg, { BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff }, 0.2)
                    Tween(knob, { Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9) }, 0.2)
                    if opts.Callback then opts.Callback(state) end
                end
                function ToggleObj:Get() return state end
                return ToggleObj
            end

            function Section:AddSlider(opts)
                opts = opts or {}
                local min = opts.Min or 0
                local max = opts.Max or 100
                local value = math.clamp(opts.Default or min, min, max)
                local suffix = opts.Suffix or ""
                local elem = Create("Frame", { Size = UDim2.new(1, 0, 0, 52), BackgroundColor3 = Theme.Element, BorderSizePixel = 0, Parent = itemList })
                Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = elem })
                Create("TextLabel", { Size = UDim2.new(0.6, 0, 0, 22), Position = UDim2.new(0, 10, 0, 6), BackgroundTransparency = 1, Text = opts.Name or "Slider", Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = Theme.TextPrimary, TextXAlignment = Enum.TextXAlignment.Left, Parent = elem })
                local valLabel = Create("TextLabel", { Size = UDim2.new(0.4, -10, 0, 22), Position = UDim2.new(0.6, 0, 0, 6), BackgroundTransparency = 1, Text = tostring(value) .. suffix, Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Theme.Accent, TextXAlignment = Enum.TextXAlignment.Right, Parent = elem })
                local track = Create("Frame", { Size = UDim2.new(1, -20, 0, 6), Position = UDim2.new(0, 10, 0, 36), BackgroundColor3 = Theme.SliderBg, BorderSizePixel = 0, Parent = elem })
                Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = track })
                local fill = Create("Frame", { Size = UDim2.new((value - min) / (max - min), 0, 1, 0), BackgroundColor3 = Theme.SliderFill, BorderSizePixel = 0, Parent = track })
                Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = fill })
                local thumb = Create("Frame", { Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new((value - min) / (max - min), -7, 0.5, -7), BackgroundColor3 = Color3.fromRGB(255,255,255), BorderSizePixel = 0, Parent = track })
                Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = thumb })
                local sliding = false
                track.InputBegan:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true end end)
                UserInputService.InputEnded:Connect(function(inp) if inp.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end end)
                UserInputService.InputChanged:Connect(function(inp)
                    if sliding and inp.UserInputType == Enum.UserInputType.MouseMovement then
                        local rel = math.clamp((inp.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                        local stepped = math.floor(min + (max - min) * rel)
                        if stepped ~= value then
                            value = stepped
                            fill.Size = UDim2.new(rel, 0, 1, 0)
                            thumb.Position = UDim2.new(rel, -7, 0.5, -7)
                            valLabel.Text = tostring(value) .. suffix
                            if opts.Callback then opts.Callback(value) end
                        end
                    end
                end)
                elem.MouseEnter:Connect(function() Tween(elem, { BackgroundColor3 = Theme.ElementHover }, 0.1) end)
                elem.MouseLeave:Connect(function() Tween(elem, { BackgroundColor3 = Theme.Element }, 0.1) end)
                local SliderObj = {}
                function SliderObj:Set(v)
                    value = math.clamp(v, min, max)
                    local rel = (value - min) / (max - min)
                    fill.Size = UDim2.new(rel, 0, 1, 0)
                    thumb.Position = UDim2.new(rel, -7, 0.5, -7)
                    valLabel.Text = tostring(value) .. suffix
                    if opts.Callback then opts.Callback(value) end
                end
                function SliderObj:Get() return value end
                return SliderObj
            end

            function Section:AddDropdown(opts)
                opts = opts or {}
                local items = opts.Items or {}
                local selected = opts.Default or (items[1] or "Select")
                local open = false
                local elem = Create("Frame", { Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = Theme.Element, BorderSizePixel = 0, ClipsDescendants = false, Parent = itemList })
                Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = elem })
                Create("TextLabel", { Size = UDim2.new(0.5, 0, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = opts.Name or "Dropdown", Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = Theme.TextPrimary, TextXAlignment = Enum.TextXAlignment.Left, Parent = elem })
                local selLabel = Create("TextLabel", { Size = UDim2.new(0.5, -36, 1, 0), Position = UDim2.new(0.5, 0, 0, 0), BackgroundTransparency = 1, Text = selected, Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = Theme.Accent, TextXAlignment = Enum.TextXAlignment.Right, Parent = elem })
                local arrow = Create("TextLabel", { Size = UDim2.new(0, 20, 1, 0), Position = UDim2.new(1, -24, 0, 0), BackgroundTransparency = 1, Text = "▼", Font = Enum.Font.Gotham, TextSize = 10, TextColor3 = Theme.TextSecondary, Parent = elem })
                local dropList = Create("Frame", { Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 1, 4), BackgroundColor3 = Theme.Element, BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 10, Visible = false, Parent = elem })
                Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = dropList })
                Create("UIStroke", { Color = Theme.Accent, Thickness = 1, Parent = dropList })
                local dropScroll = Create("ScrollingFrame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2, ScrollBarImageColor3 = Theme.Accent, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 10, Parent = dropList })
                Create("UIListLayout", { Padding = UDim.new(0, 2), Parent = dropScroll })
                Create("UIPadding", { PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4), PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4), Parent = dropScroll })

                local function BuildItems()
                    for _, c in pairs(dropScroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
                    for _, item in ipairs(items) do
                        local btn2 = Create("TextButton", { Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = item == selected and Theme.Accent or Theme.TabInactive, Text = item, Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = Theme.TextPrimary, BorderSizePixel = 0, ZIndex = 11, Parent = dropScroll })
                        Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = btn2 })
                        btn2.MouseButton1Click:Connect(function()
                            selected = item; selLabel.Text = item
                            open = false
                            Tween(dropList, { Size = UDim2.new(1, 0, 0, 0) }, 0.2)
                            task.delay(0.2, function() dropList.Visible = false end)
                            arrow.Text = "▼"
                            BuildItems()
                            if opts.Callback then opts.Callback(selected) end
                        end)
                    end
                end
                BuildItems()

                local clickArea2 = Create("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = elem })
                clickArea2.MouseButton1Click:Connect(function()
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
                function DropObj:Set(v) selected = v; selLabel.Text = v; BuildItems(); if opts.Callback then opts.Callback(v) end end
                function DropObj:Get() return selected end
                function DropObj:Refresh(newItems) items = newItems; BuildItems() end
                return DropObj
            end

            function Section:AddTextBox(opts)
                opts = opts or {}
                local elem = Create("Frame", { Size = UDim2.new(1, 0, 0, 52), BackgroundColor3 = Theme.Element, BorderSizePixel = 0, Parent = itemList })
                Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = elem })
                Create("TextLabel", { Size = UDim2.new(1, -20, 0, 22), Position = UDim2.new(0, 10, 0, 4), BackgroundTransparency = 1, Text = opts.Name or "Input", Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = Theme.TextSecondary, TextXAlignment = Enum.TextXAlignment.Left, Parent = elem })
                local box = Create("TextBox", { Size = UDim2.new(1, -20, 0, 22), Position = UDim2.new(0, 10, 0, 26), BackgroundColor3 = Theme.InputBg, Text = opts.Default or "", PlaceholderText = opts.Placeholder or "Type here...", PlaceholderColor3 = Theme.TextDisabled, Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = Theme.TextPrimary, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false, BorderSizePixel = 0, Parent = elem })
                Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = box })
                Create("UIPadding", { PaddingLeft = UDim.new(0, 6), Parent = box })
                box.FocusLost:Connect(function(enter) if enter and opts.Callback then opts.Callback(box.Text) end end)
                elem.MouseEnter:Connect(function() Tween(elem, { BackgroundColor3 = Theme.ElementHover }, 0.1) end)
                elem.MouseLeave:Connect(function() Tween(elem, { BackgroundColor3 = Theme.Element }, 0.1) end)
                local BoxObj = {}
                function BoxObj:Set(v) box.Text = v end
                function BoxObj:Get() return box.Text end
                return BoxObj
            end

            function Section:AddKeybind(opts)
                opts = opts or {}
                local current = opts.Default or Enum.KeyCode.Unknown
                local listening = false
                local elem = Create("Frame", { Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = Theme.Element, BorderSizePixel = 0, Parent = itemList })
                Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = elem })
                Create("TextLabel", { Size = UDim2.new(0.5, 0, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = opts.Name or "Keybind", Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = Theme.TextPrimary, TextXAlignment = Enum.TextXAlignment.Left, Parent = elem })
                local keyBtn = Create("TextButton", { Size = UDim2.new(0, 80, 0, 26), Position = UDim2.new(1, -88, 0.5, -13), BackgroundColor3 = Theme.TabInactive, Text = current.Name, Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Theme.Accent, BorderSizePixel = 0, Parent = elem })
                Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = keyBtn })
                keyBtn.MouseButton1Click:Connect(function() listening = true; keyBtn.Text = "..."; keyBtn.TextColor3 = Theme.TextSecondary end)
                UserInputService.InputBegan:Connect(function(inp, gpe)
                    if gpe then return end
                    if listening and inp.UserInputType == Enum.UserInputType.Keyboard then
                        current = inp.KeyCode; listening = false
                        keyBtn.Text = current.Name; keyBtn.TextColor3 = Theme.Accent
                    elseif not listening and inp.KeyCode == current then
                        if opts.Callback then opts.Callback() end
                    end
                end)
                elem.MouseEnter:Connect(function() Tween(elem, { BackgroundColor3 = Theme.ElementHover }, 0.1) end)
                elem.MouseLeave:Connect(function() Tween(elem, { BackgroundColor3 = Theme.Element }, 0.1) end)
                local KeyObj = {}
                function KeyObj:Set(k) current = k; keyBtn.Text = k.Name end
                function KeyObj:Get() return current end
                return KeyObj
            end

            function Section:AddLabel(opts)
                opts = opts or {}
                local lbl = Create("TextLabel", { Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, Text = opts.Text or "Label", Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = Theme.TextSecondary, TextXAlignment = Enum.TextXAlignment.Left, Parent = itemList })
                Create("UIPadding", { PaddingLeft = UDim.new(0, 2), Parent = lbl })
                local LabelObj = {}
                function LabelObj:Set(v) lbl.Text = v end
                function LabelObj:Get() return lbl.Text end
                return LabelObj
            end

            function Section:AddSeparator()
                Create("Frame", { Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = Theme.Border, BorderSizePixel = 0, Parent = itemList })
            end

            table.insert(self.Sections, Section)
            return Section
        end

        return Tab
    end

    return Window
end

return KrixUI
end)()

-- ════════════════════════════════════════════════════════════
--   EXAMPLE USAGE
-- ════════════════════════════════════════════════════════════

local Window = KrixUI:CreateWindow({
    Title    = "KrixUI",
    Subtitle = "v1.0 | Test",
    Size     = UDim2.new(0, 620, 0, 440),
})

-- Tab Combat
local CombatTab   = Window:AddTab({ Name = "Combat",  Icon = "⚔️" })
local MainSection = CombatTab:AddSection("Aimbot")

local aimbotToggle = MainSection:AddToggle({
    Name = "Aimbot", Default = false,
    Callback = function(s) print("[KrixUI] Aimbot:", s) end,
})

MainSection:AddSlider({
    Name = "FOV", Min = 10, Max = 500, Default = 150, Suffix = " px",
    Callback = function(v) print("[KrixUI] FOV:", v) end,
})

MainSection:AddDropdown({
    Name = "Target Part", Items = { "Head", "HumanoidRootPart", "UpperTorso" }, Default = "Head",
    Callback = function(s) print("[KrixUI] Target:", s) end,
})

CombatTab:AddSection("Keybinds"):AddKeybind({
    Name = "Toggle Aimbot", Default = Enum.KeyCode.E,
    Callback = function() aimbotToggle:Set(not aimbotToggle:Get()) end,
})

-- Tab Visual
local VisualTab  = Window:AddTab({ Name = "Visual", Icon = "👁️" })
local ESPSection = VisualTab:AddSection("ESP")

ESPSection:AddToggle({ Name = "ESP Boxes",  Default = false, Callback = function(s) print("Boxes:",  s) end })
ESPSection:AddToggle({ Name = "ESP Names",  Default = false, Callback = function(s) print("Names:",  s) end })
ESPSection:AddSlider({ Name = "Max Distance", Min = 50, Max = 2000, Default = 500, Suffix = " studs", Callback = function(v) print("Dist:", v) end })

-- Tab Misc
local MiscTab     = Window:AddTab({ Name = "Misc", Icon = "⚙️" })
local MiscSection = MiscTab:AddSection("Utilities")

MiscSection:AddButton({
    Name = "Rejoin", Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end,
})

MiscSection:AddButton({
    Name = "Copy Username", Callback = function()
        local n = game.Players.LocalPlayer.Name
        pcall(function() setclipboard(n) end)
        Window:Notify({ Title = "Copié", Description = n, Type = "Success", Duration = 3 })
    end,
})

MiscSection:AddSeparator()
MiscSection:AddLabel({ Text = "KrixUI v1.0.0 — Made by Krix" })

MiscTab:AddSection("Script Executor"):AddTextBox({
    Name = "Execute Lua", Placeholder = "Entrez votre script...",
    Callback = function(text)
        if text == "" then return end
        local fn, err = loadstring(text)
        if fn then
            local ok, runErr = pcall(fn)
            if not ok then Window:Notify({ Title = "Runtime Error", Description = tostring(runErr), Type = "Error", Duration = 5 }) end
        else
            Window:Notify({ Title = "Syntax Error", Description = tostring(err), Type = "Error", Duration = 5 })
        end
    end,
})

task.wait(1)
Window:Notify({ Title = "KrixUI Chargé ✓", Description = "Interface injectée avec succès !", Type = "Success", Duration = 4 })
