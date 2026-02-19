local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- [Giữ nguyên hàm MakeLogoDraggable và cấu trúc Window từ bản trước]

-- Cập nhật phần Elements bên trong CreateSection:
function Tab:CreateSection(title, side)
    local Parent = (side == "Right") and RightCol or LeftCol
    local Sec = Instance.new("Frame")
    Sec.Parent = Parent
    Sec.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Sec.Size = UDim2.new(1, 0, 0, 35)
    Instance.new("UICorner", Sec).CornerRadius = UDim.new(0, 6)

    -- ... (Phần sTitle và sCont giữ nguyên) ...

    local Elements = {}

    function Elements:CreateToggle(text, default, callback)
        local state = default
        local Tgl = Instance.new("TextButton")
        Tgl.Parent = sCont
        Tgl.Size = UDim2.new(1, 0, 0, 30)
        Tgl.BackgroundTransparency = 1
        Tgl.Text = "  " .. text
        Tgl.TextColor3 = Color3.fromRGB(180, 180, 180)
        Tgl.TextSize = 12
        Tgl.TextXAlignment = Enum.TextXAlignment.Left
        Tgl.Font = Enum.Font.Gotham

        -- KHUNG NỀN CỦA NÚT GẠT (HÌNH TRÒN DÀI)
        local SwitchBg = Instance.new("Frame")
        SwitchBg.Parent = Tgl
        SwitchBg.Position = UDim2.new(1, -40, 0.5, -10)
        SwitchBg.Size = UDim2.new(0, 35, 0, 20)
        SwitchBg.BackgroundColor3 = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(45, 45, 45)
        Instance.new("UICorner", SwitchBg).CornerRadius = UDim.new(1, 0) -- Bo tròn hoàn toàn

        -- NÚT TRÒN DI CHUYỂN
        local Dot = Instance.new("Frame")
        Dot.Parent = SwitchBg
        Dot.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        Dot.Size = UDim2.new(0, 16, 0, 16)
        Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

        -- DẤU TÍCH NHỎ TRÊN NÚT TRÒN
        local Check = Instance.new("TextLabel")
        Check.Parent = Dot
        Check.Size = UDim2.new(1, 0, 1, 0)
        Check.Text = "✓"
        Check.TextColor3 = Color3.fromRGB(0, 170, 255) -- Màu trùng với màu nền khi bật
        Check.TextSize = 12
        Check.BackgroundTransparency = 1
        Check.Visible = state

        Tgl.MouseButton1Click:Connect(function()
            state = not state
            
            -- Hiệu ứng trượt nút tròn
            local targetPos = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            local targetColor = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(45, 45, 45)
            
            TweenService:Create(Dot, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {Position = targetPos}):Play()
            TweenService:Create(SwitchBg, TweenInfo.new(0.25), {BackgroundColor3 = targetColor}):Play()
            
            Check.Visible = state
            callback(state)
        end)
    end

    return Elements
end
