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
    ScreenGui.IgnoreGuiInset = true

    -- [HÀM TẠO THÔNG BÁO RESET CONFIG]
    function Library:ShowResetConfig(callback)
        local ModalBack = Instance.new("Frame", ScreenGui)
        ModalBack.Size = UDim2.new(1, 0, 1, 0)
        ModalBack.BackgroundColor3 = Color3.new(0, 0, 0)
        ModalBack.BackgroundTransparency = 0.5
        ModalBack.ZIndex = 100

        local MsgBox = Instance.new("Frame", ModalBack)
        MsgBox.Size = UDim2.new(0, 300, 0, 150)
        MsgBox.Position = UDim2.new(0.5, 0, 0.5, 0)
        MsgBox.AnchorPoint = Vector2.new(0.5, 0.5)
        MsgBox.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        Instance.new("UICorner", MsgBox)

        local Title = Instance.new("TextLabel", MsgBox)
        Title.Text = "RESET CONFIG?"
        Title.Size = UDim2.new(1, 0, 0, 50)
        Title.TextColor3 = Color3.new(1, 1, 1)
        Title.Font = Enum.Font.GothamBold; Title.TextSize = 16; Title.BackgroundTransparency = 1

        local function CreateBtn(txt, pos, color, cb)
            local b = Instance.new("TextButton", MsgBox)
            b.Size = UDim2.new(0, 100, 0, 35)
            b.Position = pos
            b.Text = txt; b.BackgroundColor3 = color
            b.TextColor3 = Color3.new(1, 1, 1)
            b.Font = Enum.Font.GothamBold; b.TextSize = 14
            Instance.new("UICorner", b)
            b.MouseButton1Click:Connect(function()
                ModalBack:Destroy()
                cb()
            end)
        end

        CreateBtn("Ok", UDim2.new(0.15, 0, 0.6, 0), Color3.fromRGB(0, 170, 255), function() callback(true) end)
        CreateBtn("Không", UDim2.new(0.55, 0, 0.6, 0), Color3.fromRGB(40, 40, 40), function() callback(false) end)
    end

    -- [MENU CHÍNH]
    local Main = Instance.new("Frame", ScreenGui)
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.Size = UDim2.new(0, 600, 0, 400)
    Main.Visible = true
    Instance.new("UICorner", Main)
    MakeDraggable(Main)

    -- Khóa tương tác bên ngoài khi mở menu
    local ModalFrame = Instance.new("TextButton", Main)
    ModalFrame.Size = UDim2.new(0,0,0,0)
    ModalFrame.Modal = true -- Đây là thuộc tính quan trọng để khóa chuột vào UI

    local TabBar = Instance.new("Frame", Main)
    TabBar.Size = UDim2.new(1, -20, 0, 35)
    TabBar.Position = UDim2.new(0, 10, 0, 10)
    TabBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Instance.new("UICorner", TabBar)

    local TabScroll = Instance.new("ScrollingFrame", TabBar)
    TabScroll.Size = UDim2.new(1, -80, 1, 0)
    TabScroll.Position = UDim2.new(0, 40, 0, 0)
    TabScroll.BackgroundTransparency = 1; TabScroll.ScrollBarThickness = 0
    TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
    Instance.new("UIListLayout", TabScroll).FillDirection = Enum.FillDirection.Horizontal

    local Container = Instance.new("Frame", Main)
    Container.Position = UDim2.new(0, 10, 0, 55)
    Container.Size = UDim2.new(1, -20, 1, -65)
    Container.BackgroundTransparency = 1

    local Window = {CurrentTab = nil}

    function Window:CreateTab(name)
        local TBtn = Instance.new("TextButton", TabScroll)
        TBtn.Size = UDim2.new(0, 85, 1, 0)
        TBtn.Text = name; TBtn.TextColor3 = Color3.new(1, 1, 1); TBtn.BackgroundTransparency = 1

        local Page = Instance.new("Frame", Container)
        Page.Size = UDim2.new(1, 0, 1, 0); Page.Visible = false; Page.BackgroundTransparency = 1

        local function CreateColumn(pos)
            local Col = Instance.new("ScrollingFrame", Page)
            Col.Size = UDim2.new(0.5, -5, 1, 0); Col.Position = pos
            Col.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            Col.ScrollBarThickness = 0
            Instance.new("UICorner", Col)
            
            -- GIỚI HẠN VUỐT: Chỉ cuộn khi nội dung dài hơn khung
            Col.AutomaticCanvasSize = Enum.AutomaticSize.Y
            Col.CanvasSize = UDim2.new(0, 0, 0, 0) 
            
            local L = Instance.new("UIListLayout", Col)
            L.Padding = UDim.new(0, 8); L.HorizontalAlignment = Enum.HorizontalAlignment.Center
            Instance.new("UIPadding", Col).PaddingTop = UDim.new(0, 8)
            
            -- Cập nhật CanvasSize dựa trên nội dung thực tế
            L:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Col.ScrollingEnabled = L.AbsoluteContentSize.Y > Col.AbsoluteSize.Y
            end)

            return Col
        end

        local Left = CreateColumn(UDim2.new(0, 0, 0, 0))
        local Right = CreateColumn(UDim2.new(0.5, 5, 0, 0))

        TBtn.MouseButton1Click:Connect(function()
            if Window.CurrentTab then Window.CurrentTab.P.Visible = false end
            Page.Visible = true; Window.CurrentTab = {P = Page}
        end)
        if not Window.CurrentTab then Page.Visible = true; Window.CurrentTab = {P = Page} end

        local Tab = {}
        function Tab:CreateSection(title, side)
            local Target = (side == "Right" and Right or Left)
            local Sec = Instance.new("Frame", Target)
            Sec.Size = UDim2.new(0.94, 0, 0, 40)
            Sec.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
            Instance.new("UICorner", Sec)
            
            local sCont = Instance.new("Frame", Sec)
            sCont.Position = UDim2.new(0, 10, 0, 32); sCont.Size = UDim2.new(1, -20, 0, 0); sCont.BackgroundTransparency = 1
            local L = Instance.new("UIListLayout", sCont); L.Padding = UDim.new(0, 6)

            L:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Sec.Size = UDim2.new(0.94, 0, 0, L.AbsoluteContentSize.Y + 40)
            end)

            local Ele = {}
            function Ele:CreateToggle(text, def, cb)
                local state = def
                local Tgl = Instance.new("TextButton", sCont)
                Tgl.Size = UDim2.new(1, 0, 0, 26); Tgl.BackgroundTransparency = 1
                Tgl.Text = "  " .. text; Tgl.TextColor3 = Color3.new(0.8, 0.8, 0.8)
                Tgl.TextXAlignment = 0

                local Bg = Instance.new("Frame", Tgl)
                Bg.Size = UDim2.new(0, 34, 0, 18); Bg.Position = UDim2.new(1, -36, 0.5, -9)
                Bg.BackgroundColor3 = state and Color3.new(0, 1, 1) or Color3.new(0.2, 0.2, 0.2)
                Instance.new("UICorner", Bg).CornerRadius = UDim.new(1, 0)

                local Dot = Instance.new("Frame", Bg)
                Dot.Size = UDim2.new(0, 14, 0, 14); Dot.Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                Dot.BackgroundColor3 = Color3.new(1, 1, 1)
                Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

                local Check = Instance.new("TextLabel", Dot)
                Check.Text = "✓"; Check.Size = UDim2.new(1, 0, 1, 0); Check.BackgroundTransparency = 1
                Check.Visible = state; Check.TextColor3 = Color3.new(0, 0.7, 0.7)

                Tgl.MouseButton1Click:Connect(function()
                    state = not state
                    TweenService:Create(Bg, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.new(0, 1, 1) or Color3.new(0.2, 0.2, 0.2)}):Play()
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
