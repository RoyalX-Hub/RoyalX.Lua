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

    local Main = Instance.new("Frame", ScreenGui)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.Size = UDim2.new(0, 560, 0, 380)
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 15) -- Bo góc menu mượt hơn
    MakeDraggable(Main)

    -- [THANH TAB BAR]
    local TabBar = Instance.new("Frame", Main)
    TabBar.Size = UDim2.new(1, -20, 0, 40)
    TabBar.Position = UDim2.new(0, 10, 0, 10)
    TabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 10)

    local TabScroll = Instance.new("ScrollingFrame", TabBar)
    TabScroll.Size = UDim2.new(1, -10, 1, 0)
    TabScroll.Position = UDim2.new(0, 5, 0, 0)
    TabScroll.BackgroundTransparency = 1; TabScroll.ScrollBarThickness = 0; TabScroll.AutomaticCanvasSize = "X"
    Instance.new("UIListLayout", TabScroll).FillDirection = "Horizontal"
    TabScroll.UIListLayout.VerticalAlignment = "Center"
    TabScroll.UIListLayout.Padding = UDim.new(0, 8)

    local Container = Instance.new("Frame", Main)
    Container.Position = UDim2.new(0, 10, 0, 60); Container.Size = UDim2.new(1, -20, 1, -70); Container.BackgroundTransparency = 1

    local Window = {CurrentTab = nil}

    function Window:CreateTab(name)
        local TBtn = Instance.new("TextButton", TabScroll)
        TBtn.Size = UDim2.new(0, 100, 0, 28); TBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TBtn.Text = name; TBtn.TextColor3 = Color3.fromRGB(200, 200, 200); TBtn.Font = "GothamBold"; TBtn.TextSize = 12
        Instance.new("UICorner", TBtn).CornerRadius = UDim.new(0, 8)

        local Page = Instance.new("Frame", Container)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.Visible = false; Page.BackgroundTransparency = 1

        local function CreateCol(pos)
            local C = Instance.new("ScrollingFrame", Page); C.Size = UDim2.new(0.5, -5, 1, 0); C.Position = pos; C.BackgroundTransparency = 1; C.ScrollBarThickness = 0; C.AutomaticCanvasSize = "Y"
            Instance.new("UIListLayout", C).Padding = UDim.new(0, 10)
            return C
        end
        local Left = CreateCol(UDim2.new(0, 0, 0, 0)); local Right = CreateCol(UDim2.new(0.5, 5, 0, 0))

        TBtn.MouseButton1Click:Connect(function()
            if Window.CurrentTab then Window.CurrentTab.P.Visible = false; Window.CurrentTab.B.BackgroundColor3 = Color3.fromRGB(30, 30, 30) end
            Page.Visible = true; TBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255); Window.CurrentTab = {P = Page, B = TBtn}
        end)
        if not Window.CurrentTab then Page.Visible = true; TBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255); Window.CurrentTab = {P = Page, B = TBtn} end

        local Tab = {}
        function Tab:CreateSection(title, side)
            local Target = (side == "Right" and Right or Left)
            local Sec = Instance.new("Frame", Target); Sec.Size = UDim2.new(1, 0, 0, 45); Sec.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            Instance.new("UICorner", Sec).CornerRadius = UDim.new(0, 10); Instance.new("UIStroke", Sec).Color = Color3.fromRGB(30, 30, 30)

            local sTitle = Instance.new("TextLabel", Sec); sTitle.Text = title:upper(); sTitle.Size = UDim2.new(1, 0, 0, 35); sTitle.TextColor3 = Color3.new(1,1,1); sTitle.Font = "GothamBold"; sTitle.TextSize = 12; sTitle.BackgroundTransparency = 1

            local sCont = Instance.new("Frame", Sec); sCont.Position = UDim2.new(0, 10, 0, 38); sCont.Size = UDim2.new(1, -20, 0, 0); sCont.BackgroundTransparency = 1
            local L = Instance.new("UIListLayout", sCont); L.Padding = UDim.new(0, 7)
            L:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() Sec.Size = UDim2.new(1, 0, 0, L.AbsoluteContentSize.Y + 50) end)

            local Ele = {}
            -- [[ NÚT BẬT TẮT HÌNH TRÒN (CIRCLE TOGGLE) ]] --
            function Ele:CreateToggle(text, def, cb)
                local state = def
                local Tgl = Instance.new("TextButton", sCont)
                Tgl.Size = UDim2.new(1, 0, 0, 32); Tgl.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
                Tgl.Text = "   "..text; Tgl.TextColor3 = Color3.new(0.8,0.8,0.8); Tgl.TextXAlignment = 0; Tgl.Font = "GothamBold"; Tgl.TextSize = 12
                Instance.new("UICorner", Tgl).CornerRadius = UDim.new(0, 8)
                
                -- Khung bao nút gạt (Dạng viên thuốc)
                local ToggleBG = Instance.new("Frame", Tgl)
                ToggleBG.Size = UDim2.new(0, 40, 0, 20)
                ToggleBG.Position = UDim2.new(1, -50, 0.5, -10)
                ToggleBG.BackgroundColor3 = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(50, 50, 50)
                Instance.new("UICorner", ToggleBG).CornerRadius = UDim.new(1, 0) -- Bo tròn tuyệt đối
                
                -- Nút tròn bên trong
                local Circle = Instance.new("Frame", ToggleBG)
                Circle.Size = UDim2.new(0, 16, 0, 16)
                Circle.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                Circle.BackgroundColor3 = Color3.new(1, 1, 1)
                Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0) -- Hình tròn hoàn hảo

                Tgl.MouseButton1Click:Connect(function()
                    state = not state
                    -- Hiệu ứng mượt mà khi gạt
                    TweenService:Create(ToggleBG, TweenInfo.new(0.25), {BackgroundColor3 = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(50, 50, 50)}):Play()
                    TweenService:Create(Circle, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
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
