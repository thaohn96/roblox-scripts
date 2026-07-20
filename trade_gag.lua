-- ==========================================
-- TẢI THƯ VIỆN RAYFIELD (Giao diện chuẩn)
-- ==========================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ==========================================
-- KHỞI TẠO CỬA SỔ CHÍNH
-- ==========================================
local Window = Rayfield:CreateWindow({
   Name = "Smart Booth Seller V25",
   LoadingTitle = "Đang khởi động hệ thống...",
   LoadingSubtitle = "Auto Load, Lưu Config & Clear Cache",
   ConfigurationSaving = { Enabled = false }
})

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- 1. CÁC BIẾN & BỘ NHỚ HỆ THỐNG
-- ==========================================
local PetList = {}          
local FruitList = {}
local UniquePets = {}      
local UniqueFruits = {}

local SelectedPetName = ""     
local SelectedFruitName = ""
local SellMode = "Pet" 

local IgnoreWeight = false      
local InputPrice = 5          
local PostDelay = 5           
local MinWeight = 0.66
local MaxWeight = 999.0
local MaxBoothSlots = 50       

local ListedCache = {} 
local State = {
    IsSelling = false
}

-- Khai báo biến UI để có thể cập nhật từ Config
local PetDropdownUI, FruitDropdownUI, ModeDropdown
local IgnoreWeightToggle, MinWeightInput, MaxWeightInput, PriceInput, DelayInput
local AutoSellToggle

-- Tên file lưu cấu hình
local ConfigFileName = "SmartBoothSeller_ConfigV25.json"

-- Hàm lấy số KG từ tên
local function ExtractWeightFromName(toolName)
    local weightStr = string.match(toolName, "%[([%d%.]+)%s*[kK][gG]%]")
    return tonumber(weightStr) or 0.0 
end

-- ==========================================
-- 2. TÌM KIẾM REMOTE & MODULE CỦA GAME
-- ==========================================
local CreateListingFunc = nil
pcall(function()
    local TradeEvents = ReplicatedStorage:FindFirstChild("TradeEvents")
    if TradeEvents then
        local Booths = TradeEvents:FindFirstChild("Booths")
        if Booths then CreateListingFunc = Booths:FindFirstChild("CreateListing") end
    end
end)

if not CreateListingFunc then
    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteFunction") and v.Name == "CreateListing" then CreateListingFunc = v; break end
    end
end

local TradeBoothController = nil
pcall(function() TradeBoothController = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("TradeBoothControllers"):WaitForChild("TradeBoothController")) end)

local RemoveListingRemote = nil
pcall(function() RemoveListingRemote = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("TradeEvents").Booths.RemoveListing end)

local function GetBoothItemCount()
    if not TradeBoothController then return 0 end
    local success, boothData = pcall(function() return TradeBoothController:GetPlayerBoothData(LocalPlayer) end)
    local count = 0
    if success and boothData and boothData.Listings then
        for _ in pairs(boothData.Listings) do count = count + 1 end
    end
    return count
end

-- ==========================================
-- 3. HÀM QUÉT TÚI ĐỒ (Dùng chung cho Auto và Nút bấm)
-- ==========================================
local function ScanInventory(isSilent)
    table.clear(PetList); table.clear(FruitList)
    table.clear(UniquePets); table.clear(UniqueFruits)
    
    local checkPetDup = {}; local checkFruitDup = {}
    local totalPets = 0; local totalFruits = 0
    
    local Backpack = LocalPlayer:FindFirstChild("Backpack")
    if Backpack then
        for _, item in ipairs(Backpack:GetChildren()) do
            if item:IsA("Tool") then
                local realName = item:GetAttribute("f") or item.Name
                local weight = ExtractWeightFromName(item.Name)
                local petType = item:GetAttribute("PetType")
                local itemType = item:GetAttribute("ItemType")
                local isPet = (petType == "Pet" or itemType == "Pet")
                
                if isPet then
                    local petUUID = item:GetAttribute("PET_UUID")
                    if petUUID and petUUID ~= "" then
                        table.insert(PetList, {Name = realName, UUID = tostring(petUUID), Weight = weight})
                        totalPets = totalPets + 1
                        if not checkPetDup[realName] then checkPetDup[realName] = true; table.insert(UniquePets, realName) end
                    end
                else
                    local lowerName = string.lower(realName)
                    local isTradeSignOrSticker = string.find(lowerName, "trade sign") or string.find(lowerName, "trading ticket") or string.find(lowerName, "sign") or string.find(lowerName, "sticker")
                    
                    if not isTradeSignOrSticker then
                        local fruitUUID = item:GetAttribute("c") 
                        if fruitUUID and fruitUUID ~= "" then
                            table.insert(FruitList, {Name = realName, UUID = tostring(fruitUUID), Weight = weight})
                            totalFruits = totalFruits + 1
                            if not checkFruitDup[realName] then checkFruitDup[realName] = true; table.insert(UniqueFruits, realName) end
                        end
                    end
                end
            end
        end
    end

    table.sort(UniquePets); table.sort(UniqueFruits)
    
    if not isSilent then
        if PetDropdownUI then PetDropdownUI:Refresh(#UniquePets > 0 and UniquePets or {"Trống"}, true) end
        if FruitDropdownUI then FruitDropdownUI:Refresh(#UniqueFruits > 0 and UniqueFruits or {"Trống"}, true) end
        Rayfield:Notify({Title = "Đã quét túi đồ!", Content = string.format("Tìm thấy %d Pet và %d Trái cây.", totalPets, totalFruits), Duration = 3})
    end
end

-- ==========================================
-- 4. GIAO DIỆN TAB "BỘ LỌC BÁN HÀNG"
-- ==========================================
local MainTab = Window:CreateTab("Bộ Lọc Bán Hàng", 4483362458)

MainTab:CreateButton({
   Name = "🔄 [1] Quét Lại Túi Đồ",
   Callback = function() ScanInventory(false) end,
})

PetDropdownUI = MainTab:CreateDropdown({
   Name = "🐾 [2A] CHỌN PET:",
   Options = {"Đang tải..."},
   CurrentOption = {""},
   MultipleOptions = false, 
   Callback = function(Option) SelectedPetName = Option[1] or "" end,
})

FruitDropdownUI = MainTab:CreateDropdown({
   Name = "🍎 [2B] CHỌN TRÁI CÂY:",
   Options = {"Đang tải..."},
   CurrentOption = {""},
   MultipleOptions = false, 
   Callback = function(Option) SelectedFruitName = Option[1] or "" end,
})

ModeDropdown = MainTab:CreateDropdown({
   Name = "⚙️ [3] LOẠI HÀNG ĐĂNG BÁN:",
   Options = {"Bán Pet", "Bán Trái Cây (Holdable)"}, 
   CurrentOption = {"Bán Pet"},
   MultipleOptions = false, 
   Callback = function(Option) SellMode = (Option[1] == "Bán Pet") and "Pet" or "Holdable" end,
})

IgnoreWeightToggle = MainTab:CreateToggle({
   Name = "Bỏ qua kiểm tra Cân Nặng",
   CurrentValue = false,
   Callback = function(Value) IgnoreWeight = Value end,
})

MinWeightInput = MainTab:CreateInput({
   Name = "Cân nặng tối thiểu (Min KG):",
   PlaceholderText = tostring(MinWeight),
   RemoveTextAfterFocusLost = false,
   Callback = function(Text) MinWeight = tonumber(Text) or 0.0 end,
})

MaxWeightInput = MainTab:CreateInput({
   Name = "Cân nặng tối đa (Max KG):",
   PlaceholderText = tostring(MaxWeight),
   RemoveTextAfterFocusLost = false,
   Callback = function(Text) MaxWeight = tonumber(Text) or 9999.0 end,
})

PriceInput = MainTab:CreateInput({
   Name = "Giá bán (Số xu):",
   PlaceholderText = tostring(InputPrice),
   RemoveTextAfterFocusLost = false,
   Callback = function(Text) InputPrice = tonumber(Text) or 5 end,
})

DelayInput = MainTab:CreateInput({
   Name = "Thời gian chờ (Giây - s):",
   PlaceholderText = tostring(PostDelay),
   RemoveTextAfterFocusLost = false,
   Callback = function(Text) PostDelay = tonumber(Text) or 3 end,
})

AutoSellToggle = MainTab:CreateToggle({
   Name = "⚡ [4] TỰ ĐỘNG ĐĂNG BÁN (NÚT GẠT)",
   CurrentValue = false,
   Callback = function(Value)
      State.IsSelling = Value
      if Value then
          if not CreateListingFunc then
              Rayfield:Notify({Title = "Lỗi", Content = "Không tìm thấy hàm đăng bán của game!", Duration = 3})
              AutoSellToggle:Set(false)
              return
          end

          Rayfield:Notify({Title = "Auto Đã Bật", Content = "Hệ thống sẽ tự động quét và treo đồ lên gian hàng.", Duration = 3})
          
          task.spawn(function()
              while State.IsSelling do
                  ScanInventory(true)

                  local targetList = (SellMode == "Pet") and PetList or FruitList
                  local targetName = (SellMode == "Pet") and SelectedPetName or SelectedFruitName

                  if targetName ~= "" and targetName ~= "Trống" and targetName ~= "Đang tải..." then
                      local finalSellList = {}
                      local currentBoothUUIDs = {}
                      
                      if TradeBoothController then
                          local success, boothData = pcall(function() return TradeBoothController:GetPlayerBoothData(LocalPlayer) end)
                          if success and boothData and boothData.Listings then
                              for _, listing in pairs(boothData.Listings) do
                                  local itemData = listing.ItemData or listing
                                  local uid = itemData.c or itemData.PET_UUID or itemData.UUID or itemData.Id or listing.Id
                                  if uid then currentBoothUUIDs[tostring(uid)] = true end
                              end
                          end
                      end

                      for _, item in ipairs(targetList) do
                          if item.Name == targetName then
                              local weightPass = IgnoreWeight or (item.Weight >= MinWeight and item.Weight <= MaxWeight)
                              if weightPass and not currentBoothUUIDs[item.UUID] and not ListedCache[item.UUID] then
                                  table.insert(finalSellList, item.UUID)
                              end
                          end
                      end

                      for i, uuid in ipairs(finalSellList) do
                          if not State.IsSelling then break end
                          
                          local currentBoothCount = GetBoothItemCount()
                          while currentBoothCount >= MaxBoothSlots and State.IsSelling do
                              task.wait(2)
                              currentBoothCount = GetBoothItemCount()
                          end
                          if not State.IsSelling then break end 
                          
                          pcall(function() CreateListingFunc:InvokeServer(SellMode, uuid, InputPrice) end)
                          ListedCache[uuid] = true 
                          task.wait(PostDelay) 
                      end
                  end
                  task.wait(1.5) 
              end
          end)
      else
          Rayfield:Notify({Title = "Auto Đã Tắt", Content = "Đã dừng tự động đăng bán.", Duration = 3})
      end
   end,
})

-- ==========================================
-- 5. GIAO DIỆN TAB "QUẢN LÝ GIAN HÀNG"
-- ==========================================
local ManageTab = Window:CreateTab("Quản lý Gian hàng", 4483362458)
local CountLabel = ManageTab:CreateLabel("Tổng: 0 vật phẩm đang treo")
local AutoUpdateEnabled = true 
local AutoUpdateThread = nil

local function UpdateBoothCount()
    if not TradeBoothController then CountLabel:Set("❌ Không tìm thấy module quản lý"); return end
    CountLabel:Set("📦 Tổng: " .. GetBoothItemCount() .. " vật phẩm đang treo")
end

ManageTab:CreateButton({ Name = "↺ Làm mới thủ công", Callback = function() UpdateBoothCount() end })

ManageTab:CreateButton({
    Name = "🧨 XÓA TOÀN BỘ GIAN HÀNG",
    Callback = function()
        if not TradeBoothController or not RemoveListingRemote then return end
        local data = TradeBoothController:GetPlayerBoothData(LocalPlayer)
        if data and data.Listings then
            local count, total = 0, 0
            for _ in pairs(data.Listings) do total = total + 1 end
            if total == 0 then return end
            
            Rayfield:Notify({Title = "Thông báo", Content = "Đang xóa " .. total .. " vật phẩm...", Duration = 3})
            
            -- Xóa trên game
            for itemID, listingData in pairs(data.Listings) do
                pcall(function() RemoveListingRemote:InvokeServer(itemID) end)
                task.wait(0.3)
            end
            
            -- LÀM SẠCH BỘ NHỚ LƯU CỦA SCRIPT
            table.clear(ListedCache)
            
            Rayfield:Notify({Title = "✅ Hoàn tất", Content = "Đã gỡ toàn bộ và XÓA SẠCH bộ nhớ!", Duration = 3})
            UpdateBoothCount()
        end
    end
})

AutoUpdateThread = task.spawn(function()
    while AutoUpdateEnabled do UpdateBoothCount(); task.wait(3) end
end)

-- ==========================================
-- 6. GIAO DIỆN TAB "CÀI ĐẶT" & LƯU CONFIG
-- ==========================================
local SettingsTab = Window:CreateTab("Lưu Cài Đặt", 10842918882)

SettingsTab:CreateButton({
    Name = "💾 Lưu Cài Đặt Vào Máy",
    Callback = function()
        if writefile then
            local configData = {
                IgnoreWeight = IgnoreWeight,
                MinWeight = MinWeight,
                MaxWeight = MaxWeight,
                InputPrice = InputPrice,
                PostDelay = PostDelay,
                SellMode = SellMode,
                SelectedPetName = SelectedPetName,
                SelectedFruitName = SelectedFruitName,
                AutoSellEnabled = State.IsSelling
            }
            local success, encoded = pcall(function() return HttpService:JSONEncode(configData) end)
            if success then
                writefile(ConfigFileName, encoded)
                Rayfield:Notify({Title = "Cài Đặt", Content = "Đã lưu cài đặt (bao gồm trạng thái Auto) vào thư mục Workspace!", Duration = 3})
            end
        else
            Rayfield:Notify({Title = "Lỗi Trình Thực Thi", Content = "Trình thực thi của bạn không hỗ trợ lưu file!", Duration = 4})
        end
    end
})

-- Hàm tải dữ liệu cài đặt khi mở script
local function LoadConfig()
    if isfile and isfile(ConfigFileName) and readfile then
        local success, decoded = pcall(function() return HttpService:JSONDecode(readfile(ConfigFileName)) end)
        if success and type(decoded) == "table" then
            IgnoreWeight = decoded.IgnoreWeight or false
            MinWeight = decoded.MinWeight or 0.66
            MaxWeight = decoded.MaxWeight or 999.0
            InputPrice = decoded.InputPrice or 5
            PostDelay = decoded.PostDelay or 5
            SellMode = decoded.SellMode or "Pet"
            SelectedPetName = decoded.SelectedPetName or ""
            SelectedFruitName = decoded.SelectedFruitName or ""
            
            local autoSell = decoded.AutoSellEnabled or false
            
            if IgnoreWeightToggle then IgnoreWeightToggle:Set(IgnoreWeight) end
            if MinWeightInput then MinWeightInput:Set(tostring(MinWeight)) end
            if MaxWeightInput then MaxWeightInput:Set(tostring(MaxWeight)) end
            if PriceInput then PriceInput:Set(tostring(InputPrice)) end
            if DelayInput then DelayInput:Set(tostring(PostDelay)) end
            if ModeDropdown then ModeDropdown:Set({SellMode == "Pet" and "Bán Pet" or "Bán Trái Cây (Holdable)"}) end
            if SelectedPetName ~= "" and PetDropdownUI then PetDropdownUI:Set({SelectedPetName}) end
            if SelectedFruitName ~= "" and FruitDropdownUI then FruitDropdownUI:Set({SelectedFruitName}) end
            
            if autoSell and AutoSellToggle then 
                task.spawn(function()
                    task.wait(0.5) 
                    AutoSellToggle:Set(true)
                end)
            end
        end
    end
end

-- ==========================================
-- 7. THỰC THI KHỞI ĐỘNG (Auto Scan & Load Config)
-- ==========================================
task.spawn(function()
    task.wait(1)
    ScanInventory(false)
    LoadConfig()         
end)

-- Hủy script khi bị dịch chuyển
LocalPlayer.OnTeleport:Connect(function()
    if AutoUpdateThread then task.cancel(AutoUpdateThread); AutoUpdateThread = nil end
    State.IsSelling = false
end)

-- ==========================================
-- 8. THU NHỎ GUI XUỐNG 75%
-- ==========================================
task.spawn(function()
    task.wait(2) 
    pcall(function()
        local guiContainer = (gethui and gethui()) or game:GetService("CoreGui")
        for _, child in pairs(guiContainer:GetDescendants()) do
            if child:IsA("Frame") and child.Name == "Main" and child.Parent and child.Parent.Name == "Rayfield" then
                local uiScale = child:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")
                uiScale.Scale = 0.9
                uiScale.Parent = child
            end
        end
    end)
end)
