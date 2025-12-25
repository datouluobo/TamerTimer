-- TamerTimer 小地图图标
local addonName, TamerTimer = ...

-- 创建小地图按钮
local minimapButton = CreateFrame("Button", "TamerTimerMinimapButton", Minimap)
minimapButton:SetSize(32, 32)
minimapButton:SetFrameStrata("MEDIUM")
minimapButton:SetFrameLevel(Minimap:GetFrameLevel() + 10)
minimapButton:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

-- 图标背景
local icon = minimapButton:CreateTexture(nil, "BACKGROUND")
icon:SetSize(20, 20)
icon:SetPoint("CENTER", 0, 1)
icon:SetTexture("Interface\\AddOns\\TamerTimer\\Logo_32.png")  -- 使用自定义Logo

-- 边框
local border = minimapButton:CreateTexture(nil, "OVERLAY")
border:SetSize(52, 52)
border:SetPoint("TOPLEFT")
border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")

-- 位置保存
TamerTimerMinimapDB = TamerTimerMinimapDB or { angle = 45 }

-- 更新位置
local function UpdatePosition()
    local angle = math.rad(TamerTimerMinimapDB.angle or 45)
    local x = math.cos(angle) * 80
    local y = math.sin(angle) * 80
    minimapButton:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

-- 拖动功能
minimapButton:RegisterForDrag("LeftButton")
minimapButton:SetScript("OnDragStart", function(self)
    self:LockHighlight()
    self.isDragging = true
end)

minimapButton:SetScript("OnDragStop", function(self)
    self:UnlockHighlight()
    self.isDragging = false
end)

minimapButton:SetScript("OnUpdate", function(self)
    if self.isDragging then
        local mx, my = Minimap:GetCenter()
        local px, py = GetCursorPosition()
        local scale = Minimap:GetEffectiveScale()
        px, py = px / scale, py / scale
        
        local angle = math.deg(math.atan2(py - my, px - mx))
        TamerTimerMinimapDB.angle = angle
        UpdatePosition()
    end
end)

-- 点击事件
minimapButton:SetScript("OnClick", function(self, button)
    if button == "LeftButton" then
        TamerTimer_ToggleUI()
    elseif button == "RightButton" then
        -- 右键菜单（未来可扩展）
        print("|cFFFF9D0A驯兽师计时器|r - 右键功能开发中")
    end
end)

-- 鼠标提示
minimapButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:SetText("|cFFFF9D0A驯兽师计时器|r", 1, 1, 1)
    GameTooltip:AddLine("左键: 显示/隐藏界面", 0.7, 0.7, 0.7)
    GameTooltip:AddLine("拖动: 移动图标位置", 0.7, 0.7, 0.7)
    GameTooltip:Show()
end)

minimapButton:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
end)

-- 注册到全局
TamerTimer.minimapButton = minimapButton

-- 初始化位置
UpdatePosition()
minimapButton:Show()
