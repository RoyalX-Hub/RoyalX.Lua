local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- [HÀM KÉO MENU/LOGO]
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
    -- Xóa UI cũ để tránh lỗi chồng chéo
    for _, v in pairs(CoreGui:GetChildren()) do
        if v.Name == "RoyalX_Hub_Official" then v:Destroy() end
    end

    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    ScreenGui.Name = "RoyalX_Hub_Official"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true -- Đảm bảo không bị lệch bởi thanh công cụ Roblox

    -- 1. NÚT LOGO MỞ MENU (ẨN KHI MENU ĐANG MỞ)
    local LogoBtn = Instance.new("ImageButton", ScreenGui)
    LogoBtn.Name = "LogoBtn"
    LogoBtn.Size = UDim2.new(0, 55, 0, 55)
    LogoBtn.Position = UDim2.new(0, 20, 0, 150)
    LogoBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    LogoBtn.Image = "rbxassetid://107831103893115"
    LogoBtn.Visible = false
    LogoBtn.ZIndex = 100
    Instance.new("UICorner", LogoBtn).CornerRadius = UDim.new(0, 12)
    MakeDraggable(LogoBtn)

    -- 2. KHUNG CHÍNH
    local Main = Instance.new("Frame", ScreenGui)
    Main.Name = "MainFrame"
    Main.BackgroundColor3 = Color3.fromRGB(8, 8, 8) -- Tông đen đậm chuẩn
    Main.Position = UDim2.new(0.5, -325, 0.5, -225) -- Căn giữa thủ công để tránh lỗi Anchor
    Main.Size = UDim2.new(0, 650, 0, 450)
    Main.ClipsDescendants = true
    Main.Visible = true
    Main.ZIndex = 2
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    MakeDraggable(Main) -- Menu cũng có thể kéo được

    -- 3. THANH TAB (DƯỚI LOGO CỐ ĐỊNH)
    local TabBar = Instance.new("Frame", Main)
    TabBar.Size = UDim2.new(1, -20, 0, 45)
    TabBar.Position = UDim2.new(0, 10, 0, 10)
    TabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TabBar.ZIndex = 3
    Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 8)

    local MenuLogo = Instance.new("ImageLabel", TabBar)
    MenuLogo.Size = UDim2.new(0, 32, 0, 32)
    MenuLogo.Position = UDim2.new(0, 8, 0.5, -16)
    MenuLogo.BackgroundTransparency = 1
    MenuLogo.Image = "rbxassetid://107831103893115"
    MenuLogo.ZIndex = 4

    local TabScroll = Instance.new("ScrollingFrame", TabBar)
    TabScroll.Size = UDim2.new(1, -100, 1, 0)
    TabScroll.Position = UDim2.new(0, 50, 0, 0)
    TabScroll.BackgroundTransparency = 1
    TabScroll.ScrollBarThickness = 0
    TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
    TabScroll.ZIndex = 4

    local TabList = Instance.new("UIListLayout", TabScroll)
    TabList.FillDirection = Enum.FillDirection.Horizontal
    TabList.Padding = UDim.new(0, 10)
    TabList.VerticalAlignment = Enum.VerticalAlignment.Center

    local Close = Instance.new("TextButton", TabBar)
    Close.Size = UDim2.new(0, 40, 1, 0)
    Close.Position = UDim2.new(1, -40, 0, 0)
    Close.Text = "X"; Close.TextColor3 = Color3.fromRGB(255, 60, 60)
    Close.BackgroundTransparency = 1; Close.Font = Enum.Font.GothamBold; Close.TextSize = 20
    Close.ZIndex = 5

    local Container = Instance.new("Frame", Main)
    Container.Name = "Container"
    Container.Position = UDim2.new(0, 10, 0, 65)
    Container.Size = UDim2.new(1, -20, 1, -75)
    Container.BackgroundTransparency = 1
    Container.ZIndex = 3

    -- LOGIC ĐÓNG/MỞ
    local function ToggleUI()
        if Main.Visible then
            Main.Visible = false
            LogoBtn.Visible = true
        else
            LogoBtn.Visible = false
            Main.Visible = true
        end
    end
    Close.MouseButton1Click:Connect(ToggleUI)
    LogoBtn.MouseButton1Click:Connect(ToggleUI)

    local Window = {CurrentTab = nil}

    function Window:CreateTab(name)
        local TBtn = Instance.new("TextButton", TabScroll)
        TBtn.Size = UDim2.new(0, 100, 0, 32)
        TBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TBtn.Text = name; TBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        TBtn.Font = Enum.Font.GothamBold; TBtn.TextSize = 13
        TBtn.ZIndex = 5
        Instance.new("UICorner", TBtn).CornerRadius = UDim.new(0, 6)

        local Page = Instance.new("Frame", Container)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.Visible = false; Page.BackgroundTransparency = 1
        Page.ZIndex = 4

        local function CreateColumn(pos)
            local Col = Instance.new("ScrollingFrame", Page)
            Col.Size = UDim2.new(0.5, -7, 1, 0); Col.Position = pos
            Col.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            Col.ScrollBarThickness = 0
            Col.AutomaticCanvasSize = Enum.AutomaticSize.Y
            Col.CanvasSize = UDim2.new(0, 0, 0, 0)
            Col.ZIndex = 5
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
                Window.CurrentTab.B.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                Window.CurrentTab.B.TextColor3 = Color3.fromRGB(200, 200, 200)
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
            Sec.Size = UDim2.new(0.92, 0, 0, 40)
            Sec.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
            Sec.ZIndex = 6
            Instance.new("UICorner", Sec).CornerRadius = UDim.new(0, 6)
            
            local sTitle = Instance.new("TextLabel", Sec)
            sTitle.Text = "   " .. title:upper()
            sTitle.Size = UDim2.new(1, 0, 0, 30)
            sTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            sTitle.Font = Enum.Font.GothamBold; sTitle.TextSize = 13; sTitle.BackgroundTransparency = 1; sTitle.TextXAlignment = 0; sTitle.ZIndex = 7

            local Line = Instance.new("Frame", Sec)
            Line.Size = UDim2.new(0.9, 0, 0, 1); Line.Position = UDim2.new(0.05, 0, 0, 28)
            Line.BackgroundColor3 = Color3.fromRGB(60, 60, 60); Line.BorderSizePixel = 0; Line.ZIndex = 7

            local sCont = Instance.new("Frame", Sec)
            sCont.Position = UDim2.new(0, 10, 0, 35); sCont.Size = UDim2.new(1, -20, 0, 0); sCont.BackgroundTransparency = 1; sCont.ZIndex = 7
            local L = Instance.new("UIListLayout", sCont); L.Padding = UDim.new(0, 5)

            L:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Sec.Size = UDim2.new(0.92, 0, 0, L.AbsoluteContentSize.Y + 45)
                sCont.Size = UDim2.new(1, 0, 0, L.AbsoluteContentSize.Y)
            end)

            local Ele = {}
            function Ele:CreateToggle(text, def, cb)
                local state = def
                local Tgl = Instance.new("TextButton", sCont)
                Tgl.Size = UDim2.new(1, 0, 0, 28); Tgl.BackgroundTransparency = 1
                Tgl.Text = " " .. text; Tgl.TextColor3 = Color3.fromRGB(200, 200, 200)
                Tgl.TextXAlignment = 0; Tgl.Font = Enum.Font.Gotham; Tgl.TextSize = 12; Tgl.ZIndex = 8

                local Box = Instance.new("Frame", Tgl)
                Box.Position = UDim2.new(1, -22, 0.5, -9); Box.Size = UDim2.new(0, 18, 0, 18)
                Box.BackgroundColor3 = state and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(45, 45, 45)
                Box.ZIndex = 8
                Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)

                local Check = Instance.new("TextLabel", Box)
                Check.Text = "✓"; Check.Size = UDim2.new(1, 0, 1, 0); Check.BackgroundTransparency = 1
                Check.TextColor3 = Color3.fromRGB(255, 255, 255); Check.Visible = state; Check.ZIndex = 9

                Tgl.MouseButton1Click:Connect(function()
                    state = not state
                    Check.Visible = state
                    Box.BackgroundColor3 = state and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(45, 45, 45)
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
