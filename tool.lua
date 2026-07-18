-- ==========================================
-- TOOL ALL-IN-ONE - BẢN GỌN CHO ĐIỆN THOẠI
-- ==========================================

local player = game.Players.LocalPlayer
local userInput = game:GetService("UserInputService")
local isMobile = userInput.TouchEnabled

-- ==========================================
-- TẠO GUI (TỐI ƯU CHO ĐIỆN THOẠI)
-- ==========================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AllInOne"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999
screenGui.Parent = player.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, isMobile and 340 or 480, 0, isMobile and 420 or 560)
mainFrame.Position = UDim2.new(0, 5, 0.05, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- ==========================================
-- NÚT ẨN/HIỆN
-- ==========================================
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, isMobile and 50 or 80, 0, isMobile and 25 or 30)
toggleBtn.Position = UDim2.new(0, isMobile and 290 or 400, 0, 5)
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
toggleBtn.Text = "🔽"
toggleBtn.TextColor3 = Color3.new(0, 0, 0)
toggleBtn.TextSize = isMobile and 12 or 16
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.BorderSizePixel = 0
toggleBtn.Parent = screenGui

local cornerToggle = Instance.new("UICorner")
cornerToggle.CornerRadius = UDim.new(0, 8)
cornerToggle.Parent = toggleBtn

local isHidden = false
toggleBtn.MouseButton1Click:Connect(function()
    isHidden = not isHidden
    mainFrame.Visible = not isHidden
    toggleBtn.Text = isHidden and "🔼" or "🔽"
end)

-- ==========================================
-- TAB DẠNG DROPDOWN
-- ==========================================
local tabNames = {"📦 Vật Phẩm", "🚀 Dịch Chuyển", "🤖 Auto"}
local currentTab = 1

local dropdownFrame = Instance.new("Frame")
dropdownFrame.Size = UDim2.new(0, isMobile and 330 or 460, 0, 32)
dropdownFrame.Position = UDim2.new(0, 5, 0, 5)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
dropdownFrame.BorderSizePixel = 0
dropdownFrame.Parent = mainFrame

local cornerDF = Instance.new("UICorner")
cornerDF.CornerRadius = UDim.new(0, 6)
cornerDF.Parent = dropdownFrame

local dropdownBtn = Instance.new("TextButton")
dropdownBtn.Size = UDim2.new(0, isMobile and 330 or 460, 0, 32)
dropdownBtn.Position = UDim2.new(0, 0, 0, 0)
dropdownBtn.BackgroundTransparency = 1
dropdownBtn.Text = "📦 Vật Phẩm"
dropdownBtn.TextColor3 = Color3.new(1, 1, 1)
dropdownBtn.TextSize = isMobile and 14 or 16
dropdownBtn.Font = Enum.Font.SourceSansBold
dropdownBtn.TextXAlignment = Enum.TextXAlignment.Left
dropdownBtn.BorderSizePixel = 0
dropdownBtn.Parent = dropdownFrame

local dropdownList = Instance.new("ScrollingFrame")
dropdownList.Size = UDim2.new(0, isMobile and 330 or 460, 0, 100)
dropdownList.Position = UDim2.new(0, 0, 0, 32)
dropdownList.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
dropdownList.BorderSizePixel = 0
dropdownList.Visible = false
dropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
dropdownList.ScrollBarThickness = 3
dropdownList.Parent = dropdownFrame

local cornerDL = Instance.new("UICorner")
cornerDL.CornerRadius = UDim.new(0, 6)
cornerDL.Parent = dropdownList

-- Tạo content frames
local contentFrames = {}
for i = 1, 3 do
    local content = Instance.new("Frame")
    content.Size = UDim2.new(0, isMobile and 330 or 460, 0, isMobile and 340 or 460)
    content.Position = UDim2.new(0, 5, 0, 42)
    content.BackgroundTransparency = 1
    content.Visible = (i == 1)
    content.Parent = mainFrame
    contentFrames[i] = content
end

local contentItems = contentFrames[1]
local contentTeleport = contentFrames[2]
local contentAuto = contentFrames[3]

-- Hàm build dropdown
local function buildDropdown()
    for _, child in ipairs(dropdownList:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    local y = 0
    for i, name in ipairs(tabNames) do
        local item = Instance.new("TextButton")
        item.Size = UDim2.new(0, isMobile and 330 or 460, 0, 28)
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
            dropdownList.Visible = false
            for j, frame in ipairs(contentFrames) do
                frame.Visible = (j == i)
            end
            buildDropdown()
        end)
        y = y + 30
    end
    dropdownList.CanvasSize = UDim2.new(0, 0, 0, y)
end

dropdownBtn.MouseButton1Click:Connect(function()
    dropdownList.Visible = not dropdownList.Visible
    if dropdownList.Visible then buildDropdown() end
end)

-- ==========================================
-- TAB 1: VẬT PHẨM
-- ==========================================
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(0, isMobile and 330 or 460, 0, 22)
infoLabel.Position = UDim2.new(0, 0, 0, 0)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "📡 50 unit | 0 vật phẩm"
infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
infoLabel.TextSize = isMobile and 11 or 13
infoLabel.Font = Enum.Font.SourceSans
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.Parent = contentItems

local scrollItems = Instance.new("ScrollingFrame")
scrollItems.Size = UDim2.new(0, isMobile and 330 or 460, 0, isMobile and 240 or 360)
scrollItems.Position = UDim2.new(0, 0, 0, 25)
scrollItems.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
scrollItems.BackgroundTransparency = 0.5
scrollItems.BorderSizePixel = 0
scrollItems.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollItems.ScrollBarThickness = isMobile and 2 or 5
scrollItems.Parent = contentItems

local controlFrame = Instance.new("Frame")
controlFrame.Size = UDim2.new(0, isMobile and 330 or 460, 0, 32)
controlFrame.Position = UDim2.new(0, 0, 0, isMobile and 270 or 390)
controlFrame.BackgroundTransparency = 1
controlFrame.Parent = contentItems

local refreshBtn = Instance.new("TextButton")
refreshBtn.Size = UDim2.new(0, 50, 0, 26)
refreshBtn.Position = UDim2.new(0, 0, 0, 3)
refreshBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
refreshBtn.Text = "🔄"
refreshBtn.TextColor3 = Color3.new(1, 1, 1)
refreshBtn.TextSize = isMobile and 14 or 16
refreshBtn.Font = Enum.Font.SourceSansBold
refreshBtn.BorderSizePixel = 0
refreshBtn.Parent = controlFrame

local radiusDown = Instance.new("TextButton")
radiusDown.Size = UDim2.new(0, 22, 0, 26)
radiusDown.Position = UDim2.new(0, 55, 0, 3)
radiusDown.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
radiusDown.Text = "−"
radiusDown.TextColor3 = Color3.new(1, 1, 1)
radiusDown.TextSize = 16
radiusDown.Font = Enum.Font.SourceSansBold
radiusDown.BorderSizePixel = 0
radiusDown.Parent = controlFrame

local radiusDisplay = Instance.new("TextLabel")
radiusDisplay.Size = UDim2.new(0, 28, 0, 26)
radiusDisplay.Position = UDim2.new(0, 80, 0, 3)
radiusDisplay.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
radiusDisplay.Text = "50"
radiusDisplay.TextColor3 = Color3.new(1, 1, 1)
radiusDisplay.TextSize = isMobile and 12 or 14
radiusDisplay.Font = Enum.Font.SourceSansBold
radiusDisplay.BorderSizePixel = 0
radiusDisplay.Parent = controlFrame

local radiusUp = Instance.new("TextButton")
radiusUp.Size = UDim2.new(0, 22, 0, 26)
radiusUp.Position = UDim2.new(0, 112, 0, 3)
radiusUp.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
radiusUp.Text = "+"
radiusUp.TextColor3 = Color3.new(0, 0, 0)
radiusUp.TextSize = 16
radiusUp.Font = Enum.Font.SourceSansBold
radiusUp.BorderSizePixel = 0
radiusUp.Parent = controlFrame

local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(0, 40, 0, 26)
clearBtn.Position = UDim2.new(0, isMobile and 290 or 420, 0, 3)
clearBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
clearBtn.Text = "🗑"
clearBtn.TextColor3 = Color3.new(1, 1, 1)
clearBtn.TextSize = isMobile and 14 or 16
clearBtn.Font = Enum.Font.SourceSansBold
clearBtn.BorderSizePixel = 0
clearBtn.Parent = controlFrame

-- ==========================================
-- TAB 2: DỊCH CHUYỂN TẦNG
-- ==========================================
local floorLabel = Instance.new("TextLabel")
floorLabel.Size = UDim2.new(0, isMobile and 330 or 460, 0, 35)
floorLabel.Position = UDim2.new(0, 0, 0, 5)
floorLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
floorLabel.Text = "📍 Tầng: 0"
floorLabel.TextColor3 = Color3.new(1, 1, 1)
floorLabel.TextSize = isMobile and 16 or 18
floorLabel.Font = Enum.Font.SourceSansBold
floorLabel.Parent = contentTeleport

local upBtn = Instance.new("TextButton")
upBtn.Size = UDim2.new(0, isMobile and 150 or 200, 0, isMobile and 45 or 55)
upBtn.Position = UDim2.new(0, 10, 0, 50)
upBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
upBtn.Text = "⬆ LÊN"
upBtn.TextColor3 = Color3.new(1, 1, 1)
upBtn.TextSize = isMobile and 16 or 18
upBtn.Font = Enum.Font.SourceSansBold
upBtn.BorderSizePixel = 0
upBtn.Parent = contentTeleport

local downBtn = Instance.new("TextButton")
downBtn.Size = UDim2.new(0, isMobile and 150 or 200, 0, isMobile and 45 or 55)
downBtn.Position = UDim2.new(0, isMobile and 170 or 250, 0, 50)
downBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
downBtn.Text = "⬇ XUỐNG"
downBtn.TextColor3 = Color3.new(1, 1, 1)
downBtn.TextSize = isMobile and 16 or 18
downBtn.Font = Enum.Font.SourceSansBold
downBtn.BorderSizePixel = 0
downBtn.Parent = contentTeleport

local floorInput = Instance.new("TextBox")
floorInput.Size = UDim2.new(0, isMobile and 150 or 200, 0, 30)
floorInput.Position = UDim2.new(0, 10, 0, 110)
floorInput.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
floorInput.Text = "Tầng..."
floorInput.TextColor3 = Color3.new(1, 1, 1)
floorInput.TextSize = isMobile and 13 or 15
floorInput.Font = Enum.Font.SourceSans
floorInput.BorderSizePixel = 0
floorInput.Parent = contentTeleport

local goFloorBtn = Instance.new("TextButton")
goFloorBtn.Size = UDim2.new(0, 60, 0, 30)
goFloorBtn.Position = UDim2.new(0, isMobile and 170 or 220, 0, 110)
goFloorBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
goFloorBtn.Text = "Đến"
goFloorBtn.TextColor3 = Color3.new(0, 0, 0)
goFloorBtn.TextSize = isMobile and 13 or 15
goFloorBtn.Font = Enum.Font.SourceSansBold
goFloorBtn.BorderSizePixel = 0
goFloorBtn.Parent = contentTeleport

-- ==========================================
-- TAB 3: AUTO
-- ==========================================
local autoLabel = Instance.new("TextLabel")
autoLabel.Size = UDim2.new(0, isMobile and 330 or 460, 0, 25)
autoLabel.Position = UDim2.new(0, 0, 0, 5)
autoLabel.BackgroundTransparency = 1
autoLabel.Text = "🤖 Tìm đến vật phẩm"
autoLabel.TextColor3 = Color3.new(1, 1, 1)
autoLabel.TextSize = isMobile and 14 or 16
autoLabel.Font = Enum.Font.SourceSansBold
autoLabel.Parent = contentAuto

local autoTextBox = Instance.new("TextBox")
autoTextBox.Size = UDim2.new(0, isMobile and 200 or 280, 0, 30)
autoTextBox.Position = UDim2.new(0, 10, 0, 40)
autoTextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
autoTextBox.Text = "Nhập tên vật phẩm..."
autoTextBox.TextColor3 = Color3.new(1, 1, 1)
autoTextBox.TextSize = isMobile and 13 or 15
autoTextBox.Font = Enum.Font.SourceSans
autoTextBox.BorderSizePixel = 0
autoTextBox.Parent = contentAuto

local autoToggleBtn = Instance.new("TextButton")
autoToggleBtn.Size = UDim2.new(0, 80, 0, 30)
autoToggleBtn.Position = UDim2.new(0, isMobile and 220 or 300, 0, 40)
autoToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
autoToggleBtn.Text = "▶ BẬT"
autoToggleBtn.TextColor3 = Color3.new(1, 1, 1)
autoToggleBtn.TextSize = isMobile and 13 or 15
autoToggleBtn.Font = Enum.Font.SourceSansBold
autoToggleBtn.BorderSizePixel = 0
autoToggleBtn.Parent = contentAuto

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0, isMobile and 330 or 460, 0, 40)
statusLabel.Position = UDim2.new(0, 10, 0, 85)
statusLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
statusLabel.Text = "⏸ ĐANG DỪNG"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextSize = isMobile and 14 or 16
statusLabel.Font = Enum.Font.SourceSansBold
statusLabel.Parent = contentAuto

-- ==========================================
-- LOGIC CHÍNH
-- ==========================================
local scanRadius = 50
local currentFloor = 0
local homePosition = nil
local isAutoRunning = false
local autoCoroutine = nil

-- Hàm quét vật phẩm
function scanNearby()
    for _, child in ipairs(scrollItems:GetChildren()) do
        child:Destroy()
    end
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
        emptyLabel.Size = UDim2.new(0, isMobile and 310 or 440, 0, 30)
        emptyLabel.Position = UDim2.new(0, 10, 0, 10)
        emptyLabel.BackgroundTransparency = 1
        emptyLabel.Text = "❌ Không tìm thấy vật phẩm!"
        emptyLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        emptyLabel.TextSize = isMobile and 12 or 14
        emptyLabel.Font = Enum.Font.SourceSans
        emptyLabel.Parent = scrollItems
        scrollItems.CanvasSize = UDim2.new(0, 0, 0, 50)
        infoLabel.Text = "📡 " .. scanRadius .. " unit | 0 vật phẩm"
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
    infoLabel.Text = "📡 " .. scanRadius .. " unit | " .. #items .. " vật phẩm (" .. #uniqueItems .. " loại)"
    local yPos = 0
    for i, data in ipairs(uniqueItems) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, isMobile and 310 or 440, 0, isMobile and 26 or 30)
        btn.Position = UDim2.new(0, 10, 0, yPos)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
        btn.Text = i .. ". " .. data.name .. " (📏" .. math.floor(data.dist) .. "s)"
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.TextSize = isMobile and 11 or 13
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
        copyBtn.Size = UDim2.new(0, 30, 0, isMobile and 20 or 24)
        copyBtn.Position = UDim2.new(0, isMobile and 280 or 400, 0, 3)
        copyBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
        copyBtn.Text = "📋"
        copyBtn.TextColor3 = Color3.new(0, 0, 0)
        copyBtn.TextSize = isMobile and 10 or 12
        copyBtn.Font = Enum.Font.SourceSansBold
        copyBtn.BorderSizePixel = 0
        copyBtn.Parent = btn
        copyBtn.MouseButton1Click:Connect(function()
            setclipboard(data.name)
            print("✅ Đã copy: " .. data.name)
        end)
        yPos = yPos + (isMobile and 30 or 35)
    end
    scrollItems.CanvasSize = UDim2.new(0, 0, 0, yPos + 10)
end

-- Hàm dịch chuyển tầng
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

-- Hàm Auto
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
    local target = autoTextBox.Text
    if target == "" or target == "Nhập tên vật phẩm..." then
        statusLabel.Text = "⚠️ Nhập tên vật phẩm!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
        return
    end
    isAutoRunning = true
    autoToggleBtn.Text = "⏹ DỪNG"
    autoToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    statusLabel.Text = "🔄 ĐANG TÌM: " .. target
    statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    autoCoroutine = coroutine.create(function()
        while isAutoRunning do
            local char = player.Character
            if char then
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
                                if name:find(target:lower()) or parentName:find(target:lower()) then
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
                            statusLabel.Text = "✅ ĐÃ TÌM THẤY!"
                            statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
                        end
                    else
                        statusLabel.Text = "🔍 TÌM: " .. target
                        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
                    end
                end
            end
            task.wait(2)
        end
    end)
    coroutine.resume(autoCoroutine)
end

-- ==========================================
-- GÁN SỰ KIỆN
-- ==========================================
refreshBtn.MouseButton1Click:Connect(scanNearby)

clearBtn.MouseButton1Click:Connect(function()
    for _, child in ipairs(scrollItems:GetChildren()) do
        child:Destroy()
    end
    infoLabel.Text = "📡 " .. scanRadius .. " unit | Đã xóa"
end)

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

upBtn.MouseButton1Click:Connect(function() moveFloor(1) end)
downBtn.MouseButton1Click:Connect(function() moveFloor(-1) end)

goFloorBtn.MouseButton1Click:Connect(function()
    local floor = tonumber(floorInput.Text)
    if floor then goToFloor(floor) else print("❌ Nhập số tầng!") end
end)

autoToggleBtn.MouseButton1Click:Connect(startAuto)

-- Phím tắt
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

print("========================================")
print("🛠 TOOL ALL-IN-ONE (BẢN GỌN)")
print("========================================")
print("📌 Hướng dẫn:")
print("📦 Tab Vật Phẩm: Quét và dịch chuyển")
print("🚀 Tab Dịch Chuyển: Lên/xuống tầng (30 unit)")
print("🤖 Tab Auto: Tự động tìm và dịch chuyển")
print("⌨️ Phím tắt: ↑ (lên), ↓ (xuống)")
print("========================================")
