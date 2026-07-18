-- ==========================================
-- TOOL ĐIỀU CHỈNH VỊ TRÍ UI
-- ==========================================

local player = game.Players.LocalPlayer
local userInput = game:GetService("UserInputService")
local isMobile = userInput.TouchEnabled

-- ==========================================
-- TẠO NÚT CHÍNH (Nút màu xanh để di chuyển)
-- ==========================================
local mainGui = Instance.new("ScreenGui")
mainGui.Name = "PositionTool"
mainGui.ResetOnSpawn = false
mainGui.DisplayOrder = 999
mainGui.Parent = player.PlayerGui

local testBtn = Instance.new("TextButton")
testBtn.Size = UDim2.new(0, 100, 0, 50)
testBtn.Position = UDim2.new(0.5, -50, 0.5, -25)  -- Giữa màn hình
testBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
testBtn.Text = "⬆ NÚT TEST ⬆"
testBtn.TextColor3 = Color3.new(1, 1, 1)
testBtn.TextSize = 16
testBtn.Font = Enum.Font.SourceSansBold
testBtn.BorderSizePixel = 0
testBtn.Parent = mainGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = testBtn

-- ==========================================
-- TẠO GUI ĐIỀU CHỈNH VỊ TRÍ
-- ==========================================
local controlGui = Instance.new("ScreenGui")
controlGui.Name = "ControlPanel"
controlGui.ResetOnSpawn = false
controlGui.DisplayOrder = 1000
controlGui.Parent = player.PlayerGui

local mainFrame = Instance.new("Frame")
if isMobile then
    mainFrame.Size = UDim2.new(0, 320, 0, 280)
    mainFrame.Position = UDim2.new(0, 10, 0.2, 0)
else
    mainFrame.Size = UDim2.new(0, 350, 0, 300)
    mainFrame.Position = UDim2.new(0, 10, 0.15, 0)
end
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Parent = controlGui

local cornerFrame = Instance.new("UICorner")
cornerFrame.CornerRadius = UDim.new(0, 12)
cornerFrame.Parent = mainFrame

-- Tiêu đề
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 330, 0, 30)
title.Position = UDim2.new(0, 10, 0, 5)
title.BackgroundTransparency = 1
title.Text = "🎯 ĐIỀU CHỈNH VỊ TRÍ"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 16
title.Font = Enum.Font.SourceSansBold
title.Parent = mainFrame

-- ==========================================
-- HÀNG 1: X_Scale
-- ==========================================
local row1 = Instance.new("Frame")
row1.Size = UDim2.new(0, 330, 0, 35)
row1.Position = UDim2.new(0, 10, 0, 40)
row1.BackgroundTransparency = 1
row1.Parent = mainFrame

local label1 = Instance.new("TextLabel")
label1.Size = UDim2.new(0, 60, 0, 30)
label1.Position = UDim2.new(0, 0, 0, 2)
label1.BackgroundTransparency = 1
label1.Text = "X_Scale:"
label1.TextColor3 = Color3.fromRGB(200, 200, 200)
label1.TextSize = 13
label1.Font = Enum.Font.SourceSans
label1.TextXAlignment = Enum.TextXAlignment.Left
label1.Parent = row1

local xScaleDown = Instance.new("TextButton")
xScaleDown.Size = UDim2.new(0, 25, 0, 28)
xScaleDown.Position = UDim2.new(0, 65, 0, 3)
xScaleDown.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
xScaleDown.Text = "−"
xScaleDown.TextColor3 = Color3.new(1, 1, 1)
xScaleDown.TextSize = 16
xScaleDown.Font = Enum.Font.SourceSansBold
xScaleDown.BorderSizePixel = 0
xScaleDown.Parent = row1

local xScaleDisplay = Instance.new("TextLabel")
xScaleDisplay.Size = UDim2.new(0, 40, 0, 28)
xScaleDisplay.Position = UDim2.new(0, 95, 0, 3)
xScaleDisplay.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
xScaleDisplay.Text = "0.50"
xScaleDisplay.TextColor3 = Color3.new(1, 1, 1)
xScaleDisplay.TextSize = 13
xScaleDisplay.Font = Enum.Font.SourceSansBold
xScaleDisplay.BorderSizePixel = 0
xScaleDisplay.Parent = row1

local xScaleUp = Instance.new("TextButton")
xScaleUp.Size = UDim2.new(0, 25, 0, 28)
xScaleUp.Position = UDim2.new(0, 140, 0, 3)
xScaleUp.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
xScaleUp.Text = "+"
xScaleUp.TextColor3 = Color3.new(0, 0, 0)
xScaleUp.TextSize = 16
xScaleUp.Font = Enum.Font.SourceSansBold
xScaleUp.BorderSizePixel = 0
xScaleUp.Parent = row1

local xScaleBox = Instance.new("TextBox")
xScaleBox.Size = UDim2.new(0, 80, 0, 28)
xScaleBox.Position = UDim2.new(0, 175, 0, 3)
xScaleBox.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
xScaleBox.Text = "0.5"
xScaleBox.TextColor3 = Color3.new(1, 1, 1)
xScaleBox.TextSize = 13
xScaleBox.Font = Enum.Font.SourceSans
xScaleBox.BorderSizePixel = 0
xScaleBox.Parent = row1

-- ==========================================
-- HÀNG 2: X_Offset
-- ==========================================
local row2 = Instance.new("Frame")
row2.Size = UDim2.new(0, 330, 0, 35)
row2.Position = UDim2.new(0, 10, 0, 80)
row2.BackgroundTransparency = 1
row2.Parent = mainFrame

local label2 = Instance.new("TextLabel")
label2.Size = UDim2.new(0, 60, 0, 30)
label2.Position = UDim2.new(0, 0, 0, 2)
label2.BackgroundTransparency = 1
label2.Text = "X_Offset:"
label2.TextColor3 = Color3.fromRGB(200, 200, 200)
label2.TextSize = 13
label2.Font = Enum.Font.SourceSans
label2.TextXAlignment = Enum.TextXAlignment.Left
label2.Parent = row2

local xOffDown = Instance.new("TextButton")
xOffDown.Size = UDim2.new(0, 25, 0, 28)
xOffDown.Position = UDim2.new(0, 65, 0, 3)
xOffDown.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
xOffDown.Text = "−"
xOffDown.TextColor3 = Color3.new(1, 1, 1)
xOffDown.TextSize = 16
xOffDown.Font = Enum.Font.SourceSansBold
xOffDown.BorderSizePixel = 0
xOffDown.Parent = row2

local xOffDisplay = Instance.new("TextLabel")
xOffDisplay.Size = UDim2.new(0, 40, 0, 28)
xOffDisplay.Position = UDim2.new(0, 95, 0, 3)
xOffDisplay.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
xOffDisplay.Text = "-50"
xOffDisplay.TextColor3 = Color3.new(1, 1, 1)
xOffDisplay.TextSize = 13
xOffDisplay.Font = Enum.Font.SourceSansBold
xOffDisplay.BorderSizePixel = 0
xOffDisplay.Parent = row2

local xOffUp = Instance.new("TextButton")
xOffUp.Size = UDim2.new(0, 25, 0, 28)
xOffUp.Position = UDim2.new(0, 140, 0, 3)
xOffUp.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
xOffUp.Text = "+"
xOffUp.TextColor3 = Color3.new(0, 0, 0)
xOffUp.TextSize = 16
xOffUp.Font = Enum.Font.SourceSansBold
xOffUp.BorderSizePixel = 0
xOffUp.Parent = row2

local xOffBox = Instance.new("TextBox")
xOffBox.Size = UDim2.new(0, 80, 0, 28)
xOffBox.Position = UDim2.new(0, 175, 0, 3)
xOffBox.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
xOffBox.Text = "-50"
xOffBox.TextColor3 = Color3.new(1, 1, 1)
xOffBox.TextSize = 13
xOffBox.Font = Enum.Font.SourceSans
xOffBox.BorderSizePixel = 0
xOffBox.Parent = row2

-- ==========================================
-- HÀNG 3: Y_Scale
-- ==========================================
local row3 = Instance.new("Frame")
row3.Size = UDim2.new(0, 330, 0, 35)
row3.Position = UDim2.new(0, 10, 0, 120)
row3.BackgroundTransparency = 1
row3.Parent = mainFrame

local label3 = Instance.new("TextLabel")
label3.Size = UDim2.new(0, 60, 0, 30)
label3.Position = UDim2.new(0, 0, 0, 2)
label3.BackgroundTransparency = 1
label3.Text = "Y_Scale:"
label3.TextColor3 = Color3.fromRGB(200, 200, 200)
label3.TextSize = 13
label3.Font = Enum.Font.SourceSans
label3.TextXAlignment = Enum.TextXAlignment.Left
label3.Parent = row3

local yScaleDown = Instance.new("TextButton")
yScaleDown.Size = UDim2.new(0, 25, 0, 28)
yScaleDown.Position = UDim2.new(0, 65, 0, 3)
yScaleDown.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
yScaleDown.Text = "−"
yScaleDown.TextColor3 = Color3.new(1, 1, 1)
yScaleDown.TextSize = 16
yScaleDown.Font = Enum.Font.SourceSansBold
yScaleDown.BorderSizePixel = 0
yScaleDown.Parent = row3

local yScaleDisplay = Instance.new("TextLabel")
yScaleDisplay.Size = UDim2.new(0, 40, 0, 28)
yScaleDisplay.Position = UDim2.new(0, 95, 0, 3)
yScaleDisplay.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
yScaleDisplay.Text = "0.50"
yScaleDisplay.TextColor3 = Color3.new(1, 1, 1)
yScaleDisplay.TextSize = 13
yScaleDisplay.Font = Enum.Font.SourceSansBold
yScaleDisplay.BorderSizePixel = 0
yScaleDisplay.Parent = row3

local yScaleUp = Instance.new("TextButton")
yScaleUp.Size = UDim2.new(0, 25, 0, 28)
yScaleUp.Position = UDim2.new(0, 140, 0, 3)
yScaleUp.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
yScaleUp.Text = "+"
yScaleUp.TextColor3 = Color3.new(0, 0, 0)
yScaleUp.TextSize = 16
yScaleUp.Font = Enum.Font.SourceSansBold
yScaleUp.BorderSizePixel = 0
yScaleUp.Parent = row3

local yScaleBox = Instance.new("TextBox")
yScaleBox.Size = UDim2.new(0, 80, 0, 28)
yScaleBox.Position = UDim2.new(0, 175, 0, 3)
yScaleBox.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
yScaleBox.Text = "0.5"
yScaleBox.TextColor3 = Color3.new(1, 1, 1)
yScaleBox.TextSize = 13
yScaleBox.Font = Enum.Font.SourceSans
yScaleBox.BorderSizePixel = 0
yScaleBox.Parent = row3

-- ==========================================
-- HÀNG 4: Y_Offset
-- ==========================================
local row4 = Instance.new("Frame")
row4.Size = UDim2.new(0, 330, 0, 35)
row4.Position = UDim2.new(0, 10, 0, 160)
row4.BackgroundTransparency = 1
row4.Parent = mainFrame

local label4 = Instance.new("TextLabel")
label4.Size = UDim2.new(0, 60, 0, 30)
label4.Position = UDim2.new(0, 0, 0, 2)
label4.BackgroundTransparency = 1
label4.Text = "Y_Offset:"
label4.TextColor3 = Color3.fromRGB(200, 200, 200)
label4.TextSize = 13
label4.Font = Enum.Font.SourceSans
label4.TextXAlignment = Enum.TextXAlignment.Left
label4.Parent = row4

local yOffDown = Instance.new("TextButton")
yOffDown.Size = UDim2.new(0, 25, 0, 28)
yOffDown.Position = UDim2.new(0, 65, 0, 3)
yOffDown.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
yOffDown.Text = "−"
yOffDown.TextColor3 = Color3.new(1, 1, 1)
yOffDown.TextSize = 16
yOffDown.Font = Enum.Font.SourceSansBold
yOffDown.BorderSizePixel = 0
yOffDown.Parent = row4

local yOffDisplay = Instance.new("TextLabel")
yOffDisplay.Size = UDim2.new(0, 40, 0, 28)
yOffDisplay.Position = UDim2.new(0, 95, 0, 3)
yOffDisplay.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
yOffDisplay.Text = "-25"
yOffDisplay.TextColor3 = Color3.new(1, 1, 1)
yOffDisplay.TextSize = 13
yOffDisplay.Font = Enum.Font.SourceSansBold
yOffDisplay.BorderSizePixel = 0
yOffDisplay.Parent = row4

local yOffUp = Instance.new("TextButton")
yOffUp.Size = UDim2.new(0, 25, 0, 28)
yOffUp.Position = UDim2.new(0, 140, 0, 3)
yOffUp.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
yOffUp.Text = "+"
yOffUp.TextColor3 = Color3.new(0, 0, 0)
yOffUp.TextSize = 16
yOffUp.Font = Enum.Font.SourceSansBold
yOffUp.BorderSizePixel = 0
yOffUp.Parent = row4

local yOffBox = Instance.new("TextBox")
yOffBox.Size = UDim2.new(0, 80, 0, 28)
yOffBox.Position = UDim2.new(0, 175, 0, 3)
yOffBox.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
yOffBox.Text = "-25"
yOffBox.TextColor3 = Color3.new(1, 1, 1)
yOffBox.TextSize = 13
yOffBox.Font = Enum.Font.SourceSans
yOffBox.BorderSizePixel = 0
yOffBox.Parent = row4

-- ==========================================
-- NÚT ÁP DỤNG VÀ RESET
-- ==========================================
local btnFrame = Instance.new("Frame")
btnFrame.Size = UDim2.new(0, 330, 0, 40)
btnFrame.Position = UDim2.new(0, 10, 0, 205)
btnFrame.BackgroundTransparency = 1
btnFrame.Parent = mainFrame

local applyBtn = Instance.new("TextButton")
applyBtn.Size = UDim2.new(0, 150, 0, 32)
applyBtn.Position = UDim2.new(0, 0, 0, 4)
applyBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
applyBtn.Text = "✅ ÁP DỤNG"
applyBtn.TextColor3 = Color3.new(1, 1, 1)
applyBtn.TextSize = 14
applyBtn.Font = Enum.Font.SourceSansBold
applyBtn.BorderSizePixel = 0
applyBtn.Parent = btnFrame

local cornerApply = Instance.new("UICorner")
cornerApply.CornerRadius = UDim.new(0, 6)
cornerApply.Parent = applyBtn

local resetBtn = Instance.new("TextButton")
resetBtn.Size = UDim2.new(0, 150, 0, 32)
resetBtn.Position = UDim2.new(0, 180, 0, 4)
resetBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
resetBtn.Text = "🔄 RESET"
resetBtn.TextColor3 = Color3.new(1, 1, 1)
resetBtn.TextSize = 14
resetBtn.Font = Enum.Font.SourceSansBold
resetBtn.BorderSizePixel = 0
resetBtn.Parent = btnFrame

local cornerReset = Instance.new("UICorner")
cornerReset.CornerRadius = UDim.new(0, 6)
cornerReset.Parent = resetBtn

-- ==========================================
-- HIỂN THỊ VỊ TRÍ HIỆN TẠI
-- ==========================================
local posLabel = Instance.new("TextLabel")
posLabel.Size = UDim2.new(0, 330, 0, 20)
posLabel.Position = UDim2.new(0, 10, 0, 250)
posLabel.BackgroundTransparency = 1
posLabel.Text = "📌 Vị trí hiện tại: (0.5, -50, 0.5, -25)"
posLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
posLabel.TextSize = 11
posLabel.Font = Enum.Font.SourceSans
posLabel.TextXAlignment = Enum.TextXAlignment.Left
posLabel.Parent = mainFrame

-- ==========================================
-- BIẾN LƯU VỊ TRÍ
-- ==========================================
local pos = {
    xScale = 0.5,
    xOffset = -50,
    yScale = 0.5,
    yOffset = -25
}

-- ==========================================
-- HÀM CẬP NHẬT VỊ TRÍ NÚT
-- ==========================================
local function updatePosition()
    testBtn.Position = UDim2.new(pos.xScale, pos.xOffset, pos.yScale, pos.yOffset)
    
    -- Cập nhật label hiển thị
    posLabel.Text = string.format(
        "📌 Vị trí hiện tại: (%.2f, %d, %.2f, %d)",
        pos.xScale, pos.xOffset, pos.yScale, pos.yOffset
    )
    
    -- Cập nhật display
    xScaleDisplay.Text = string.format("%.2f", pos.xScale)
    xOffDisplay.Text = tostring(pos.xOffset)
    yScaleDisplay.Text = string.format("%.2f", pos.yScale)
    yOffDisplay.Text = tostring(pos.yOffset)
    
    -- Cập nhật box
    xScaleBox.Text = string.format("%.2f", pos.xScale)
    xOffBox.Text = tostring(pos.xOffset)
    yScaleBox.Text = string.format("%.2f", pos.yScale)
    yOffBox.Text = tostring(pos.yOffset)
end

-- ==========================================
-- HÀM RESET VỀ MẶC ĐỊNH
-- ==========================================
local function resetPosition()
    pos.xScale = 0.5
    pos.xOffset = -50
    pos.yScale = 0.5
    pos.yOffset = -25
    updatePosition()
end

-- ==========================================
-- HÀM ÁP DỤNG TỪ Ô NHẬP
-- ==========================================
local function applyFromBoxes()
    local xScale = tonumber(xScaleBox.Text)
    local xOffset = tonumber(xOffBox.Text)
    local yScale = tonumber(yScaleBox.Text)
    local yOffset = tonumber(yOffBox.Text)
    
    if xScale and xOffset and yScale and yOffset then
        pos.xScale = xScale
        pos.xOffset = xOffset
        pos.yScale = yScale
        pos.yOffset = yOffset
        updatePosition()
    else
        -- Nếu nhập sai, khôi phục lại giá trị hiện tại
        updatePosition()
        print("⚠️ Vui lòng nhập số hợp lệ!")
    end
end

-- ==========================================
-- GÁN SỰ KIỆN CHO NÚT TĂNG/GIẢM
-- ==========================================
xScaleDown.MouseButton1Click:Connect(function()
    pos.xScale = math.max(0, pos.xScale - 0.05)
    updatePosition()
end)

xScaleUp.MouseButton1Click:Connect(function()
    pos.xScale = math.min(1, pos.xScale + 0.05)
    updatePosition()
end)

xOffDown.MouseButton1Click:Connect(function()
    pos.xOffset = pos.xOffset - 5
    updatePosition()
end)

xOffUp.MouseButton1Click:Connect(function()
    pos.xOffset = pos.xOffset + 5
    updatePosition()
end)

yScaleDown.MouseButton1Click:Connect(function()
    pos.yScale = math.max(0, pos.yScale - 0.05)
    updatePosition()
end)

yScaleUp.MouseButton1Click:Connect(function()
    pos.yScale = math.min(1, pos.yScale + 0.05)
    updatePosition()
end)

yOffDown.MouseButton1Click:Connect(function()
    pos.yOffset = pos.yOffset - 5
    updatePosition()
end)

yOffUp.MouseButton1Click:Connect(function()
    pos.yOffset = pos.yOffset + 5
    updatePosition()
end)

-- ==========================================
-- GÁN SỰ KIỆN CHO NÚT ÁP DỤNG & RESET
-- ==========================================
applyBtn.MouseButton1Click:Connect(applyFromBoxes)

resetBtn.MouseButton1Click:Connect(function()
    resetPosition()
    -- Cập nhật lại các ô nhập
    xScaleBox.Text = "0.5"
    xOffBox.Text = "-50"
    yScaleBox.Text = "0.5"
    yOffBox.Text = "-25"
end)

-- ==========================================
-- GÁN SỰ KIỆN CHO Ô NHẬP (Enter để áp dụng)
-- ==========================================
xScaleBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then applyFromBoxes() end
end)

xOffBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then applyFromBoxes() end
end)

yScaleBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then applyFromBoxes() end
end)

yOffBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then applyFromBoxes() end
end)

-- ==========================================
-- KHỞI TẠO VỊ TRÍ BAN ĐẦU
-- ==========================================
updatePosition()

print("========================================")
print("🎯 TOOL ĐIỀU CHỈNH VỊ TRÍ")
print("========================================")
print("📌 4 thành phần của UDim2:")
print("   X_Scale: Tỷ lệ chiều ngang (0-1)")
print("   X_Offset: Pixel dịch ngang")
print("   Y_Scale: Tỷ lệ chiều dọc (0-1)")
print("   Y_Offset: Pixel dịch dọc")
print("========================================")
print("🖱️ Kéo thả hoặc dùng nút +/− để điều chỉnh")
print("📝 Nhập số trực tiếp vào ô và bấm Enter")
print("========================================")