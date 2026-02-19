local RoyalXLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/RoyalX-Hub/RoyalX.Lua/main/RoyalXLib.lua"))()
local Win = RoyalXLib:CreateWindow()

local Tab = Win:CreateTab("RoyalX Hub")

-- Cột 1 (Bên trái, trên)
local C1 = Tab:CreateSection("Auto Farming", "Left")
C1:CreateToggle("Auto Level", true, function() end)
C1:CreateToggle("Auto Chest", false, function() end)

-- Cột 3 (Bên trái, dưới)
local C3 = Tab:CreateSection("Teleport", "Left")
C3:CreateToggle("Sea 1", false, function() end)
C3:CreateToggle("Sea 2", false, function() end)

-- Cột 2 (Bên phải, trên)
local C2 = Tab:CreateSection("Combat", "Right")
C2:CreateToggle("Kill Aura", false, function() end)
C2:CreateToggle("Fast Attack", true, function() end)

-- Cột 4 (Bên phải, dưới)
local C4 = Tab:CreateSection("Misc Settings", "Right")
C4:CreateToggle("Anti AFK", true, function() end)
C4:CreateToggle("Infinite Energy", false, function() end)

print("✅ RoyalX V5 Full Code đã sẵn sàng!")
