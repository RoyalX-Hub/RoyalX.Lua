local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Utility functions
local function MakeDraggable(gui)
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

function Library:CreateWindow(config)
    config = config or {}
    local windowTitle = config.Name or "RoyalX Lib"
    local logoId = config.Logo or "rbxassetid://107831103893115" -- Id logo của mày

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RoyalXLib"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Nền đen nhạt
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.ClipsDescendants = true
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    MakeDraggable(MainFrame)

    -- Sidebar (Tabs)
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Sidebar.BorderSizePixel = 0
    Sidebar.Size = UDim2.new(0, 160, 1, 0)

    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 8)
    SidebarCorner.Parent = Sidebar

    -- Logo & Title
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Parent = Sidebar
    Header.BackgroundTransparency = 1
    Header.Size = UDim2.new(1, 0, 0, 60)

    local Logo = Instance.new("ImageLabel")
    Logo.Name = "Logo"
    Logo.Parent = Header
    Logo.BackgroundTransparency = 1
    Logo.Position = UDim2.new(0, 10, 0, 10)
    Logo.Size = UDim2.new(0, 40, 0, 40)
    Logo.Image = logoId

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = Header
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 60, 0, 0)
    Title.Size = UDim2.new(1, -60, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = windowTitle
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = Sidebar
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.Position = UDim2.new(0, 0, 0, 60)
    TabContainer.Size = UDim2.new(1, 0, 1, -60)
    TabContainer.ScrollBarThickness = 2
    TabContainer.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Parent = TabContainer
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 5)

    local TabPadding = Instance.new("UIPadding")
    TabPadding.Parent = TabContainer
    TabPadding.PaddingLeft = UDim.new(0, 10)
    TabPadding.PaddingRight = UDim.new(0, 10)
    TabPadding.PaddingTop = UDim.new(0, 5)

    -- Main Content Area
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Parent = MainFrame
    ContentArea.BackgroundTransparency = 1
    ContentArea.Position = UDim2.new(0, 160, 0, 0)
    ContentArea.Size = UDim2.new(1, -160, 1, 0)

    local Pages = Instance.new("Folder")
    Pages.Name = "Pages"
    Pages.Parent = ContentArea

    local Window = {
        CurrentTab = nil
    }

    function Window:CreateTab(name, icon)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name .. "Tab"
        TabButton.Parent = TabContainer
        TabButton.BackgroundColor3 = Color3.fromRGB(10, 10, 10) -- Tab đen
        TabButton.Size = UDim2.new(1, 0, 0, 35)
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = "  " .. name
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabButton.TextSize = 14
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.AutoButtonColor = false

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 4)
        TabCorner.Parent = TabButton

        local TabStroke = Instance.new("UIStroke")
        TabStroke.Parent = TabButton
        TabStroke.Color = Color3.fromRGB(255, 255, 255)
        TabStroke.Thickness = 1.5
        TabStroke.Transparency = 1 -- Hidden by default

        local Page = Instance.new("ScrollingFrame")
        Page.Name = name .. "Page"
        Page.Parent = Pages
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)

        local PageListLayout = Instance.new("UIListLayout")
        PageListLayout.Parent = Page
        PageListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageListLayout.Padding = UDim.new(0, 10)

        local PagePadding = Instance.new("UIPadding")
        PagePadding.Parent = Page
        PagePadding.PaddingBottom = UDim.new(0, 10)
        PagePadding.PaddingLeft = UDim.new(0, 15)
        PagePadding.PaddingRight = UDim.new(0, 15)
        PagePadding.PaddingTop = UDim.new(0, 15)

        local function Select()
            if Window.CurrentTab then
                Window.CurrentTab.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
                Window.CurrentTab.Stroke.Transparency = 1
                Window.CurrentTab.Page.Visible = false
            end
            
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabStroke.Transparency = 0 -- Hiện viền trắng khi trong tab
            Page.Visible = true
            Window.CurrentTab = {Button = TabButton, Page = Page, Stroke = TabStroke}
        end

        TabButton.MouseButton1Click:Connect(Select)

        if Window.CurrentTab == nil then
            Select()
        end

        local Tab = {}

        function Tab:CreateSection(sectionName)
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = sectionName .. "Section"
            SectionFrame.Parent = Page
            SectionFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            SectionFrame.Size = UDim2.new(1, 0, 0, 30) -- Height dynamic
            
            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 6)
            SectionCorner.Parent = SectionFrame

            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "Title"
            SectionTitle.Parent = SectionFrame
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Position = UDim2.new(0, 10, 0, 5)
            SectionTitle.Size = UDim2.new(1, -10, 0, 20)
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.Text = sectionName
            SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            SectionTitle.TextSize = 14
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left

            local Container = Instance.new("Frame")
            Container.Name = "Container"
            Container.Parent = SectionFrame
            Container.BackgroundTransparency = 1
            Container.Position = UDim2.new(0, 0, 0, 30)
            Container.Size = UDim2.new(1, 0, 1, -30)

            local ContainerLayout = Instance.new("UIListLayout")
            ContainerLayout.Parent = Container
            ContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ContainerLayout.Padding = UDim.new(0, 5)

            local ContainerPadding = Instance.new("UIPadding")
            ContainerPadding.Parent = Container
            ContainerPadding.PaddingBottom = UDim.new(0, 5)
            ContainerPadding.PaddingLeft = UDim.new(0, 10)
            ContainerPadding.PaddingRight = UDim.new(0, 10)
            ContainerPadding.PaddingTop = UDim.new(0, 5)

            ContainerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                SectionFrame.Size = UDim2.new(1, 0, 0, ContainerLayout.AbsoluteContentSize.Y + 40)
            end)

            local Section = {}

            function Section:CreateButton(text, callback)
                local Button = Instance.new("TextButton")
                Button.Name = text .. "Button"
                Button.Parent = Container
                Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                Button.Size = UDim2.new(1, 0, 0, 30)
                Button.Font = Enum.Font.Gotham
                Button.Text = text
                Button.TextColor3 = Color3.fromRGB(255, 255, 255)
                Button.TextSize = 13
                Button.AutoButtonColor = true

                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 4)
                ButtonCorner.Parent = Button

                Button.MouseButton1Click:Connect(function()
                    callback()
                end)
            end

            function Section:CreateToggle(text, default, callback)
                local Toggle = Instance.new("TextButton")
                Toggle.Name = text .. "Toggle"
                Toggle.Parent = Container
                Toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                Toggle.Size = UDim2.new(1, 0, 0, 32)
                Toggle.Font = Enum.Font.Gotham
                Toggle.Text = "  " .. text
                Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
                Toggle.TextSize = 13
                Toggle.TextXAlignment = Enum.TextXAlignment.Left
                Toggle.AutoButtonColor = false

                local ToggleCorner = Instance.new("UICorner")
                ToggleCorner.CornerRadius = UDim.new(0, 4)
                ToggleCorner.Parent = Toggle

                local Status = Instance.new("Frame")
                Status.Name = "Status"
                Status.Parent = Toggle
                Status.AnchorPoint = Vector2.new(1, 0.5)
                Status.BackgroundColor3 = default and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(50, 50, 50)
                Status.Position = UDim2.new(1, -10, 0.5, 0)
                Status.Size = UDim2.new(0, 24, 0, 12)

                local StatusCorner = Instance.new("UICorner")
                StatusCorner.CornerRadius = UDim.new(1, 0)
                StatusCorner.Parent = Status

                local Circle = Instance.new("Frame")
                Circle.Name = "Circle"
                Circle.Parent = Status
                Circle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
                Circle.Position = default and UDim2.new(1, -12, 0, 0) or UDim2.new(0, 0, 0, 0)
                Circle.Size = UDim2.new(0, 12, 0, 12)

                local CircleCorner = Instance.new("UICorner")
                CircleCorner.CornerRadius = UDim.new(1, 0)
                CircleCorner.Parent = Circle

                local enabled = default
                Toggle.MouseButton1Click:Connect(function()
                    enabled = not enabled
                    TweenService:Create(Circle, TweenInfo.new(0.2), {Position = enabled and UDim2.new(1, -12, 0, 0) or UDim2.new(0, 0, 0, 0)}):Play()
                    TweenService:Create(Status, TweenInfo.new(0.2), {BackgroundColor3 = enabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(50, 50, 50)}):Play()
                    callback(enabled)
                end)
            end

            function Section:CreateSlider(text, min, max, default, callback)
                local Slider = Instance.new("Frame")
                Slider.Name = text .. "Slider"
                Slider.Parent = Container
                Slider.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                Slider.Size = UDim2.new(1, 0, 0, 45)

                local SliderCorner = Instance.new("UICorner")
                SliderCorner.CornerRadius = UDim.new(0, 4)
                SliderCorner.Parent = Slider

                local SliderTitle = Instance.new("TextLabel")
                SliderTitle.Name = "Title"
                SliderTitle.Parent = Slider
                SliderTitle.BackgroundTransparency = 1
                SliderTitle.Position = UDim2.new(0, 10, 0, 5)
                SliderTitle.Size = UDim2.new(1, -20, 0, 20)
                SliderTitle.Font = Enum.Font.Gotham
                SliderTitle.Text = text
                SliderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
                SliderTitle.TextSize = 13
                SliderTitle.TextXAlignment = Enum.TextXAlignment.Left

                local ValueLabel = Instance.new("TextLabel")
                ValueLabel.Name = "Value"
                ValueLabel.Parent = Slider
                ValueLabel.BackgroundTransparency = 1
                ValueLabel.Position = UDim2.new(0, 10, 0, 5)
                ValueLabel.Size = UDim2.new(1, -20, 0, 20)
                ValueLabel.Font = Enum.Font.Gotham
                ValueLabel.Text = tostring(default)
                ValueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                ValueLabel.TextSize = 13
                ValueLabel.TextXAlignment = Enum.TextXAlignment.Right

                local SliderBar = Instance.new("Frame")
                SliderBar.Name = "Bar"
                SliderBar.Parent = Slider
                SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                SliderBar.BorderSizePixel = 0
                SliderBar.Position = UDim2.new(0, 10, 0, 30)
                SliderBar.Size = UDim2.new(1, -20, 0, 4)

                local SliderFill = Instance.new("Frame")
                SliderFill.Name = "Fill"
                SliderFill.Parent = SliderBar
                SliderFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SliderFill.BorderSizePixel = 0
                SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)

                local dragging = false
                local function move(input)
                    local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                    local val = math.floor(min + (max - min) * pos)
                    ValueLabel.Text = tostring(val)
                    SliderFill.Size = UDim2.new(pos, 0, 1, 0)
                    callback(val)
                end

                Slider.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        move(input)
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        move(input)
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
            end

            function Section:CreateDropdown(text, options, default, callback)
                local Dropdown = Instance.new("Frame")
                Dropdown.Name = text .. "Dropdown"
                Dropdown.Parent = Container
                Dropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                Dropdown.Size = UDim2.new(1, 0, 0, 32)
                Dropdown.ClipsDescendants = true

                local DropdownCorner = Instance.new("UICorner")
                DropdownCorner.CornerRadius = UDim.new(0, 4)
                DropdownCorner.Parent = Dropdown

                local DropdownButton = Instance.new("TextButton")
                DropdownButton.Name = "Button"
                DropdownButton.Parent = Dropdown
                DropdownButton.BackgroundTransparency = 1
                DropdownButton.Size = UDim2.new(1, 0, 0, 32)
                DropdownButton.Font = Enum.Font.Gotham
                DropdownButton.Text = "  " .. text .. " : " .. (default or "None")
                DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                DropdownButton.TextSize = 13
                DropdownButton.TextXAlignment = Enum.TextXAlignment.Left

                local Arrow = Instance.new("ImageLabel")
                Arrow.Name = "Arrow"
                Arrow.Parent = DropdownButton
                Arrow.AnchorPoint = Vector2.new(1, 0.5)
                Arrow.BackgroundTransparency = 1
                Arrow.Position = UDim2.new(1, -10, 0.5, 0)
                Arrow.Size = UDim2.new(0, 16, 0, 16)
                Arrow.Image = "rbxassetid://6034818372"

                local OptionContainer = Instance.new("Frame")
                OptionContainer.Name = "Options"
                OptionContainer.Parent = Dropdown
                OptionContainer.BackgroundTransparency = 1
                OptionContainer.Position = UDim2.new(0, 0, 0, 32)
                OptionContainer.Size = UDim2.new(1, 0, 0, 0)

                local OptionLayout = Instance.new("UIListLayout")
                OptionLayout.Parent = OptionContainer
                OptionLayout.SortOrder = Enum.SortOrder.LayoutOrder

                local open = false
                DropdownButton.MouseButton1Click:Connect(function()
                    open = not open
                    local targetSize = open and UDim2.new(1, 0, 0, OptionLayout.AbsoluteContentSize.Y + 32) or UDim2.new(1, 0, 0, 32)
                    TweenService:Create(Dropdown, TweenInfo.new(0.3), {Size = targetSize}):Play()
                    TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = open and 180 or 0}):Play()
                end)

                for _, option in pairs(options) do
                    local OptionBtn = Instance.new("TextButton")
                    OptionBtn.Name = option
                    OptionBtn.Parent = OptionContainer
                    OptionBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                    OptionBtn.BorderSizePixel = 0
                    OptionBtn.Size = UDim2.new(1, 0, 0, 25)
                    OptionBtn.Font = Enum.Font.Gotham
                    OptionBtn.Text = option
                    OptionBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
                    OptionBtn.TextSize = 12

                    OptionBtn.MouseButton1Click:Connect(function()
                        DropdownButton.Text = "  " .. text .. " : " .. option
                        open = false
                        TweenService:Create(Dropdown, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 32)}):Play()
                        TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
                        callback(option)
                    end)
                end
            end

            function Section:CreateTextbox(text, placeholder, callback)
                local TextboxFrame = Instance.new("Frame")
                TextboxFrame.Name = text .. "Textbox"
                TextboxFrame.Parent = Container
                TextboxFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                TextboxFrame.Size = UDim2.new(1, 0, 0, 32)

                local TextboxCorner = Instance.new("UICorner")
                TextboxCorner.CornerRadius = UDim.new(0, 4)
                TextboxCorner.Parent = TextboxFrame

                local TextboxTitle = Instance.new("TextLabel")
                TextboxTitle.Name = "Title"
                TextboxTitle.Parent = TextboxFrame
                TextboxTitle.BackgroundTransparency = 1
                TextboxTitle.Position = UDim2.new(0, 10, 0, 0)
                TextboxTitle.Size = UDim2.new(0.4, -10, 1, 0)
                TextboxTitle.Font = Enum.Font.Gotham
                TextboxTitle.Text = text
                TextboxTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
                TextboxTitle.TextSize = 13
                TextboxTitle.TextXAlignment = Enum.TextXAlignment.Left

                local Input = Instance.new("TextBox")
                Input.Name = "Input"
                Input.Parent = TextboxFrame
                Input.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                Input.Position = UDim2.new(0.4, 0, 0, 5)
                Input.Size = UDim2.new(0.6, -10, 0, 22)
                Input.Font = Enum.Font.Gotham
                Input.PlaceholderText = placeholder
                Input.Text = ""
                Input.TextColor3 = Color3.fromRGB(255, 255, 255)
                Input.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
                Input.TextSize = 12

                local InputCorner = Instance.new("UICorner")
                InputCorner.CornerRadius = UDim.new(0, 4)
                InputCorner.Parent = Input

                Input.FocusLost:Connect(function(enterPressed)
                    callback(Input.Text)
                end)
            end

            function Section:CreateLabel(text)
                local Label = Instance.new("TextLabel")
                Label.Name = text .. "Label"
                Label.Parent = Container
                Label.BackgroundTransparency = 1
                Label.Size = UDim2.new(1, 0, 0, 20)
                Label.Font = Enum.Font.Gotham
                Label.Text = text
                Label.TextColor3 = Color3.fromRGB(200, 200, 200)
                Label.TextSize = 12
                Label.TextXAlignment = Enum.TextXAlignment.Left
            end

            return Section
        end

        return Tab
    end

    return Window
end

return Library
