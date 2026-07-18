-- ==========================================
-- TOOL ALL-IN-ONE - BẢN THÔNG MINH (V2.0)
-- ==========================================

local player = game.Players.LocalPlayer
local userInput = game:GetService("UserInputService")
local isMobile = userInput.TouchEnabled
local runService = game:GetService("RunService")

-- ==========================================
-- CẤU HÌNH THÔNG MINH
-- ==========================================
local CONFIG = {
    scanRadius = 60,              -- Bán kính quét (tăng lên)
    autoRefreshInterval = 5,      -- Tự động refresh mỗi 5 giây
    maxItems = 50,               -- Giới hạn số lượng hiển thị
    priorityKeywords = {         -- Từ khóa ưu tiên (hiển thị đầu)
        "boombox", "void", "dragon", "vampire", "archangel",
        "dumpling", "exclusive", "mythical", "legendary"
    },
    filterBodyParts = true,      -- Lọc bỏ bộ phận nhân vật
    useCache = true,             -- Dùng bộ nhớ đệm
    smartSort = true,            -- Sắp xếp thông minh
}

-- ==========================================
-- BỘ NHỚ ĐỆM (CACHE) - QUÉT NHANH HƠN
-- ==========================================
local cache = {
    items = {},
    lastScan = 0,
    isScanning = false,
}

-- Danh sách bộ phận nhân vật cần bỏ qua
local BODY_PARTS = {
    "head", "uppertorso", "lowertorso", "upperarm", "lowerarm",
    "hand", "arm", "leg", "foot", "torso", "neck", "root",
    "humanoidrootpart", "left", "right", "attach", "joint",
    "body", "limb", "bones", "skeleton", "spine", "hip", "chest",
    "shoulder", "elbow", "wrist", "knee", "ankle", "hip"
}

-- ==========================================
-- HÀM QUÉT THÔNG MINH (CÓ CACHE)
-- ==========================================
local function smartScan(force)
    local now = tick()
    
    -- Nếu cache còn hiệu lực và không force thì dùng cache
    if not force and CONFIG.useCache and (now - cache.lastScan) < CONFIG.autoRefreshInterval then
        return cache.items
    end
    
    -- Chống quét trùng lặp
    if cache.isScanning then
        return cache.items
    end
    
    cache.isScanning = true
    
    local char = player.Character
    if not char then
        cache.isScanning = false
        return {}
    end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        cache.isScanning = false
        return {}
    end
    
    local center = hrp.Position
    local items = {}
    local startTime = tick()
    
    -- Sử dụng workspace:GetDescendants() nhưng giới hạn số lượng
    local descendants = workspace:GetDescendants()
    local count = 0
    
    for _, obj in ipairs(descendants) do
        -- Giới hạn số lượng để tránh lag
        if count > 500 then break end
        
        if obj:IsA("Model") or obj:IsA("BasePart") then
            -- Bỏ qua nhân vật
            if obj == char then continue end
            if obj:IsDescendantOf(char) then continue end
            if obj:FindFirstChild("Humanoid") then continue end
            if obj:FindFirstChild("HumanoidRootPart") then continue end
            
            -- Bỏ qua bộ phận nhân vật (nếu bật)
            if CONFIG.filterBodyParts then
                local name = obj.Name or ""
                local lowerName = name:lower()
                local isBody = false
                for _, part in ipairs(BODY_PARTS) do
                    if lowerName == part or lowerName:find(part) then
                        isBody = true
                        break
                    end
                end
                if isBody then continue end
            end
            
            -- Lấy vị trí
            local success, pos = pcall(function()
                if obj:IsA("Model") then
                    return obj:GetPivot().Position
                else
                    return obj.Position
                end
            end)
            
            if success and pos then
                local dist = (pos - center).Magnitude
                if dist <= CONFIG.scanRadius then
                    local displayName = obj.Name or "Unknown"
                    if obj:IsA("BasePart") and obj.Parent and obj.Parent:IsA("Model") then
                        displayName = obj.Parent.Name
                    end
                    
                    if displayName ~= "" and displayName ~= "Workspace" and displayName ~= "Terrain" then
                        -- Tính điểm ưu tiên
                        local priority = 0
                        local lowerDisplay = displayName:lower()
                        for i, kw in ipairs(CONFIG.priorityKeywords) do
                            if lowerDisplay:find(kw) then
                                priority = #CONFIG.priorityKeywords - i + 1
                                break
                            end
                        end
                        
                        -- Chỉ thêm nếu chưa có
                        local isDuplicate = false
                        for _, existing in ipairs(items) do
                            if existing.name:lower() == displayName:lower() then
                                isDuplicate = true
                                break
                            end
                        end
                        
                        if not isDuplicate then
                            table.insert(items, {
                                name = displayName,
                                obj = obj,
                                dist = dist,
                                priority = priority,
                                timestamp = tick()
                            })
                            count = count + 1
                        end
                    end
                end
            end
        end
    end
    
    -- Sắp xếp thông minh
    if CONFIG.smartSort then
        table.sort(items, function(a, b)
            -- Ưu tiên theo priority, sau đó khoảng cách
            if a.priority ~= b.priority then
                return a.priority > b.priority
            end
            return a.dist < b.dist
        end)
    else
        table.sort(items, function(a, b)
            return a.dist < b.dist
        end)
    end
    
    -- Giới hạn số lượng
    if #items > CONFIG.maxItems then
        local newItems = {}
        for i = 1, CONFIG.maxItems do
            newItems[i] = items[i]
        end
        items = newItems
    end
    
    -- Cập nhật cache
    cache.items = items
    cache.lastScan = tick()
    cache.isScanning = false
    
    local elapsed = (tick() - startTime) * 1000
    print("⚡ Quét hoàn tất trong " .. math.floor(elapsed) .. "ms | " .. #items .. " vật phẩm")
    
    return items
end

-- ==========================================
-- HIỂN THỊ DANH SÁCH (TỐI ƯU)
-- ==========================================
local function updateDisplay()
    local items = smartScan(false)
    
    -- Xóa danh sách cũ (chỉ xóa nếu cần)
    for _, child in ipairs(scrollItems:GetChildren()) do
        child:Destroy()
    end
    
    if #items == 0 then
        local emptyLabel = Instance.new("TextLabel")
        emptyLabel.Size = UDim2.new(0, isMobile and 310 or 390, 0, 25)
        emptyLabel.Position = UDim2.new(0, 10, 0, 10)
        emptyLabel.BackgroundTransparency = 1
        emptyLabel.Text = "❌ Không tìm thấy vật phẩm!"
        emptyLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        emptyLabel.TextSize = isMobile and 10 or 12
        emptyLabel.Font = Enum.Font.SourceSans
        emptyLabel.Parent = scrollItems
        scrollItems.CanvasSize = UDim2.new(0, 0, 0, 50)
        infoLabel.Text = "📡 " .. CONFIG.scanRadius .. "u | 0 vật phẩm"
        return
    end
    
    infoLabel.Text = "📡 " .. CONFIG.scanRadius .. "u | " .. #items .. " vật phẩm"
    
    local yPos = 0
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    
    for i, data in ipairs(items) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, isMobile and 310 or 390, 0, isMobile and 22 or 26)
        btn.Position = UDim2.new(0, 10, 0, yPos)
        
        -- Màu sắc theo priority
        if data.priority > 0 then
            btn.BackgroundColor3 = Color3.fromRGB(255, 200, 50)  -- Vàng cho ưu tiên
        else
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 65)
        end
        
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
        copyBtn.Position = UDim2.new(0, isMobile and 288 or 370, 0, 3)
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

-- ==========================================
-- TỰ ĐỘNG CẬP NHẬT (CHẠY NỀN)
-- ==========================================
local autoUpdateRunning = false

local function startAutoUpdate()
    if autoUpdateRunning then return end
    autoUpdateRunning = true
    
    spawn(function()
        while autoUpdateRunning do
            task.wait(CONFIG.autoRefreshInterval)
            -- Chỉ cập nhật nếu tab đang mở
            if content1.Visible then
                updateDisplay()
            end
        end
    end)
end

-- ==========================================
-- THAY THẾ HÀM SCAN CŨ
-- ==========================================
-- Ghi đè hàm scanNearby cũ bằng hàm mới thông minh hơn
scanNearby = function()
    CONFIG.useCache = false  -- Tắt cache để quét mới
    updateDisplay()
    CONFIG.useCache = true   -- Bật lại cache
end

clearItems = function()
    for _, child in ipairs(scrollItems:GetChildren()) do child:Destroy() end
    infoLabel.Text = "📡 " .. CONFIG.scanRadius .. "u | Đã xóa"
    cache.items = {}
    cache.lastScan = 0
end

-- ==========================================
-- CẬP NHẬT CÁC NÚT ĐIỀU KHIỂN
-- ==========================================
refreshBtn.MouseButton1Click:Connect(function()
    CONFIG.useCache = false
    updateDisplay()
    CONFIG.useCache = true
end)

radiusDown.MouseButton1Click:Connect(function()
    CONFIG.scanRadius = math.max(10, CONFIG.scanRadius - 5)
    radiusDisplay.Text = tostring(CONFIG.scanRadius)
    CONFIG.useCache = false
    updateDisplay()
    CONFIG.useCache = true
end)

radiusUp.MouseButton1Click:Connect(function()
    CONFIG.scanRadius = math.min(100, CONFIG.scanRadius + 5)
    radiusDisplay.Text = tostring(CONFIG.scanRadius)
    CONFIG.useCache = false
    updateDisplay()
    CONFIG.useCache = true
end)

-- ==========================================
-- KHỞI ĐỘNG TỰ ĐỘNG
-- ==========================================
-- Bắt đầu auto update
startAutoUpdate()

print("========================================")
print("🧠 TOOL THÔNG MINH V2.0")
print("========================================")
print("⚡ Quét nhanh hơn với cache")
print("🎯 Ưu tiên vật phẩm quan trọng")
print("🔄 Tự động refresh mỗi " .. CONFIG.autoRefreshInterval .. "s")
print("📊 Giới hạn " .. CONFIG.maxItems .. " vật phẩm hiển thị")
print("========================================")