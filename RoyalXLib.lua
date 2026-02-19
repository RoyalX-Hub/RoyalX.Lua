local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- [Hàm kéo Logo di động - Không cho ra ngoài màn hình]
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

function Library:CreateWindow(config)
    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    ScreenGui.Name = "RoyalX_Hub_Maru"

    -- 1. NÚT LOGO BẬT/TẮT (Nằm sẵn trong Lib)
    local LogoBtn = Instance.new("ImageButton", ScreenGui)
    LogoBtn.Size = UDim2.new(0, 50, 0, 50)
    LogoBtn.Position = UDim2.new(0, 20, 0, 150)
    LogoBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    LogoBtn.Image = "rbxassetid://107831103893115"
    LogoBtn.Visible = false
    LogoBtn.ZIndex = 100
    Instance.new("UICorner", LogoBtn).CornerRadius = UDim.new(0, 10)
    MakeDraggable(LogoBtn)

    -- 2. KHUNG CHÍNH (650x450 - ĐEN ĐẬM)
    local Main = Instance.new("Frame", ScreenGui)
    Main.Name = "Main"
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.Size = UDim2.new(0, 650, 0, 450)
    Main.ClipsDescendants = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

    -- 3. KHU VỰC THANH TAB (ĐEN NHẠT)
    local TabBar = Instance.new("Frame", Main)
    TabBar.Size = UDim2.new(1, -20, 0, 45)
    TabBar.Position = UDim2.new(0, 10, 0, 10)
    TabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 8)

    local TabScroll = Instance.new("ScrollingFrame", TabBar)
    TabScroll.Size = UDim2.new(1, -50, 1, 0)
    TabScroll.BackgroundTransparency = 1
    TabScroll.ScrollBarThickness = 0
    TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
    local TabList = Instance.new("UIListLayout", TabScroll)
    TabList.FillDirection = Enum.FillDirection.Horizontal
    TabList.Padding = UDim.new(0, 8)
    TabList.VerticalAlignment = Enum.VerticalAlignment.Center

    -- Nút Đóng UI (X)
    local Close = Instance.new("TextButton", TabBar)
    Close.Size = UDim2.new(0, 35, 1, 0)
    Close.Position = UDim2.new(1, -35, 0, 0)
    Close.Text = "X"; Close.TextColor3 = Color3.fromRGB(255, 80, 80)
    Close.BackgroundTransparency = 1; Close.Font = Enum.Font.GothamBold; Close.TextSize = 16

    local Container = Instance.new("Frame", Main)
    Container.Position = UDim2.new(0, 10, 0, 65)
    Container.Size = UDim2.new(1, -20, 1, -75)
    Container.BackgroundTransparency = 1

    -- LOGIC ĐÓNG/MỞ MENU CỰC MƯỢT
    local function ToggleUI()
        local isOpen = Main.Visible
        if isOpen then
            TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 0, 0, 0)}):Play()
            task.wait(0.3)
            Main.Visible = false
            LogoBtn.Visible = true
            LogoBtn.Size = UDim2.new(0, 0, 0, 0)
            TweenService:Create(LogoBtn, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Size = UDim2.new(0, 50, 0, 50)}):Play()
        else
            LogoBtn.Visible = false
            Main.Visible = true
            TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.new(0, 650, 0, 450)}):Play()
        end
    end
    Close.MouseButton1Click:Connect(ToggleUI)
    LogoBtn.MouseButton1Click:Connect(ToggleUI)

    local Window = {CurrentTab = nil}

    function Window:CreateTab(name)
        local TBtn = Instance.new("TextButton", TabScroll)
        TBtn.Size = UDim2.new(0, 100, 0, 32)
        TBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TBtn.Text = name; TBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
        TBtn.Font = Enum.Font.GothamBold; TBtn.TextSize = 12
        Instance.new("UICorner", TBtn).CornerRadius = UDim.new(0, 8)

        local Page = Instance.new("Frame", Container)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.Visible = false; Page.BackgroundTransparency = 1

        -- 4. HAI CỘT NỘI DUNG (ĐEN NHẠT)
        local function CreateColumn(pos)
            local Col = Instance.new("ScrollingFrame", Page)
            Col.Size = UDim2.new(0.5, -7, 1, 0)
            Col.Position = pos
            Col.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
            Col.ScrollBarThickness = 0
            Instance.new("UICorner", Col).CornerRadius = UDim.new(0, 10)
            local Layout = Instance.new("UIListLayout", Col)
            Layout.Padding = UDim.new(0, 10); Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            return Col
        end

        local LeftCol = CreateColumn(UDim2.new(0, 0, 0, 0))
        local RightCol = CreateColumn(UDim2.new(0.5, 7, 0, 0))

        TBtn.MouseButton1Click:Connect(function()
            if Window.CurrentTab then
                Window.CurrentTab.P.Visible = false
                TweenService:Create(Window.CurrentTab.B, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(30, 30, 30), TextColor3 = Color3.fromRGB(180, 180, 180)}):Play()
            end
            Page.Visible = true
            TweenService:Create(TBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 255, 255), TextColor3 = Color3.fromRGB(0, 0, 0)}):Play()
            Window.CurrentTab = {P = Page, B = TBtn}
        end)

        if not Window.CurrentTab then
            Page.Visible = true
            TBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 255); TBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
            Window.CurrentTab = {P = Page, B = TBtn}
        end

        local Tab = {}
        function Tab:CreateSection(title, side)
            local TargetCol = (side == "Right" and RightCol or LeftCol)
            local Sec = Instance.new("Frame", TargetCol)
            Sec.Size = UDim2.new(0.94, 0, 0, 40)
            Sec.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            Instance.new("UICorner", Sec).CornerRadius = UDim.new(0, 8)
            
            local sTitle = Instance.new("TextLabel", Sec)
            sTitle.Text = "  " .. title; sTitle.Size = UDim2.new(1, 0, 0, 32)
            sTitle.TextColor3 = Color3.fromRGB(0, 255, 255)
            sTitle.Font = Enum.Font.GothamBold; sTitle.BackgroundTransparency = 1; sTitle.TextXAlignment = 0

            local sCont = Instance.new("Frame", Sec)
            sCont.Position = UDim2.new(0, 10, 0, 32); sCont.Size = UDim2.new(1, -20, 0, 0); sCont.BackgroundTransparency = 1
            local L = Instance.new("UIListLayout", sCont); L.Padding = UDim.new(0, 6)

            L:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Sec.Size = UDim2.new(0.94, 0, 0, L.AbsoluteContentSize.Y + 42)
                sCont.Size = UDim2.new(1, 0, 0, L.AbsoluteContentSize.Y)
            end)

            local Ele = {}
            -- [TOGGLE HÌNH TRÒN CÓ DẤU TÍCH]
            function Ele:CreateToggle(text, def, cb)
                local state = def
                local Tgl = Instance.new("TextButton", sCont)
                Tgl.Size = UDim2.new(1, 0, 0, 30); Tgl.BackgroundTransparency = 1; Tgl.Text = " " .. text
                Tgl.TextColor3 = Color3.fromRGB(200, 200, 200); Tgl.TextXAlignment = 0; Tgl.Font = Enum.Font.Gotham

                local Bg = Instance.new("Frame", Tgl)
                Bg.Position = UDim2.new(1, -38, 0.5, -10); Bg.Size = UDim2.new(0, 38, 0, 20)
                Bg.BackgroundColor3 = state and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(50, 50, 50)
                Instance.new("UICorner", Bg).CornerRadius = UDim.new(1, 0)

                local Dot = Instance.new("Frame", Bg)
                Dot.Size = UDim2.new(0, 16, 0, 16); Dot.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

                local Check = Instance.new("TextLabel", Dot)
                Check.Text = "✓"; Check.Size = UDim2.new(1, 0, 1, 0); Check.BackgroundTransparency = 1
                Check.TextColor3 = Color3.fromRGB(0, 200, 200); Check.Visible = state; Check.Font = Enum.Font.GothamBold

                Tgl.MouseButton1Click:Connect(function()
                    state = not state
                    Check.Visible = state
                    TweenService:Create(Bg, TweenInfo.new(0.3), {BackgroundColor3 = state and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(50, 50, 50)}):Play()
                    TweenService:Create(Dot, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
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
