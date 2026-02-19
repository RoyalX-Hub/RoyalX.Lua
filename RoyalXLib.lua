local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- [Hàm kéo UI]
local function MakeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = gui.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    gui.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end

function Library:CreateWindow()
    if CoreGui:FindFirstChild("RoyalX_Hub") then CoreGui:FindFirstChild("RoyalX_Hub"):Destroy() end

    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    ScreenGui.Name = "RoyalX_Hub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true

    -- 1. NÚT LOGO MỞ MENU (CÓ ANIMATION)
    local LogoBtn = Instance.new("ImageButton", ScreenGui)
    LogoBtn.Name = "LogoBtn"
    LogoBtn.Size = UDim2.new(0, 0, 0, 0) -- Mặc định ẩn
    LogoBtn.Position = UDim2.new(0, 50, 0, 150)
    LogoBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    LogoBtn.Image = "rbxassetid://107831103893115"
    LogoBtn.Visible = false
    LogoBtn.ZIndex = 10
    Instance.new("UICorner", LogoBtn).CornerRadius = UDim.new(0, 10)
    MakeDraggable(LogoBtn)

    -- 2. KHUNG CHÍNH (MAIN)
    local Main = Instance.new("Frame", ScreenGui)
    Main.Name = "Main"
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.Size = UDim2.new(0, 0, 0, 0) -- Bắt đầu từ 0 để bung ra
    Main.ClipsDescendants = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
    MakeDraggable(Main)

    -- Animation Bung Menu khi vừa load
    TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.new(0, 650, 0, 450)}):Play()

    -- 3. THANH TAB
    local TabBar = Instance.new("Frame", Main)
    TabBar.Size = UDim2.new(1, -20, 0, 45)
    TabBar.Position = UDim2.new(0, 10, 0, 10)
    TabBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 8)

    local MenuLogo = Instance.new("ImageLabel", TabBar)
    MenuLogo.Size = UDim2.new(0, 32, 0, 32)
    MenuLogo.Position = UDim2.new(0, 8, 0.5, -16)
    MenuLogo.BackgroundTransparency = 1
    MenuLogo.Image = "rbxassetid://107831103893115"

    local TabScroll = Instance.new("ScrollingFrame", TabBar)
    TabScroll.Size = UDim2.new(1, -100, 1, 0)
    TabScroll.Position = UDim2.new(0, 50, 0, 0)
    TabScroll.BackgroundTransparency = 1
    TabScroll.ScrollBarThickness = 0
    TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
    
    local TabList = Instance.new("UIListLayout", TabScroll)
    TabList.FillDirection = Enum.FillDirection.Horizontal
    TabList.Padding = UDim.new(0, 8)
    TabList.VerticalAlignment = Enum.VerticalAlignment.Center

    local Close = Instance.new("TextButton", TabBar)
    Close.Size = UDim2.new(0, 40, 1, 0)
    Close.Position = UDim2.new(1, -40, 0, 0)
    Close.Text = "X"; Close.TextColor3 = Color3.fromRGB(255, 80, 80)
    Close.BackgroundTransparency = 1; Close.Font = Enum.Font.GothamBold; Close.TextSize = 20

    local Container = Instance.new("Frame", Main)
    Container.Position = UDim2.new(0, 10, 0, 65)
    Container.Size = UDim2.new(1, -20, 1, -75)
    Container.BackgroundTransparency = 1

    -- Logic Đóng/Mở Mượt Mà
    local function ToggleUI()
        if Main.Visible then
            -- Thu nhỏ Main
            local t = TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
            t:Play()
            t.Completed:Connect(function()
                Main.Visible = false
                LogoBtn.Visible = true
                TweenService:Create(LogoBtn, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Size = UDim2.new(0, 50, 0, 50)}):Play()
            end)
        else
            -- Thu nhỏ Logo rồi hiện Main
            local t = TweenService:Create(LogoBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 0, 0, 0)})
            t:Play()
            t.Completed:Connect(function()
                LogoBtn.Visible = false
                Main.Visible = true
                TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.new(0, 650, 0, 450)}):Play()
            end)
        end
    end
    Close.MouseButton1Click:Connect(ToggleUI)
    LogoBtn.MouseButton1Click:Connect(ToggleUI)

    local Window = {CurrentTab = nil}

    function Window:CreateTab(name)
        local TBtn = Instance.new("TextButton", TabScroll)
        TBtn.Size = UDim2.new(0, 110, 0, 32)
        TBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        TBtn.Text = name; TBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        TBtn.Font = Enum.Font.GothamBold; TBtn.TextSize = 13
        Instance.new("UICorner", TBtn).CornerRadius = UDim.new(0, 6)

        local Page = Instance.new("Frame", Container)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.Visible = false; Page.BackgroundTransparency = 1

        local function CreateColumn(pos)
            local Col = Instance.new("ScrollingFrame", Page)
            Col.Size = UDim2.new(0.5, -7, 1, 0); Col.Position = pos
            Col.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            Col.ScrollBarThickness = 0
            Col.CanvasSize = UDim2.new(0, 0, 0, 0)
            Col.AutomaticCanvasSize = Enum.AutomaticSize.Y
            Instance.new("UICorner", Col).CornerRadius = UDim.new(0, 8)
            local L = Instance.new("UIListLayout", Col); L.Padding = UDim.new(0, 10); L.HorizontalAlignment = Enum.HorizontalAlignment.Center
            Instance.new("UIPadding", Col).PaddingTop = UDim.new(0, 10)
            return Col
        end

        local Left = CreateColumn(UDim2.new(0, 0, 0, 0))
        local Right = CreateColumn(UDim2.new(0.5, 7, 0, 0))

        TBtn.MouseButton1Click:Connect(function()
            if Window.CurrentTab then
                Window.CurrentTab.P.Visible = false
                Window.CurrentTab.B.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            end
            Page.Visible = true
            TBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            Window.CurrentTab = {P = Page, B = TBtn}
        end)

        if not Window.CurrentTab then
            Page.Visible = true; TBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            Window.CurrentTab = {P = Page, B = TBtn}
        end

        local Tab = {}
        function Tab:CreateSection(title, side)
            local Target = (side == "Right" and Right or Left)
            local Sec = Instance.new("Frame", Target)
            Sec.Size = UDim2.new(0.94, 0, 0, 40)
            Sec.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
            Instance.new("UICorner", Sec).CornerRadius = UDim.new(0, 8)
            
            local sTitle = Instance.new("TextLabel", Sec)
            sTitle.Text = title:upper()
            sTitle.Size = UDim2.new(1, 0, 0, 35)
            sTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            sTitle.Font = Enum.Font.GothamBold; sTitle.TextSize = 14
            sTitle.BackgroundTransparency = 1; sTitle.TextXAlignment = Enum.TextXAlignment.Center

            local Line = Instance.new("Frame", Sec)
            Line.Size = UDim2.new(0.4, 0, 0, 1); Line.Position = UDim2.new(0.5, 0, 0, 32); Line.AnchorPoint = Vector2.new(0.5, 0)
            Line.BackgroundColor3 = Color3.fromRGB(80, 80, 80); Line.BorderSizePixel = 0

            local sCont = Instance.new("Frame", Sec)
            sCont.Position = UDim2.new(0, 10, 0, 42); sCont.Size = UDim2.new(1, -20, 0, 0); sCont.BackgroundTransparency = 1
            local L = Instance.new("UIListLayout", sCont); L.Padding = UDim.new(0, 8)

            L:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Sec.Size = UDim2.new(0.94, 0, 0, L.AbsoluteContentSize.Y + 52)
                sCont.Size = UDim2.new(1, 0, 0, L.AbsoluteContentSize.Y)
            end)

            local Ele = {}
            function Ele:CreateToggle(text, def, cb)
                local state = def
                local Tgl = Instance.new("TextButton", sCont)
                Tgl.Size = UDim2.new(1, 0, 0, 30); Tgl.BackgroundTransparency = 1
                Tgl.Text = " " .. text; Tgl.TextColor3 = Color3.fromRGB(255, 255, 255)
                Tgl.TextXAlignment = Enum.TextXAlignment.Left; Tgl.Font = Enum.Font.Gotham; Tgl.TextSize = 13

                local Box = Instance.new("Frame", Tgl)
                Box.Position = UDim2.new(1, -25, 0.5, -10); Box.Size = UDim2.new(0, 20, 0, 20)
                Box.BackgroundColor3 = state and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(60, 60, 60)
                Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)

                local Check = Instance.new("TextLabel", Box)
                Check.Text = "✓"; Check.Size = UDim2.new(1, 0, 1, 0); Check.BackgroundTransparency = 1
                Check.TextColor3 = Color3.fromRGB(255, 255, 255); Check.Visible = state; Check.Font = Enum.Font.GothamBold

                Tgl.MouseButton1Click:Connect(function()
                    state = not state
                    -- Animation cho nút Toggle
                    Check.Visible = state
                    TweenService:Create(Box, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(60, 60, 60)}):Play()
                    cb(state)
                end)
            end
            return Ele
        end
        return Tab
    end
    return Window
end

return Library
