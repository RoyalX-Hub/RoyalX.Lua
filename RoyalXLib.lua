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
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local LogoBtn = Instance.new("ImageButton", ScreenGui)
    LogoBtn.Size = UDim2.new(0, 0, 0, 0); LogoBtn.Position = UDim2.new(0, 50, 0, 150)
    LogoBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20); LogoBtn.Image = "rbxassetid://107831103893115"; LogoBtn.Visible = false
    Instance.new("UICorner", LogoBtn).CornerRadius = UDim.new(0, 10); MakeDraggable(LogoBtn)

    local Main = Instance.new("Frame", ScreenGui)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.AnchorPoint = Vector2.new(0.5, 0.5); Main.Size = UDim2.new(0, 0, 0, 0); Main.ClipsDescendants = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12); MakeDraggable(Main)

    TweenService:Create(Main, TweenInfo.new(0.6, Enum.EasingStyle.Back), {Size = UDim2.new(0, 600, 0, 400)}):Play()

    local TabBar = Instance.new("Frame", Main)
    TabBar.Size = UDim2.new(1, -20, 0, 40); TabBar.Position = UDim2.new(0, 10, 0, 10)
    TabBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22); Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 8)

    local TabScroll = Instance.new("ScrollingFrame", TabBar)
    TabScroll.Size = UDim2.new(1, -85, 1, 0); TabScroll.Position = UDim2.new(0, 42, 0, 0)
    TabScroll.BackgroundTransparency = 1; TabScroll.ScrollBarThickness = 0; TabScroll.ScrollingDirection = Enum.ScrollingDirection.X 
    TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0); TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
    local TabList = Instance.new("UIListLayout", TabScroll); TabList.FillDirection = Enum.FillDirection.Horizontal; TabList.VerticalAlignment = Enum.VerticalAlignment.Center; TabList.Padding = UDim.new(0, 6)

    local Close = Instance.new("TextButton", TabBar)
    Close.Size = UDim2.new(0, 35, 1, 0); Close.Position = UDim2.new(1, -35, 0, 0)
    Close.Text = "×"; Close.TextColor3 = Color3.fromRGB(255, 80, 80); Close.BackgroundTransparency = 1; Close.Font = Enum.Font.GothamBold; Close.TextSize = 24

    local function ToggleUI()
        local isOpen = Main.Size.X.Offset > 0
        if isOpen then
            TweenService:Create(Main, TweenInfo.new(0.4), {Size = UDim2.new(0, 0, 0, 0)}):Play()
            task.wait(0.4); Main.Visible = false; LogoBtn.Visible = true
            TweenService:Create(LogoBtn, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Size = UDim2.new(0, 50, 0, 50)}):Play()
        else
            TweenService:Create(LogoBtn, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)}):Play()
            task.wait(0.2); LogoBtn.Visible = false; Main.Visible = true
            TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.new(0, 600, 0, 400)}):Play()
        end
    end
    Close.MouseButton1Click:Connect(ToggleUI); LogoBtn.MouseButton1Click:Connect(ToggleUI)

    local Container = Instance.new("Frame", Main)
    Container.Position = UDim2.new(0, 10, 0, 60); Container.Size = UDim2.new(1, -20, 1, -70); Container.BackgroundTransparency = 1
    local Window = {CurrentTab = nil}

    function Window:CreateTab(name)
        local TBtn = Instance.new("TextButton", TabScroll)
        TBtn.Size = UDim2.new(0, 100, 0, 30); TBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TBtn.Text = name; TBtn.TextColor3 = Color3.fromRGB(180, 180, 180); TBtn.Font = Enum.Font.GothamBold; TBtn.TextSize = 11
        Instance.new("UICorner", TBtn).CornerRadius = UDim.new(0, 5)

        local Page = Instance.new("Frame", Container)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.Visible = false; Page.BackgroundTransparency = 1

        local Left = Instance.new("ScrollingFrame", Page)
        Left.Size = UDim2.new(0.5, -5, 1, 0); Left.BackgroundTransparency = 1; Left.ScrollBarThickness = 0; Left.CanvasSize = UDim2.new(0,0,0,0); Left.AutomaticCanvasSize = "Y"
        Instance.new("UIListLayout", Left).Padding = UDim.new(0, 8)

        local Right = Instance.new("ScrollingFrame", Page)
        Right.Size = UDim2.new(0.5, -5, 1, 0); Right.Position = UDim2.new(0.5, 5, 0, 0); Right.BackgroundTransparency = 1; Right.ScrollBarThickness = 0; Right.CanvasSize = UDim2.new(0,0,0,0); Right.AutomaticCanvasSize = "Y"
        Instance.new("UIListLayout", Right).Padding = UDim.new(0, 8)

        TBtn.MouseButton1Click:Connect(function()
            if Window.CurrentTab then Window.CurrentTab.P.Visible = false; Window.CurrentTab.B.BackgroundColor3 = Color3.fromRGB(30, 30, 30) end
            Page.Visible = true; TBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50); Window.CurrentTab = {P = Page, B = TBtn}
        end)
        if not Window.CurrentTab then Page.Visible = true; TBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50); Window.CurrentTab = {P = Page, B = TBtn} end

        local Tab = {}
        function Tab:CreateSection(title, side)
            local Target = (side == "Right" and Right or Left)
            local Sec = Instance.new("Frame", Target)
            Sec.Size = UDim2.new(0.96, 0, 0, 40); Sec.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
            Instance.new("UICorner", Sec).CornerRadius = UDim.new(0, 8)
            
            local sTitle = Instance.new("TextLabel", Sec)
            sTitle.Text = title:upper(); sTitle.Size = UDim2.new(1, 0, 0, 30); sTitle.TextColor3 = Color3.new(1,1,1)
            sTitle.Font = "GothamBold"; sTitle.TextSize = 12; sTitle.BackgroundTransparency = 1

            local sCont = Instance.new("Frame", Sec)
            sCont.Position = UDim2.new(0, 10, 0, 35); sCont.Size = UDim2.new(1, -20, 0, 0); sCont.BackgroundTransparency = 1
            local L = Instance.new("UIListLayout", sCont); L.Padding = UDim.new(0, 5)
            L:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Sec.Size = UDim2.new(0.96, 0, 0, L.AbsoluteContentSize.Y + 45)
            end)

            local Ele = {}
            function Ele:CreateToggle(text, def, cb)
                local state = def
                local Tgl = Instance.new("TextButton", sCont)
                Tgl.Size = UDim2.new(1, 0, 0, 28); Tgl.BackgroundColor3 = Color3.fromRGB(25, 25, 25); Tgl.Text = "  "..text
                Tgl.TextColor3 = Color3.new(0.7,0.7,0.7); Tgl.TextXAlignment = 0; Tgl.Font = "Gotham"; Tgl.TextSize = 11
                Instance.new("UICorner", Tgl).CornerRadius = UDim.new(0, 6)
                Tgl.MouseButton1Click:Connect(function()
                    state = not state
                    Tgl.TextColor3 = state and Color3.new(1,1,1) or Color3.new(0.7,0.7,0.7)
                    cb(state)
                end)
            end

            function Ele:CreateDropdown(text, options, cb)
                local index = 1
                local Drop = Instance.new("TextButton", sCont)
                Drop.Size = UDim2.new(1, 0, 0, 28); Drop.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                Drop.Text = text .. ": " .. tostring(options[index])
                Drop.TextColor3 = Color3.new(1, 1, 1); Drop.Font = "GothamBold"; Drop.TextSize = 11
                Instance.new("UICorner", Drop).CornerRadius = UDim.new(0, 6)
                Drop.MouseButton1Click:Connect(function()
                    index = index + 1
                    if index > #options then index = 1 end
                    Drop.Text = text .. ": " .. tostring(options[index])
                    cb(options[index])
                end)
            end
            return Ele
        end
        return Tab
    end
    return Window
end
return Library
