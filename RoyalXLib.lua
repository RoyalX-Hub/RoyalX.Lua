local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

function Library:CreateWindow()
    if CoreGui:FindFirstChild("RoyalX_Hub") then CoreGui["RoyalX_Hub"]:Destroy() end
    local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "RoyalX_Hub"
    
    local Main = Instance.new("Frame", ScreenGui)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Main.Size = UDim2.new(0, 550, 0, 350)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0); Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    
    local Container = Instance.new("Frame", Main)
    Container.Position = UDim2.new(0, 10, 0, 50); Container.Size = UDim2.new(1, -20, 1, -60); Container.BackgroundTransparency = 1

    local Window = {CurrentTab = nil}
    function Window:CreateTab(name)
        local Page = Instance.new("Frame", Container); Page.Size = UDim2.new(1, 0, 1, 0); Page.Visible = false; Page.BackgroundTransparency = 1
        local Left = Instance.new("ScrollingFrame", Page); Left.Size = UDim2.new(0.5, -5, 1, 0); Left.BackgroundTransparency = 1; Left.ScrollBarThickness = 0; Left.AutomaticCanvasSize = "Y"
        Instance.new("UIListLayout", Left).Padding = UDim.new(0, 10)
        local Right = Instance.new("ScrollingFrame", Page); Right.Size = UDim2.new(0.5, -5, 1, 0); Right.Position = UDim2.new(0.5, 5, 0, 0); Right.BackgroundTransparency = 1; Right.ScrollBarThickness = 0; Right.AutomaticCanvasSize = "Y"
        Instance.new("UIListLayout", Right).Padding = UDim.new(0, 10)
        
        Page.Visible = true -- Tạm thời hiện tab đầu tiên
        local Tab = {}
        function Tab:CreateSection(title, side)
            local Target = (side == "Right" and Right or Left)
            local Sec = Instance.new("Frame", Target); Sec.Size = UDim2.new(1, 0, 0, 30); Sec.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            Instance.new("UICorner", Sec).CornerRadius = UDim.new(0, 8)
            local sCont = Instance.new("Frame", Sec); sCont.Position = UDim2.new(0, 10, 0, 35); sCont.Size = UDim2.new(1, -20, 0, 0); sCont.BackgroundTransparency = 1
            local L = Instance.new("UIListLayout", sCont); L.Padding = UDim.new(0, 5)
            L:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() Sec.Size = UDim2.new(1, 0, 0, L.AbsoluteContentSize.Y + 45) end)
            
            local Ele = {}
            -- [[ 1. NÚT BẬT TẮT (TOGGLE) NHƯ CŨ ]] --
            function Ele:CreateToggle(text, def, cb)
                local state = def
                local Tgl = Instance.new("TextButton", sCont)
                Tgl.Size = UDim2.new(1, 0, 0, 30); Tgl.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Tgl.Text = "  "..text
                Tgl.TextColor3 = state and Color3.new(1,1,1) or Color3.new(0.6,0.6,0.6); Tgl.TextXAlignment = 0; Tgl.Font = "Gotham"; Tgl.TextSize = 12
                Instance.new("UICorner", Tgl).CornerRadius = UDim.new(0, 6)
                
                local Status = Instance.new("Frame", Tgl)
                Status.Size = UDim2.new(0, 10, 0, 10); Status.Position = UDim2.new(1, -20, 0.5, -5)
                Status.BackgroundColor3 = state and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
                Instance.new("UICorner", Status).CornerRadius = UDim.new(1, 0)

                Tgl.MouseButton1Click:Connect(function()
                    state = not state
                    Status.BackgroundColor3 = state and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
                    Tgl.TextColor3 = state and Color3.new(1,1,1) or Color3.new(0.6,0.6,0.6)
                    cb(state)
                end)
            end

            -- [[ 2. CHỌN THEO DANH SÁCH (DROPDOWN) ]] --
            function Ele:CreateDropdown(text, options, cb)
                local Drop = Instance.new("Frame", sCont)
                Drop.Size = UDim2.new(1, 0, 0, 30); Drop.BackgroundColor3 = Color3.fromRGB(35, 35, 35); Drop.ClipsDescendants = true
                Instance.new("UICorner", Drop).CornerRadius = UDim.new(0, 6)
                
                local Btn = Instance.new("TextButton", Drop)
                Btn.Size = UDim2.new(1, 0, 0, 30); Btn.BackgroundTransparency = 1; Btn.Text = "  "..text..": "..options[1]
                Btn.TextColor3 = Color3.new(1,1,1); Btn.TextXAlignment = 0; Btn.Font = "GothamBold"; Btn.TextSize = 11
                
                local ListFrame = Instance.new("Frame", Drop)
                ListFrame.Position = UDim2.new(0, 0, 0, 30); ListFrame.Size = UDim2.new(1, 0, 0, #options * 25); ListFrame.BackgroundTransparency = 1
                Instance.new("UIListLayout", ListFrame)

                local isOpen = false
                Btn.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    Drop.Size = isOpen and UDim2.new(1, 0, 0, 30 + (25 * #options)) or UDim2.new(1, 0, 0, 30)
                end)

                for _, v in pairs(options) do
                    local Opt = Instance.new("TextButton", ListFrame)
                    Opt.Size = UDim2.new(1, 0, 0, 25); Opt.BackgroundColor3 = Color3.fromRGB(45, 45, 45); Opt.Text = v
                    Opt.TextColor3 = Color3.new(0.8,0.8,0.8); Opt.Font = "Gotham"; Opt.TextSize = 11
                    Opt.MouseButton1Click:Connect(function()
                        Btn.Text = "  "..text..": "..v
                        isOpen = false; Drop.Size = UDim2.new(1, 0, 0, 30)
                        cb(v)
                    end)
                end
            end
            return Ele
        end
        return Tab
    end
    return Window
end
return Libraryy
