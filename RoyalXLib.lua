local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

function Library:CreateWindow()
    if CoreGui:FindFirstChild("RoyalX_Hub") then CoreGui["RoyalX_Hub"]:Destroy() end
    local ScreenGui = Instance.new("ScreenGui", CoreGui); ScreenGui.Name = "RoyalX_Hub"
    
    local Main = Instance.new("Frame", ScreenGui)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Main.Size = UDim2.new(0, 400, 0, 300)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0); Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", Main).Color = Color3.fromRGB(45, 45, 45)
    
    local Container = Instance.new("ScrollingFrame", Main)
    Container.Position = UDim2.new(0, 10, 0, 10); Container.Size = UDim2.new(1, -20, 1, -20)
    Container.BackgroundTransparency = 1; Container.ScrollBarThickness = 2
    local L = Instance.new("UIListLayout", Container); L.Padding = UDim.new(0, 10)

    local Win = {}
    -- [[ HÀM NÚT BẬT TẮT ]] --
    function Win:CreateToggle(text, cb)
        local state = false
        local Tgl = Instance.new("TextButton", Container)
        Tgl.Size = UDim2.new(1, 0, 0, 35); Tgl.BackgroundColor3 = Color3.fromRGB(25, 25, 25); Tgl.Text = "  "..text
        Tgl.TextColor3 = Color3.new(0.6, 0.6, 0.6); Tgl.TextXAlignment = 0; Tgl.Font = "GothamBold"
        Instance.new("UICorner", Tgl).CornerRadius = UDim.new(0, 8)
        
        local Indicator = Instance.new("Frame", Tgl)
        Indicator.Size = UDim2.new(0, 10, 1, -10); Indicator.Position = UDim2.new(1, -15, 0, 5)
        Indicator.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        Instance.new("UICorner", Indicator)

        Tgl.MouseButton1Click:Connect(function()
            state = not state
            Indicator.BackgroundColor3 = state and Color3.fromRGB(50, 255, 100) or Color3.fromRGB(255, 50, 50)
            Tgl.TextColor3 = state and Color3.new(1,1,1) or Color3.new(0.6, 0.6, 0.6)
            cb(state)
        end)
    end

    -- [[ HÀM THANH KÉO (SLIDER) ]] --
    function Win:CreateSlider(text, min, max, def, cb)
        local SliderFrame = Instance.new("Frame", Container)
        SliderFrame.Size = UDim2.new(1, 0, 0, 50); SliderFrame.BackgroundTransparency = 1
        
        local Title = Instance.new("TextLabel", SliderFrame)
        Title.Text = text .. " : " .. def; Title.Size = UDim2.new(1, 0, 0, 20); Title.TextColor3 = Color3.new(1,1,1)
        Title.BackgroundTransparency = 1; Title.Font = "Gotham"; Title.TextSize = 12; Title.TextXAlignment = 0

        local BG = Instance.new("Frame", SliderFrame)
        BG.Size = UDim2.new(1, 0, 0, 6); BG.Position = UDim2.new(0, 0, 0, 30); BG.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Instance.new("UICorner", BG)

        local Fill = Instance.new("Frame", BG)
        Fill.Size = UDim2.new((def - min)/(max - min), 0, 1, 0); Fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        Instance.new("UICorner", Fill)

        local function Update(input)
            local pos = math.clamp((input.Position.X - BG.AbsolutePosition.X) / BG.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + (max - min) * pos)
            Fill.Size = UDim2.new(pos, 0, 1, 0)
            Title.Text = text .. " : " .. val
            cb(val)
        end

        local dragging = false
        BG.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then Update(input) end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
        end)
    end

    return Win
end
return Library
