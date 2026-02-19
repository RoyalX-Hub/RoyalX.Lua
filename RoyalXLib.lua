local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

function Library:CreateWindow(config)
    config = config or {}
    local windowTitle = config.Name or "RoyalX HUB"
    local logoId = "rbxassetid://107831103893115"

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RoyalX_Final_Fixed"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true -- Đảm bảo không bị lệch bởi thanh công cụ của Roblox

    -- MAIN FRAME
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MainFrame.Position = UDim2.new(0.5, -325, 0.5, -225) 
    MainFrame.Size = UDim2.new(0, 650, 0, 450) -- Kích thước nhỏ gọn đã chốt
    MainFrame.Visible = true -- ĐẢM BẢO LUÔN HIỆN LÚC ĐẦU ĐỂ KIỂM TRA
    MainFrame.ClipsDescendants = true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

    -- NỀN TAB RIÊNG
    local TabBackground = Instance.new("Frame")
    TabBackground.Parent = MainFrame
    TabBackground.Size = UDim2.new(1, -20, 0, 35)
    TabBackground.Position = UDim2.new(0, 10, 0, 10)
    TabBackground.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Instance.new("UICorner", TabBackground).CornerRadius = UDim.new(0, 8)

    -- Thanh Scroll Tab (Đã fix để hiện tab)
    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Parent = TabBackground
    TabScroll.Position = UDim2.new(0, 45, 0, 5)
    TabScroll.Size = UDim2.new(1, -85, 1, -10)
    TabScroll.BackgroundTransparency = 1
    TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
    TabScroll.ScrollBarThickness = 0
    TabScroll.ElasticBehavior = Enum.ElasticBehavior.Never
    local TabList = Instance.new("UIListLayout", TabScroll)
    TabList.FillDirection = Enum.FillDirection.Horizontal
    TabList.Padding = UDim.new(0, 8)
    TabList.VerticalAlignment = Enum.VerticalAlignment.Center

    local ContentArea = Instance.new("Frame")
    ContentArea.Parent = MainFrame
    ContentArea.Position = UDim2.new(0, 10, 0, 55)
    ContentArea.Size = UDim2.new(1, -20, 1, -65)
    ContentArea.BackgroundTransparency = 1

    local Window = { CurrentTab = nil }

    -- === HÀM TẠO TAB (QUAN TRỌNG) ===
    function Window:CreateTab(name)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = TabScroll
        TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TabBtn.Size = UDim2.new(0, 90, 0, 25)
        TabBtn.Text = name
        TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabBtn.Font = Enum.Font.GothamBold
        TabBtn.TextSize = 11
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

        local Page = Instance.new("Frame")
        Page.Name = name.."_Page"
        Page.Parent = ContentArea
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.Visible = false
        Page.BackgroundTransparency = 1

        -- Cột Trái/Phải
        local function CreateCol(pos)
            local Bg = Instance.new("Frame")
            Bg.Parent = Page
            Bg.Position = pos
            Bg.Size = UDim2.new(0.5, -6, 1, 0)
            Bg.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
            Instance.new("UICorner", Bg).CornerRadius = UDim.new(0, 8)

            local Sc = Instance.new("ScrollingFrame")
            Sc.Parent = Bg
            Sc.Size = UDim2.new(1, -10, 1, -10)
            Sc.Position = UDim2.new(0, 5, 0, 5)
            Sc.BackgroundTransparency = 1
            Sc.ScrollBarThickness = 0
            Sc.AutomaticCanvasSize = Enum.AutomaticSize.Y
            Sc.ElasticBehavior = Enum.ElasticBehavior.Never
            Instance.new("UIListLayout", Sc).Padding = UDim.new(0, 8)
            return Sc
        end

        local Left = CreateCol(UDim2.new(0, 0, 0, 0))
        local Right = CreateCol(UDim2.new(0.5, 6, 0, 0))

        TabBtn.MouseButton1Click:Connect(function()
            if Window.CurrentTab then
                Window.CurrentTab.Page.Visible = false
                Window.CurrentTab.Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            end
            Page.Visible = true
            TabBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            Window.CurrentTab = {Page = Page, Btn = TabBtn}
        end)

        -- Tự động chọn tab đầu tiên
        if not Window.CurrentTab then
            Page.Visible = true
            TabBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            Window.CurrentTab = {Page = Page, Btn = TabBtn}
        end

        local Tab = {}
        function Tab:CreateSection(title, side)
            local Target = (side == "Right") and Right or Left
            local Sec = Instance.new("Frame")
            Sec.Parent = Target
            Sec.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
            Sec.Size = UDim2.new(1, 0, 0, 30)
            Instance.new("UICorner", Sec).CornerRadius = UDim.new(0, 6)

            local sTitle = Instance.new("TextLabel")
            sTitle.Parent = Sec
            sTitle.Text = title
            sTitle.Size = UDim2.new(1, 0, 0, 25)
            sTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            sTitle.BackgroundTransparency = 1
            sTitle.Font = Enum.Font.GothamBold
            sTitle.TextSize = 12

            local sCont = Instance.new("Frame")
            sCont.Parent = Sec
            sCont.Position = UDim2.new(0, 10, 0, 30)
            sCont.Size = UDim2.new(1, -20, 1, -35)
            sCont.BackgroundTransparency = 1
            local lay = Instance.new("UIListLayout", sCont)
            lay.Padding = UDim.new(0, 6)
            lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Sec.Size = UDim2.new(1, 0, 0, lay.AbsoluteContentSize.Y + 40)
            end)

            local Ele = {}
            function Ele:CreateToggle(t, d, cb)
                -- Code Toggle Switch tròn đã viết ở trên...
                -- [Phần này giữ nguyên code Toggle cũ của bạn]
            end
            return Ele
        end
        return Tab
    end
    return Window
end

return Library
