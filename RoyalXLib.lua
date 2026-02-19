local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

function Library:CreateWindow()
    if CoreGui:FindFirstChild("RoyalX_Hub") then CoreGui["RoyalX_Hub"]:Destroy() end
    local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "RoyalX_Hub"
    
    local Main = Instance.new("Frame", ScreenGui)
    Main.BackgroundColor3 = Color3.fromRGB(12, 12, 12); Main.Size = UDim2.new(0, 560, 0, 380)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0); Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", Main).Color = Color3.fromRGB(40, 40, 40)

    local Container = Instance.new("Frame", Main)
    Container.Position = UDim2.new(0, 10, 0, 50); Container.Size = UDim2.new(1, -20, 1, -60); Container.BackgroundTransparency = 1

    local Window = {CurrentTab = nil}
    function Window:CreateTab(name)
        local Page = Instance.new("Frame", Container); Page.Size = UDim2.new(1, 0, 1, 0); Page.Visible = false; Page.BackgroundTransparency = 1
        local Left = Instance.new("ScrollingFrame", Page); Left.Size = UDim2.new(0.5, -5, 1, 0); Left.BackgroundTransparency = 1; Left.ScrollBarThickness = 0; Left.AutomaticCanvasSize = "Y"
        Instance.new("UIListLayout", Left).Padding = UDim.new(0, 10)
        local Right = Instance.new("ScrollingFrame", Page); Right.Size = UDim2.new(0.5, -5, 1, 0); Right.Position = UDim2.new(0.5, 5, 0, 0); Right.BackgroundTransparency = 1; Right.ScrollBarThickness = 0; Right.AutomaticCanvasSize = "Y"
        Instance.new("UIListLayout", Right).Padding = UDim.new(0, 10)
        
        Page.Visible = true 
        local Tab = {}
        function Tab:CreateSection(title, side)
            local Target = (side == "Right" and Right or Left)
            local Sec = Instance.new("Frame", Target); Sec.Size = UDim2.new(1, 0, 0, 35); Sec.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            Instance.new("UICorner", Sec).CornerRadius = UDim.new(0, 8)
            local sCont = Instance.new("Frame", Sec); sCont.Position = UDim2.new(0, 10, 0, 35); sCont.Size = UDim2.new(1, -20, 0, 0); sCont.BackgroundTransparency = 1
            local L = Instance.new("UIListLayout", sCont); L.Padding = UDim.new(0, 8)
            L:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() Sec.Size = UDim2.new(1, 0, 0, L.AbsoluteContentSize.Y + 45) end)
            
            local Ele = {}
            -- [[ TOGGLE NHƯ CŨ ]] --
            function Ele:CreateToggle(text, def, cb)
                local state = def
                local Tgl = Instance.new("TextButton", sCont)
                Tgl.Size = UDim2.new(1, 0, 0, 30); Tgl.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Tgl.Text = "  "..text
                Tgl.TextColor3 = state and Color3.new(1,1,1) or Color3.new(0.6,0.6,0.6); Tgl.TextXAlignment = 0; Tgl.Font = "GothamBold"; Tgl.TextSize = 12
                Instance.new("UICorner", Tgl).CornerRadius = UDim.new(0, 6)
                local Dot = Instance.new("Frame", Tgl); Dot.Size = UDim2.new(0, 12, 0, 12); Dot.Position = UDim2.new(1, -22, 0.5, -6)
                Dot.BackgroundColor3 = state and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 50, 50); Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
                Tgl.MouseButton1Click:Connect(function()
                    state = not state
                    Dot.BackgroundColor3 = state and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 50, 50)
                    Tgl.TextColor3 = state and Color3.new(1,1,1) or Color3.new(0.6,0.6,0.6)
                    cb(state)
                end)
            end

            -- [[ DROPDOWN NHƯ CŨ ]] --
            function Ele:CreateDropdown(text, options, cb)
                local Drop = Instance.new("TextButton", sCont); Drop.Size = UDim2.new(1, 0, 0, 30); Drop.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                Drop.Text = "  "..text..": "..options[1]; Drop.TextColor3 = Color3.new(1,1,1); Drop.TextXAlignment = 0; Drop.Font = "GothamBold"; Drop.TextSize = 11
                Instance.new("UICorner", Drop).CornerRadius = UDim.new(0, 6)
                local idx = 1
                Drop.MouseButton1Click:Connect(function()
                    idx = idx + 1; if idx > #options then idx = 1 end
                    Drop.Text = "  "..text..": "..options[idx]; cb(options[idx])
                end)
            end

            -- [[ SLIDER TỐC ĐỘ ]] --
            function Ele:CreateSlider(text, min, max, def, cb)
                local Sli = Instance.new("Frame", sCont); Sli.Size = UDim2.new(1, 0, 0, 45); Sli.BackgroundTransparency = 1
                local Title = Instance.new("TextLabel", Sli); Title.Text = text.." : "..def; Title.Size = UDim2.new(1, 0, 0, 20); Title.TextColor3 = Color3.new(1,1,1); Title.BackgroundTransparency = 1; Title.TextXAlignment = 0; Title.Font = "Gotham"; Title.TextSize = 11
                local BG = Instance.new("Frame", Sli); BG.Size = UDim2.new(1, 0, 0, 6); BG.Position = UDim2.new(0, 0, 0, 25); BG.BackgroundColor3 = Color3.fromRGB(45, 45, 45); Instance.new("UICorner", BG)
                local Fill = Instance.new("Frame", BG); Fill.Size = UDim2.new((def-min)/(max-min), 0, 1, 0); Fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255); Instance.new("UICorner", Fill)
                BG.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local dragging = true
                        local function upd()
                            local mPos = UserInputService:GetMouseLocation().X - BG.AbsolutePosition.X
                            local p = math.clamp(mPos/BG.AbsoluteSize.X, 0, 1)
                            local v = math.floor(min + (max-min)*p)
                            Fill.Size = UDim2.new(p, 0, 1, 0); Title.Text = text.." : "..v; cb(v)
                        end
                        upd()
                        local con; con = UserInputService.InputChanged:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseMovement then upd() end
                        end)
                        UserInputService.InputEnded:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false; con:Disconnect() end
                        end)
                    end
                end)
            end
            return Ele
        end
        return Tab
    end
    return Window
end
return Library
