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
   LoadingSubtitle = "Đã lọc Trade Sign & Sticker khỏi Trái Cây",
   ConfigurationSaving = { Enabled = false }
})

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
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
local SellMode = "Pet" -- Giá trị gửi lên Server: "Pet" hoặc "Holdable"

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

local PetDropdownUI = nil 
local FruitDropdownUI = nil 

-- Hàm lấy số KG từ tên (Bỏ qua Age, chỉ lấy số cạnh chữ KG/kg)
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
        if v:IsA("RemoteFunction") and v.Name == "CreateListing" then
            CreateListingFunc = v
            break
        end
    end
end

local TradeBoothController = nil
pcall(function()
    TradeBoothController = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("TradeBoothControllers"):WaitForChild("TradeBoothController"))
end)

local RemoveListingRemote = nil
pcall(function()
    RemoveListingRemote = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("TradeEvents").Booths.RemoveListing
end)

local function GetBoothItemCount()
    if not TradeBoothController then return 0 end
    local success, boothData = pcall(function()
        return TradeBoothController:GetPlayerBoothData(LocalPlayer)
    end)
    
    local count = 0
    if success and boothData and boothData.Listings then
        for _ in pairs(boothData.Listings) do count = count + 1 end
    end
    return count
end

-- ==========================================
-- 3. GIAO DIỆN TAB "BỘ LỌC BÁN HÀNG"
-- ==========================================
local MainTab = Window:CreateTab("Bộ Lọc Bán Hàng", 4483362458)

MainTab:CreateButton({
   Name = "🔄 [1] Quét Túi Đồ (Lọc Pet / Trái Cây chuẩn)",
   Callback = function()
      table.clear(PetList)
      table.clear(FruitList)
      table.clear(UniquePets)
      table.clear(UniqueFruits)
      
      local checkPetDup = {}
      local checkFruitDup = {}
      local totalPets = 0
      local totalFruits = 0
      
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
                          local uuidStr = tostring(petUUID)
                          table.insert(PetList, {Name = realName, UUID = uuidStr, Weight = weight})
                          totalPets = totalPets + 1
                          
                          if not checkPetDup[realName] then
                              checkPetDup[realName] = true
                              table.insert(UniquePets, realName)
                          end
                      end
                  else
                      -- Xử lý Trái cây (Holdable), loại bỏ Trade Sign và Trade Sticker
                      local lowerName = string.lower(realName)
                      local isTradeSignOrSticker = string.find(lowerName, "trade sign") or string.find(lowerName, "trading ticket") or string.find(lowerName, "sign") or string.find(lowerName, "sticker")
                      
                      if not isTradeSignOrSticker then
                          local fruitUUID = item:GetAttribute("c") 
                          if fruitUUID and fruitUUID ~= "" then
                              local uuidStr = tostring(fruitUUID)
                              table.insert(FruitList, {Name = realName, UUID = uuidStr, Weight = weight})
                              totalFruits = totalFruits + 1
                              
                              if not checkFruitDup[realName] then
                                  checkFruitDup[realName] = true
                                  table.insert(UniqueFruits, realName)
                              end
                          end
                      end
                  end
              end
          end
      end

      -- Cập nhật UI
      table.sort(UniquePets)
      table.sort(UniqueFruits)
      
      if #UniquePets > 0 then PetDropdownUI:Refresh(UniquePets, true) else PetDropdownUI:Refresh({"Trống"}, true) end
      if #UniqueFruits > 0 then FruitDropdownUI:Refresh(UniqueFruits, true) else FruitDropdownUI:Refresh({"Trống"}, true) end
      
      Rayfield:Notify({Title = "Thành công!", Content = string.format("Đã tìm thấy %d Pet và %d Trái cây (Đã lọc Sign/Sticker).", totalPets, totalFruits), Duration = 4})
   end,
})

PetDropdownUI = MainTab:CreateDropdown({
   Name = "🐾 [2A] CHỌN PET:",
   Options = {"Bấm Quét Túi Đồ..."},
   CurrentOption = {""},
   MultipleOptions = false, 
   Callback = function(Option) SelectedPetName = Option[1] or "" end,
})

FruitDropdownUI = MainTab:CreateDropdown({
   Name = "🍎 [2B] CHỌN TRÁI CÂY (Đã lọc Sign/Sticker):",
   Options = {"Bấm Quét Túi Đồ..."},
   CurrentOption = {""},
   MultipleOptions = false, 
   Callback = function(Option) SelectedFruitName = Option[1] or "" end,
})

MainTab:CreateDropdown({
   Name = "⚙️ [3] PHÂN LOẠI MUỐN ĐĂNG BÁN LÚC NÀY:",
   Options = {"Bán Pet", "Bán Trái Cây (Holdable)"}, 
   CurrentOption = {"Bán Pet"},
   MultipleOptions = false, 
   Callback = function(Option) 
       if Option[1] == "Bán Pet" then
           SellMode = "Pet"
       else
           SellMode = "Holdable"
       end
   end,
})

MainTab:CreateToggle({
   Name = "Bỏ qua kiểm tra Cân Nặng",
   CurrentValue = false,
   Callback = function(Value) IgnoreWeight = Value end,
})
MainTab:CreateLabel("📌 Trái cây vẫn có số KG, nên bạn có thể dùng hoặc bỏ qua lọc KG tùy ý.")

MainTab:CreateInput({
   Name = "Cân nặng tối thiểu (Min KG):",
   PlaceholderText = "0.66",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text) MinWeight = tonumber(Text) or 0.0 end,
})

MainTab:CreateInput({
   Name = "Cân nặng tối đa (Max KG):",
   PlaceholderText = "999.0",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text) MaxWeight = tonumber(Text) or 9999.0 end,
})

MainTab:CreateInput({
   Name = "Giá bán (Số xu):",
   PlaceholderText = "Mặc định: 5",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      local num = tonumber(Text)
      if num and num > 0 then InputPrice = num else InputPrice = 5 end
   end,
})

MainTab:CreateInput({
   Name = "Thời gian chờ (Giây - s):",
   PlaceholderText = "Mặc định: 5",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      local num = tonumber(Text)
      if num and num >= 0.5 then PostDelay = num else PostDelay = 3 end
   end,
})

MainTab:CreateButton({
   Name = "⚡ [4] BẮT ĐẦU ĐĂNG BÁN",
   Callback = function()
      if State.IsSelling then
          Rayfield:Notify({Title = "Thông báo", Content = "Hệ thống đang chạy rồi!", Duration = 3})
          return 
      end

      local targetList = (SellMode == "Pet") and PetList or FruitList
      local targetName = (SellMode == "Pet") and SelectedPetName or SelectedFruitName

      if targetName == "" or targetName == "Trống" or targetName == "Bấm Quét Túi Đồ..." then
          Rayfield:Notify({Title = "Thiếu thông tin", Content = "Vui lòng chọn vật phẩm ở bảng số [2A] hoặc [2B]!", Duration = 3})
          return
      end

      if not CreateListingFunc then
          Rayfield:Notify({Title = "Lỗi", Content = "Không tìm thấy hàm đăng bán của game!", Duration = 3})
          return
      end

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

      if #finalSellList == 0 then
          Rayfield:Notify({Title = "Trống", Content = string.format("Không có '%s' nào thỏa mãn hoặc đã đăng hết!", targetName), Duration = 4})
          return
      end

      State.IsSelling = true
      task.spawn(function()
          local successCount = 0
          local totalSelected = #finalSellList
          
          Rayfield:Notify({Title = "Bắt đầu đăng!", Content = string.format("Tìm thấy %d '%s' sẵn sàng.", totalSelected, targetName), Duration = 4})
          
          for i, uuid in ipairs(finalSellList) do
              if not State.IsSelling then break end
              
              local currentBoothCount = GetBoothItemCount()
              local hasNotifiedFull = false
              
              while currentBoothCount >= MaxBoothSlots and State.IsSelling do
                  if not hasNotifiedFull then
                      Rayfield:Notify({Title = "Gian hàng đầy", Content = "Đang chờ gian hàng trống chỗ...", Duration = 5})
                      hasNotifiedFull = true
                  end
                  task.wait(3)
                  currentBoothCount = GetBoothItemCount()
              end
              if not State.IsSelling then break end 
              
              Rayfield:Notify({
                  Title = "Đang treo...", 
                  Content = string.format("Đang đăng (%d/%d) (Chờ %ss)", i, totalSelected, tostring(PostDelay)), 
                  Duration = math.max(0.5, PostDelay - 0.2)
              })
              
              local success, _ = pcall(function()
                  return CreateListingFunc:InvokeServer(SellMode, uuid, InputPrice)
              end)
              
              if success then 
                  successCount = successCount + 1 
                  ListedCache[uuid] = true 
              end
              task.wait(PostDelay) 
          end
          
          local noticeTitle = State.IsSelling and "Hoàn thành!" or "Đã dừng!"
          Rayfield:Notify({Title = noticeTitle, Content = string.format("Đã đăng thành công %d vật phẩm!", successCount), Duration = 5})
          State.IsSelling = false
      end)
   end,
})

MainTab:CreateButton({
   Name = "🛑 DỪNG ĐĂNG KHẨN CẤP",
   Callback = function() 
       State.IsSelling = false 
       Rayfield:Notify({Title = "Hệ thống nhận lệnh!", Content = "Đang dừng vòng lặp, vui lòng đợi giây lát...", Duration = 3})
   end,
})

-- ==========================================
-- 4. GIAO DIỆN TAB "QUẢN LÝ GIAN HÀNG"
-- ==========================================
local ManageTab = Window:CreateTab("Quản lý Gian hàng", 4483362458)

local CountLabel = ManageTab:CreateLabel("Tổng: 0 vật phẩm đang treo")
local AutoUpdateEnabled = true 
local AutoUpdateThread = nil

local function UpdateBoothCount()
    if not TradeBoothController then
        CountLabel:Set("❌ Không tìm thấy module quản lý")
        return
    end
    local count = GetBoothItemCount()
    CountLabel:Set("📦 Tổng: " .. count .. " vật phẩm đang treo")
end

ManageTab:CreateButton({
    Name = "↺ Làm mới thủ công",
    Callback = function()
        UpdateBoothCount()
        Rayfield:Notify({Title = "✅ Đã cập nhật!", Content = "Số lượng gian hàng đã được làm mới.", Duration = 2})
    end
})

ManageTab:CreateButton({
    Name = "🔄 BẬT/TẮT TỰ ĐỘNG CẬP NHẬT (Mặc định: Bật)", 
    Callback = function()
        AutoUpdateEnabled = not AutoUpdateEnabled
        if AutoUpdateEnabled then
            if AutoUpdateThread then task.cancel(AutoUpdateThread); AutoUpdateThread = nil end
            AutoUpdateThread = task.spawn(function()
                while AutoUpdateEnabled do
                    UpdateBoothCount()
                    task.wait(3)
                end
            end)
            Rayfield:Notify({Title = "✅ ĐÃ BẬT", Content = "Tự động cập nhật mỗi 3 giây.", Duration = 3})
            UpdateBoothCount()
        else
            if AutoUpdateThread then task.cancel(AutoUpdateThread); AutoUpdateThread = nil end
            Rayfield:Notify({Title = "❌ ĐÃ TẮT", Content = "Đã dừng tự động cập nhật.", Duration = 3})
        end
    end
})

ManageTab:CreateButton({
    Name = "🧨 XÓA TOÀN BỘ GIAN HÀNG",
    Callback = function()
        if not TradeBoothController or not RemoveListingRemote then
            Rayfield:Notify({Title = "Lỗi", Content = "Không thể kết nối đến hệ thống gian hàng!", Duration = 3})
            return
        end
        local data = TradeBoothController:GetPlayerBoothData(LocalPlayer)
        if data and data.Listings then
            local count, total = 0, 0
            for _ in pairs(data.Listings) do total = total + 1 end
            
            if total == 0 then return end
            
            Rayfield:Notify({Title = "Thông báo", Content = "Đang xóa " .. total .. " vật phẩm...", Duration = 3})
            
            for itemID, listingData in pairs(data.Listings) do
                local success = pcall(function() RemoveListingRemote:InvokeServer(itemID) end)
                if success then 
                    count = count + 1 
                    local itemData = listingData.ItemData or listingData
                    local uid = itemData.c or itemData.PET_UUID or itemData.UUID or itemData.Id or listingData.Id
                    if uid then ListedCache[tostring(uid)] = nil end
                end
                task.wait(0.3)
            end
            
            Rayfield:Notify({Title = "✅ Hoàn tất", Content = "Đã xóa " .. count .. "/" .. total .. " vật phẩm!", Duration = 3})
            UpdateBoothCount()
        end
    end
})

AutoUpdateThread = task.spawn(function()
    while AutoUpdateEnabled do UpdateBoothCount(); task.wait(3) end
end)

LocalPlayer.OnTeleport:Connect(function()
    if AutoUpdateThread then task.cancel(AutoUpdateThread); AutoUpdateThread = nil end
    State.IsSelling = false
end)

Rayfield:Notify({
    Title = "🚀 ĐÃ TẢI THÀNH CÔNG!",
    Content = "Smart Booth Seller V25 đã lọc bỏ Trade Sign & Sticker ở mục Trái Cây.",
    Duration = 4
})
