local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

function Library:CreateWindow(config)
    config = config or {}
    local windowTitle = config.Name or "RoyalX HUB"
    local logoId = "rbxassetid://107831103893115"

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RoyalX_TabSeparated"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

    -- MAIN FRAME (Nền tổng thể)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.Position = UDim2.new(0.5, -400, 0.5, -250) 
    MainFrame.Size = UDim2.new(0, 800, 0, 500)
    MainFrame.ClipsDescendants = true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

    -- === PHẦN NỀN RIÊNG CHO TAB (Top Bar Background) ===
    local TabBackground = Instance.new("Frame")
    TabBackground.Name = "TabBackground"
    TabBackground.Parent = MainFrame
    TabBackground.Size = UDim2.new(1, -20, 0, 40) -- Nền riêng cho thanh tab
    TabBackground.Position = UDim2.new(0, 10, 0, 10)
    TabBackground.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Màu Tab đậm hơn nền chính
    Instance.new("UICorner", TabBackground).CornerRadius = UDim.new(0, 8)

    -- Logo nằm trong nền Tab
    local MainLogo = Instance.new("ImageLabel")
    MainLogo.Parent = TabBackground
    MainLogo.Position = UDim2.new(0, 8, 0.5, -14)
    MainLogo.Size = UDim2.new(0, 28, 0, 28)
    MainLogo.Image = logoId
    MainLogo.BackgroundTransparency = 1

    -- Scrolling chứa các nút Tab
    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Parent = TabBackground
    TabScroll.Position = UDim2.new(0, 45, 0, 4)
    TabScroll.Size = UDim2.new(1, -85, 1, -8)
    TabScroll.BackgroundTransparency = 1
    TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
    TabScroll.ScrollBarThickness = 0
    TabScroll.ElasticBehavior = Enum.ElasticBehavior.Never

    local TabList = Instance.new("UIListLayout", TabScroll)
    TabList.FillDirection = Enum.FillDirection.Horizontal
    TabList.Padding = UDim.new(0, 8)
    TabList.VerticalAlignment = Enum.VerticalAlignment.Center

    -- Khu vực nội dung bên dưới
    local ContentArea = Instance.new("Frame")
    ContentArea.Parent = MainFrame
    ContentArea.Position = UDim2.new(0, 10, 0, 60)
    ContentArea.Size = UDim2.new(1, -20, 1, -70)
    ContentArea.BackgroundTransparency = 1

    local Window = { CurrentTab = nil }

    function Window:CreateTab(name)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = TabScroll
        TabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        TabBtn.Size = UDim2.new(0, 95, 0, 24) -- Nút tab gọn hơn
        TabBtn.Text = name
        TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 11
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

        local Page = Instance.new("Frame")
        Page.Parent = ContentArea
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.Visible = false
        Page.BackgroundTransparency = 1

        -- Cột Trái/Phải với nền đậm riêng biệt
        local function CreateColumn(pos)
            local ColBackground = Instance.new("Frame")
            ColBackground.Parent = Page
            ColBackground.Position = pos
            ColBackground.Size = UDim2.new(0.5, -7, 1, 0)
            ColBackground.BackgroundColor3 = Color3.fromRGB(10, 10, 10) -- Nền cột đậm nhất
            Instance.new("UICorner", ColBackground).CornerRadius = UDim.new(0, 10)

            local ColScroll = Instance.new("ScrollingFrame")
            ColScroll.Parent = ColBackground
            ColScroll.Size = UDim2.new(1, -10, 1, -10)
            ColScroll.Position = UDim2.new(0, 5, 0, 5)
            ColScroll.BackgroundTransparency = 1
            ColScroll.ScrollBarThickness = 0
            ColScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
            ColScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
            ColScroll.ElasticBehavior = Enum.ElasticBehavior.Never
            
            local Layout = Instance.new("UIListLayout", ColScroll)
            Layout.Padding = UDim.new(0, 10)
            return ColScroll
        end

        local LeftCol = CreateColumn(UDim2.new(0, 0, 0, 0))
        local RightCol = CreateColumn(UDim2.new(0.5, 7, 0, 0))

        TabBtn.MouseButton1Click:Connect(function()
            if Window.CurrentTab then
                Window.CurrentTab.Page.Visible = false
                TweenService:Create(Window.CurrentTab.Btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(35, 35, 35), TextColor3 = Color3.fromRGB(180, 180, 180)}):Play()
            end
            Page.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 170, 255), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            Window.CurrentTab = {Page = Page, Btn = TabBtn}
        end)

        if not Window.CurrentTab then
            Page.Visible = true
            TabBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Window.CurrentTab = {Page = Page, Btn = TabBtn}
        end

        local Tab = {}
        function Tab:CreateSection(title, side)
            local Parent = (side == "Right") and RightCol or LeftCol
            local Section = Instance.new("Frame")
            Section.Parent = Parent
            Section.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            Section.Size = UDim2.new(1, 0, 0, 35)
            Instance.new("UICorner", Section).CornerRadius = UDim.new(0, 8)

            local sTitle = Instance.new("TextLabel")
            sTitle.Parent = Section
            sTitle.Text = title
            sTitle.Size = UDim2.new(1, 0, 0, 28)
            sTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            sTitle.BackgroundTransparency = 1
            sTitle.Font = Enum.Font.GothamBold
            sTitle.TextSize = 12

            local sCont = Instance.new("Frame")
            sCont.Parent = Section
            sCont.Position = UDim2.new(0, 10, 0, 30)
            sCont.Size = UDim2.new(1, -20, 1, -40)
            sCont.BackgroundTransparency = 1
            local sLayout = Instance.new("UIListLayout", sCont)
            sLayout.Padding = UDim.new(0, 6)

            sLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Section.Size = UDim2.new(1, 0, 0, sLayout.AbsoluteContentSize.Y + 40)
            end)

            local Elements = {}
            function Elements:CreateToggle(text, default, callback)
                local Tgl = Instance.new("TextButton")
                Tgl.Parent = sCont
                Tgl.Size = UDim2.new(1, 0, 0, 30)
                Tgl.BackgroundTransparency = 1
                Tgl.Text = "  " .. text
                Tgl.TextColor3 = Color3.fromRGB(180, 180, 180)
                Tgl.TextSize = 12
                Tgl.TextXAlignment = Enum.TextXAlignment.Left
                Tgl.Font = Enum.Font.Gotham

                local Box = Instance.new("Frame")
                Box.Parent = Tgl
                Box.Position = UDim2.new(1, -22, 0.5, -9)
                Box.Size = UDim2.new(0, 18, 0, 18)
                Box.BackgroundColor3 = default and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(45, 45, 45)
                Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)

                local Check = Instance.new("TextLabel")
                Check.Parent = Box
                Check.Size = UDim2.new(1, 0, 1, 0)
                Check.Text = "✓"
                Check.TextColor3 = Color3.fromRGB(255, 255, 255)
                Check.BackgroundTransparency = 1
                Check.TextSize = 14
                Check.Visible = default

                local state = default
                Tgl.MouseButton1Click:Connect(function()
                    state = not state
                    Check.Visible = state
                    TweenService:Create(Box, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(45, 45, 45)}):Play()
                    callback(state)
                end)
            end
            return Elements
        end
        return Tab
    end

    -- Close Button "X" nằm trên nền Tab
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Text = "X"
    CloseBtn.Parent = TabBackground
    CloseBtn.Position = UDim2.new(1, -30, 0, 0)
    CloseBtn.Size = UDim2.new(0, 30, 1, 0)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.TextColor3 = Color3.fromRGB(200, 0, 0)
    CloseBtn.Font = Enum.Font.GothamBold

    -- Nút Logo bật tắt UI (Floating Button)
    local ToggleButton = Instance.new("ImageButton")
    ToggleButton.Size = UDim2.new(0, 55, 0, 55)
    ToggleButton.Position = UDim2.new(0.02, 0, 0.15, 0)
    ToggleButton.Image = logoId
    ToggleButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    ToggleButton.Visible = false
    ToggleButton.Parent = ScreenGui
    Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 12)

    local function ToggleUI(state)
        if state then
            MainFrame.Visible = true
            MainFrame:TweenSize(UDim2.new(0, 800, 0, 500), "Out", "Back", 0.5, true)
            ToggleButton.Visible = false
        else
            MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Quart", 0.3, true, function()
                MainFrame.Visible = false
                ToggleButton.Visible = true
            end)
        end
    end

    CloseBtn.MouseButton1Click:Connect(function() ToggleUI(false) end)
    ToggleButton.MouseButton1Click:Connect(function() ToggleUI(true) end)

    return Window
end

return Library
