local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Cấu hình Animation chuẩn mượt
local AnimInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local SpringInfo = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

function Library:CreateWindow(config)
    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    
    -- LOGO NỔI VỚI HIỆU ỨNG HOVER
    local LogoBtn = Instance.new("ImageButton", ScreenGui)
    LogoBtn.Size = UDim2.new(0, 48, 0, 48)
    LogoBtn.Position = UDim2.new(0, 50, 0, 50)
    LogoBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    LogoBtn.Image = "rbxassetid://107831103893115"
    LogoBtn.Visible = false
    Instance.new("UICorner", LogoBtn).CornerRadius = UDim.new(0, 10)
    
    -- Animation cho Logo
    LogoBtn.MouseEnter:Connect(function()
        TweenService:Create(LogoBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 52, 0, 52)}):Play()
    end)
    LogoBtn.MouseLeave:Connect(function()
        TweenService:Create(LogoBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 48, 0, 48)}):Play()
    end)

    -- MAIN FRAME
    local Main = Instance.new("Frame", ScreenGui)
    Main.BackgroundColor3 = Color3.fromRGB(13, 13, 13)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0) -- Bắt đầu từ tâm
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.Size = UDim2.new(0, 0, 0, 0) -- Bắt đầu với kích thước 0
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
    Main.ClipsDescendants = true

    -- [Phần TabHolder và Container giữ nguyên cấu trúc cũ...]
    local TabHolder = Instance.new("Frame", Main)
    TabHolder.Size = UDim2.new(1, -20, 0, 45)
    TabHolder.Position = UDim2.new(0, 10, 0, 10)
    TabHolder.BackgroundTransparency = 1
    local TabList = Instance.new("UIListLayout", TabHolder)
    TabList.FillDirection = Enum.FillDirection.Horizontal
    TabList.Padding = UDim.new(0, 10)

    local Container = Instance.new("Frame", Main)
    Container.Position = UDim2.new(0, 10, 0, 65)
    Container.Size = UDim2.new(1, -20, 1, -75)
    Container.BackgroundTransparency = 1

    -- LOGIC ĐÓNG/MỞ CỰC MƯỢT
    local function ToggleUI()
        if Main.Visible then
            -- Hiệu ứng đóng: Thu nhỏ và biến mất
            TweenService:Create(Main, AnimInfo, {Size = UDim2.new(0, 0, 0, 0)}):Play()
            task.wait(0.2)
            Main.Visible = false
            LogoBtn.Visible = true
            LogoBtn.Size = UDim2.new(0, 0, 0, 0)
            TweenService:Create(LogoBtn, SpringInfo, {Size = UDim2.new(0, 48, 0, 48)}):Play()
        else
            -- Hiệu ứng mở: Bung ra với độ nảy (Back style)
            LogoBtn.Visible = false
            Main.Visible = true
            TweenService:Create(Main, SpringInfo, {Size = UDim2.new(0, 650, 0, 450)}):Play()
        end
    end
    
    LogoBtn.MouseButton1Click:Connect(ToggleUI)
    -- Thêm phím tắt mở lại nếu cần (ví dụ phím RightShift)
    
    local Window = {CurrentTab = nil}

    function Window:CreateTab(name)
        local TBtn = Instance.new("TextButton", TabBar)
        TBtn.Size = UDim2.new(0, 100, 0, 32)
        TBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TBtn.Text = name
        TBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        Instance.new("UICorner", TBtn).CornerRadius = UDim.new(0, 8)

        local Page = Instance.new("Frame", Container)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.Visible = false
        Page.BackgroundTransparency = 1
        Page.Position = UDim2.new(0, 0, 0, 20) -- Bắt đầu hơi lệch xuống để làm anim trượt lên

        -- ANIMATION CHUYỂN TAB
        TBtn.MouseButton1Click:Connect(function()
            if Window.CurrentTab and Window.CurrentTab.B ~= TBtn then
                -- Tab cũ ẩn đi
                local oldPage = Window.CurrentTab.P
                TweenService:Create(oldPage, AnimInfo, {Position = UDim2.new(0, 0, 0, 20), GroupTransparency = 1}):Play()
                oldPage.Visible = false
                TweenService:Create(Window.CurrentTab.B, AnimInfo, {BackgroundColor3 = Color3.fromRGB(30, 30, 30), TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
                
                -- Tab mới hiện lên
                Page.Visible = true
                Page.GroupTransparency = 1
                TweenService:Create(Page, AnimInfo, {Position = UDim2.new(0, 0, 0, 0), GroupTransparency = 0}):Play()
                TweenService:Create(TBtn, AnimInfo, {BackgroundColor3 = Color3.fromRGB(60, 60, 60), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                
                Window.CurrentTab = {P = Page, B = TBtn}
            end
        end)
        
        -- (Phần CreateSection và Elements giữ nguyên logic Maru...)
        -- Trong CreateToggle, thêm Animation trượt mượt cho Dot
        return Tab
    end

    -- Mở UI lần đầu
    Main.Visible = true
    TweenService:Create(Main, SpringInfo, {Size = UDim2.new(0, 650, 0, 450)}):Play()

    return Window
end

return Library
