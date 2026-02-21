local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local Library = {}

function Library:CreateWindow(Config)
    local Title = Config.Name or "Library UI"
    local LogoID = Config.Logo or "rbxassetid://0"
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CustomLibrary"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- CanvasGroup để tạo hiệu ứng Fade cho toàn bộ UI
    local CanvasGroup = Instance.new("CanvasGroup") 
    CanvasGroup.Parent = ScreenGui
    CanvasGroup.Size = UDim2.new(1, 0, 1, 0)
    CanvasGroup.BackgroundTransparency = 1

    -- Main Frame (MÀU CHÍNH NHẠT)
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = CanvasGroup
    Main.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Màu xám nhạt
    Main.Position = UDim2.new(0.5, -275, 0.5, -175)
    Main.Size = UDim2.new(0, 550, 0, 350)
    Main.ClipsDescendants = true

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = Main

    -- Top Bar chứa Tab (KHU TAB ĐẬM HƠN)
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Parent = Main
    TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- Đen đậm
    TopBar.Size = UDim2.new(1, 0, 0, 50)

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Parent = TopBar
    TabContainer.BackgroundTransparency = 1
    TabContainer.Size = UDim2.new(1, -90, 1, 0) -- Trừ chỗ cho Logo
    TabContainer.ScrollBarThickness = 0
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Parent = TabContainer
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.Padding = UDim.new(0, 10)
    TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center

    -- Logo to góc phải
    local Logo = Instance.new("ImageLabel")
    Logo.Parent = TopBar
    Logo.AnchorPoint = Vector2.new(1, 0.5)
    Logo.Position = UDim2.new(1, -10, 0.5, 0)
    Logo.Size = UDim2.new(0, 80, 0, 45)
    Logo.BackgroundTransparency = 1
    Logo.Image = LogoID
    Logo.ScaleType = Enum.ScaleType.Fit

    -- Container chứa nội dung các Tab
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Parent = Main
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 0, 0, 50)
    ContentContainer.Size = UDim2.new(1, 0, 1, -50)

    -- Hàm xử lý Bật/Tắt Menu (Fade in/out)
    local function ToggleUI(state)
        local targetAlpha = state and 1 or 0
        TweenService:Create(CanvasGroup, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {GroupTransparency = 1 - targetAlpha}):Play()
        if not state then
            task.wait(0.3)
            CanvasGroup.Visible = false
        else
            CanvasGroup.Visible = true
        end
    end

    -- Nút bật tắt UI tròn ở góc
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
    ToggleBtn.Position = UDim2.new(0, 15, 0, 15)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    ToggleBtn.Text = "Hub"
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.Parent = ScreenGui
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)

    local isOpen = true
    ToggleBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        ToggleUI(isOpen)
    end)

    local WindowConfig = {}
    
    -- TẠO TAB & CỘT
    function WindowConfig:CreateTab(TabName)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = TabContainer
        TabBtn.Size = UDim2.new(0, 100, 0, 35)
        TabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        TabBtn.Text = TabName
        TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

        local TabPage = Instance.new("Frame")
        TabPage.Parent = ContentContainer
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.Visible = false -- Sẽ code logic ẩn hiện Tab sau

        -- CHIA 2 CỘT (CỘT MÀU ĐEN ĐẬM HƠN)
        local LeftCol = Instance.new("ScrollingFrame")
        LeftCol.Parent = TabPage
        LeftCol.Size = UDim2.new(0.5, -15, 1, -20)
        LeftCol.Position = UDim2.new(0, 10, 0, 10)
        LeftCol.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Cột đen đậm
        LeftCol.ScrollBarThickness = 2
        Instance.new("UICorner", LeftCol).CornerRadius = UDim.new(0, 6)
        
        local RightCol = Instance.new("ScrollingFrame")
        RightCol.Parent = TabPage
        RightCol.Size = UDim2.new(0.5, -15, 1, -20)
        RightCol.Position = UDim2.new(0.5, 5, 0, 10)
        RightCol.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Cột đen đậm
        RightCol.ScrollBarThickness = 2
        Instance.new("UICorner", RightCol).CornerRadius = UDim.new(0, 6)

        local LeftLayout = Instance.new("UIListLayout", LeftCol)
        LeftLayout.Padding = UDim.new(0, 8)
        LeftLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder

        local TabElements = {}

        -- TẠO TOGGLE (Nút nhạt hơn, Tích tròn)
        function TabElements:AddToggle(Text, ColumnSide, Callback)
            local ParentCol = ColumnSide == "Right" and RightCol or LeftCol
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Parent = ParentCol
            ToggleFrame.Size = UDim2.new(1, -16, 0, 40)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60) -- Chức năng nhạt hơn
            Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 6)

            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Parent = ToggleFrame
            ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = Text
            ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left

            -- Vòng tròn Tích (Không cần kéo)
            local CheckCircle = Instance.new("TextButton")
            CheckCircle.Parent = ToggleFrame
            CheckCircle.Size = UDim2.new(0, 24, 0, 24)
            CheckCircle.Position = UDim2.new(1, -34, 0.5, -12)
            CheckCircle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            CheckCircle.Text = ""
            CheckCircle.TextColor3 = Color3.fromRGB(255, 255, 255)
            CheckCircle.TextSize = 18
            Instance.new("UICorner", CheckCircle).CornerRadius = UDim.new(1, 0) -- Tròn

            local toggled = false
            CheckCircle.MouseButton1Click:Connect(function()
                toggled = not toggled
                if toggled then
                    CheckCircle.Text = "✓"
                    TweenService:Create(CheckCircle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 170, 0)}):Play()
                else
                    CheckCircle.Text = ""
                    TweenService:Create(CheckCircle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
                end
                Callback(toggled)
            end)
        end

        return TabElements
    end

    return WindowConfig
end
