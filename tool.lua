-- ==========================================
-- TOOL ALL-IN-ONE - CHẠY LẶP LẠI TỪNG VẬT PHẨM
-- ==========================================

local player = game.Players.LocalPlayer
local userInput = game:GetService("UserInputService")
local isMobile = userInput.TouchEnabled

-- ==========================================
-- HỆ THỐNG LƯU TRỮ
-- ==========================================
local hasWriteFile = type(writefile) == "function"
local hasShared = type(shared) == "table"
local hasGetgenv = type(getgenv) == "function" or type(getgenv) == "table"

local storage = {}
local saveMethod = "ram"

if hasWriteFile then
    local fileName = "saved_items.txt"
    
    function loadFromFile()
        local success, content = pcall(function()
            return readfile(fileName)
        end)
        if success and content and content ~= "" then
            local items = {}
            for name in content:gmatch("[^\n]+") do
                if name ~= "" then
                    table.insert(items, name)
                end
            end
            return items
        end
        return nil
    end
    
    function saveToFile(items)
        local success, err = pcall(function()
            writefile(fileName, table.concat(items, "\n"))
        end)
        return success
    end
    
    local loaded = loadFromFile()
    if loaded then
        storage.SavedItems = loaded
        saveMethod = "file (vĩnh viễn)"
    else
        storage.SavedItems = {}
        saveToFile({})
        saveMethod = "file (mới)"
    end
    
    function saveToMemory()
        saveToFile(storage.SavedItems)
    end
    
elseif hasShared then
    if not shared.SavedItems then
        shared.SavedItems = {}
    end
    storage = shared
    saveMethod = "shared (tạm)"
    function saveToMemory()
        shared.SavedItems = storage.SavedItems
    end
    
elseif hasGetgenv then
    local env = (type(getgenv) == "function") and getgenv() or getgenv
    if not env.SavedItems then
        env.SavedItems = {}
    end
    storage = env
    saveMethod = "getgenv (tạm)"
    function saveToMemory()
        env.SavedItems = storage.SavedItems
    end
    
else
    storage.SavedItems = {}
    saveMethod = "ram (tạm)"
    function saveToMemory() end
end

local savedItems = storage.SavedItems

-- ==========================================
-- BIẾN LƯU TRẠNG THÁI LOOP CHO TỪNG ITEM
-- ==========================================
local itemLoopStates = {} -- Lưu trạng thái loop của từng item

-- ==========================================
-- TẠO GUI
-- ==========================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AllInOne"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999
screenGui.Parent = player.PlayerGui

local mainFrame = Instance.new("Frame")
if isMobile then
    mainFrame.Size = UDim2.new(0, 360, 0, 530)
    mainFrame.Position = UDim2.new(0, 5, 0.01, 0)
else
    mainFrame.Size = UDim2.new(0, 460, 0, 590)
    mainFrame.Position = UDim2.new(0, 10, 0.01, 0)
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
toggleBtn.Size = UDim2.new(0, isMobile and 40 or 60, 0, isMobile and 22 or 28)
toggleBtn.Position = UDim2.new(0, isMobile and 320 or 400, 0, 5)
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
toggleBtn.Text = "🔽"
toggleBtn.TextColor3 = Color3.new(0, 0, 0)
toggleBtn.TextSize = isMobile and 12 or 16
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.BorderSizePixel = 0
toggleBtn.Parent = screenGui

local isHidden = false
toggleBtn.MouseButton1Click:Connect(function()
    isHidden = not isHidden
    mainFrame.Visible = not isHidden
    toggleBtn.Text = isHidden and "🔼" or "🔽"
end)

-- ==========================================
-- 3 TAB NGANG
-- ==========================================
local tabHeight = 28
local tabY = 5

local tab1 = Instance.new("TextButton")
tab1.Size = UDim2.new(0, isMobile and 105 or 135, 0, tabHeight)
tab1.Position = UDim2.new(0, 5, 0, tabY)
tab1.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
tab1.Text = "📦 Vật Phẩm"
tab1.TextColor3 = Color3.new(1, 1, 1)
tab1.TextSize = isMobile and 11 or 13
tab1.Font = Enum.Font.SourceSansBold
tab1.BorderSizePixel = 0
tab1.Parent = mainFrame

local tab2 = Instance.new("TextButton")
tab2.Size = UDim2.new(0, isMobile and 105 or 135, 0, tabHeight)
tab2.Position = UDim2.new(0, isMobile and 115 or 150, 0, tabY)
tab2.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
tab2.Text = "🚀 Dịch Chuyển"
tab2.TextColor3 = Color3.new(1, 1, 1)
tab2.TextSize = isMobile and 11 or 13
tab2.Font = Enum.Font.SourceSansBold
tab2.BorderSizePixel = 0
tab2.Parent = mainFrame

local tab3 = Instance.new("TextButton")
tab3.Size = UDim2.new(0, isMobile and 105 or 135, 0, tabHeight)
tab3.Position = UDim2.new(0, isMobile and 225 or 290, 0, tabY)
tab3.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
tab3.Text = "🤖 Auto"
tab3.TextColor3 = Color3.new(1, 1, 1)
tab3.TextSize = isMobile and 11 or 13
tab3.Font = Enum.Font.SourceSansBold
tab3.BorderSizePixel = 0
tab3.Parent = mainFrame

-- ==========================================
-- CONTENT
-- ==========================================
local contentY = tabY + tabHeight + 5
local contentHeight = isMobile and 450 or 520

-- TAB 1: VẬT PHẨM (giữ nguyên)
local content1 = Instance.new("Frame")
content1.Size = UDim2.new(0, isMobile and 350 or 440, 0, contentHeight)
content1.Position = UDim2.new(0, 5, 0, contentY)
content1.BackgroundTransparency = 1
content1.Visible = true
content1.Parent = mainFrame

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(0, isMobile and 350 or 440, 0, 24)
topBar.Position = UDim2.new(0, 0, 0, 0)
topBar.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
topBar.BorderSizePixel = 0
topBar.Parent = content1

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(0, isMobile and 130 or 180, 0, 24)
infoLabel.Position = UDim2.new(0, 5, 0, 0)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "📡 50u | 0 vật phẩm"
infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
infoLabel.TextSize = isMobile and 10 or 12
infoLabel.Font = Enum.Font.SourceSans
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.Parent = topBar

local refreshBtn = Instance.new("TextButton")
refreshBtn.Size = UDim2.new(0, isMobile and 50 or 65, 0, 20)
refreshBtn.Position = UDim2.new(0, isMobile and 140 or 190, 0, 2)
refreshBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
refreshBtn.Text = "🔄"
refreshBtn.TextColor3 = Color3.new(1, 1, 1)
refreshBtn.TextSize = isMobile and 12 or 14
refreshBtn.Font = Enum.Font.SourceSansBold
refreshBtn.BorderSizePixel = 0
refreshBtn.Parent = topBar
refreshBtn.ZIndex = 10

local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(0, isMobile and 45 or 60, 0, 20)
clearBtn.Position = UDim2.new(0, isMobile and 195 or 260, 0, 2)
clearBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
clearBtn.Text = "🗑️"
clearBtn.TextColor3 = Color3.new(1, 1, 1)
clearBtn.TextSize = isMobile and 11 or 13
clearBtn.Font = Enum.Font.SourceSansBold
clearBtn.BorderSizePixel = 0
clearBtn.Parent = topBar
clearBtn.ZIndex = 10

local radiusDown = Instance.new("TextButton")
radiusDown.Size = UDim2.new(0, 18, 0, 18)
radiusDown.Position = UDim2.new(0, isMobile and 305 or 395, 0, 3)
radiusDown.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
radiusDown.Text = "−"
radiusDown.TextColor3 = Color3.new(1, 1, 1)
radiusDown.TextSize = 12
radiusDown.Font = Enum.Font.SourceSansBold
radiusDown.BorderSizePixel = 0
radiusDown.Parent = topBar

local radiusDisplay = Instance.new("TextLabel")
radiusDisplay.Size = UDim2.new(0, 18, 0, 18)
radiusDisplay.Position = UDim2.new(0, isMobile and 305 or 395, 0, 3)
radiusDisplay.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
radiusDisplay.Text = "50"
radiusDisplay.TextColor3 = Color3.new(1, 1, 1)
radiusDisplay.TextSize = isMobile and 9 or 11
radiusDisplay.Font = Enum.Font.SourceSansBold
radiusDisplay.BorderSizePixel = 0
radiusDisplay.Parent = topBar

local radiusUp = Instance.new("TextButton")
radiusUp.Size = UDim2.new(0, 18, 0, 18)
radiusUp.Position = UDim2.new(0, isMobile and 325 or 420, 0, 3)
radiusUp.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
radiusUp.Text = "+"
radiusUp.TextColor3 = Color3.new(0, 0, 0)
radiusUp.TextSize = 12
radiusUp.Font = Enum.Font.SourceSansBold
radiusUp.BorderSizePixel = 0
radiusUp.Parent = topBar

local scrollItems = Instance.new("ScrollingFrame")
scrollItems.Size = UDim2.new(0, isMobile and 350 or 440, 0, isMobile and 335 or 390)
scrollItems.Position = UDim2.new(0, 0, 0, 27)
scrollItems.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
scrollItems.BackgroundTransparency = 0.5
scrollItems.BorderSizePixel = 0
scrollItems.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollItems.ScrollBarThickness = isMobile and 2 or 4
scrollItems.Parent = content1

-- TAB 2: DỊCH CHUYỂN (giữ nguyên)
local content2 = Instance.new("Frame")
content2.Size = UDim2.new(0, isMobile and 350 or 440, 0, contentHeight)
content2.Position = UDim2.new(0, 5, 0, contentY)
content2.BackgroundTransparency = 1
content2.Visible = false
content2.Parent = mainFrame

local floorLabel = Instance.new("TextLabel")
floorLabel.Size = UDim2.new(0, isMobile and 350 or 440, 0, 28)
floorLabel.Position = UDim2.new(0, 0, 0, 5)
floorLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
floorLabel.Text = "📍 Tầng: 0"
floorLabel.TextColor3 = Color3.new(1, 1, 1)
floorLabel.TextSize = isMobile and 15 or 17
floorLabel.Font = Enum.Font.SourceSansBold
floorLabel.Parent = content2

local upBtn = Instance.new("TextButton")
upBtn.Size = UDim2.new(0, isMobile and 135 or 175, 0, isMobile and 35 or 45)
upBtn.Position = UDim2.new(0, 10, 0, 42)
upBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
upBtn.Text = "⬆ LÊN"
upBtn.TextColor3 = Color3.new(1, 1, 1)
upBtn.TextSize = isMobile and 14 or 17
upBtn.Font = Enum.Font.SourceSansBold
upBtn.BorderSizePixel = 0
upBtn.Parent = content2

local downBtn = Instance.new("TextButton")
downBtn.Size = UDim2.new(0, isMobile and 135 or 175, 0, isMobile and 35 or 45)
downBtn.Position = UDim2.new(0, isMobile and 155 or 205, 0, 42)
downBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
downBtn.Text = "⬇ XUỐNG"
downBtn.TextColor3 = Color3.new(1, 1, 1)
downBtn.TextSize = isMobile and 14 or 17
downBtn.Font = Enum.Font.SourceSansBold
downBtn.BorderSizePixel = 0
downBtn.Parent = content2

local floorInput = Instance.new("TextBox")
floorInput.Size = UDim2.new(0, isMobile and 120 or 150, 0, 26)
floorInput.Position = UDim2.new(0, 10, 0, 88)
floorInput.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
floorInput.Text = "Tầng..."
floorInput.TextColor3 = Color3.new(1, 1, 1)
floorInput.TextSize = isMobile and 12 or 14
floorInput.Font = Enum.Font.SourceSans
floorInput.BorderSizePixel = 0
floorInput.Parent = content2

local goFloorBtn = Instance.new("TextButton")
goFloorBtn.Size = UDim2.new(0, 45, 0, 26)
goFloorBtn.Position = UDim2.new(0, isMobile and 140 or 180, 0, 88)
goFloorBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
goFloorBtn.Text = "Đến"
goFloorBtn.TextColor3 = Color3.new(0, 0, 0)
goFloorBtn.TextSize = isMobile and 12 or 14
goFloorBtn.Font = Enum.Font.SourceSansBold
goFloorBtn.BorderSizePixel = 0
goFloorBtn.Parent = content2

local homeBtn = Instance.new("TextButton")
homeBtn.Size = UDim2.new(0, isMobile and 200 or 250, 0, 32)
homeBtn.Position = UDim2.new(0, 10, 0, 125)
homeBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
homeBtn.Text = "🏠 Về vị trí cũ"
homeBtn.TextColor3 = Color3.new(0, 0, 0)
homeBtn.TextSize = isMobile and 13 or 15
homeBtn.Font = Enum.Font.SourceSansBold
homeBtn.BorderSizePixel = 0
homeBtn.Parent = content2

-- ==========================================
-- TAB 3: AUTO (CÓ NÚT CHẠY LẶP LẠI TỪNG VẬT PHẨM)
-- ==========================================
local content3 = Instance.new("Frame")
content3.Size = UDim2.new(0, isMobile and 350 or 440, 0, contentHeight)
content3.Position = UDim2.new(0, 5, 0, contentY)
content3.BackgroundTransparency = 1
content3.Visible = false
content3.Parent = mainFrame

local autoLabel = Instance.new("TextLabel")
autoLabel.Size = UDim2.new(0, isMobile and 350 or 440, 0, 22)
autoLabel.Position = UDim2.new(0, 0, 0, 0)
autoLabel.BackgroundTransparency = 1
autoLabel.Text = "🤖 AUTO - CHẠY LẶP TỪNG VẬT PHẨM"
autoLabel.TextColor3 = Color3.new(1, 1, 1)
autoLabel.TextSize = isMobile and 13 or 15
autoLabel.Font = Enum.Font.SourceSansBold
autoLabel.Parent = content3

-- Khung nhập + nút lưu
local inputFrame = Instance.new("Frame")
inputFrame.Size = UDim2.new(0, isMobile and 350 or 440, 0, 32)
inputFrame.Position = UDim2.new(0, 0, 0, 25)
inputFrame.BackgroundTransparency = 1
inputFrame.Parent = content3

local autoTextBox = Instance.new("TextBox")
autoTextBox.Size = UDim2.new(0, isMobile and 170 or 230, 0, 28)
autoTextBox.Position = UDim2.new(0, 0, 0, 2)
autoTextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
autoTextBox.Text = "Nhập tên vật phẩm..."
autoTextBox.TextColor3 = Color3.new(1, 1, 1)
autoTextBox.TextSize = isMobile and 11 or 13
autoTextBox.Font = Enum.Font.SourceSans
autoTextBox.BorderSizePixel = 0
autoTextBox.Parent = inputFrame

local saveItemBtn = Instance.new("TextButton")
saveItemBtn.Size = UDim2.new(0, isMobile and 50 or 60, 0, 28)
saveItemBtn.Position = UDim2.new(0, isMobile and 175 or 240, 0, 2)
saveItemBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
saveItemBtn.Text = "💾 Lưu"
saveItemBtn.TextColor3 = Color3.new(1, 1, 1)
saveItemBtn.TextSize = isMobile and 11 or 13
saveItemBtn.Font = Enum.Font.SourceSansBold
saveItemBtn.BorderSizePixel = 0
saveItemBtn.Parent = inputFrame

-- Delay chung
local delayFrame = Instance.new("Frame")
delayFrame.Size = UDim2.new(0, isMobile and 350 or 440, 0, 30)
delayFrame.Position = UDim2.new(0, 0, 0, 62)
delayFrame.BackgroundTransparency = 1
delayFrame.Parent = content3

local delayLabel = Instance.new("TextLabel")
delayLabel.Size = UDim2.new(0, 80, 0, 26)
delayLabel.Position = UDim2.new(0, 5, 0, 2)
delayLabel.BackgroundTransparency = 1
delayLabel.Text = "⏱ Delay:"
delayLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
delayLabel.TextSize = isMobile and 11 or 13
delayLabel.Font = Enum.Font.SourceSans
delayLabel.TextXAlignment = Enum.TextXAlignment.Left
delayLabel.Parent = delayFrame

local delayDown = Instance.new("TextButton")
delayDown.Size = UDim2.new(0, 22, 0, 22)
delayDown.Position = UDim2.new(0, 90, 0, 4)
delayDown.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
delayDown.Text = "−"
delayDown.TextColor3 = Color3.new(1, 1, 1)
delayDown.TextSize = 14
delayDown.Font = Enum.Font.SourceSansBold
delayDown.BorderSizePixel = 0
delayDown.Parent = delayFrame

local delayDisplay = Instance.new("TextLabel")
delayDisplay.Size = UDim2.new(0, 30, 0, 22)
delayDisplay.Position = UDim2.new(0, 117, 0, 4)
delayDisplay.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
delayDisplay.Text = "1.0"
delayDisplay.TextColor3 = Color3.new(1, 1, 1)
delayDisplay.TextSize = isMobile and 10 or 12
delayDisplay.Font = Enum.Font.SourceSansBold
delayDisplay.BorderSizePixel = 0
delayDisplay.Parent = delayFrame

local delayUp = Instance.new("TextButton")
delayUp.Size = UDim2.new(0, 22, 0, 22)
delayUp.Position = UDim2.new(0, 152, 0, 4)
delayUp.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
delayUp.Text = "+"
delayUp.TextColor3 = Color3.new(0, 0, 0)
delayUp.TextSize = 14
delayUp.Font = Enum.Font.SourceSansBold
delayUp.BorderSizePixel = 0
delayUp.Parent = delayFrame

-- ==========================================
-- DANH SÁCH VẬT PHẨM (CÓ NÚT CHẠY LẶP)
-- ==========================================
local savedLabel = Instance.new("TextLabel")
savedLabel.Size = UDim2.new(0, isMobile and 350 or 440, 0, 18)
savedLabel.Position = UDim2.new(0, 5, 0, 97)
savedLabel.BackgroundTransparency = 1
savedLabel.Text = "📋 VẬT PHẨM ĐÃ LƯU (" .. #savedItems .. ")"
savedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
savedLabel.TextSize = isMobile and 10 or 12
savedLabel.Font = Enum.Font.SourceSansBold
savedLabel.TextXAlignment = Enum.TextXAlignment.Left
savedLabel.Parent = content3

local savedScroll = Instance.new("ScrollingFrame")
savedScroll.Size = UDim2.new(0, isMobile and 350 or 440, 0, isMobile and 210 or 250)
savedScroll.Position = UDim2.new(0, 0, 0, 117)
savedScroll.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
savedScroll.BackgroundTransparency = 0.5
savedScroll.BorderSizePixel = 0
savedScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
savedScroll.ScrollBarThickness = isMobile and 2 or 4
savedScroll.Parent = content3

-- Trạng thái
local statusFrame = Instance.new("Frame")
statusFrame.Size = UDim2.new(0, isMobile and 350 or 440, 0, 35)
statusFrame.Position = UDim2.new(0, 0, 0, isMobile and 335 or 375)
statusFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
statusFrame.Parent = content3

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0, isMobile and 350 or 440, 0, 35)
statusLabel.Position = UDim2.new(0, 0, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "⏸ ĐANG DỪNG"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextSize = isMobile and 12 or 14
statusLabel.Font = Enum.Font.SourceSansBold
statusLabel.Parent = statusFrame

-- Thông tin lưu
local saveInfo = Instance.new("TextLabel")
saveInfo.Size = UDim2.new(0, isMobile and 350 or 440, 0, 16)
saveInfo.Position = UDim2.new(0, 5, 0, isMobile and 375 or 415)
saveInfo.BackgroundTransparency = 1
saveInfo.Text = "💾 Phương thức lưu: " .. saveMethod
saveInfo.TextColor3 = Color3.fromRGB(150, 150, 200)
saveInfo.TextSize = isMobile and 9 or 11
saveInfo.Font = Enum.Font.SourceSans
saveInfo.TextXAlignment = Enum.TextXAlignment.Left
saveInfo.Parent = content3

-- Nút xóa hết
local clearListBtn = Instance.new("TextButton")
clearListBtn.Size = UDim2.new(0, 80, 0, 22)
clearListBtn.Position = UDim2.new(0, isMobile and 270 or 360, 0, 97)
clearListBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
clearListBtn.Text = "🗑️ Xóa hết"
clearListBtn.TextColor3 = Color3.new(1, 1, 1)
clearListBtn.TextSize = isMobile and 10 or 12
clearListBtn.Font = Enum.Font.SourceSansBold
clearListBtn.BorderSizePixel = 0
clearListBtn.Parent = content3

-- ==========================================
-- CHUYỂN TAB
-- ==========================================
local function switchTab(tab)
    content1.Visible = (tab == 1)
    content2.Visible = (tab == 2)
    content3.Visible = (tab == 3)
    tab1.BackgroundColor3 = (tab == 1) and Color3.fromRGB(50, 150, 255) or Color3.fromRGB(40, 40, 60)
    tab2.BackgroundColor3 = (tab == 2) and Color3.fromRGB(50, 150, 255) or Color3.fromRGB(40, 40, 60)
    tab3.BackgroundColor3 = (tab == 3) and Color3.fromRGB(50, 150, 255) or Color3.fromRGB(40, 40, 60)
end

tab1.MouseButton1Click:Connect(function() switchTab(1) end)
tab2.MouseButton1Click:Connect(function() switchTab(2) end)
tab3.MouseButton1Click:Connect(function() switchTab(3) end)

-- ==========================================
-- LOGIC QUÉT VẬT PHẨM
-- ==========================================
local scanRadius = 50
local allItems = {}
local bodyParts = {
    "head", "uppertorso", "lowertorso", "upperarm", "lowerarm",
    "hand", "arm", "leg", "foot", "torso", "neck", "root",
    "humanoidrootpart", "left", "right", "attach", "joint",
    "body", "limb", "bones", "skeleton", "spine", "hip", "chest"
}

function scanNearby()
    for _, child in ipairs(scrollItems:GetChildren()) do child:Destroy() end
    local char = player.Character
    if not char then
        infoLabel.Text = "❌ Chưa có nhân vật!"
        return
    end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        infoLabel.Text = "❌ Không tìm thấy nhân vật!"
        return
    end
    
    allItems = {}
    local center = hrp.Position
    local count = 0
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        if count > 300 then break end
        if obj:IsA("Model") or obj:IsA("BasePart") then
            if obj == char then continue end
            if obj:IsDescendantOf(char) then continue end
            if obj:FindFirstChild("Humanoid") then continue end
            if obj:FindFirstChild("HumanoidRootPart") then continue end
            
            local name = obj.Name or ""
            local lowerName = name:lower()
            local isBody = false
            for _, part in ipairs(bodyParts) do
                if lowerName == part or lowerName:find(part) then
                    isBody = true
                    break
                end
            end
            if isBody then continue end
            
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
                    local displayName = name
                    if obj:IsA("BasePart") and obj.Parent and obj.Parent:IsA("Model") then
                        displayName = obj.Parent.Name
                    end
                    
                    if displayName ~= "" and displayName ~= "Workspace" and displayName ~= "Terrain" then
                        local isDuplicate = false
                        for _, existing in ipairs(allItems) do
                            if existing.name:lower() == displayName:lower() then
                                isDuplicate = true
                                break
                            end
                        end
                        if not isDuplicate then
                            table.insert(allItems, {name = displayName, obj = obj, dist = dist})
                            count = count + 1
                        end
                    end
                end
            end
        end
    end
    
    table.sort(allItems, function(a, b) return a.dist < b.dist end)
    
    if #allItems == 0 then
        local emptyLabel = Instance.new("TextLabel")
        emptyLabel.Size = UDim2.new(0, isMobile and 320 or 410, 0, 25)
        emptyLabel.Position = UDim2.new(0, 10, 0, 10)
        emptyLabel.BackgroundTransparency = 1
        emptyLabel.Text = "❌ Không tìm thấy vật phẩm!"
        emptyLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        emptyLabel.TextSize = isMobile and 10 or 12
        emptyLabel.Font = Enum.Font.SourceSans
        emptyLabel.Parent = scrollItems
        scrollItems.CanvasSize = UDim2.new(0, 0, 0, 50)
        infoLabel.Text = "📡 " .. scanRadius .. "u | 0 vật phẩm"
        return
    end
    
    infoLabel.Text = "📡 " .. scanRadius .. "u | " .. #allItems .. " vật phẩm"
    
    local yPos = 0
    for i, data in ipairs(allItems) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, isMobile and 320 or 410, 0, isMobile and 22 or 26)
        btn.Position = UDim2.new(0, 10, 0, yPos)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
        btn.Text = i .. ". " .. data.name .. " (📏" .. math.floor(data.dist) .. "s)"
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.TextSize = isMobile and 9 or 11
        btn.Font = Enum.Font.SourceSans
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.BorderSizePixel = 0
        btn.Parent = scrollItems
        
        btn.MouseButton1Click:Connect(function()
            local target = data.obj
            if target and hrp then
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
        copyBtn.Size = UDim2.new(0, 24, 0, isMobile and 16 or 20)
        copyBtn.Position = UDim2.new(0, isMobile and 298 or 390, 0, 3)
        copyBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
        copyBtn.Text = "📋"
        copyBtn.TextColor3 = Color3.new(0, 0, 0)
        copyBtn.TextSize = isMobile and 8 or 10
        copyBtn.Font = Enum.Font.SourceSansBold
        copyBtn.BorderSizePixel = 0
        copyBtn.Parent = btn
        
        copyBtn.MouseButton1Click:Connect(function()
            setclipboard(data.name)
            print("✅ Đã copy: " .. data.name)
        end)
        
        yPos = yPos + (isMobile and 26 or 30)
    end
    scrollItems.CanvasSize = UDim2.new(0, 0, 0, yPos + 10)
end

function clearItems()
    for _, child in ipairs(scrollItems:GetChildren()) do child:Destroy() end
    infoLabel.Text = "📡 " .. scanRadius .. "u | Đã xóa"
    allItems = {}
end

refreshBtn.MouseButton1Click:Connect(scanNearby)
clearBtn.MouseButton1Click:Connect(clearItems)

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

-- ==========================================
-- LOGIC DỊCH CHUYỂN TẦNG
-- ==========================================
local currentFloor = 0
local homePosition = nil

function moveFloor(direction)
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if not homePosition then homePosition = hrp.Position end
    currentFloor = currentFloor + direction
    local newY = hrp.Position.Y + direction * 30
    hrp.CFrame = CFrame.new(hrp.Position.X, newY, hrp.Position.Z)
    floorLabel.Text = "📍 Tầng: " .. currentFloor
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
    floorLabel.Text = "📍 Tầng: " .. currentFloor
end

upBtn.MouseButton1Click:Connect(function() moveFloor(1) end)
downBtn.MouseButton1Click:Connect(function() moveFloor(-1) end)

goFloorBtn.MouseButton1Click:Connect(function()
    local floor = tonumber(floorInput.Text)
    if floor then goToFloor(floor) else print("❌ Nhập số tầng!") end
end)

homeBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if homePosition then
        hrp.CFrame = CFrame.new(homePosition)
        print("🏠 Đã về vị trí cũ!")
    else
        print("❌ Chưa có vị trí lưu!")
    end
end)

-- ==========================================
-- HÀM TELEPORT ĐẾN 1 VẬT PHẨM (DÙNG CHUNG)
-- ==========================================
function teleportToItem(itemName)
    local char = player.Character
    if not char then
        statusLabel.Text = "❌ Nhân vật chưa xuất hiện!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return false
    end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        statusLabel.Text = "❌ Không tìm thấy nhân vật!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return false
    end
    
    local found = nil
    local minDist = math.huge
    local center = hrp.Position
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            if obj ~= char and obj:FindFirstChild("Humanoid") == nil then
                local name = obj.Name:lower()
                local parentName = obj.Parent and obj.Parent.Name:lower() or ""
                if name:find(itemName:lower()) or parentName:find(itemName:lower()) then
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
    
    if not found then
        statusLabel.Text = "❌ Không tìm thấy: " .. itemName
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return false
    end
    
    local success, pos = pcall(function()
        if found:IsA("Model") then
            return found:GetPivot().Position
        else
            return found.Position
        end
    end)
    
    if success and pos then
        hrp.CFrame = CFrame.new(pos.X, pos.Y + 3, pos.Z)
        return true
    end
    return false
end

-- ==========================================
-- HÀM TELEPORT CẠNH VẬT PHẨM
-- ==========================================
local nearbyDistance = 3

function teleportNearbyItem()
    local targetName = autoTextBox.Text
    if targetName == "" or targetName == "Nhập tên vật phẩm..." then
        statusLabel.Text = "⚠️ Nhập tên vật phẩm!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
        return
    end
    
    local char = player.Character
    if not char then
        statusLabel.Text = "❌ Nhân vật chưa xuất hiện!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        statusLabel.Text = "❌ Không tìm thấy nhân vật!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    
    local found = nil
    local minDist = math.huge
    local center = hrp.Position
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            if obj ~= char and obj:FindFirstChild("Humanoid") == nil then
                local name = obj.Name:lower()
                local parentName = obj.Parent and obj.Parent.Name:lower() or ""
                if name:find(targetName:lower()) or parentName:find(targetName:lower()) then
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
    
    if not found then
        statusLabel.Text = "❌ Không tìm thấy: " .. targetName
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end
    
    local success, pos = pcall(function()
        if found:IsA("Model") then
            return found:GetPivot().Position
        else
            return found.Position
        end
    end)
    
    if success and pos then
        local angle = math.random() * 2 * math.pi
        local offsetX = nearbyDistance * math.cos(angle)
        local offsetZ = nearbyDistance * math.sin(angle)
        
        hrp.CFrame = CFrame.new(pos.X + offsetX, pos.Y + 1, pos.Z + offsetZ)
        statusLabel.Text = "📍 Đã teleport cạnh: " .. found.Name
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        print("📍 Teleport cạnh: " .. found.Name)
    end
end

-- ==========================================
-- QUẢN LÝ DANH SÁCH VẬT PHẨM
-- ==========================================
function updateSavedList()
    for _, child in ipairs(savedScroll:GetChildren()) do child:Destroy() end
    savedLabel.Text = "📋 VẬT PHẨM ĐÃ LƯU (" .. #savedItems .. ")"
    
    if #savedItems == 0 then
        local emptyLabel = Instance.new("TextLabel")
        emptyLabel.Size = UDim2.new(0, isMobile and 320 or 410, 0, 30)
        emptyLabel.Position = UDim2.new(0, 10, 0, 10)
        emptyLabel.BackgroundTransparency = 1
        emptyLabel.Text = "📭 Chưa có vật phẩm nào"
        emptyLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        emptyLabel.TextSize = isMobile and 11 or 13
        emptyLabel.Font = Enum.Font.SourceSans
        emptyLabel.Parent = savedScroll
        savedScroll.CanvasSize = UDim2.new(0, 0, 0, 50)
        return
    end
    
    local yPos = 0
    for i, itemName in ipairs(savedItems) do
        -- Frame chứa item
        local btnFrame = Instance.new("Frame")
        btnFrame.Size = UDim2.new(0, isMobile and 330 or 420, 0, 30)
        btnFrame.Position = UDim2.new(0, 10, 0, yPos)
        btnFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        btnFrame.BorderSizePixel = 0
        btnFrame.Parent = savedScroll

        -- Tên item
        local itemLabel = Instance.new("TextLabel")
        itemLabel.Size = UDim2.new(0, isMobile and 140 or 190, 0, 26)
        itemLabel.Position = UDim2.new(0, 5, 0, 2)
        itemLabel.BackgroundTransparency = 1
        itemLabel.Text = i .. ". " .. itemName
        itemLabel.TextColor3 = Color3.new(1, 1, 1)
        itemLabel.TextSize = isMobile and 10 or 12
        itemLabel.Font = Enum.Font.SourceSans
        itemLabel.TextXAlignment = Enum.TextXAlignment.Left
        itemLabel.Parent = btnFrame

        -- ==========================================
        -- NÚT CHẠY LẶP (Bật/Tắt)
        -- ==========================================
        local isRunning = itemLoopStates[itemName] or false
        
        local runBtn = Instance.new("TextButton")
        runBtn.Size = UDim2.new(0, isMobile and 70 or 90, 0, 24)
        runBtn.Position = UDim2.new(0, isMobile and 155 or 210, 0, 3)
        if isRunning then
            runBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            runBtn.Text = "⏹ Dừng"
        else
            runBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
            runBtn.Text = "▶ Chạy"
        end
        runBtn.TextColor3 = Color3.new(1, 1, 1)
        runBtn.TextSize = isMobile and 9 or 11
        runBtn.Font = Enum.Font.SourceSansBold
        runBtn.BorderSizePixel = 0
        runBtn.Parent = btnFrame
        
        -- Biến lưu coroutine cho item này
        local itemCoroutine = nil
        
        runBtn.MouseButton1Click:Connect(function()
            if itemLoopStates[itemName] then
                -- ĐANG CHẠY -> DỪNG
                itemLoopStates[itemName] = false
                if itemCoroutine then
                    coroutine.close(itemCoroutine)
                    itemCoroutine = nil
                end
                runBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
                runBtn.Text = "▶ Chạy"
                statusLabel.Text = "⏸ Đã dừng: " .. itemName
                statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
                print("⏸ Đã dừng chạy: " .. itemName)
                return
            end
            
            -- BẮT ĐẦU CHẠY LẶP
            itemLoopStates[itemName] = true
            runBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            runBtn.Text = "⏹ Dừng"
            statusLabel.Text = "🔄 Đang chạy: " .. itemName
            statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            print("▶ Bắt đầu chạy lặp: " .. itemName)
            
            local delay = tonumber(delayDisplay.Text) or 1.0
            
            itemCoroutine = coroutine.create(function()
                while itemLoopStates[itemName] do
                    local success = teleportToItem(itemName)
                    if success then
                        statusLabel.Text = "✅ Đã teleport: " .. itemName
                        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
                    end
                    task.wait(delay)
                end
                
                -- Khi thoát vòng lặp, cập nhật lại nút
                if not itemLoopStates[itemName] then
                    runBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
                    runBtn.Text = "▶ Chạy"
                    statusLabel.Text = "⏸ Đã dừng: " .. itemName
                    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                end
            end)
            
            coroutine.resume(itemCoroutine)
        end)

        -- Nút xóa
        local delBtn = Instance.new("TextButton")
        delBtn.Size = UDim2.new(0, 25, 0, 24)
        delBtn.Position = UDim2.new(0, isMobile and 230 or 305, 0, 3)
        delBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        delBtn.Text = "✖"
        delBtn.TextColor3 = Color3.new(1, 1, 1)
        delBtn.TextSize = isMobile and 10 or 12
        delBtn.Font = Enum.Font.SourceSansBold
        delBtn.BorderSizePixel = 0
        delBtn.Parent = btnFrame
        delBtn.MouseButton1Click:Connect(function()
            -- Dừng loop nếu đang chạy
            if itemLoopStates[itemName] then
                itemLoopStates[itemName] = false
            end
            table.remove(savedItems, i)
            saveToMemory()
            updateSavedList()
            statusLabel.Text = "🗑️ Đã xóa: " .. itemName
            statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
        end)

        yPos = yPos + 32
    end
    savedScroll.CanvasSize = UDim2.new(0, 0, 0, yPos + 10)
end

-- Lưu vật phẩm
saveItemBtn.MouseButton1Click:Connect(function()
    local name = autoTextBox.Text
    if name == "" or name == "Nhập tên vật phẩm..." then
        statusLabel.Text = "⚠️ Nhập tên vật phẩm!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
        return
    end
    for _, item in ipairs(savedItems) do
        if item:lower() == name:lower() then
            statusLabel.Text = "⚠️ Đã có trong danh sách!"
            statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
            return
        end
    end
    table.insert(savedItems, name)
    itemLoopStates[name] = false
    saveToMemory()
    updateSavedList()
    statusLabel.Text = "✅ Đã lưu: " .. name
    statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    print("💾 Đã lưu '" .. name .. "'")
end)

-- Xóa hết danh sách
clearListBtn.MouseButton1Click:Connect(function()
    if #savedItems == 0 then
        statusLabel.Text = "📭 Danh sách đã trống!"
        statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        return
    end
    -- Dừng tất cả loop
    for _, name in ipairs(savedItems) do
        itemLoopStates[name] = false
    end
    savedItems = {}
    saveToMemory()
    updateSavedList()
    statusLabel.Text = "🗑️ Đã xóa toàn bộ danh sách!"
    statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    print("🗑️ Đã xóa toàn bộ danh sách!")
end)

-- Delay
delayDown.MouseButton1Click:Connect(function()
    local val = tonumber(delayDisplay.Text) or 1.0
    val = math.max(0.3, val - 0.2)
    delayDisplay.Text = string.format("%.1f", val)
end)

delayUp.MouseButton1Click:Connect(function()
    local val = tonumber(delayDisplay.Text) or 1.0
    val = math.min(5.0, val + 0.2)
    delayDisplay.Text = string.format("%.1f", val)
end)

-- ==========================================
-- PHÍM TẮT
-- ==========================================
userInput.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Up then moveFloor(1)
    elseif input.KeyCode == Enum.KeyCode.Down then moveFloor(-1) end
end)

-- ==========================================
-- KHỞI TẠO
-- ==========================================
task.wait(1)
scanNearby()
switchTab(1)
updateSavedList()

print("========================================")
print("🛠 TOOL - CHẠY LẶP TỪNG VẬT PHẨM")
print("========================================")
print("📌 Tab Auto:")
print("   ▶ Chạy: Bắt đầu chạy lặp vật phẩm đó")
print("   ⏹ Dừng: Dừng chạy lặp vật phẩm đó")
print("   ✖ Xóa: Xóa vật phẩm khỏi danh sách")
print("   ⏱ Delay: Thời gian giữa các lần teleport")
print("========================================")
if #savedItems > 0 then
    print("📋 Đã có " .. #savedItems .. " vật phẩm trong danh sách!")
end
print("========================================")