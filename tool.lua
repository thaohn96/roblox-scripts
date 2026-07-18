-- ==========================================
-- GUI CHO ĐIỆN THOẠI - TAB DẠNG DROPDOWN
-- ==========================================

local player = game.Players.LocalPlayer
local userInput = game:GetService("UserInputService")
local isMobile = userInput.TouchEnabled

-- Tạo ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AllInOneTool"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999
screenGui.Parent = player.PlayerGui

-- MAIN FRAME - Nhỏ gọn
local mainFrame = Instance.new("Frame")
if isMobile then
    mainFrame.Size = UDim2.new(0, 360, 0, 400)
    mainFrame.Position = UDim2.new(0, 5, 0.05, 0)
else
    mainFrame.Size = UDim2.new(0, 500, 0, 580)
    mainFrame.Position = UDim2.new(0, 10, 0.05, 0)
end
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- NÚT ẨN/HIỆN
local toggleBtn = Instance.new("TextButton")
if isMobile then
    toggleBtn.Size = UDim2.new(0, 50, 0, 25)
    toggleBtn.Position = UDim2.new(0, 370, 0, 5)
    toggleBtn.TextSize = 11
else
    toggleBtn.Size = UDim2.new(0, 80, 0, 30)
    toggleBtn.Position = UDim2.new(0, 520, 0, 10)
    toggleBtn.TextSize = 13
end
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
toggleBtn.Text = "🔽"
toggleBtn.TextColor3 = Color3.new(0, 0, 0)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.BorderSizePixel = 0
toggleBtn.Parent = screenGui

local cornerToggle = Instance.new("UICorner")
cornerToggle.CornerRadius = UDim.new(0, 8)
cornerToggle.Parent = toggleBtn

local isHidden = false
local function toggleGUI()
    isHidden = not isHidden
    mainFrame.Visible = not isHidden
    toggleBtn.Text = isHidden and "🔼" or "🔽"
    toggleBtn.BackgroundColor3 = isHidden and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(255, 200, 50)
end
toggleBtn.MouseButton1Click:Connect(toggleGUI)

-- ==========================================
-- TAB DẠNG DROPDOWN (Thay vì thanh ngang)
-- ==========================================
local dropdownFrame = Instance.new("Frame")
dropdownFrame.Size = UDim2.new(0, isMobile and 350 or 480, 0, 35)
dropdownFrame.Position = UDim2.new(0, 5, 0, 5)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
dropdownFrame.BorderSizePixel = 0
dropdownFrame.Parent = mainFrame

local cornerDF = Instance.new("UICorner")
cornerDF.CornerRadius = UDim.new(0, 6)
cornerDF.Parent = dropdownFrame

-- Nút chọn tab
local dropdownBtn = Instance.new("TextButton")
dropdownBtn.Size = UDim2.new(0, isMobile and 350 or 480, 0, 35)
dropdownBtn.Position = UDim2.new(0, 0, 0, 0)
dropdownBtn.BackgroundTransparency = 1
dropdownBtn.Text = "📦 Vật Phẩm"
dropdownBtn.TextColor3 = Color3.new(1, 1, 1)
dropdownBtn.TextSize = isMobile and 14 or 16
dropdownBtn.Font = Enum.Font.SourceSansBold
dropdownBtn.TextXAlignment = Enum.TextXAlignment.Left
dropdownBtn.BorderSizePixel = 0
dropdownBtn.Parent = dropdownFrame

-- Dropdown list
local dropdownList = Instance.new("ScrollingFrame")
dropdownList.Size = UDim2.new(0, isMobile and 350 or 480, 0, 120)
dropdownList.Position = UDim2.new(0, 0, 0, 35)
dropdownList.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
dropdownList.BorderSizePixel = 0
dropdownList.Visible = false
dropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
dropdownList.ScrollBarThickness = 3
dropdownList.Parent = dropdownFrame

local cornerDL = Instance.new("UICorner")
cornerDL.CornerRadius = UDim.new(0, 6)
cornerDL.Parent = dropdownList

-- Danh sách tab
local tabNames = {"📦 Vật Phẩm", "🚀 Dịch Chuyển", "🤖 Auto", "🏆 Grade"}
local currentTab = 1
local dropdownOpen = false

-- Tạo nút trong dropdown
local function buildDropdown()
    for _, child in ipairs(dropdownList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    local y = 0
    for i, name in ipairs(tabNames) do
        local item = Instance.new("TextButton")
        item.Size = UDim2.new(0, isMobile and 350 or 480, 0, 30)
        item.Position = UDim2.new(0, 0, 0, y)
        item.BackgroundColor3 = (i == currentTab) and Color3.fromRGB(50, 150, 255) or Color3.fromRGB(30, 30, 50)
        item.Text = name
        item.TextColor3 = Color3.new(1, 1, 1)
        item.TextSize = isMobile and 13 or 15
        item.Font = Enum.Font.SourceSans
        item.TextXAlignment = Enum.TextXAlignment.Left
        item.BorderSizePixel = 0
        item.Parent = dropdownList
        
        item.MouseButton1Click:Connect(function()
            currentTab = i
            dropdownBtn.Text = name
            dropdownOpen = false
            dropdownList.Visible = false
            switchTab(i)
            buildDropdown()
        end)
        y = y + 32
    end
    dropdownList.CanvasSize = UDim2.new(0, 0, 0, y)
end

-- Toggle dropdown
dropdownBtn.MouseButton1Click:Connect(function()
    dropdownOpen = not dropdownOpen
    dropdownList.Visible = dropdownOpen
    if dropdownOpen then
        buildDropdown()
    end
end)

-- ==========================================
-- NỘI DUNG CÁC TAB (Gọn hơn)
-- ==========================================
local contentFrames = {}
for i = 1, 4 do
    local content = Instance.new("Frame")
    content.Size = UDim2.new(0, isMobile and 350 or 480, 0, isMobile and 340 or 500)
    content.Position = UDim2.new(0, 5, 0, 45)
    content.BackgroundTransparency = 1
    content.Visible = (i == 1)
    content.Parent = mainFrame
    contentFrames[i] = content
end

local contentItems = contentFrames[1]
local contentTeleport = contentFrames[2]
local contentAuto = contentFrames[3]
local contentGrade = contentFrames[4]

-- Hàm chuyển tab
function switchTab(index)
    for i, frame in ipairs(contentFrames) do
        frame.Visible = (i == index)
    end
end

-- ==========================================
-- TAB VẬT PHẨM (Giới hạn hiển thị)
-- ==========================================

-- Info label
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(0, isMobile and 350 or 460, 0, 22)
infoLabel.Position = UDim2.new(0, 0, 0, 0)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "📡 50 unit | 0 vật phẩm"
infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
infoLabel.TextSize = isMobile and 11 or 13
infoLabel.Font = Enum.Font.SourceSans
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.Parent = contentItems

-- Scrolling Frame cho danh sách (giới hạn chiều cao)
local scrollItems = Instance.new("ScrollingFrame")
scrollItems.Size = UDim2.new(0, isMobile and 350 or 460, 0, isMobile and 240 or 380)
scrollItems.Position = UDim2.new(0, 0, 0, 25)
scrollItems.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
scrollItems.BackgroundTransparency = 0.5
scrollItems.BorderSizePixel = 0
scrollItems.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollItems.ScrollBarThickness = isMobile and 2 or 5
scrollItems.Parent = contentItems

-- Control buttons (gọn hơn)
local controlFrame1 = Instance.new("Frame")
controlFrame1.Size = UDim2.new(0, isMobile and 350 or 460, 0, 35)
controlFrame1.Position = UDim2.new(0, 0, 0, isMobile and 270 or 420)
controlFrame1.BackgroundTransparency = 1
controlFrame1.Parent = contentItems

local refreshBtn = Instance.new("TextButton")
refreshBtn.Size = UDim2.new(0, 60, 0, 28)
refreshBtn.Position = UDim2.new(0, 0, 0, 3)
refreshBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
refreshBtn.Text = "🔄"
refreshBtn.TextColor3 = Color3.new(1, 1, 1)
refreshBtn.TextSize = isMobile and 14 or 16
refreshBtn.Font = Enum.Font.SourceSansBold
refreshBtn.BorderSizePixel = 0
refreshBtn.Parent = controlFrame1

local cornerR = Instance.new("UICorner")
cornerR.CornerRadius = UDim.new(0, 6)
cornerR.Parent = refreshBtn

local radiusDown = Instance.new("TextButton")
radiusDown.Size = UDim2.new(0, 25, 0, 28)
radiusDown.Position = UDim2.new(0, 65, 0, 3)
radiusDown.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
radiusDown.Text = "−"
radiusDown.TextColor3 = Color3.new(1, 1, 1)
radiusDown.TextSize = 16
radiusDown.Font = Enum.Font.SourceSansBold
radiusDown.BorderSizePixel = 0
radiusDown.Parent = controlFrame1

local cornerRD = Instance.new("UICorner")
cornerRD.CornerRadius = UDim.new(0, 6)
cornerRD.Parent = radiusDown

local radiusDisplay = Instance.new("TextLabel")
radiusDisplay.Size = UDim2.new(0, 30, 0, 28)
radiusDisplay.Position = UDim2.new(0, 95, 0, 3)
radiusDisplay.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
radiusDisplay.Text = "50"
radiusDisplay.TextColor3 = Color3.new(1, 1, 1)
radiusDisplay.TextSize = isMobile and 12 or 14
radiusDisplay.Font = Enum.Font.SourceSansBold
radiusDisplay.BorderSizePixel = 0
radiusDisplay.Parent = controlFrame1

local cornerRD2 = Instance.new("UICorner")
cornerRD2.CornerRadius = UDim.new(0, 6)
cornerRD2.Parent = radiusDisplay

local radiusUp = Instance.new("TextButton")
radiusUp.Size = UDim2.new(0, 25, 0, 28)
radiusUp.Position = UDim2.new(0, 130, 0, 3)
radiusUp.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
radiusUp.Text = "+"
radiusUp.TextColor3 = Color3.new(0, 0, 0)
radiusUp.TextSize = 16
radiusUp.Font = Enum.Font.SourceSansBold
radiusUp.BorderSizePixel = 0
radiusUp.Parent = controlFrame1

local cornerRU = Instance.new("UICorner")
cornerRU.CornerRadius = UDim.new(0, 6)
cornerRU.Parent = radiusUp

local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(0, 40, 0, 28)
clearBtn.Position = UDim2.new(0, isMobile and 310 or 420, 0, 3)
clearBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
clearBtn.Text = "🗑"
clearBtn.TextColor3 = Color3.new(1, 1, 1)
clearBtn.TextSize = isMobile and 14 or 16
clearBtn.Font = Enum.Font.SourceSansBold
clearBtn.BorderSizePixel = 0
clearBtn.Parent = controlFrame1

local cornerC = Instance.new("UICorner")
cornerC.CornerRadius = UDim.new(0, 6)
cornerC.Parent = clearBtn

print("✅ GUI đã tối ưu cho " .. (isMobile and "ĐIỆN THOẠI" or "PC"))
-- Biến ẩn/hiện
local isHidden = false
local function toggleGUI()
    isHidden = not isHidden
    mainFrame.Visible = not isHidden
    if isHidden then
        toggleBtn.Text = "🔼"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    else
        toggleBtn.Text = "🔽"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
    end
end
toggleBtn.MouseButton1Click:Connect(toggleGUI)

-- Phím tắt Ctrl + H
userInput.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.H and userInput:IsKeyDown(Enum.KeyCode.LeftControl) then
        toggleGUI()
    end
end)

-- ==========================================
-- TAB HEADER - Dạng Scrolling cho điện thoại
-- ==========================================
local tabFrame = Instance.new("ScrollingFrame")
tabFrame.Size = UDim2.new(0, isMobile and 380 or 500, 0, 40)
tabFrame.Position = UDim2.new(0, 0, 0, 0)
tabFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
tabFrame.BorderSizePixel = 0
tabFrame.ScrollBarThickness = isMobile and 2 or 4
tabFrame.CanvasSize = UDim2.new(0, 600, 0, 0)
tabFrame.Parent = mainFrame

local cornerTab = Instance.new("UICorner")
cornerTab.CornerRadius = UDim.new(0, 12)
cornerTab.Parent = tabFrame

-- Tạo các tab
local tabNames = {"📦 Vật Phẩm", "🚀 Dịch Chuyển", "🤖 Auto", "🏆 Grade"}
local tabButtons = {}
local contentFrames = {}

for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 120, 0, 32)
    btn.Position = UDim2.new(0, 5 + (i-1) * 125, 0, 4)
    btn.BackgroundColor3 = (i == 1) and Color3.fromRGB(50, 150, 255) or Color3.fromRGB(40, 40, 60)
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = isMobile and 12 or 14
    btn.Font = Enum.Font.SourceSansBold
    btn.BorderSizePixel = 0
    btn.Parent = tabFrame
    tabButtons[i] = btn
    
    local cornerBtn = Instance.new("UICorner")
    cornerBtn.CornerRadius = UDim.new(0, 6)
    cornerBtn.Parent = btn
-- ==========================================
-- GUI CHO ĐIỆN THOẠI - TAB DẠNG DROPDOWN
-- ==========================================

local player = game.Players.LocalPlayer
local userInput = game:GetService("UserInputService")
local isMobile = userInput.TouchEnabled

-- Tạo ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AllInOneTool"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999
screenGui.Parent = player.PlayerGui

-- MAIN FRAME - Nhỏ gọn
local mainFrame = Instance.new("Frame")
if isMobile then
    mainFrame.Size = UDim2.new(0, 360, 0, 400)
    mainFrame.Position = UDim2.new(0, 5, 0.05, 0)
else
    mainFrame.Size = UDim2.new(0, 500, 0, 580)
    mainFrame.Position = UDim2.new(0, 10, 0.05, 0)
end
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- NÚT ẨN/HIỆN
local toggleBtn = Instance.new("TextButton")
if isMobile then
    toggleBtn.Size = UDim2.new(0, 50, 0, 25)
    toggleBtn.Position = UDim2.new(0, 370, 0, 5)
    toggleBtn.TextSize = 11
else
    toggleBtn.Size = UDim2.new(0, 80, 0, 30)
    toggleBtn.Position = UDim2.new(0, 520, 0, 10)
    toggleBtn.TextSize = 13
end
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
toggleBtn.Text = "🔽"
toggleBtn.TextColor3 = Color3.new(0, 0, 0)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.BorderSizePixel = 0
toggleBtn.Parent = screenGui

local cornerToggle = Instance.new("UICorner")
cornerToggle.CornerRadius = UDim.new(0, 8)
cornerToggle.Parent = toggleBtn

local isHidden = false
local function toggleGUI()
    isHidden = not isHidden
    mainFrame.Visible = not isHidden
    toggleBtn.Text = isHidden and "🔼" or "🔽"
    toggleBtn.BackgroundColor3 = isHidden and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(255, 200, 50)
end
toggleBtn.MouseButton1Click:Connect(toggleGUI)

-- ==========================================
-- TAB DẠNG DROPDOWN (Thay vì thanh ngang)
-- ==========================================
local dropdownFrame = Instance.new("Frame")
dropdownFrame.Size = UDim2.new(0, isMobile and 350 or 480, 0, 35)
dropdownFrame.Position = UDim2.new(0, 5, 0, 5)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
dropdownFrame.BorderSizePixel = 0
dropdownFrame.Parent = mainFrame

local cornerDF = Instance.new("UICorner")
cornerDF.CornerRadius = UDim.new(0, 6)
cornerDF.Parent = dropdownFrame

-- Nút chọn tab
local dropdownBtn = Instance.new("TextButton")
dropdownBtn.Size = UDim2.new(0, isMobile and 350 or 480, 0, 35)
dropdownBtn.Position = UDim2.new(0, 0, 0, 0)
dropdownBtn.BackgroundTransparency = 1
dropdownBtn.Text = "📦 Vật Phẩm"
dropdownBtn.TextColor3 = Color3.new(1, 1, 1)
dropdownBtn.TextSize = isMobile and 14 or 16
dropdownBtn.Font = Enum.Font.SourceSansBold
dropdownBtn.TextXAlignment = Enum.TextXAlignment.Left
dropdownBtn.BorderSizePixel = 0
dropdownBtn.Parent = dropdownFrame

-- Dropdown list
local dropdownList = Instance.new("ScrollingFrame")
dropdownList.Size = UDim2.new(0, isMobile and 350 or 480, 0, 120)
dropdownList.Position = UDim2.new(0, 0, 0, 35)
dropdownList.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
dropdownList.BorderSizePixel = 0
dropdownList.Visible = false
dropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
dropdownList.ScrollBarThickness = 3
dropdownList.Parent = dropdownFrame

local cornerDL = Instance.new("UICorner")
cornerDL.CornerRadius = UDim.new(0, 6)
cornerDL.Parent = dropdownList

-- Danh sách tab
local tabNames = {"📦 Vật Phẩm", "🚀 Dịch Chuyển", "🤖 Auto", "🏆 Grade"}
local currentTab = 1
local dropdownOpen = false

-- Tạo nút trong dropdown
local function buildDropdown()
    for _, child in ipairs(dropdownList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    local y = 0
    for i, name in ipairs(tabNames) do
        local item = Instance.new("TextButton")
        item.Size = UDim2.new(0, isMobile and 350 or 480, 0, 30)
        item.Position = UDim2.new(0, 0, 0, y)
        item.BackgroundColor3 = (i == currentTab) and Color3.fromRGB(50, 150, 255) or Color3.fromRGB(30, 30, 50)
        item.Text = name
        item.TextColor3 = Color3.new(1, 1, 1)
        item.TextSize = isMobile and 13 or 15
        item.Font = Enum.Font.SourceSans
        item.TextXAlignment = Enum.TextXAlignment.Left
        item.BorderSizePixel = 0
        item.Parent = dropdownList
        
        item.MouseButton1Click:Connect(function()
            currentTab = i
            dropdownBtn.Text = name
            dropdownOpen = false
            dropdownList.Visible = false
            switchTab(i)
            buildDropdown()
        end)
        y = y + 32
    end
    dropdownList.CanvasSize = UDim2.new(0, 0, 0, y)
end

-- Toggle dropdown
dropdownBtn.MouseButton1Click:Connect(function()
    dropdownOpen = not dropdownOpen
    dropdownList.Visible = dropdownOpen
    if dropdownOpen then
        buildDropdown()
    end
end)

-- ==========================================
-- NỘI DUNG CÁC TAB (Gọn hơn)
-- ==========================================
local contentFrames = {}
for i = 1, 4 do
    local content = Instance.new("Frame")
    content.Size = UDim2.new(0, isMobile and 350 or 480, 0, isMobile and 340 or 500)
    content.Position = UDim2.new(0, 5, 0, 45)
    content.BackgroundTransparency = 1
    content.Visible = (i == 1)
    content.Parent = mainFrame
    contentFrames[i] = content
end

local contentItems = contentFrames[1]
local contentTeleport = contentFrames[2]
local contentAuto = contentFrames[3]
local contentGrade = contentFrames[4]

-- Hàm chuyển tab
function switchTab(index)
    for i, frame in ipairs(contentFrames) do
        frame.Visible = (i == index)
    end
end

-- ==========================================
-- TAB VẬT PHẨM (Giới hạn hiển thị)
-- ==========================================

-- Info label
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(0, isMobile and 350 or 460, 0, 22)
infoLabel.Position = UDim2.new(0, 0, 0, 0)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "📡 50 unit | 0 vật phẩm"
infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
infoLabel.TextSize = isMobile and 11 or 13
infoLabel.Font = Enum.Font.SourceSans
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.Parent = contentItems

-- Scrolling Frame cho danh sách (giới hạn chiều cao)
local scrollItems = Instance.new("ScrollingFrame")
scrollItems.Size = UDim2.new(0, isMobile and 350 or 460, 0, isMobile and 240 or 380)
scrollItems.Position = UDim2.new(0, 0, 0, 25)
scrollItems.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
scrollItems.BackgroundTransparency = 0.5
scrollItems.BorderSizePixel = 0
scrollItems.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollItems.ScrollBarThickness = isMobile and 2 or 5
scrollItems.Parent = contentItems

-- Control buttons (gọn hơn)
local controlFrame1 = Instance.new("Frame")
controlFrame1.Size = UDim2.new(0, isMobile and 350 or 460, 0, 35)
controlFrame1.Position = UDim2.new(0, 0, 0, isMobile and 270 or 420)
controlFrame1.BackgroundTransparency = 1
controlFrame1.Parent = contentItems

local refreshBtn = Instance.new("TextButton")
refreshBtn.Size = UDim2.new(0, 60, 0, 28)
refreshBtn.Position = UDim2.new(0, 0, 0, 3)
refreshBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
refreshBtn.Text = "🔄"
refreshBtn.TextColor3 = Color3.new(1, 1, 1)
refreshBtn.TextSize = isMobile and 14 or 16
refreshBtn.Font = Enum.Font.SourceSansBold
refreshBtn.BorderSizePixel = 0
refreshBtn.Parent = controlFrame1

local cornerR = Instance.new("UICorner")
cornerR.CornerRadius = UDim.new(0, 6)
cornerR.Parent = refreshBtn

local radiusDown = Instance.new("TextButton")
radiusDown.Size = UDim2.new(0, 25, 0, 28)
radiusDown.Position = UDim2.new(0, 65, 0, 3)
radiusDown.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
radiusDown.Text = "−"
radiusDown.TextColor3 = Color3.new(1, 1, 1)
radiusDown.TextSize = 16
radiusDown.Font = Enum.Font.SourceSansBold
radiusDown.BorderSizePixel = 0
radiusDown.Parent = controlFrame1

local cornerRD = Instance.new("UICorner")
cornerRD.CornerRadius = UDim.new(0, 6)
cornerRD.Parent = radiusDown

local radiusDisplay = Instance.new("TextLabel")
radiusDisplay.Size = UDim2.new(0, 30, 0, 28)
radiusDisplay.Position = UDim2.new(0, 95, 0, 3)
radiusDisplay.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
radiusDisplay.Text = "50"
radiusDisplay.TextColor3 = Color3.new(1, 1, 1)
radiusDisplay.TextSize = isMobile and 12 or 14
radiusDisplay.Font = Enum.Font.SourceSansBold
radiusDisplay.BorderSizePixel = 0
radiusDisplay.Parent = controlFrame1

local cornerRD2 = Instance.new("UICorner")
cornerRD2.CornerRadius = UDim.new(0, 6)
cornerRD2.Parent = radiusDisplay

local radiusUp = Instance.new("TextButton")
radiusUp.Size = UDim2.new(0, 25, 0, 28)
radiusUp.Position = UDim2.new(0, 130, 0, 3)
radiusUp.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
radiusUp.Text = "+"
radiusUp.TextColor3 = Color3.new(0, 0, 0)
radiusUp.TextSize = 16
radiusUp.Font = Enum.Font.SourceSansBold
radiusUp.BorderSizePixel = 0
radiusUp.Parent = controlFrame1

local cornerRU = Instance.new("UICorner")
cornerRU.CornerRadius = UDim.new(0, 6)
cornerRU.Parent = radiusUp

local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(0, 40, 0, 28)
clearBtn.Position = UDim2.new(0, isMobile and 310 or 420, 0, 3)
clearBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
clearBtn.Text = "🗑"
clearBtn.TextColor3 = Color3.new(1, 1, 1)
clearBtn.TextSize = isMobile and 14 or 16
clearBtn.Font = Enum.Font.SourceSansBold
clearBtn.BorderSizePixel = 0
clearBtn.Parent = controlFrame1

local cornerC = Instance.new("UICorner")
cornerC.CornerRadius = UDim.new(0, 6)
cornerC.Parent = clearBtn

print("✅ GUI đã tối ưu cho " .. (isMobile and "ĐIỆN THOẠI" or "PC"))==========================================
-- PHẦN 3: TAB VẬT PHẨM (Quét + Danh sách)
-- ==========================================

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(0, 460, 0, 25)
infoLabel.Position = UDim2.new(0, 10, 0, 5)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "📡 Bán kính: 50 unit | Đang quét..."
infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
infoLabel.TextSize = 13
infoLabel.Font = Enum.Font.SourceSans
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.Parent = contentItems

local scrollItems = Instance.new("ScrollingFrame")
scrollItems.Size = UDim2.new(0, 460, 0, 380)
scrollItems.Position = UDim2.new(0, 10, 0, 35)
scrollItems.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
scrollItems.BackgroundTransparency = 0.5
scrollItems.BorderSizePixel = 0
scrollItems.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollItems.ScrollBarThickness = 5
scrollItems.Parent = contentItems

local controlFrame1 = Instance.new("Frame")
controlFrame1.Size = UDim2.new(0, 460, 0, 40)
controlFrame1.Position = UDim2.new(0, 10, 0, 420)
controlFrame1.BackgroundTransparency = 1
controlFrame1.Parent = contentItems

local refreshBtn = Instance.new("TextButton")
refreshBtn.Size = UDim2.new(0, 100, 0, 32)
refreshBtn.Position = UDim2.new(0, 0, 0, 4)
refreshBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
refreshBtn.Text = "🔄 Quét"
refreshBtn.TextColor3 = Color3.new(1, 1, 1)
refreshBtn.TextSize = 13
refreshBtn.Font = Enum.Font.SourceSansBold
refreshBtn.BorderSizePixel = 0
refreshBtn.Parent = controlFrame1

local cornerR = Instance.new("UICorner")
cornerR.CornerRadius = UDim.new(0, 6)
cornerR.Parent = refreshBtn

local radiusDown = Instance.new("TextButton")
radiusDown.Size = UDim2.new(0, 30, 0, 32)
radiusDown.Position = UDim2.new(0, 110, 0, 4)
radiusDown.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
radiusDown.Text = "-"
radiusDown.TextColor3 = Color3.new(1, 1, 1)
radiusDown.TextSize = 18
radiusDown.Font = Enum.Font.SourceSansBold
radiusDown.BorderSizePixel = 0
radiusDown.Parent = controlFrame1

local cornerRD = Instance.new("UICorner")
cornerRD.CornerRadius = UDim.new(0, 6)
cornerRD.Parent = radiusDown

local radiusDisplay = Instance.new("TextLabel")
radiusDisplay.Size = UDim2.new(0, 40, 0, 32)
radiusDisplay.Position = UDim2.new(0, 145, 0, 4)
radiusDisplay.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
radiusDisplay.Text = "50"
radiusDisplay.TextColor3 = Color3.new(1, 1, 1)
radiusDisplay.TextSize = 16
radiusDisplay.Font = Enum.Font.SourceSansBold
radiusDisplay.BorderSizePixel = 0
radiusDisplay.Parent = controlFrame1

local cornerRD2 = Instance.new("UICorner")
cornerRD2.CornerRadius = UDim.new(0, 6)
cornerRD2.Parent = radiusDisplay

local radiusUp = Instance.new("TextButton")
radiusUp.Size = UDim2.new(0, 30, 0, 32)
radiusUp.Position = UDim2.new(0, 190, 0, 4)
radiusUp.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
radiusUp.Text = "+"
radiusUp.TextColor3 = Color3.new(0, 0, 0)
radiusUp.TextSize = 18
radiusUp.Font = Enum.Font.SourceSansBold
radiusUp.BorderSizePixel = 0
radiusUp.Parent = controlFrame1

local cornerRU = Instance.new("UICorner")
cornerRU.CornerRadius = UDim.new(0, 6)
cornerRU.Parent = radiusUp

local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(0, 60, 0, 32)
clearBtn.Position = UDim2.new(0, 390, 0, 4)
clearBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
clearBtn.Text = "🗑️"
clearBtn.TextColor3 = Color3.new(1, 1, 1)
clearBtn.TextSize = 16
clearBtn.Font = Enum.Font.SourceSansBold
clearBtn.BorderSizePixel = 0
clearBtn.Parent = controlFrame1

local cornerC = Instance.new("UICorner")
cornerC.CornerRadius = UDim.new(0, 6)
cornerC.Parent = clearBtn

print("✅ PHẦN 3: Tab Vật Phẩm đã tạo!")
-- ==========================================
-- PHẦN 4: TAB DỊCH CHUYỂN TẦNG
-- ==========================================

local floorLabel = Instance.new("TextLabel")
floorLabel.Size = UDim2.new(0, 460, 0, 40)
floorLabel.Position = UDim2.new(0, 10, 0, 10)
floorLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
floorLabel.Text = "📍 Tầng hiện tại: 0"
floorLabel.TextColor3 = Color3.new(1, 1, 1)
floorLabel.TextSize = 18
floorLabel.Font = Enum.Font.SourceSansBold
floorLabel.Parent = contentTeleport

local cornerFL = Instance.new("UICorner")
cornerFL.CornerRadius = UDim.new(0, 8)
cornerFL.Parent = floorLabel

local floorControl = Instance.new("Frame")
floorControl.Size = UDim2.new(0, 460, 0, 80)
floorControl.Position = UDim2.new(0, 10, 0, 60)
floorControl.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
floorControl.Parent = contentTeleport

local cornerFC = Instance.new("UICorner")
cornerFC.CornerRadius = UDim.new(0, 8)
cornerFC.Parent = floorControl

local upBtn = Instance.new("TextButton")
upBtn.Size = UDim2.new(0, 200, 0, 60)
upBtn.Position = UDim2.new(0, 20, 0, 10)
upBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
upBtn.Text = "⬆ LÊN TẦNG"
upBtn.TextColor3 = Color3.new(1, 1, 1)
upBtn.TextSize = 18
upBtn.Font = Enum.Font.SourceSansBold
upBtn.BorderSizePixel = 0
upBtn.Parent = floorControl

local cornerUp = Instance.new("UICorner")
cornerUp.CornerRadius = UDim.new(0, 8)
cornerUp.Parent = upBtn

local downBtn = Instance.new("TextButton")
downBtn.Size = UDim2.new(0, 200, 0, 60)
downBtn.Position = UDim2.new(0, 240, 0, 10)
downBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
downBtn.Text = "⬇ XUỐNG TẦNG"
downBtn.TextColor3 = Color3.new(1, 1, 1)
downBtn.TextSize = 18
downBtn.Font = Enum.Font.SourceSansBold
downBtn.BorderSizePixel = 0
downBtn.Parent = floorControl

local cornerDown = Instance.new("UICorner")
cornerDown.CornerRadius = UDim.new(0, 8)
cornerDown.Parent = downBtn

local floorInput = Instance.new("Frame")
floorInput.Size = UDim2.new(0, 460, 0, 45)
floorInput.Position = UDim2.new(0, 10, 0, 150)
floorInput.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
floorInput.Parent = contentTeleport

local cornerFI = Instance.new("UICorner")
cornerFI.CornerRadius = UDim.new(0, 8)
cornerFI.Parent = floorInput

local floorTextBox = Instance.new("TextBox")
floorTextBox.Size = UDim2.new(0, 300, 0, 32)
floorTextBox.Position = UDim2.new(0, 10, 0, 6.5)
floorTextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
floorTextBox.Text = "Nhập tầng muốn đến..."
floorTextBox.TextColor3 = Color3.new(1, 1, 1)
floorTextBox.TextSize = 14
floorTextBox.Font = Enum.Font.SourceSans
floorTextBox.BorderSizePixel = 0
floorTextBox.Parent = floorInput

local cornerTB = Instance.new("UICorner")
cornerTB.CornerRadius = UDim.new(0, 6)
cornerTB.Parent = floorTextBox

local goFloorBtn = Instance.new("TextButton")
goFloorBtn.Size = UDim2.new(0, 80, 0, 32)
goFloorBtn.Position = UDim2.new(0, 370, 0, 6.5)
goFloorBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
goFloorBtn.Text = "Đến"
goFloorBtn.TextColor3 = Color3.new(0, 0, 0)
goFloorBtn.TextSize = 14
goFloorBtn.Font = Enum.Font.SourceSansBold
goFloorBtn.BorderSizePixel = 0
goFloorBtn.Parent = floorInput

local cornerGF = Instance.new("UICorner")
cornerGF.CornerRadius = UDim.new(0, 6)
cornerGF.Parent = goFloorBtn

local homeBtn = Instance.new("TextButton")
homeBtn.Size = UDim2.new(0, 200, 0, 40)
homeBtn.Position = UDim2.new(0, 130, 0, 205)
homeBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
homeBtn.Text = "🏠 Về Vị Trí Cũ"
homeBtn.TextColor3 = Color3.new(0, 0, 0)
homeBtn.TextSize = 16
homeBtn.Font = Enum.Font.SourceSansBold
homeBtn.BorderSizePixel = 0
homeBtn.Parent = contentTeleport

local cornerHome = Instance.new("UICorner")
cornerHome.CornerRadius = UDim.new(0, 8)
cornerHome.Parent = homeBtn

print("✅ PHẦN 4: Tab Dịch Chuyển đã tạo!")
-- ==========================================
-- PHẦN 5: TAB AUTO
-- ==========================================

local autoLabel = Instance.new("TextLabel")
autoLabel.Size = UDim2.new(0, 460, 0, 30)
autoLabel.Position = UDim2.new(0, 10, 0, 5)
autoLabel.BackgroundTransparency = 1
autoLabel.Text = "🤖 TỰ ĐỘNG DỊCH CHUYỂN ĐẾN VẬT PHẨM"
autoLabel.TextColor3 = Color3.new(1, 1, 1)
autoLabel.TextSize = 16
autoLabel.Font = Enum.Font.SourceSansBold
autoLabel.Parent = contentAuto

local autoInputFrame = Instance.new("Frame")
autoInputFrame.Size = UDim2.new(0, 460, 0, 45)
autoInputFrame.Position = UDim2.new(0, 10, 0, 45)
autoInputFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
autoInputFrame.Parent = contentAuto

local cornerAI = Instance.new("UICorner")
cornerAI.CornerRadius = UDim.new(0, 8)
cornerAI.Parent = autoInputFrame

local autoTextBox = Instance.new("TextBox")
autoTextBox.Size = UDim2.new(0, 300, 0, 32)
autoTextBox.Position = UDim2.new(0, 10, 0, 6.5)
autoTextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
autoTextBox.Text = "Nhập tên vật phẩm cần tìm..."
autoTextBox.TextColor3 = Color3.new(1, 1, 1)
autoTextBox.TextSize = 14
autoTextBox.Font = Enum.Font.SourceSans
autoTextBox.BorderSizePixel = 0
autoTextBox.Parent = autoInputFrame

local cornerATB = Instance.new("UICorner")
cornerATB.CornerRadius = UDim.new(0, 6)
cornerATB.Parent = autoTextBox

local autoToggleBtn = Instance.new("TextButton")
autoToggleBtn.Size = UDim2.new(0, 100, 0, 32)
autoToggleBtn.Position = UDim2.new(0, 350, 0, 6.5)
autoToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
autoToggleBtn.Text = "▶ BẬT"
autoToggleBtn.TextColor3 = Color3.new(1, 1, 1)
autoToggleBtn.TextSize = 14
autoToggleBtn.Font = Enum.Font.SourceSansBold
autoToggleBtn.BorderSizePixel = 0
autoToggleBtn.Parent = autoInputFrame

local cornerAT = Instance.new("UICorner")
cornerAT.CornerRadius = UDim.new(0, 6)
cornerAT.Parent = autoToggleBtn

local autoStatus = Instance.new("Frame")
autoStatus.Size = UDim2.new(0, 460, 0, 60)
autoStatus.Position = UDim2.new(0, 10, 0, 100)
autoStatus.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
autoStatus.Parent = contentAuto

local cornerAS = Instance.new("UICorner")
cornerAS.CornerRadius = UDim.new(0, 8)
cornerAS.Parent = autoStatus

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0, 460, 0, 60)
statusLabel.Position = UDim2.new(0, 0, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "⏸ ĐANG DỪNG"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextSize = 18
statusLabel.Font = Enum.Font.SourceSansBold
statusLabel.Parent = autoStatus

print("✅ PHẦN 5: Tab Auto đã tạo!")
-- ==========================================
-- PHẦN 6: LOGIC CHÍNH
-- ==========================================

local scanRadius = 50
local currentFloor = 0
local homePosition = nil
local isAutoRunning = false
local autoTargetName = ""
local autoCoroutine = nil

-- HÀM QUÉT VẬT PHẨM
function scanNearby()
    for _, child in ipairs(scrollItems:GetChildren()) do
        child:Destroy()
    end
    
    local char = player.Character
    if not char then
        infoLabel.Text = "❌ Nhân vật chưa xuất hiện!"
        return
    end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        infoLabel.Text = "❌ Không tìm thấy nhân vật!"
        return
    end
    
    local items = {}
    local center = hrp.Position
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            if obj ~= char and obj ~= hrp and obj:FindFirstChild("Humanoid") == nil then
                if obj.Name ~= "Terrain" and obj.Name ~= "Camera" then
                    local success, pos = pcall(function()
                        if obj:IsA("Model") then
                            return obj:GetPivot().Position
                        else
                            return obj.Position
                        end
                    end)
                    if success and pos then
                        local dist = (pos - center).Magnitude
                        if dist <= scanRadius then
                            local name = obj.Name
                            if name == "" or name == "Part" then
                                if obj.Parent then
                                    name = obj.Parent.Name
                                end
                            end
                            if name ~= "" and name ~= "Workspace" and name ~= "Terrain" then
                                table.insert(items, {name = name, obj = obj, dist = dist})
                            end
                        end
                    end
                end
            end
        end
    end
    
    table.sort(items, function(a, b) return a.dist < b.dist end)
    
    if #items == 0 then
        local emptyLabel = Instance.new("TextLabel")
        emptyLabel.Size = UDim2.new(0, 440, 0, 40)
        emptyLabel.Position = UDim2.new(0, 10, 0, 10)
        emptyLabel.BackgroundTransparency = 1
        emptyLabel.Text = "❌ Không tìm thấy vật phẩm nào trong bán kính " .. scanRadius .. " unit!"
        emptyLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        emptyLabel.TextSize = 14
        emptyLabel.Font = Enum.Font.SourceSans
        emptyLabel.Parent = scrollItems
        scrollItems.CanvasSize = UDim2.new(0, 0, 0, 60)
        infoLabel.Text = "📡 Bán kính: " .. scanRadius .. " unit | 0 vật phẩm"
        return
    end
    
    local uniqueItems = {}
    local nameMap = {}
    for _, data in ipairs(items) do
        local key = data.name:lower()
        if not nameMap[key] then
            nameMap[key] = true
            table.insert(uniqueItems, data)
        end
    end
    
    infoLabel.Text = "📡 Bán kính: " .. scanRadius .. " unit | " .. #items .. " vật phẩm (" .. #uniqueItems .. " loại)"
    
    local yPos = 0
    for i, data in ipairs(uniqueItems) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 440, 0, 32)
        btn.Position = UDim2.new(0, 10, 0, yPos)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
        btn.Text = i .. ". " .. data.name .. " (📏 " .. math.floor(data.dist) .. "s)"
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.TextSize = 13
        btn.Font = Enum.Font.SourceSans
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.BorderSizePixel = 0
        btn.Parent = scrollItems
        
        btn.MouseButton1Click:Connect(function()
            local target = data.obj
            if target then
                local success, pos = pcall(function()
                    if target:IsA("Model") then
                        return target:GetPivot().Position
                    else
                        return target.Position
                    end
                end)
                if success and pos then
                    hrp.CFrame = CFrame.new(pos.X, pos.Y + 3, pos.Z)
                    print("✅ Đã dịch chuyển đến: " .. data.name)
                end
            end
        end)
        
        local copyBtn = Instance.new("TextButton")
        copyBtn.Size = UDim2.new(0, 50, 0, 26)
        copyBtn.Position = UDim2.new(0, 395, 0, 3)
        copyBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
        copyBtn.Text = "📋"
        copyBtn.TextColor3 = Color3.new(0, 0, 0)
        copyBtn.TextSize = 12
        copyBtn.Font = Enum.Font.SourceSansBold
        copyBtn.BorderSizePixel = 0
        copyBtn.Parent = btn
        copyBtn.MouseButton1Click:Connect(function()
            setclipboard(data.name)
            print("✅ Đã copy tên: " .. data.name)
        end)
        
        yPos = yPos + 36
    end
    scrollItems.CanvasSize = UDim2.new(0, 0, 0, yPos + 10)
end

-- HÀM DỊCH CHUYỂN TẦNG
function moveFloor(direction)
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if not homePosition then homePosition = hrp.Position end
    currentFloor = currentFloor + direction
    local newY = hrp.Position.Y + direction * 30
    hrp.CFrame = CFrame.new(hrp.Position.X, newY, hrp.Position.Z)
    floorLabel.Text = "📍 Tầng hiện tại: " .. currentFloor
end

function goToFloor(floor)
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if not homePosition then homePosition = hrp.Position end
    local diff = floor - currentFloor
    currentFloor = floor
    local newY = hrp.Position.Y + diff * 30
    hrp.CFrame = CFrame.new(hrp.Position.X, newY, hrp.Position.Z)
    floorLabel.Text = "📍 Tầng hiện tại: " .. currentFloor
end

-- HÀM AUTO
function startAuto()
    if isAutoRunning then
        isAutoRunning = false
        if autoCoroutine then
            coroutine.close(autoCoroutine)
            autoCoroutine = nil
        end
        autoToggleBtn.Text = "▶ BẬT"
        autoToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        statusLabel.Text = "⏸ ĐÃ DỪNG"
        statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        return
    end
    
    autoTargetName = autoTextBox.Text
    if autoTargetName == "" or autoTargetName == "Nhập tên vật phẩm cần tìm..." then
        statusLabel.Text = "⚠️ Vui lòng nhập tên vật phẩm!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
        return
    end
    
    isAutoRunning = true
    autoToggleBtn.Text = "⏹ DỪNG"
    autoToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    statusLabel.Text = "🔄 ĐANG TÌM KIẾM: " .. autoTargetName
    statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    
    autoCoroutine = coroutine.create(function()
        while isAutoRunning do
            local char = player.Character
            if not char then
                task.wait(1)
            else
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local found = nil
                    local minDist = math.huge
                    local center = hrp.Position
                    
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("BasePart") or obj:IsA("Model") then
                            if obj ~= char and obj ~= hrp and obj:FindFirstChild("Humanoid") == nil then
                                local name = obj.Name:lower()
                                local parentName = obj.Parent and obj.Parent.Name:lower() or ""
                                if name:find(autoTargetName:lower()) or parentName:find(autoTargetName:lower()) then
                                    local success, pos = pcall(function()
                                        if obj:IsA("Model") then
                                            return obj:GetPivot().Position
                                        else
                                            return obj.Position
                                        end
                                    end)
                                    if success and pos then
                                        local dist = (pos - center).Magnitude
                                        if dist < minDist then
                                            minDist = dist
                                            found = obj
                                        end
                                    end
                                end
                            end
                        end
                    end
                    
                    if found then
                        local success, pos = pcall(function()
                            if found:IsA("Model") then
                                return found:GetPivot().Position
                            else
                                return found.Position
                            end
                        end)
                        if success and pos then
                            hrp.CFrame = CFrame.new(pos.X, pos.Y + 3, pos.Z)
                            statusLabel.Text = "✅ ĐÃ TÌM THẤY: " .. found.Name
                            statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
                        end
                    else
                        statusLabel.Text = "🔍 ĐANG TÌM: " .. autoTargetName
                        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
                    end
                end
            end
            task.wait(2)
        end
    end)
    coroutine.resume(autoCoroutine)
end

print("✅ PHẦN 6: Logic chính đã tạo!")
-- ==========================================
-- PHẦN 7: GÁN SỰ KIỆN + KHỞI TẠO
-- ==========================================

-- Nút Quét
refreshBtn.MouseButton1Click:Connect(scanNearby)

-- Nút Xóa
clearBtn.MouseButton1Click:Connect(function()
    for _, child in ipairs(scrollItems:GetChildren()) do
        child:Destroy()
    end
    infoLabel.Text = "📡 Bán kính: " .. scanRadius .. " unit | Đã xóa danh sách"
end)

-- Nút tăng/giảm bán kính
radiusDown.MouseButton1Click:Connect(function()
    scanRadius = math.max(10, scanRadius - 5)
    radiusDisplay.Text = tostring(scanRadius)
    scanNearby()
end)

radiusUp.MouseButton1Click:Connect(function()
    scanRadius = math.min(100, scanRadius + 5)
    radiusDisplay.Text = tostring(scanRadius)
    scanNearby()
end)

-- Nút lên/xuống tầng
upBtn.MouseButton1Click:Connect(function() moveFloor(1) end)
downBtn.MouseButton1Click:Connect(function() moveFloor(-1) end)

-- Nút đến tầng
goFloorBtn.MouseButton1Click:Connect(function()
    local floor = tonumber(floorTextBox.Text)
    if floor then
        goToFloor(floor)
    else
        print("❌ Vui lòng nhập số tầng hợp lệ!")
    end
end)

-- Nút về vị trí cũ
homeBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if homePosition then
        hrp.CFrame = CFrame.new(homePosition)
        print("🏠 Đã về vị trí ban đầu!")
    end
end)

-- Nút Auto
autoToggleBtn.MouseButton1Click:Connect(startAuto)

-- Phím tắt lên/xuống tầng
userInput.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Up then
        moveFloor(1)
    elseif input.KeyCode == Enum.KeyCode.Down then
        moveFloor(-1)
    end
end)

-- KHỞI TẠO
task.wait(1)
scanNearby()
switchTab(1)

print("========================================")
print("🛠 TOOL ALL-IN-ONE")
print("========================================")
print("📌 Hướng dẫn:")
print("📦 Tab Vật Phẩm: Quét và dịch chuyển")
print("🚀 Tab Dịch Chuyển: Lên/xuống tầng (30 unit)")
print("🤖 Tab Auto: Tự động tìm và dịch chuyển")
print("⌨️ Phím tắt: ↑ (lên), ↓ (xuống)")
print("🔄 Phím tắt ẩn/hiện GUI: Ctrl + H")
print("========================================")
