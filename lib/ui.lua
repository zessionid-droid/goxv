-- ============================================================
-- GOxv UI
-- ============================================================

return function(U, T, config)

    local CoreGui = game:GetService("CoreGui")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local Players = game:GetService("Players")

    U.cleanup({"GOxv", "GOxv_Gui"})

    local UI = {}

    -- ============================================================
    -- ScreenGui
    -- ============================================================
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "GOxv"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 99999
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = CoreGui
    UI.ScreenGui = ScreenGui

    -- ============================================================
    -- Main window
    -- ============================================================
    local Main = Instance.new("Frame")
    Main.Name = "Root"
    Main.BackgroundColor3 = T.BG
    Main.BorderSizePixel = 0
    Main.Size = UDim2.new(0, config.WindowWidth, 0, config.WindowHeight)
    Main.Position = UDim2.new(0.5, -config.WindowWidth/2, 0.5, -config.WindowHeight/2)
    Main.Active = true
    Main.ClipsDescendants = true
    Main.Parent = ScreenGui
    UI.Main = Main

    local mc = Instance.new("UICorner")
    mc.CornerRadius = UDim.new(0, 18)
    mc.Parent = Main

    local ms = Instance.new("UIStroke")
    ms.Color = T.Accent
    ms.Transparency = 0.5
    ms.Thickness = 1.5
    ms.Parent = Main

    -- ambient gradient
    local amb = Instance.new("Frame")
    amb.BackgroundColor3 = Color3.new(1,1,1)
    amb.BackgroundTransparency = 1
    amb.BorderSizePixel = 0
    amb.Size = UDim2.new(1, 0, 0, 200)
    amb.ZIndex = 1
    amb.Parent = Main

    local ambG = Instance.new("UIGradient")
    ambG.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, T.Accent),
        ColorSequenceKeypoint.new(0.6, T.Accent2),
        ColorSequenceKeypoint.new(1, T.BG),
    })
    ambG.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.88),
        NumberSequenceKeypoint.new(0.7, 0.98),
        NumberSequenceKeypoint.new(1, 1),
    })
    ambG.Rotation = 60
    ambG.Parent = amb

    local ambC = Instance.new("UICorner")
    ambC.CornerRadius = UDim.new(0, 18)
    ambC.Parent = amb

    -- ============================================================
    -- Header
    -- ============================================================
    local Header = Instance.new("Frame")
    Header.BackgroundColor3 = T.BG2
    Header.BackgroundTransparency = 0.15
    Header.BorderSizePixel = 0
    Header.Size = UDim2.new(1, 0, 0, 56)
    Header.Active = true
    Header.ZIndex = 5
    Header.Parent = Main

    local hC = Instance.new("UICorner")
    hC.CornerRadius = UDim.new(0, 18)
    hC.Parent = Header

    local Title = Instance.new("TextLabel")
    Title.BackgroundTransparency = 1
    Title.Size = UDim2.new(1, -100, 0, 20)
    Title.Position = UDim2.new(0, 18, 0, 10)
    Title.Font = T.FontBold
    Title.TextSize = 15
    Title.TextColor3 = T.Text
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Text = config.Name
    Title.ZIndex = 6
    Title.Parent = Header

    local Sub = Instance.new("TextLabel")
    Sub.BackgroundTransparency = 1
    Sub.Size = UDim2.new(1, -100, 0, 14)
    Sub.Position = UDim2.new(0, 18, 0, 30)
    Sub.Font = T.Font
    Sub.TextSize = 10
    Sub.TextColor3 = T.Dim
    Sub.TextXAlignment = Enum.TextXAlignment.Left
    Sub.Text = "v" .. config.Version .. " · Studio Lite Helper"
    Sub.ZIndex = 6
    Sub.Parent = Header

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.BackgroundColor3 = T.Surface
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Size = UDim2.new(0, 34, 0, 34)
    CloseBtn.Position = UDim2.new(1, -44, 0, 11)
    CloseBtn.Font = T.FontBold
    CloseBtn.TextSize = 16
    CloseBtn.TextColor3 = T.Danger
    CloseBtn.Text = "×"
    CloseBtn.ZIndex = 7
    CloseBtn.Parent = Header
    local cbc = Instance.new("UICorner")
    cbc.CornerRadius = UDim.new(0, 10)
    cbc.Parent = CloseBtn

    CloseBtn.MouseButton1Click:Connect(function()
        Main.Visible = false
    end)

    -- ============================================================
    -- Tab row
    -- ============================================================
    local TabRow = Instance.new("Frame")
    TabRow.BackgroundTransparency = 1
    TabRow.Size = UDim2.new(1, -20, 0, 36)
    TabRow.Position = UDim2.new(0, 10, 0, 62)
    TabRow.ZIndex = 5
    TabRow.Parent = Main

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 4)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = TabRow

    -- ============================================================
    -- Content container
    -- ============================================================
    local Content = Instance.new("Frame")
    Content.BackgroundTransparency = 1
    Content.Size = UDim2.new(1, -20, 1, -112)
    Content.Position = UDim2.new(0, 10, 0, 102)
    Content.ZIndex = 5
    Content.Parent = Main

    -- ============================================================
    -- Resize handle
    -- ============================================================
    local Resize = Instance.new("TextButton")
    Resize.BackgroundTransparency = 1
    Resize.Size = UDim2.new(0, 26, 0, 26)
    Resize.Position = UDim2.new(1, -26, 1, -26)
    Resize.Text = ""
    Resize.ZIndex = 10
    Resize.Parent = Main

    local g1 = Instance.new("Frame")
    g1.BackgroundColor3 = T.Accent
    g1.BackgroundTransparency = 0.4
    g1.BorderSizePixel = 0
    g1.Size = UDim2.new(0, 10, 0, 2)
    g1.Position = UDim2.new(1, -14, 1, -8)
    g1.Rotation = -45
    g1.ZIndex = 10
    g1.Parent = Main

    local g2 = Instance.new("Frame")
    g2.BackgroundColor3 = T.Accent
    g2.BackgroundTransparency = 0.6
    g2.BorderSizePixel = 0
    g2.Size = UDim2.new(0, 6, 0, 2)
    g2.Position = UDim2.new(1, -8, 1, -14)
    g2.Rotation = -45
    g2.ZIndex = 10
    g2.Parent = Main

    local resizing, resizeStart, startSize
    Resize.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            resizeStart = input.Position
            startSize = Main.Size
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    resizing = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - resizeStart
            local newW = math.max(config.MinWidth, math.min(config.MaxWidth, startSize.X.Offset + delta.X))
            local newH = math.max(config.MinHeight, math.min(config.MaxHeight, startSize.Y.Offset + delta.Y))
            Main.Size = UDim2.new(0, newW, 0, newH)
        end
    end)

    -- ============================================================
    -- Drag
    -- ============================================================
    local dragging, dragStart, startPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            Main.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y
            )
        end
    end)

    -- ============================================================
    -- API untuk module lain
    -- ============================================================

    UI.tabs = {}

    function UI.addTab(id, label)
        local b = Instance.new("TextButton")
        b.BackgroundColor3 = T.Surface
        b.BorderSizePixel = 0
        b.Size = UDim2.new(0, 100, 1, 0)
        b.LayoutOrder = #UI.tabs + 1
        b.Text = ""
        b.ZIndex = 7
        b.Parent = TabRow

        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 8)
        c.Parent = b

        local lbl = Instance.new("TextLabel")
        lbl.BackgroundTransparency = 1
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.Font = T.FontBold
        lbl.TextSize = 11
        lbl.TextColor3 = T.Dim
        lbl.Text = label
        lbl.ZIndex = 8
        lbl.Parent = b

        b.MouseButton1Click:Connect(function()
            UI.switchTab(id)
        end)

        UI.tabs[id] = {button = b, label = lbl}

        -- container
        local container = Instance.new("Frame")
        container.BackgroundTransparency = 1
        container.Size = UDim2.new(1, 0, 1, 0)
        container.Visible = false
        container.ZIndex = 6
        container.Parent = Content
        UI.tabs[id].container = container

        return container
    end

    function UI.switchTab(id)
        for tid, tab in pairs(UI.tabs) do
            tab.container.Visible = (tid == id)
            local active = tid == id
            TweenService:Create(tab.button, TweenInfo.new(0.15), {
                BackgroundColor3 = active and T.Accent or T.Surface,
            }):Play()
            tab.label.TextColor3 = active and Color3.new(0,0,0) or T.Dim
        end
    end

    function UI.makeScroll(parent)
        local scroll = Instance.new("ScrollingFrame")
        scroll.BackgroundColor3 = T.BG2
        scroll.BackgroundTransparency = 0.3
        scroll.BorderSizePixel = 0
        scroll.Size = UDim2.new(1, 0, 1, 0)
        scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        scroll.ScrollBarThickness = 3
        scroll.ScrollBarImageColor3 = T.Accent
        scroll.ZIndex = 6
        scroll.Parent = parent

        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 10)
        c.Parent = scroll

        local pad = Instance.new("UIPadding")
        pad.PaddingTop = UDim.new(0, 8)
        pad.PaddingLeft = UDim.new(0, 8)
        pad.PaddingRight = UDim.new(0, 8)
        pad.PaddingBottom = UDim.new(0, 8)
        pad.Parent = scroll

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 6)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = scroll

        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
        end)

        return scroll, layout
    end

    -- helper: buat text label
    function UI.makeLabel(parent, text, size, color, bold)
        local lbl = Instance.new("TextLabel")
        lbl.BackgroundTransparency = 1
        lbl.Size = UDim2.new(1, 0, 0, size or 20)
        lbl.Font = bold and T.FontBold or T.Font
        lbl.TextSize = 11
        lbl.TextColor3 = color or T.Text
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextWrapped = true
        lbl.Text = text or ""
        lbl.Parent = parent
        return lbl
    end

    -- helper: input text
    function UI.makeInput(parent, placeholder, height)
        local f = Instance.new("Frame")
        f.BackgroundColor3 = T.Surface
        f.BorderSizePixel = 0
        f.Size = UDim2.new(1, 0, 0, height or 44)
        f.Parent = parent

        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 8)
        c.Parent = f

        local tb = Instance.new("TextBox")
        tb.BackgroundTransparency = 1
        tb.Size = UDim2.new(1, -20, 1, 0)
        tb.Position = UDim2.new(0, 10, 0, 0)
        tb.Font = T.Font
        tb.TextSize = 12
        tb.TextColor3 = T.Text
        tb.PlaceholderText = placeholder or ""
        tb.PlaceholderColor3 = T.Dim
        tb.TextXAlignment = Enum.TextXAlignment.Left
        tb.TextWrapped = true
        tb.ClearTextOnFocus = false
        tb.ZIndex = 7
        tb.Parent = f

        return tb, f
    end

    -- helper: button
    function UI.makeButton(parent, text, width, height, color)
        local b = Instance.new("TextButton")
        b.BackgroundColor3 = color or T.Accent
        b.BorderSizePixel = 0
        b.Size = UDim2.new(0, width or 80, 0, height or 32)
        b.Font = T.FontBold
        b.TextSize = 11
        b.TextColor3 = Color3.new(0,0,0)
        b.Text = text or "OK"
        b.ZIndex = 7
        b.Parent = parent

        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 6)
        c.Parent = b

        return b
    end

    -- helper: bubble chat
    function UI.makeBubble(parent, text, isUser, isCode)
        local bubble = Instance.new("Frame")
        bubble.BackgroundColor3 = isUser and T.Accent or T.Surface
        bubble.BorderSizePixel = 0
        bubble.Size = UDim2.new(0.85, 0, 0, 30)
        bubble.AutomaticSize = Enum.AutomaticSize.Y
        bubble.Parent = parent

        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 8)
        c.Parent = bubble

        local lbl = Instance.new("TextLabel")
        lbl.BackgroundTransparency = 1
        lbl.Size = UDim2.new(1, -16, 1, -12)
        lbl.Position = UDim2.new(0, 8, 0, 6)
        lbl.Font = T.Font
        lbl.TextSize = 11
        lbl.TextColor3 = isUser and Color3.new(0,0,0) or T.Text
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextWrapped = true
        lbl.Text = text
        lbl.AutomaticSize = Enum.AutomaticSize.Y
        lbl.Parent = bubble

        if isCode then
            local copyBtn = UI.makeButton(bubble, "COPY", 60, 22, T.Success)
            copyBtn.Position = UDim2.new(1, -68, 0, 4)
            copyBtn.TextSize = 9
            copyBtn.MouseButton1Click:Connect(function()
                U.copy(text)
                copyBtn.Text = "OK!"
            end)
        end

        return bubble
    end

    return UI
end
