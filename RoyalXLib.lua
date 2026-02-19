local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local function MakeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function Library:CreateWindow(config)
    config = config or {}
    local windowTitle = config.Name or "RoyalX HUB"
    local logoId = "rbxassetid://107831103893115"

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RoyalX_Final"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

    -- === LOADING SCREEN (Hiện nguyên chữ rồi mờ dần) ===
    local LoadingFrame = Instance.new("Frame")
    LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
    LoadingFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    LoadingFrame.ZIndex = 10
    LoadingFrame.Parent = ScreenGui

    local LoadingText = Instance.new("TextLabel")
    LoadingText.Size = UDim2.new(1, 0, 1, 0)
    LoadingText.BackgroundTransparency = 1
    LoadingText.Font = Enum.Font.GothamBold
    LoadingText.Text = windowTitle
    LoadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
    LoadingText.TextSize = 45
    LoadingText.TextTransparency = 1
    LoadingText.Parent = LoadingFrame

    -- === MAIN UI ===
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BackgroundTransparency = 0.1
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.Visible = false
    MainFrame.ClipsDescendants = true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
    MakeDraggable(MainFrame)

    -- TopBar (Chứa Tabs)
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundTransparency = 1
    TopBar.Size = UDim2.new(1, 0, 0, 50)

    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Name = "TabScroll"
    TabScroll.Parent = TopBar
    TabScroll.BackgroundTransparency = 1
    TabScroll.Position = UDim2.new(0, 50, 0, 8)
    TabScroll.Size = UDim2.new(1, -90, 1, -15)
    TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabScroll.ScrollBarThickness = 0
    local TabList = Instance.new("UIListLayout", TabScroll)
    TabList.FillDirection = Enum.FillDirection.Horizontal
    TabList.Padding = UDim.new(0, 8)

    -- Content Area
    local ContainerArea = Instance.new("Frame")
    ContainerArea.Name = "ContainerArea"
    ContainerArea.Parent = MainFrame
    ContainerArea.BackgroundTransparency = 1
    ContainerArea.Position = UDim2.new(0, 15, 0, 60)
    ContainerArea.Size = UDim2.new(1, -30, 1, -75)

    -- Nút bật/tắt nổi
    local ToggleButton = Instance.new("ImageButton")
    ToggleButton.Size = UDim2.new(0, 50, 0, 50)
    ToggleButton.Position = UDim2.new(0.02, 0, 0.15, 0)
    ToggleButton.Image = logoId
    ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ToggleButton.Visible = false
    ToggleButton.Parent = ScreenGui
    Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 10)

    -- Animation bật tắt UI
    local function ToggleUI(state)
        if state then
            MainFrame.Visible = true
            TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.new(0, 600, 0, 400)}):Play()
            ToggleButton.Visible = false
        else
            local tw = TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)})
            tw:Play()
            tw.Completed:Connect(function()
                MainFrame.Visible = false
                ToggleButton.Visible = true
            end)
        end
    end

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Text = "X"
    CloseBtn.Parent = MainFrame
    CloseBtn.Position = UDim2.new(1, -35, 0, 10)
    CloseBtn.Size = UDim2.new(0, 25, 0, 25)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    CloseBtn.MouseButton1Click:Connect(function() ToggleUI(false) end)
    ToggleButton.MouseButton1Click:Connect(function() ToggleUI(true) end)

    -- Chạy Loading
    task.spawn(function()
        TweenService:Create(LoadingText, TweenInfo.new(1), {TextTransparency = 0}):Play()
        task.wait(1.5)
        TweenService:Create(LoadingText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        local fadeOut = TweenService:Create(LoadingFrame, TweenInfo.new(0.8), {BackgroundTransparency = 1})
        fadeOut:Play()
        fadeOut.Completed:Connect(function()
            LoadingFrame:Destroy()
            ToggleUI(true)
        end)
    end)

    local Window = { Tabs = {}, CurrentTab = nil }

    function Window:CreateTab(name)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = TabScroll
        TabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        TabBtn.Size = UDim2.new(0, 100, 1, 0)
        TabBtn.Text = name
        TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabBtn.Font = Enum.Font.GothamMedium
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

        local Page = Instance.new("Frame")
        Page.Parent = ContainerArea
        Page.BackgroundTransparency = 1
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.Visible = false

        local LeftCol = Instance.new("ScrollingFrame")
        LeftCol.Parent = Page
        LeftCol.Size = UDim2.new(0.5, -7, 1, 0)
        LeftCol.BackgroundTransparency = 1
        LeftCol.ScrollBarThickness = 0
        Instance.new("UIListLayout", LeftCol).Padding = UDim.new(0, 10)

        local RightCol = Instance.new("ScrollingFrame")
        RightCol.Parent = Page
        RightCol.Position = UDim2.new(0.5, 7, 0, 0)
        RightCol.Size = UDim2.new(0.5, -7, 1, 0)
        RightCol.BackgroundTransparency = 1
        RightCol.ScrollBarThickness = 0
        Instance.new("UIListLayout", RightCol).Padding = UDim.new(0, 10)

        TabBtn.MouseButton1Click:Connect(function()
            if Window.CurrentTab then
                Window.CurrentTab.Page.Visible = false
                Window.CurrentTab.Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            end
            Page.Visible = true
            TabBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            Window.CurrentTab = {Page = Page, Btn = TabBtn}
        end)

        if not Window.CurrentTab then
            Page.Visible = true
            TabBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            Window.CurrentTab = {Page = Page, Btn = TabBtn}
        end

        local Tab = {}
        function Tab:CreateSection(title, side)
            local ParentCol = (side == "Right") and RightCol or LeftCol
            local Section = Instance.new("Frame")
            Section.Parent = ParentCol
            Section.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            Section.Size = UDim2.new(1, 0, 0, 40)
            Instance.new("UICorner", Section).CornerRadius = UDim.new(0, 8)

            local sTitle = Instance.new("TextLabel")
            sTitle.Parent = Section
            sTitle.Text = "✨ " .. title .. " ✨"
            sTitle.Size = UDim2.new(1, 0, 0, 30)
            sTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            sTitle.BackgroundTransparency = 1
            sTitle.Font = Enum.Font.GothamBold

            local sContainer = Instance.new("Frame")
            sContainer.Parent = Section
            sContainer.Position = UDim2.new(0, 10, 0, 35)
            sContainer.Size = UDim2.new(1, -20, 1, -40)
            sContainer.BackgroundTransparency = 1
            local sLayout = Instance.new("UIListLayout", sContainer)
            sLayout.Padding = UDim.new(0, 8)

            sLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Section.Size = UDim2.new(1, 0, 0, sLayout.AbsoluteContentSize.Y + 45)
            end)

            local Elements = {}
            function Elements:CreateToggle(text, default, callback)
                local Tgl = Instance.new("TextButton")
                Tgl.Parent = sContainer
                Tgl.Size = UDim2.new(1, 0, 0, 30)
                Tgl.BackgroundTransparency = 1
                Tgl.Text = "  " .. text
                Tgl.TextColor3 = Color3.fromRGB(180, 180, 180)
                Tgl.TextXAlignment = Enum.TextXAlignment.Left

                local Box = Instance.new("Frame")
                Box.Parent = Tgl
                Box.Position = UDim2.new(1, -25, 0.5, -10)
                Box.Size = UDim2.new(0, 20, 0, 20)
                Box.BackgroundColor3 = default and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 60)
                Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)

                local state = default
                Tgl.MouseButton1Click:Connect(function()
                    state = not state
                    TweenService:Create(Box, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 60)}):Play()
                    callback(state)
                end)
            end
            return Elements
        end
        return Tab
    end
    return Window
end

return Library
