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
    local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "RoyalX_Hub"

    local Main = Instance.new("Frame", ScreenGui)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Main.Position = UDim2.new(0.5, 0, 0.5, 0); Main.AnchorPoint = Vector2.new(0.5, 0.5); Main.Size = UDim2.new(0, 560, 0, 400); Main.ClipsDescendants = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12); MakeDraggable(Main)

    local TabBar = Instance.new("Frame", Main)
    TabBar.Size = UDim2.new(1, -20, 0, 40); TabBar.Position = UDim2.new(0, 10, 0, 10); TabBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22); Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 8)

    local TabScroll = Instance.new("ScrollingFrame", TabBar)
    TabScroll.Size = UDim2.new(1, -10, 1, 0); TabScroll.Position = UDim2.new(0, 5, 0, 0); TabScroll.BackgroundTransparency = 1; TabScroll.ScrollBarThickness = 0; TabScroll.AutomaticCanvasSize = "X"
    local TL = Instance.new("UIListLayout", TabScroll); TL.FillDirection = "Horizontal"; TL.VerticalAlignment = "Center"; TL.Padding = UDim.new(0, 8)

    local Container = Instance.new("Frame", Main)
    Container.Position = UDim2.new(0, 10, 0, 60); Container.Size = UDim2.new(1, -20, 1, -70); Container.BackgroundTransparency = 1

    local Window = {CurrentTab = nil}

    function Window:CreateTab(name)
        local TBtn = Instance.new("TextButton", TabScroll)
        TBtn.Size = UDim2.new(0, 100, 0, 30); TBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30); TBtn.Text = name; TBtn.TextColor3 = Color3.fromRGB(180, 180, 180); TBtn.Font = "GothamBold"; TBtn.TextSize = 12; Instance.new("UICorner", TBtn).CornerRadius = UDim.new(0, 6)

        local Page = Instance.new("Frame", Container); Page.Size = UDim2.new(1, 0, 1, 0); Page.Visible = false; Page.BackgroundTransparency = 1
        local function CreateCol(pos)
            local C = Instance.new("ScrollingFrame", Page); C.Size = UDim2.new(0.5, -5, 1, 0); C.Position = pos; C.BackgroundTransparency = 1; C.ScrollBarThickness = 0; C.AutomaticCanvasSize = "Y"
            Instance.new("UIListLayout", C).Padding = UDim.new(0, 10); return C
        end
        local Left = CreateCol(UDim2.new(0, 0, 0, 0)); local Right = CreateCol(UDim2.new(0.5, 5, 0, 0))

        TBtn.MouseButton1Click:Connect(function()
            if Window.CurrentTab then Window.CurrentTab.P.Visible = false; Window.CurrentTab.B.BackgroundColor3 = Color3.fromRGB(30, 30, 30) end
            Page.Visible = true; TBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255); Window.CurrentTab = {P = Page, B = TBtn}
        end)
        if not Window.CurrentTab then Page.Visible = true; TBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255); Window.CurrentTab = {P = Page, B = TBtn} end

        local Tab = {}
        function Tab:CreateSection(title, side)
            local Target = (side == "Right" and Right or Left)
            local Sec = Instance.new("Frame", Target); Sec.Size = UDim2.new(1, 0, 0, 45); Sec.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Instance.new("UICorner", Sec).CornerRadius = UDim.new(0, 10); Instance.new("UIStroke", Sec).Color = Color3.fromRGB(30, 30, 30)
            local sTitle = Instance.new("TextLabel", Sec); sTitle.Text = title:upper(); sTitle.Size = UDim2.new(1, 0, 0, 35); sTitle.TextColor3 = Color3.new(1,1,1); sTitle.Font = "GothamBold"; sTitle.TextSize = 12; sTitle.BackgroundTransparency = 1
            local sCont = Instance.new("Frame", Sec); sCont.Position = UDim2.new(0, 10, 0, 38); sCont.Size = UDim2.new(1, -20, 0, 0); sCont.BackgroundTransparency = 1
            local L = Instance.new("UIListLayout", sCont); L.Padding = UDim.new(0, 8)
            L:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() Sec.Size = UDim2.new(1, 0, 0, L.AbsoluteContentSize.Y + 48) end)

            local Ele = {}
            -- [TOGGLE HÌNH TRÒN]
            function Ele:CreateToggle(text, def, cb)
                local state = def
                local Tgl = Instance.new("TextButton", sCont); Tgl.Size = UDim2.new(1, 0, 0, 32); Tgl.BackgroundColor3 = Color3.fromRGB(25, 25, 25); Tgl.Text = "   "..text; Tgl.TextColor3 = Color3.new(0.8,0.8,0.8); Tgl.TextXAlignment = 0; Tgl.Font = "Gotham"; Tgl.TextSize = 12; Instance.new("UICorner", Tgl).CornerRadius = UDim.new(0, 6)
                local Bg = Instance.new("Frame", Tgl); Bg.Size = UDim2.new(0, 38, 0, 20); Bg.Position = UDim2.new(1, -45, 0.5, -10); Bg.BackgroundColor3 = state and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(50, 50, 50); Instance.new("UICorner", Bg).CornerRadius = UDim.new(1, 0)
                local Dot = Instance.new("Frame", Bg); Dot.Size = UDim2.new(0, 16, 0, 16); Dot.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8); Dot.BackgroundColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
                Tgl.MouseButton1Click:Connect(function()
                    state = not state
                    TweenService:Create(Bg, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(50, 50, 50)}):Play()
                    TweenService:Create(Dot, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
                    cb(state)
                end)
            end

            -- [DROPDOWN XỔ DANH SÁCH]
            function Ele:CreateDropdown(text, options, cb)
                local open = false
                local DropFrame = Instance.new("Frame", sCont); DropFrame.Size = UDim2.new(1, 0, 0, 30); DropFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25); DropFrame.ClipsDescendants = true; Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, 6)
                local Btn = Instance.new("TextButton", DropFrame); Btn.Size = UDim2.new(1, 0, 0, 30); Btn.BackgroundTransparency = 1; Btn.Text = "   "..text..": "..options[1]; Btn.TextColor3 = Color3.new(0.8,0.8,0.8); Btn.TextXAlignment = 0; Btn.Font = "Gotham"; Btn.TextSize = 12
                local Arr = Instance.new("TextLabel", Btn); Arr.Size = UDim2.new(0, 30, 1, 0); Arr.Position = UDim2.new(1, -30, 0, 0); Arr.Text = "▼"; Arr.BackgroundTransparency = 1; Arr.TextColor3 = Color3.new(0.5,0.5,0.5)
                local List = Instance.new("Frame", DropFrame); List.Size = UDim2.new(1, 0, 0, #options * 25); List.Position = UDim2.new(0,0,0,30); List.BackgroundTransparency = 1; Instance.new("UIListLayout", List)
                for _, v in pairs(options) do
                    local O = Instance.new("TextButton", List); O.Size = UDim2.new(1, 0, 0, 25); O.BackgroundColor3 = Color3.fromRGB(30, 30, 30); O.Text = v; O.TextColor3 = Color3.new(0.6,0.6,0.6); O.Font = "Gotham"; O.TextSize = 11; O.BorderSizePixel = 0
                    O.MouseButton1Click:Connect(function()
                        open = false; Btn.Text = "   "..text..": "..v; TweenService:Create(DropFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 30)}):Play(); Arr.Text = "▼"; cb(v)
                    end)
                end
                Btn.MouseButton1Click:Connect(function()
                    open = not open
                    TweenService:Create(DropFrame, TweenInfo.new(0.3), {Size = open and UDim2.new(1, 0, 0, 30 + (#options * 25)) or UDim2.new(1, 0, 0, 30)}):Play()
                    Arr.Text = open and "▲" or "▼"
                end)
            end
            return Ele
        end
        return Tab
    end
    return Window
end
return Library
