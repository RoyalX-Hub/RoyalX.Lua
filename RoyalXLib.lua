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
    ScreenGui.Name = "RoyalX_Animated"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

    -- === 1. LOADING ANIMATION (Chữ hiện từng chữ) ===
    local LoadingFrame = Instance.new("Frame")
    LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
    LoadingFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    LoadingFrame.ZIndex = 10
    LoadingFrame.Parent = ScreenGui

    local LoadingText = Instance.new("TextLabel")
    LoadingText.Size = UDim2.new(1, 0, 1, 0)
    LoadingText.BackgroundTransparency = 1
    LoadingText.Font = Enum.Font.GothamBold
    LoadingText.Text = ""
    LoadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
    LoadingText.TextSize = 40
    LoadingText.Parent = LoadingFrame

    -- Hàm chạy chữ
    task.spawn(function()
        local fullText = "RoyalX HUB"
        for i = 1, #fullText do
            LoadingText.Text = string.sub(fullText, 1, i)
            task.wait(0.1) -- Tốc độ hiện chữ
        end
        task.wait(0.5)
        -- Hiệu ứng biến mất
        TweenService:Create(LoadingText, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        local fade = TweenService:Create(LoadingFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1})
        fade:Play()
        fade.Completed:Connect(function()
            LoadingFrame:Destroy()
        end)
    end)

    -- === 2. MAIN UI & TOGGLE BUTTON ===
    local ToggleButton = Instance.new("ImageButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Parent = ScreenGui
    ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ToggleButton.Position = UDim2.new(0.02, 0, 0.15, 0)
    ToggleButton.Size = UDim2.new(0, 50, 0, 50)
    ToggleButton.Image = logoId
    ToggleButton.Visible = false
    Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 10)

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.BackgroundTransparency = 0.1
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.ClipsDescendants = true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
    
    MakeDraggable(MainFrame)

    -- Hàm Animation Bật/Tắt UI
    local function ToggleUI(state)
        if state then
            MainFrame.Visible = true
            MainFrame.Size = UDim2.new(0, 0, 0, 0) -- Bắt đầu từ 0
            TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Size = UDim2.new(0, 600, 0, 400)}):Play()
            ToggleButton.Visible = false
        else
            local close = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 0, 0, 0)})
            close:Play()
            close.Completed:Connect(function()
                MainFrame.Visible = false
                ToggleButton.Visible = true
            end)
        end
    end

    -- Nút đóng và mở
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = MainFrame
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Position = UDim2.new(1, -35, 0, 10)
    CloseBtn.Size = UDim2.new(0, 25, 0, 25)
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.MouseButton1Click:Connect(function() ToggleUI(false) end)
    ToggleButton.MouseButton1Click:Connect(function() ToggleUI(true) end)

    -- [Phần Code Tab và ContentArea giữ nguyên như bản trước...]
    local ContentArea = Instance.new("Frame")
    ContentArea.Parent = MainFrame
    ContentArea.BackgroundTransparency = 1
    ContentArea.Position = UDim2.new(0, 10, 0, 50)
    ContentArea.Size = UDim2.new(1, -20, 1, -60)

    local Window = { CurrentTab = nil }

    function Window:CreateTab(name)
        local Page = Instance.new("ScrollingFrame")
        Page.Parent = ContentArea
        Page.BackgroundTransparency = 1
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.Visible = false
        Page.ScrollBarThickness = 0
        local Layout = Instance.new("UIListLayout", Page)
        Layout.Padding = UDim.new(0, 8)

        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = MainFrame -- (Cần sắp xếp vào TopBar ở code đầy đủ)
        TabBtn.Text = name
        
        TabBtn.MouseButton1Click:Connect(function()
            if Window.CurrentTab then Window.CurrentTab.Visible = false end
            Page.Visible = true
            Window.CurrentTab = Page
        end)
        if not Window.CurrentTab then Page.Visible = true Window.CurrentTab = Page end

        local Tab = {}
        function Tab:CreateToggle(text, default, callback)
            local TglFrame = Instance.new("Frame")
            TglFrame.Parent = Page
            TglFrame.Size = UDim2.new(1, 0, 0, 35)
            TglFrame.BackgroundTransparency = 1

            local TglLabel = Instance.new("TextLabel")
            TglLabel.Parent = TglFrame
            TglLabel.Text = "  " .. text
            TglLabel.Size = UDim2.new(1, 0, 1, 0)
            TglLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            TglLabel.TextXAlignment = Enum.TextXAlignment.Left
            TglLabel.BackgroundTransparency = 1

            local Switch = Instance.new("TextButton")
            Switch.Parent = TglFrame
            Switch.Size = UDim2.new(0, 40, 0, 20)
            Switch.Position = UDim2.new(1, -45, 0.5, -10)
            Switch.BackgroundColor3 = default and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(50, 50, 50)
            Switch.Text = ""
            Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

            local Circle = Instance.new("Frame")
            Circle.Parent = Switch
            Circle.Size = UDim2.new(0, 16, 0, 16)
            Circle.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

            local state = default
            Switch.MouseButton1Click:Connect(function()
                state = not state
                -- === 3. ANIMATION BẬT/TẮT CHỨC NĂNG ===
                local targetPos = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                local targetCol = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(50, 50, 50)
                
                TweenService:Create(Circle, TweenInfo.new(0.2), {Position = targetPos}):Play()
                TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = targetCol}):Play()
                callback(state)
            end)
        end
        return Tab
    end
    return Window
end

return Library
