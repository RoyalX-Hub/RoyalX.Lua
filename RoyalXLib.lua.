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
    local windowTitle = config.Name or "RoyalX Lib"
    local logoId = "rbxassetid://107831103893115"

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RoyalX_NewUI"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Nút bật/tắt nổi (Floating Logo) giống ảnh 1
    local ToggleButton = Instance.new("ImageButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Parent = ScreenGui
    ToggleButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    ToggleButton.Position = UDim2.new(0.05, 0, 0.1, 0)
    ToggleButton.Size = UDim2.new(0, 50, 0, 50)
    ToggleButton.Image = logoId
    ToggleButton.Visible = false

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 12)
    ToggleCorner.Parent = ToggleButton

    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    MainFrame.Position = UDim2.new(0.5, -350, 0.5, -220)
    MainFrame.Size = UDim2.new(0, 700, 0, 440)
    MainFrame.BorderSizePixel = 0
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame

    MakeDraggable(MainFrame)

    -- Top Bar (Chứa Logo và Tabs)
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundTransparency = 1
    TopBar.Size = UDim2.new(1, 0, 0, 50)

    local TopLogo = Instance.new("ImageLabel")
    TopLogo.Parent = TopBar
    TopLogo.BackgroundTransparency = 1
    TopLogo.Position = UDim2.new(0, 10, 0, 10)
    TopLogo.Size = UDim2.new(0, 30, 0, 30)
    TopLogo.Image = logoId

    -- Tab Container (Dàn ngang giống ảnh 2)
    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Name = "TabScroll"
    TabScroll.Parent = TopBar
    TabScroll.BackgroundTransparency = 1
    TabScroll.Position = UDim2.new(0, 50, 0, 8)
    TabScroll.Size = UDim2.new(1, -90, 1, -15)
    TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabScroll.ScrollBarThickness = 0

    local TabList = Instance.new("UIListLayout")
    TabList.Parent = TabScroll
    TabList.FillDirection = Enum.FillDirection.Horizontal
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 8)

    -- Nút đóng
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = TopBar
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Position = UDim2.new(1, -40, 0, 10)
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    CloseBtn.TextSize = 18

    CloseBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        ToggleButton.Visible = true
    end)

    ToggleButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        ToggleButton.Visible = false
    end)

    -- Content Area
    local ContainerArea = Instance.new("Frame")
    ContainerArea.Name = "ContainerArea"
    ContainerArea.Parent = MainFrame
    ContainerArea.BackgroundTransparency = 1
    ContainerArea.Position = UDim2.new(0, 15, 0, 60)
    ContainerArea.Size = UDim2.new(1, -30, 1, -75)

    local Window = { Tabs = {}, CurrentTab = nil }

    function Window:CreateTab(name)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Name = name .. "Tab"
        TabBtn.Parent = TabScroll
        TabBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        TabBtn.Size = UDim2.new(0, 110, 1, 0)
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.Text = name
        TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabBtn.TextSize = 13
        
        local TabBtnCorner = Instance.new("UICorner")
        TabBtnCorner.CornerRadius = UDim.new(0, 6)
        TabBtnCorner.Parent = TabBtn

        -- Trang nội dung (Chia 2 cột giống ảnh 2)
        local Page = Instance.new("Frame")
        Page.Name = name .. "Page"
        Page.Parent = ContainerArea
        Page.BackgroundTransparency = 1
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.Visible = false

        local LeftCol = Instance.new("ScrollingFrame")
        LeftCol.Parent = Page
        LeftCol.BackgroundTransparency = 1
        LeftCol.Size = UDim2.new(0.5, -7, 1, 0)
        LeftCol.ScrollBarThickness = 0

        local RightCol = Instance.new("ScrollingFrame")
        RightCol.Parent = Page
        RightCol.Position = UDim2.new(0.5, 7, 0, 0)
        RightCol.BackgroundTransparency = 1
        RightCol.Size = UDim2.new(0.5, -7, 1, 0)
        RightCol.ScrollBarThickness = 0

        for _, col in pairs({LeftCol, RightCol}) do
            local l = Instance.new("UIListLayout")
            l.Parent = col
            l.Padding = UDim.new(0, 10)
        end

        local function Select()
            if Window.CurrentTab then
                Window.CurrentTab.Page.Visible = false
                Window.CurrentTab.Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            end
            Page.Visible = true
            TabBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            Window.CurrentTab = {Page = Page, Btn = TabBtn}
        end

        TabBtn.MouseButton1Click:Connect(Select)
        if #TabScroll:GetChildren() == 2 then Select() end -- Tab đầu tiên

        local Tab = {}

        function Tab:CreateSection(title, side)
            local ParentCol = (side == "Right") and RightCol or LeftCol
            
            local Section = Instance.new("Frame")
            Section.Parent = ParentCol
            Section.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            Section.Size = UDim2.new(1, 0, 0, 40)
            
            local sCorner = Instance.new("UICorner")
            sCorner.CornerRadius = UDim.new(0, 8)
            sCorner.Parent = Section

            local sTitle = Instance.new("TextLabel")
            sTitle.Parent = Section
            sTitle.BackgroundTransparency = 1
            sTitle.Position = UDim2.new(0, 10, 0, 10)
            sTitle.Size = UDim2.new(1, -20, 0, 20)
            sTitle.Font = Enum.Font.GothamBold
            sTitle.Text = "✨ " .. title .. " ✨"
            sTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            sTitle.TextSize = 14

            local sContainer = Instance.new("Frame")
            sContainer.Parent = Section
            sContainer.BackgroundTransparency = 1
            sContainer.Position = UDim2.new(0, 10, 0, 35)
            sContainer.Size = UDim2.new(1, -20, 1, -40)

            local sLayout = Instance.new("UIListLayout")
            sLayout.Parent = sContainer
            sLayout.Padding = UDim.new(0, 8)

            sLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Section.Size = UDim2.new(1, 0, 0, sLayout.AbsoluteContentSize.Y + 50)
            end)

            local Elements = {}

            function Elements:CreateToggle(text, default, callback)
                local Tgl = Instance.new("TextButton")
                Tgl.Parent = sContainer
                Tgl.BackgroundTransparency = 1
                Tgl.Size = UDim2.new(1, 0, 0, 30)
                Tgl.Font = Enum.Font.Gotham
                Tgl.Text = text
                Tgl.TextColor3 = Color3.fromRGB(180, 180, 180)
                Tgl.TextSize = 13
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
