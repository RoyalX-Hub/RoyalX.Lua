local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

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
    if CoreGui:FindFirstChild("RoyalX_Hub") then CoreGui["RoyalX_Hub"]:Destroy() end

    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    ScreenGui.Name = "RoyalX_Hub"
    ScreenGui.ResetOnSpawn = false

    local LogoBtn = Instance.new("ImageButton", ScreenGui)
    LogoBtn.Size = UDim2.new(0, 0, 0, 0)
    LogoBtn.Position = UDim2.new(0, 50, 0, 150)
    LogoBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    LogoBtn.Image = "rbxassetid://107831103893115"
    LogoBtn.Visible = false
    Instance.new("UICorner", LogoBtn).CornerRadius = UDim.new(0, 10)
    MakeDraggable(LogoBtn)

    local Main = Instance.new("Frame", ScreenGui)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.Size = UDim2.new(0, 0, 0, 0)
    Main.ClipsDescendants = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    MakeDraggable(Main)

    TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.new(0, 600, 0, 400)}):Play()

    -- 3. THANH TAB (ĐÃ THU NHỎ CHIỀU CAO TỪ 45 XUỐNG 35)
    local TabBar = Instance.new("Frame", Main)
    TabBar.Size = UDim2.new(1, -20, 0, 35) -- Nhỏ lại
    TabBar.Position = UDim2.new(0, 10, 0, 10)
    TabBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 6)

    local MenuLogo = Instance.new("ImageLabel", TabBar)
    MenuLogo.Size = UDim2.new(0, 24, 0, 24) -- Logo nhỏ lại theo tab
    MenuLogo.Position = UDim2.new(0, 8, 0.5, -12)
    MenuLogo.BackgroundTransparency = 1
    MenuLogo.Image = "rbxassetid://107831103893115"

    local TabScroll = Instance.new("ScrollingFrame", TabBar)
    TabScroll.Size = UDim2.new(1, -80, 1, 0)
    TabScroll.Position = UDim2.new(0, 40, 0, 0)
    TabScroll.BackgroundTransparency = 1
    TabScroll.ScrollBarThickness = 0
    TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
    
    local TabList = Instance.new("UIListLayout", TabScroll)
    TabList.FillDirection = Enum.FillDirection.Horizontal
    TabList.Padding = UDim.new(0, 5) -- Khoảng cách tab khít hơn
    TabList.VerticalAlignment = Enum.VerticalAlignment.Center

    local Close = Instance.new("TextButton", TabBar)
    Close.Size = UDim2.new(0, 30, 1, 0)
    Close.Position = UDim2.new(1, -30, 0, 0)
    Close.Text = "×"; Close.TextColor3 = Color3.fromRGB(255, 80, 80)
    Close.BackgroundTransparency = 1; Close.Font = Enum.Font.GothamBold; Close.TextSize = 18

    local Container = Instance.new("Frame", Main)
    Container.Position = UDim2.new(0, 10, 0, 55) -- Dịch lên do tab nhỏ lại
    Container.Size = UDim2.new(1, -20, 1, -65)
    Container.BackgroundTransparency = 1

    local function ToggleUI()
        if Main.Visible then
            local t = TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
            t:Play()
            t.Completed:Connect(function()
                Main.Visible = false; LogoBtn.Visible = true
                TweenService:Create(LogoBtn, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Size = UDim2.new(0, 50, 0, 50)}):Play()
            end)
        else
            TweenService:Create(LogoBtn, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)}):Play()
            task.wait(0.2)
            LogoBtn.Visible = false; Main.Visible = true
            TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.new(0, 600, 0, 400)}):Play()
        end
    end
    Close.MouseButton1Click:Connect(ToggleUI)
    LogoBtn.MouseButton1Click:Connect(ToggleUI)

    local Window = {CurrentTab = nil}

    function Window:CreateTab(name)
        local TBtn = Instance.new("TextButton", TabScroll)
        TBtn.Size = UDim2.new(0, 85, 0, 26) -- Nút tab nhỏ lại
        TBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TBtn.Text = name; TBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
        TBtn.Font = Enum.Font.GothamBold; TBtn.TextSize = 11
        Instance.new("UICorner", TBtn).CornerRadius = UDim.new(0, 4)

        local Page = Instance.new("Frame", Container)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.Visible = false; Page.BackgroundTransparency = 1

        local function CreateColumn(pos)
            local Col = Instance.new("ScrollingFrame", Page)
            Col.Size = UDim2.new(0.5, -5, 1, 0); Col.Position = pos
            Col.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            Col.ScrollBarThickness = 0; Col.AutomaticCanvasSize = Enum.AutomaticSize.Y
            Instance.new("UICorner", Col).CornerRadius = UDim.new(0, 8)
            Instance.new("UIListLayout", Col).Padding = UDim.new(0, 8)
            Instance.new("UIPadding", Col).PaddingTop = UDim.new(0, 8)
            return Col
        end

        local Left = CreateColumn(UDim2.new(0, 0, 0, 0))
        local Right = CreateColumn(UDim2.new(0.5, 5, 0, 0))

        TBtn.MouseButton1Click:Connect(function()
            if Window.CurrentTab then
                Window.CurrentTab.P.Visible = false
                Window.CurrentTab.B.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                Window.CurrentTab.B.TextColor3 = Color3.fromRGB(180, 180, 180)
            end
            Page.Visible = true
            TBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            TBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Window.CurrentTab = {P = Page, B = TBtn}
        end)

        if not Window.CurrentTab then
            Page.Visible = true; TBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50); TBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Window.CurrentTab = {P = Page, B = TBtn}
        end

        local Tab = {}
        function Tab:CreateSection(title, side)
            local Target = (side == "Right" and Right or Left)
            local Sec = Instance.new("Frame", Target)
            Sec.Size = UDim2.new(0.94, 0, 0, 35)
            Sec.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
            Instance.new("UICorner", Sec).CornerRadius = UDim.new(0, 6)
            
            local sTitle = Instance.new("TextLabel", Sec)
            sTitle.Text = "  " .. title:upper()
            sTitle.Size = UDim2.new(1, 0, 0, 28)
            sTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            sTitle.Font = Enum.Font.GothamBold; sTitle.TextSize = 12
            sTitle.BackgroundTransparency = 1; sTitle.TextXAlignment = 0

            local Line = Instance.new("Frame", Sec)
            Line.Size = UDim2.new(0.9, 0, 0, 1); Line.Position = UDim2.new(0.05, 0, 0, 26)
            Line.BackgroundColor3 = Color3.fromRGB(60, 60, 60); Line.BorderSizePixel = 0

            local sCont = Instance.new("Frame", Sec)
            sCont.Position = UDim2.new(0, 10, 0, 32); sCont.Size = UDim2.new(1, -20, 0, 0); sCont.BackgroundTransparency = 1
            local L = Instance.new("UIListLayout", sCont); L.Padding = UDim.new(0, 6)

            L:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Sec.Size = UDim2.new(0.94, 0, 0, L.AbsoluteContentSize.Y + 40)
                sCont.Size = UDim2.new(1, 0, 0, L.AbsoluteContentSize.Y)
            end)

            local Ele = {}
            -- TOGGLE HÌNH TRÒN CÓ DẤU ✓
            function Ele:CreateToggle(text, def, cb)
                local state = def
                local Tgl = Instance.new("TextButton", sCont)
                Tgl.Size = UDim2.new(1, 0, 0, 26); Tgl.BackgroundTransparency = 1
                Tgl.Text = "  " .. text; Tgl.TextColor3 = Color3.fromRGB(200, 200, 200)
                Tgl.TextXAlignment = 0; Tgl.Font = Enum.Font.Gotham; Tgl.TextSize = 12

                local Bg = Instance.new("Frame", Tgl)
                Bg.Size = UDim2.new(0, 34, 0, 18)
                Bg.Position = UDim2.new(1, -36, 0.5, -9)
                Bg.BackgroundColor3 = state and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(45, 45, 45)
                Instance.new("UICorner", Bg).CornerRadius = UDim.new(1, 0)

                local Dot = Instance.new("Frame", Bg)
                Dot.Size = UDim2.new(0, 14, 0, 14)
                Dot.Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

                local Check = Instance.new("TextLabel", Dot)
                Check.Text = "✓"; Check.Size = UDim2.new(1, 0, 1, 0); Check.BackgroundTransparency = 1
                Check.TextColor3 = Color3.fromRGB(0, 180, 180); Check.Visible = state; Check.Font = Enum.Font.GothamBold; Check.TextSize = 10

                Tgl.MouseButton1Click:Connect(function()
                    state = not state
                    TweenService:Create(Bg, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(45, 45, 45)}):Play()
                    TweenService:Create(Dot, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
                    Check.Visible = state
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
