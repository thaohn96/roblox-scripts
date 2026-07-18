-- ==========================================
-- TOOL ALL-IN-ONE - SỬA LỖI LƯU FILE
-- ==========================================

local player = game.Players.LocalPlayer
local userInput = game:GetService("UserInputService")
local isMobile = userInput.TouchEnabled

-- ==========================================
-- LƯU TRỮ (SỬA LỖI)
-- ==========================================
local hasWriteFile = type(writefile) == "function"
local hasShared = type(shared) == "table"
local hasGetgenv = type(getgenv) == "function" or type(getgenv) == "table"

local storage = {}
local saveMethod = "ram"

-- Hàm lưu vào file (luôn ghi đè)
local function saveToFile(items)
    if not hasWriteFile then return false end
    local success, err = pcall(function()
        writefile("saved_items.txt", table.concat(items, "\n"))
    end)
    return success
end

-- Hàm đọc từ file
local function loadFromFile()
    if not hasWriteFile then return nil end
    local success, content = pcall(function()
        return readfile("saved_items.txt")
    end)
    if success and content and content ~= "" then
        local items = {}
        for name in content:gmatch("[^\n]+") do
            if name ~= "" then table.insert(items, name) end
        end
        return items
    end
    return nil
end

-- Chọn phương thức lưu
if hasWriteFile then
    local loaded = loadFromFile()
    if loaded then
        storage.SavedItems = loaded
        saveMethod = "file (vĩnh viễn)"
        print("📂 Đã tải " .. #loaded .. " vật phẩm từ file!")
    else
        storage.SavedItems = {}
        saveToFile({})
        saveMethod = "file (vĩnh viễn)"
        print("📂 Tạo file mới!")
    end
    -- Hàm lưu ghi đè file
    function saveToMemory()
        saveToFile(storage.SavedItems)
        print("💾 Đã lưu " .. #storage.SavedItems .. " vật phẩm vào file!")
    end
elseif hasShared then
    if not shared.SavedItems then shared.SavedItems = {} end
    storage = shared
    saveMethod = "shared (tạm)"
    function saveToMemory()
        shared.SavedItems = storage.SavedItems
    end
elseif hasGetgenv then
    local env = (type(getgenv) == "function") and getgenv() or getgenv
    if not env.SavedItems then env.SavedItems = {} end
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
local itemLoopStates = {}

-- ==========================================
-- HÀM THÊM VÀ XÓA (TỰ ĐỘNG LƯU)
-- ==========================================
function addItemToSaved(name)
    if name == "" then return false end
    for _, item in ipairs(savedItems) do
        if item:lower() == name:lower() then
            return false
        end
    end
    table.insert(savedItems, name)
    itemLoopStates[name] = false
    saveToMemory()  -- Lưu ngay
    updateSavedList()
    return true
end

function removeItemFromSaved(index)
    if index < 1 or index > #savedItems then return false end
    local removed = table.remove(savedItems, index)
    saveToMemory()  -- Lưu ngay sau khi xóa
    updateSavedList()
    return removed
end

-- ==========================================
-- TẠO NÚT UP/DOWN
-- ==========================================
local upDownGui = Instance.new("ScreenGui")
upDownGui.Name = "UpDownButtons"
upDownGui.ResetOnSpawn = false
upDownGui.DisplayOrder = 1000
upDownGui.Parent = player.PlayerGui

local upBtnOut = Instance.new("TextButton")
upBtnOut.Size = UDim2.new(0, 120, 0, 120)
if isMobile then
    upBtnOut.Position = UDim2.new(1, -45, 1, -80)
else
    upBtnOut.Position = UDim2.new(1, -50, 1, -80)
end
upBtnOut.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
upBtnOut.Text = "⬆"
upBtnOut.TextColor3 = Color3.new(1, 1, 1)
upBtnOut.TextSize = 20
upBtnOut.Font = Enum.Font.SourceSansBold
upBtnOut.BorderSizePixel = 0
upBtnOut.Parent = upDownGui

local cornerUp = Instance.new("UICorner")
cornerUp.CornerRadius = UDim.new(0, 8)
cornerUp.Parent = upBtnOut

local downBtnOut = Instance.new("TextButton")
downBtnOut.Size = UDim2.new(0, 120, 0, 120)
if isMobile then
    downBtnOut.Position = UDim2.new(1, -45, 1, -35)
else
    downBtnOut.Position = UDim2.new(1, -50, 1, -35)
end
downBtnOut.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
downBtnOut.Text = "⬇"
downBtnOut.TextColor3 = Color3.new(1, 1, 1)
downBtnOut.TextSize = 20
downBtnOut.Font = Enum.Font.SourceSansBold
downBtnOut.BorderSizePixel = 0
downBtnOut.Parent = upDownGui

local cornerDown = Instance.new("UICorner")
cornerDown.CornerRadius = UDim.new(0, 8)
cornerDown.Parent = downBtnOut

-- ==========================================
-- DỊCH CHUYỂN TẦNG
-- ==========================================
local currentFloor = 0
local homePosition = nil

function moveFloor(d)
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if not homePosition then homePosition = hrp.Position end
    currentFloor = currentFloor + d
    hrp.CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y + d * 30, hrp.Position.Z)
end

upBtnOut.MouseButton1Click:Connect(function() moveFloor(1) end)
downBtnOut.MouseButton1Click:Connect(function() moveFloor(-1) end)

-- ==========================================
-- TẠO GUI CHÍNH
-- ==========================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AllInOne"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999
screenGui.Parent = player.PlayerGui

local mainFrame = Instance.new("Frame")
if isMobile then
    mainFrame.Size = UDim2.new(0, 340, 0, 400)
    mainFrame.Position = UDim2.new(0, 5, 0.02, 0)
else
    mainFrame.Size = UDim2.new(0, 440, 0, 440)
    mainFrame.Position = UDim2.new(0, 10, 0.02, 0)
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
toggleBtn.Position = UDim2.new(0, isMobile and 300 or 380, 0, 5)
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
-- 2 TAB NGANG
-- ==========================================
local tabHeight = 26
local tabY = 5

local tab1 = Instance.new("TextButton")
tab1.Size = UDim2.new(0, isMobile and 140 or 180, 0, tabHeight)
tab1.Position = UDim2.new(0, 5, 0, tabY)
tab1.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
tab1.Text = "📦 Vật Phẩm"
tab1.TextColor3 = Color3.new(1, 1, 1)
tab1.TextSize = isMobile and 11 or 13
tab1.Font = Enum.Font.SourceSansBold
tab1.BorderSizePixel = 0
tab1.Parent = mainFrame

local tab3 = Instance.new("TextButton")
tab3.Size = UDim2.new(0, isMobile and 140 or 180, 0, tabHeight)
tab3.Position = UDim2.new(0, isMobile and 155 or 200, 0, tabY)
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
local contentHeight = isMobile and 325 or 365

-- TAB 1: VẬT PHẨM
local content1 = Instance.new("Frame")
content1.Size = UDim2.new(0, isMobile and 330 or 420, 0, contentHeight)
content1.Position = UDim2.new(0, 5, 0, contentY)
content1.BackgroundTransparency = 1
content1.Visible = true
content1.Parent = mainFrame

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(0, isMobile and 330 or 420, 0, 24)
topBar.Position = UDim2.new(0, 0, 0, 0)
topBar.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
topBar.BorderSizePixel = 0
topBar.Parent = content1

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(0, isMobile and 120 or 160, 0, 24)
infoLabel.Position = UDim2.new(0, 5, 0, 0)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "📡 50u | 0"
infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
infoLabel.TextSize = isMobile and 10 or 12
infoLabel.Font = Enum.Font.SourceSans
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.Parent = topBar

local refreshBtn = Instance.new("TextButton")
refreshBtn.Size = UDim2.new(0, isMobile and 35 or 45, 0, 20)
refreshBtn.Position = UDim2.new(0, isMobile and 130 or 175, 0, 2)
refreshBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
refreshBtn.Text = "🔄"
refreshBtn.TextColor3 = Color3.new(1, 1, 1)
refreshBtn.TextSize = isMobile and 12 or 14
refreshBtn.Font = Enum.Font.SourceSansBold
refreshBtn.BorderSizePixel = 0
refreshBtn.Parent = topBar

local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(0, isMobile and 35 or 45, 0, 20)
clearBtn.Position = UDim2.new(0, isMobile and 170 or 225, 0, 2)
clearBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
clearBtn.Text = "🗑"
clearBtn.TextColor3 = Color3.new(1, 1, 1)
clearBtn.TextSize = isMobile and 12 or 14
clearBtn.Font = Enum.Font.SourceSansBold
clearBtn.BorderSizePixel = 0
clearBtn.Parent = topBar

local radiusDown = Instance.new("TextButton")
radiusDown.Size = UDim2.new(0, 16, 0, 16)
radiusDown.Position = UDim2.new(0, isMobile and 210 or 275, 0, 4)
radiusDown.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
radiusDown.Text = "−"
radiusDown.TextColor3 = Color3.new(1, 1, 1)
radiusDown.TextSize = 11
radiusDown.Font = Enum.Font.SourceSansBold
radiusDown.BorderSizePixel = 0
radiusDown.Parent = topBar

local radiusDisplay = Instance.new("TextLabel")
radiusDisplay.Size = UDim2.new(0, 16, 0, 16)
radiusDisplay.Position = UDim2.new(0, isMobile and 210 or 275, 0, 4)
radiusDisplay.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
radiusDisplay.Text = "50"
radiusDisplay.TextColor3 = Color3.new(1, 1, 1)
radiusDisplay.TextSize = isMobile and 8 or 10
radiusDisplay.Font = Enum.Font.SourceSansBold
radiusDisplay.BorderSizePixel = 0
radiusDisplay.Parent = topBar

local radiusUp = Instance.new("TextButton")
radiusUp.Size = UDim2.new(0, 16, 0, 16)
radiusUp.Position = UDim2.new(0, isMobile and 228 or 298, 0, 4)
radiusUp.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
radiusUp.Text = "+"
radiusUp.TextColor3 = Color3.new(0, 0, 0)
radiusUp.TextSize = 11
radiusUp.Font = Enum.Font.SourceSansBold
radiusUp.BorderSizePixel = 0
radiusUp.Parent = topBar

local scrollItems = Instance.new("ScrollingFrame")
scrollItems.Size = UDim2.new(0, isMobile and 330 or 420, 0, isMobile and 255 or 295)
scrollItems.Position = UDim2.new(0, 0, 0, 27)
scrollItems.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
scrollItems.BackgroundTransparency = 0.5
scrollItems.BorderSizePixel = 0
scrollItems.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollItems.ScrollBarThickness = isMobile and 2 or 4
scrollItems.Parent = content1

-- TAB 2: AUTO
local content3 = Instance.new("Frame")
content3.Size = UDim2.new(0, isMobile and 330 or 420, 0, contentHeight)
content3.Position = UDim2.new(0, 5, 0, contentY)
content3.BackgroundTransparency = 1
content3.Visible = false
content3.Parent = mainFrame

local autoLabel = Instance.new("TextLabel")
autoLabel.Size = UDim2.new(0, isMobile and 330 or 420, 0, 18)
autoLabel.Position = UDim2.new(0, 0, 0, 0)
autoLabel.BackgroundTransparency = 1
autoLabel.Text = "🤖 AUTO"
autoLabel.TextColor3 = Color3.new(1, 1, 1)
autoLabel.TextSize = isMobile and 12 or 14
autoLabel.Font = Enum.Font.SourceSansBold
autoLabel.Parent = content3

local inputFrame = Instance.new("Frame")
inputFrame.Size = UDim2.new(0, isMobile and 330 or 420, 0, 26)
inputFrame.Position = UDim2.new(0, 0, 0, 20)
inputFrame.BackgroundTransparency = 1
inputFrame.Parent = content3

local autoTextBox = Instance.new("TextBox")
autoTextBox.Size = UDim2.new(0, isMobile and 180 or 240, 0, 22)
autoTextBox.Position = UDim2.new(0, 0, 0, 2)
autoTextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
autoTextBox.Text = "Nhập tên..."
autoTextBox.TextColor3 = Color3.new(1, 1, 1)
autoTextBox.TextSize = isMobile and 10 or 12
autoTextBox.Font = Enum.Font.SourceSans
autoTextBox.BorderSizePixel = 0
autoTextBox.Parent = inputFrame

local saveItemBtn = Instance.new("TextButton")
saveItemBtn.Size = UDim2.new(0, isMobile and 35 or 45, 0, 22)
saveItemBtn.Position = UDim2.new(0, isMobile and 185 or 250, 0, 2)
saveItemBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
saveItemBtn.Text = "💾"
saveItemBtn.TextColor3 = Color3.new(1, 1, 1)
saveItemBtn.TextSize = isMobile and 12 or 14
saveItemBtn.Font = Enum.Font.SourceSansBold
saveItemBtn.BorderSizePixel = 0
saveItemBtn.Parent = inputFrame

local controlFrame = Instance.new("Frame")
controlFrame.Size = UDim2.new(0, isMobile and 330 or 420, 0, 26)
controlFrame.Position = UDim2.new(0, 0, 0, 50)
controlFrame.BackgroundTransparency = 1
controlFrame.Parent = content3

local delayLabel = Instance.new("TextLabel")
delayLabel.Size = UDim2.new(0, 30, 0, 22)
delayLabel.Position = UDim2.new(0, 0, 0, 2)
delayLabel.BackgroundTransparency = 1
delayLabel.Text = "⏱"
delayLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
delayLabel.TextSize = isMobile and 12 or 14
delayLabel.Font = Enum.Font.SourceSansBold
delayLabel.Parent = controlFrame

local delayDown = Instance.new("TextButton")
delayDown.Size = UDim2.new(0, 16, 0, 18)
delayDown.Position = UDim2.new(0, 30, 0, 4)
delayDown.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
delayDown.Text = "−"
delayDown.TextColor3 = Color3.new(1, 1, 1)
delayDown.TextSize = 11
delayDown.Font = Enum.Font.SourceSansBold
delayDown.BorderSizePixel = 0
delayDown.Parent = controlFrame

local delayDisplay = Instance.new("TextLabel")
delayDisplay.Size = UDim2.new(0, 22, 0, 18)
delayDisplay.Position = UDim2.new(0, 50, 0, 4)
delayDisplay.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
delayDisplay.Text = "1.0"
delayDisplay.TextColor3 = Color3.new(1, 1, 1)
delayDisplay.TextSize = isMobile and 8 or 10
delayDisplay.Font = Enum.Font.SourceSansBold
delayDisplay.BorderSizePixel = 0
delayDisplay.Parent = controlFrame

local delayUp = Instance.new("TextButton")
delayUp.Size = UDim2.new(0, 16, 0, 18)
delayUp.Position = UDim2.new(0, 76, 0, 4)
delayUp.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
delayUp.Text = "+"
delayUp.TextColor3 = Color3.new(0, 0, 0)
delayUp.TextSize = 11
delayUp.Font = Enum.Font.SourceSansBold
delayUp.BorderSizePixel = 0
delayUp.Parent = controlFrame

local delay2Label = Instance.new("TextLabel")
delay2Label.Size = UDim2.new(0, 30, 0, 22)
delay2Label.Position = UDim2.new(0, 100, 0, 2)
delay2Label.BackgroundTransparency = 1
delay2Label.Text = "⏳"
delay2Label.TextColor3 = Color3.fromRGB(200, 200, 200)
delay2Label.TextSize = isMobile and 12 or 14
delay2Label.Font = Enum.Font.SourceSansBold
delay2Label.Parent = controlFrame

local delay2Down = Instance.new("TextButton")
delay2Down.Size = UDim2.new(0, 16, 0, 18)
delay2Down.Position = UDim2.new(0, 130, 0, 4)
delay2Down.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
delay2Down.Text = "−"
delay2Down.TextColor3 = Color3.new(1, 1, 1)
delay2Down.TextSize = 11
delay2Down.Font = Enum.Font.SourceSansBold
delay2Down.BorderSizePixel = 0
delay2Down.Parent = controlFrame

local delay2Display = Instance.new("TextLabel")
delay2Display.Size = UDim2.new(0, 22, 0, 18)
delay2Display.Position = UDim2.new(0, 150, 0, 4)
delay2Display.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
delay2Display.Text = "0.5"
delay2Display.TextColor3 = Color3.new(1, 1, 1)
delay2Display.TextSize = isMobile and 8 or 10
delay2Display.Font = Enum.Font.SourceSansBold
delay2Display.BorderSizePixel = 0
delay2Display.Parent = controlFrame

local delay2Up = Instance.new("TextButton")
delay2Up.Size = UDim2.new(0, 16, 0, 18)
delay2Up.Position = UDim2.new(0, 176, 0, 4)
delay2Up.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
delay2Up.Text = "+"
delay2Up.TextColor3 = Color3.new(0, 0, 0)
delay2Up.TextSize = 11
delay2Up.Font = Enum.Font.SourceSansBold
delay2Up.BorderSizePixel = 0
delay2Up.Parent = controlFrame

local allBtn = Instance.new("TextButton")
allBtn.Size = UDim2.new(0, isMobile and 60 or 80, 0, 22)
allBtn.Position = UDim2.new(0, isMobile and 260 or 330, 0, 2)
allBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
allBtn.Text = "▶ Tất cả"
allBtn.TextColor3 = Color3.new(0, 0, 0)
allBtn.TextSize = isMobile and 9 or 11
allBtn.Font = Enum.Font.SourceSansBold
allBtn.BorderSizePixel = 0
allBtn.Parent = controlFrame

local cornerAll = Instance.new("UICorner")
cornerAll.CornerRadius = UDim.new(0, 4)
cornerAll.Parent = allBtn

local stopAllBtn = Instance.new("TextButton")
stopAllBtn.Size = UDim2.new(0, isMobile and 60 or 80, 0, 22)
stopAllBtn.Position = UDim2.new(0, isMobile and 260 or 330, 0, 2)
stopAllBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
stopAllBtn.Text = "⏹ Dừng"
stopAllBtn.TextColor3 = Color3.new(1, 1, 1)
stopAllBtn.TextSize = isMobile and 9 or 11
stopAllBtn.Font = Enum.Font.SourceSansBold
stopAllBtn.BorderSizePixel = 0
stopAllBtn.Visible = false
stopAllBtn.Parent = controlFrame

local cornerStopAll = Instance.new("UICorner")
cornerStopAll.CornerRadius = UDim.new(0, 4)
cornerStopAll.Parent = stopAllBtn

-- DANH SÁCH AUTO
local savedLabel = Instance.new("TextLabel")
savedLabel.Size = UDim2.new(0, isMobile and 330 or 420, 0, 16)
savedLabel.Position = UDim2.new(0, 5, 0, 80)
savedLabel.BackgroundTransparency = 1
savedLabel.Text = "📋 ĐÃ LƯU (" .. #savedItems .. ")"
savedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
savedLabel.TextSize = isMobile and 9 or 11
savedLabel.Font = Enum.Font.SourceSansBold
savedLabel.TextXAlignment = Enum.TextXAlignment.Left
savedLabel.Parent = content3

local savedScroll = Instance.new("ScrollingFrame")
savedScroll.Size = UDim2.new(0, isMobile and 330 or 420, 0, isMobile and 170 or 200)
savedScroll.Position = UDim2.new(0, 0, 0, 98)
savedScroll.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
savedScroll.BackgroundTransparency = 0.5
savedScroll.BorderSizePixel = 0
savedScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
savedScroll.ScrollBarThickness = isMobile and 2 or 4
savedScroll.Parent = content3

local clearListBtn = Instance.new("TextButton")
clearListBtn.Size = UDim2.new(0, isMobile and 50 or 70, 0, 16)
clearListBtn.Position = UDim2.new(0, isMobile and 275 or 350, 0, 80)
clearListBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
clearListBtn.Text = "🗑 Xóa hết"
clearListBtn.TextColor3 = Color3.new(1, 1, 1)
clearListBtn.TextSize = isMobile and 8 or 10
clearListBtn.Font = Enum.Font.SourceSansBold
clearListBtn.BorderSizePixel = 0
clearListBtn.Parent = content3

local statusFrame = Instance.new("Frame")
statusFrame.Size = UDim2.new(0, isMobile and 330 or 420, 0, 26)
statusFrame.Position = UDim2.new(0, 0, 0, isMobile and 275 or 305)
statusFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
statusFrame.Parent = content3

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0, isMobile and 330 or 420, 0, 26)
statusLabel.Position = UDim2.new(0, 0, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "⏸ ĐANG DỪNG"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextSize = isMobile and 10 or 12
statusLabel.Font = Enum.Font.SourceSansBold
statusLabel.Parent = statusFrame

local saveInfo = Instance.new("TextLabel")
saveInfo.Size = UDim2.new(0, isMobile and 330 or 420, 0, 12)
saveInfo.Position = UDim2.new(0, 5, 0, isMobile and 306 or 336)
saveInfo.BackgroundTransparency = 1
saveInfo.Text = "💾 " .. saveMethod
saveInfo.TextColor3 = Color3.fromRGB(150, 150, 200)
saveInfo.TextSize = isMobile and 7 or 9
saveInfo.Font = Enum.Font.SourceSans
saveInfo.TextXAlignment = Enum.TextXAlignment.Left
saveInfo.Parent = content3

-- ==========================================
-- CHUYỂN TAB
-- ==========================================
local function switchTab(tab)
    content1.Visible = (tab == 1)
    content3.Visible = (tab == 2)
    tab1.BackgroundColor3 = (tab == 1) and Color3.fromRGB(50, 150, 255) or Color3.fromRGB(40, 40, 60)
    tab3.BackgroundColor3 = (tab == 2) and Color3.fromRGB(50, 150, 255) or Color3.fromRGB(40, 40, 60)
end

tab1.MouseButton1Click:Connect(function() switchTab(1) end)
tab3.MouseButton1Click:Connect(function() switchTab(2) end)

-- ==========================================
-- LOGIC QUÉT
-- ==========================================
local scanRadius = 50
local allItems = {}
local bodyParts = {
    "head","uppertorso","lowertorso","upperarm","lowerarm","hand","arm","leg","foot","torso","neck","root",
    "humanoidrootpart","left","right","attach","joint","body","limb","bones","skeleton","spine","hip","chest"
}

function scanNearby()
    for _, child in ipairs(scrollItems:GetChildren()) do child:Destroy() end
    local char = player.Character
    if not char then infoLabel.Text = "❌ Chưa có nhân vật!" return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then infoLabel.Text = "❌ Không tìm thấy nhân vật!" return end
    
    allItems = {}
    local center = hrp.Position
    local count = 0
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        if count > 300 then break end
        if obj:IsA("Model") or obj:IsA("BasePart") then
            if obj == char or obj:IsDescendantOf(char) or obj:FindFirstChild("Humanoid") or obj:FindFirstChild("HumanoidRootPart") then continue end
            local name = obj.Name or ""
            local lowerName = name:lower()
            local isBody = false
            for _, part in ipairs(bodyParts) do
                if lowerName == part or lowerName:find(part) then isBody = true break end
            end
            if isBody then continue end
            local success, pos = pcall(function()
                if obj:IsA("Model") then return obj:GetPivot().Position else return obj.Position end
            end)
            if success and pos then
                local dist = (pos - center).Magnitude
                if dist <= scanRadius then
                    local displayName = name
                    if obj:IsA("BasePart") and obj.Parent and obj.Parent:IsA("Model") then displayName = obj.Parent.Name end
                    if displayName ~= "" and displayName ~= "Workspace" and displayName ~= "Terrain" then
                        local isDuplicate = false
                        for _, existing in ipairs(allItems) do
                            if existing.name:lower() == displayName:lower() then isDuplicate = true break end
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
        emptyLabel.Size = UDim2.new(0, isMobile and 310 or 400, 0, 25)
        emptyLabel.Position = UDim2.new(0, 10, 0, 10)
        emptyLabel.BackgroundTransparency = 1
        emptyLabel.Text = "❌ Không tìm thấy vật phẩm!"
        emptyLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        emptyLabel.TextSize = isMobile and 10 or 12
        emptyLabel.Font = Enum.Font.SourceSans
        emptyLabel.Parent = scrollItems
        scrollItems.CanvasSize = UDim2.new(0, 0, 0, 50)
        infoLabel.Text = "📡 " .. scanRadius .. "u | 0"
        return
    end
    
    infoLabel.Text = "📡 " .. scanRadius .. "u | " .. #allItems
    
    local yPos = 0
    for i, data in ipairs(allItems) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, isMobile and 250 or 320, 0, isMobile and 20 or 24)
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
                    if target:IsA("Model") then return target:GetPivot().Position else return target.Position end
                end)
                if success and pos then hrp.CFrame = CFrame.new(pos.X, pos.Y + 3, pos.Z) end
            end
        end)
        
        -- Nút Add (dùng hàm addItemToSaved)
        local addBtn = Instance.new("TextButton")
        addBtn.Size = UDim2.new(0, isMobile and 30 or 40, 0, isMobile and 16 or 20)
        addBtn.Position = UDim2.new(0, isMobile and 285 or 365, 0, 2)
        addBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        addBtn.Text = "➕"
        addBtn.TextColor3 = Color3.new(1, 1, 1)
        addBtn.TextSize = isMobile and 9 or 11
        addBtn.Font = Enum.Font.SourceSansBold
        addBtn.BorderSizePixel = 0
        addBtn.Parent = btn
        addBtn.MouseButton1Click:Connect(function()
            if addItemToSaved(data.name) then
                statusLabel.Text = "✅ Đã thêm: " .. data.name
                statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            else
                statusLabel.Text = "⚠️ Đã có: " .. data.name
                statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
            end
        end)
        
        yPos = yPos + (isMobile and 24 or 28)
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
-- TELEPORT
-- ==========================================
local teleportCache = {}
local cacheTime = 5

function teleportToItem(itemName)
    local char = player.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    local now = tick()
    if teleportCache[itemName] and (now - teleportCache[itemName].time) < cacheTime then
        local pos = teleportCache[itemName].pos
        hrp.CFrame = CFrame.new(pos.X, pos.Y + 3, pos.Z)
        return true
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
                        if obj:IsA("Model") then return obj:GetPivot().Position else return obj.Position end
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
    
    if not found then return false end
    
    local success, pos = pcall(function()
        if found:IsA("Model") then return found:GetPivot().Position else return found.Position end
    end)
    
    if success and pos then
        teleportCache[itemName] = {pos = pos, time = tick()}
        hrp.CFrame = CFrame.new(pos.X, pos.Y + 3, pos.Z)
        return true
    end
    return false
end

-- ==========================================
-- QUẢN LÝ DANH SÁCH AUTO (DÙNG HÀM MỚI)
-- ==========================================
local allRunning = false
local allCoroutines = {}

function updateSavedList()
    for _, child in ipairs(savedScroll:GetChildren()) do child:Destroy() end
    savedLabel.Text = "📋 ĐÃ LƯU (" .. #savedItems .. ")"
    
    if #savedItems == 0 then
        local emptyLabel = Instance.new("TextLabel")
        emptyLabel.Size = UDim2.new(0, isMobile and 310 or 400, 0, 25)
        emptyLabel.Position = UDim2.new(0, 10, 0, 10)
        emptyLabel.BackgroundTransparency = 1
        emptyLabel.Text = "📭 Chưa có vật phẩm"
        emptyLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        emptyLabel.TextSize = isMobile and 10 or 12
        emptyLabel.Font = Enum.Font.SourceSans
        emptyLabel.Parent = savedScroll
        savedScroll.CanvasSize = UDim2.new(0, 0, 0, 50)
        return
    end
    
    local yPos = 0
    for i, itemName in ipairs(savedItems) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, isMobile and 310 or 400, 0, isMobile and 22 or 26)
        btn.Position = UDim2.new(0, 10, 0, yPos)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
        btn.Text = i .. ". " .. itemName
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.TextSize = isMobile and 9 or 11
        btn.Font = Enum.Font.SourceSans
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.BorderSizePixel = 0
        btn.Parent = savedScroll
        
        local isRunning = itemLoopStates[itemName] or false
        local runBtn = Instance.new("TextButton")
        runBtn.Size = UDim2.new(0, isMobile and 30 or 40, 0, isMobile and 16 or 20)
        runBtn.Position = UDim2.new(0, isMobile and 235 or 305, 0, 3)
        runBtn.BackgroundColor3 = isRunning and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(50, 200, 100)
        runBtn.Text = isRunning and "⏹" or "▶"
        runBtn.TextColor3 = Color3.new(1, 1, 1)
        runBtn.TextSize = isMobile and 9 or 11
        runBtn.Font = Enum.Font.SourceSansBold
        runBtn.BorderSizePixel = 0
        runBtn.Parent = btn
        
        -- Nút Xóa (dùng hàm removeItemFromSaved)
        local delBtn = Instance.new("TextButton")
        delBtn.Size = UDim2.new(0, isMobile and 22 or 28, 0, isMobile and 16 or 20)
        delBtn.Position = UDim2.new(0, isMobile and 270 or 350, 0, 3)
        delBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        delBtn.Text = "✖"
        delBtn.TextColor3 = Color3.new(1, 1, 1)
        delBtn.TextSize = isMobile and 9 or 11
        delBtn.Font = Enum.Font.SourceSansBold
        delBtn.BorderSizePixel = 0
        delBtn.Parent = btn
        
        local itemCoroutine = nil
        runBtn.MouseButton1Click:Connect(function()
            if itemLoopStates[itemName] then
                itemLoopStates[itemName] = false
                if itemCoroutine then coroutine.close(itemCoroutine); itemCoroutine = nil end
                runBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
                runBtn.Text = "▶"
                statusLabel.Text = "⏸ Dừng: " .. itemName
                statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
                return
            end
            
            itemLoopStates[itemName] = true
            runBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            runBtn.Text = "⏹"
            statusLabel.Text = "🔄 Đang chạy: " .. itemName
            statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            
            local delay = tonumber(delayDisplay.Text) or 1.0
            itemCoroutine = coroutine.create(function()
                while itemLoopStates[itemName] do
                    if not teleportToItem(itemName) then
                        task.wait(delay * 2)
                    else
                        task.wait(delay)
                    end
                end
                if not itemLoopStates[itemName] then
                    runBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
                    runBtn.Text = "▶"
                end
            end)
            coroutine.resume(itemCoroutine)
        end)
        
        -- Xóa item (dùng hàm removeItemFromSaved)
        delBtn.MouseButton1Click:Connect(function()
            if itemLoopStates[itemName] then itemLoopStates[itemName] = false end
            if removeItemFromSaved(i) then
                statusLabel.Text = "🗑 Đã xóa: " .. itemName
                statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
                -- updateSavedList đã được gọi trong removeItemFromSaved
            end
        end)
        
        yPos = yPos + (isMobile and 26 or 30)
    end
    savedScroll.CanvasSize = UDim2.new(0, 0, 0, yPos + 10)
end

-- ==========================================
-- CHẠY TẤT CẢ
-- ==========================================
function toggleAll()
    if allRunning then
        allRunning = false
        for _, name in ipairs(savedItems) do
            itemLoopStates[name] = false
        end
        for _, cor in ipairs(allCoroutines) do
            if cor then coroutine.close(cor) end
        end
        allCoroutines = {}
        allBtn.Text = "▶ Tất cả"
        allBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
        stopAllBtn.Visible = false
        allBtn.Visible = true
        statusLabel.Text = "⏸ Đã dừng tất cả"
        statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        updateSavedList()
        return
    end
    
    if #savedItems == 0 then
        statusLabel.Text = "⚠️ Danh sách trống!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
        return
    end
    
    allRunning = true
    allBtn.Text = "⏹ Đang chạy..."
    allBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    stopAllBtn.Visible = true
    allBtn.Visible = false
    statusLabel.Text = "🔄 Đang chạy tất cả..."
    statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    
    local delay1 = tonumber(delayDisplay.Text) or 1.0
    local delay2 = tonumber(delay2Display.Text) or 0.5
    allCoroutines = {}
    
    for _, name in ipairs(savedItems) do
        itemLoopStates[name] = true
        local cor = coroutine.create(function()
            while itemLoopStates[name] and allRunning do
                if not teleportToItem(name) then
                    task.wait(delay1 * 2)
                else
                    task.wait(delay1)
                end
            end
        end)
        table.insert(allCoroutines, cor)
        coroutine.resume(cor)
        task.wait(delay2)
    end
    
    updateSavedList()
end

allBtn.MouseButton1Click:Connect(toggleAll)
stopAllBtn.MouseButton1Click:Connect(toggleAll)

-- ==========================================
-- LƯU VÀ XÓA
-- ==========================================
saveItemBtn.MouseButton1Click:Connect(function()
    local name = autoTextBox.Text
    if name == "" or name == "Nhập tên..." then
        statusLabel.Text = "⚠️ Nhập tên vật phẩm!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
        return
    end
    if addItemToSaved(name) then
        statusLabel.Text = "✅ Đã lưu: " .. name
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        statusLabel.Text = "⚠️ Đã có: " .. name
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    end
end)

clearListBtn.MouseButton1Click:Connect(function()
    if #savedItems == 0 then
        statusLabel.Text = "📭 Danh sách trống!"
        statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        return
    end
    for _, name in ipairs(savedItems) do
        itemLoopStates[name] = false
    end
    allRunning = false
    savedItems = {}
    saveToMemory()
    updateSavedList()
    statusLabel.Text = "🗑 Đã xóa toàn bộ!"
    statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
end)

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

delay2Down.MouseButton1Click:Connect(function()
    local val = tonumber(delay2Display.Text) or 0.5
    val = math.max(0.1, val - 0.2)
    delay2Display.Text = string.format("%.1f", val)
end)

delay2Up.MouseButton1Click:Connect(function()
    local val = tonumber(delay2Display.Text) or 0.5
    val = math.min(3.0, val + 0.2)
    delay2Display.Text = string.format("%.1f", val)
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
print("✅ TOOL ĐÃ SẴN SÀNG")
print("💾 Phương thức lưu: " .. saveMethod)
if hasWriteFile then
    print("📂 File: saved_items.txt")
end
print("========================================")