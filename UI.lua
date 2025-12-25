-- TamerTimer UI - 游戏内界面（与WPF UI一致）

local TamerTimer_CurrentNotePet = nil
local FRAME_WIDTH = 270 -- 保持窄宽度
local FRAME_HEIGHT = 800
local PET_ITEM_HEIGHT = 78 -- 72 -> 78，增加高度以适应更高的进度条

-- 小时输入对话框
StaticPopupDialogs["TAMERTIMER_INPUT_HOUR"] = {
    text = "输入小时 (0-23)：",
    button1 = "确定",
    button2 = "取消",
    hasEditBox = true,
    maxLetters = 2,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
    OnShow = function(self)
        local editBox = _G[self:GetName().."EditBox"]
        if editBox and TamerTimer_SetTimeDialog then
            editBox:SetText(TamerTimer_SetTimeDialog.hourText:GetText())
            editBox:SetFocus()
            editBox:HighlightText()
            editBox:SetNumeric(true)
        end
    end,
    OnAccept = function(self)
        local editBox = _G[self:GetName().."EditBox"]
        local hour = tonumber(editBox:GetText())
        if hour and hour >= 0 and hour <= 23 and TamerTimer_SetTimeDialog then
            TamerTimer_SetTimeDialog.hourText:SetText(string.format("%02d", hour))
        end
    end,
}

-- 分钟输入对话框
StaticPopupDialogs["TAMERTIMER_INPUT_MINUTE"] = {
    text = "输入分钟 (0-59)：",
    button1 = "确定",
    button2 = "取消",
    hasEditBox = true,
    maxLetters = 2,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
    OnShow = function(self)
        local editBox = _G[self:GetName().."EditBox"]
        if editBox and TamerTimer_SetTimeDialog then
            editBox:SetText(TamerTimer_SetTimeDialog.minuteText:GetText())
            editBox:SetFocus()
            editBox:HighlightText()
            editBox:SetNumeric(true)
        end
    end,
    OnAccept = function(self)
        local editBox = _G[self:GetName().."EditBox"]
        local minute = tonumber(editBox:GetText())
        if minute and minute >= 0 and minute <= 59 and TamerTimer_SetTimeDialog then
            TamerTimer_SetTimeDialog.minuteText:SetText(string.format("%02d", minute))
        end
    end,
}
local TamerTimer_SelectedDay = 0 -- 0 = 今天, 1 = 昨天

-- 创建击杀时间设置对话框
local function CreateSetTimeDialog()
    local dialog = CreateFrame("Frame", "TamerTimerSetTimeDialog", UIParent)
    dialog:SetSize(350, 220)
    dialog:SetPoint("CENTER")
    dialog:SetFrameStrata("DIALOG")
    dialog:SetMovable(true)
    dialog:EnableMouse(true)
    dialog:SetClampedToScreen(true)
    dialog:Hide()
    
    -- 背景
    dialog.bg = dialog:CreateTexture(nil, "BACKGROUND")
    dialog.bg:SetAllPoints()
    dialog.bg:SetColorTexture(0.15, 0.17, 0.20, 0.50)
    
    -- 边框
    dialog.border = dialog:CreateTexture(nil, "BORDER")
    dialog.border:SetAllPoints()
    dialog.border:SetColorTexture(0.12, 0.14, 0.17, 0.20)
    
    -- 标题栏
    dialog.titleBar = CreateFrame("Frame", nil, dialog)
    dialog.titleBar:SetSize(350, 40)
    dialog.titleBar:SetPoint("TOP")
    dialog.titleBar.bg = dialog.titleBar:CreateTexture(nil, "BACKGROUND")
    dialog.titleBar.bg:SetAllPoints()
    dialog.titleBar.bg:SetColorTexture(0.12, 0.14, 0.17, 0.60)
    
    dialog.title = dialog.titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    dialog.title:SetPoint("LEFT", 16, 0)
    dialog.title:SetText("设置击杀时间")
    dialog.title:SetTextColor(1, 1, 1)
    
    -- 关闭按钮
    dialog.closeBtn = CreateFrame("Button", nil, dialog.titleBar, "UIPanelCloseButton")
    dialog.closeBtn:SetPoint("TOPRIGHT", -5, -5)
    dialog.closeBtn:SetSize(24, 24)
    dialog.closeBtn:SetScript("OnClick", function() dialog:Hide() end)
    
    -- 拖动
    dialog.titleBar:EnableMouse(true)
    dialog.titleBar:RegisterForDrag("LeftButton")
    dialog.titleBar:SetScript("OnDragStart", function() dialog:StartMoving() end)
    dialog.titleBar:SetScript("OnDragStop", function() dialog:StopMovingOrSizing() end)
    
    -- 宠物名称显示
    dialog.petNameText = dialog:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    dialog.petNameText:SetPoint("TOP", 0, -50)
    dialog.petNameText:SetTextColor(1, 0.82, 0)
    
    -- 日期选择标签
    dialog.dateLabel = dialog:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    dialog.dateLabel:SetPoint("TOPLEFT", 20, -80)
    dialog.dateLabel:SetText("日期：")
    dialog.dateLabel:SetTextColor(0.7, 0.7, 0.7)
    
    -- 今天按钮
    dialog.todayBtn = CreateFrame("Button", nil, dialog)
    dialog.todayBtn:SetSize(65, 28)
    dialog.todayBtn:SetPoint("LEFT", dialog.dateLabel, "RIGHT", 10, 0)
    dialog.todayBtn.bg = dialog.todayBtn:CreateTexture(nil, "BACKGROUND")
    dialog.todayBtn.bg:SetAllPoints()
    dialog.todayBtn.bg:SetColorTexture(0.06, 0.73, 0.51, 1)
    dialog.todayBtn.text = dialog.todayBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    dialog.todayBtn.text:SetPoint("CENTER")
    dialog.todayBtn.text:SetText("今天")
    dialog.todayBtn.text:SetTextColor(1, 1, 1)
    dialog.todayBtn:SetScript("OnClick", function()
        TamerTimer_SelectedDay = 0
        dialog.todayBtn.bg:SetColorTexture(0.06, 0.73, 0.51, 1)
        dialog.yesterdayBtn.bg:SetColorTexture(0.3, 0.3, 0.3, 1)
    end)
    
    -- 昨天按钮
    dialog.yesterdayBtn = CreateFrame("Button", nil, dialog)
    dialog.yesterdayBtn:SetSize(65, 28)
    dialog.yesterdayBtn:SetPoint("LEFT", dialog.todayBtn, "RIGHT", 10, 0)
    dialog.yesterdayBtn.bg = dialog.yesterdayBtn:CreateTexture(nil, "BACKGROUND")
    dialog.yesterdayBtn.bg:SetAllPoints()
    dialog.yesterdayBtn.bg:SetColorTexture(0.3, 0.3, 0.3, 1)
    dialog.yesterdayBtn.text = dialog.yesterdayBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    dialog.yesterdayBtn.text:SetPoint("CENTER")
    dialog.yesterdayBtn.text:SetText("昨天")
    dialog.yesterdayBtn.text:SetTextColor(1, 1, 1)
    dialog.yesterdayBtn:SetScript("OnClick", function()
        TamerTimer_SelectedDay = 1
        dialog.todayBtn.bg:SetColorTexture(0.3, 0.3, 0.3, 1)
        dialog.yesterdayBtn.bg:SetColorTexture(0.06, 0.73, 0.51, 1)
    end)
    
    -- 时间输入标签
    dialog.timeLabel = dialog:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    dialog.timeLabel:SetPoint("TOPLEFT", 20, -120)
    dialog.timeLabel:SetText("时间：")
    dialog.timeLabel:SetTextColor(0.7, 0.7, 0.7)
    
    -- 小时选择器（可点击、可滚轮）
    dialog.hourFrame = CreateFrame("Button", nil, dialog)
    dialog.hourFrame:SetSize(40, 30)
    dialog.hourFrame:SetPoint("LEFT", dialog.timeLabel, "RIGHT", 10, 0)
    dialog.hourFrame:EnableMouseWheel(true)
    
    -- 小时显示文本
    dialog.hourText = dialog.hourFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    dialog.hourText:SetPoint("CENTER")
    dialog.hourText:SetText("00")
    dialog.hourText:SetTextColor(1, 1, 1)
    dialog.hourText:SetFont("Fonts\\FRIZQT__.TTF", 18, "")
    
    -- 点击输入
    dialog.hourFrame:SetScript("OnClick", function()
        StaticPopup_Show("TAMERTIMER_INPUT_HOUR")
    end)
    
    -- 鼠标滚轮
    dialog.hourFrame:SetScript("OnMouseWheel", function(self, delta)
        local hour = tonumber(dialog.hourText:GetText())
        if delta > 0 then
            hour = (hour + 1) % 24
        else
            hour = (hour - 1) % 24
            if hour < 0 then hour = 23 end
        end
        dialog.hourText:SetText(string.format("%02d", hour))
    end)
    
    -- 悬停提示
    dialog.hourFrame:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:SetText("点击输入 | 滚轮调整")
        GameTooltip:Show()
    end)
    dialog.hourFrame:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    
    -- 小时递增按钮
    dialog.hourUp = CreateFrame("Button", nil, dialog)
    dialog.hourUp:SetSize(30, 20)
    dialog.hourUp:SetPoint("BOTTOM", dialog.hourText, "TOP", 0, 2)
    dialog.hourUp.text = dialog.hourUp:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    dialog.hourUp.text:SetPoint("CENTER")
    dialog.hourUp.text:SetText("▲")
    dialog.hourUp.text:SetTextColor(0.7, 0.7, 0.7)
    dialog.hourUp:SetScript("OnClick", function()
        local hour = tonumber(dialog.hourText:GetText())
        hour = (hour + 1) % 24
        dialog.hourText:SetText(string.format("%02d", hour))
    end)
    
    -- 小时递减按钮
    dialog.hourDown = CreateFrame("Button", nil, dialog)
    dialog.hourDown:SetSize(30, 20)
    dialog.hourDown:SetPoint("TOP", dialog.hourText, "BOTTOM", 0, -2)
    dialog.hourDown.text = dialog.hourDown:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    dialog.hourDown.text:SetPoint("CENTER")
    dialog.hourDown.text:SetText("▼")
    dialog.hourDown.text:SetTextColor(0.7, 0.7, 0.7)
    dialog.hourDown:SetScript("OnClick", function()
        local hour = tonumber(dialog.hourText:GetText())
        hour = (hour - 1) % 24
        if hour < 0 then hour = 23 end
        dialog.hourText:SetText(string.format("%02d", hour))
    end)
    
    -- 冒号分隔符
    dialog.colon = dialog:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    dialog.colon:SetPoint("LEFT", dialog.hourText, "RIGHT", 5, 0)
    dialog.colon:SetText(":")
    dialog.colon:SetTextColor(1, 1, 1)
    dialog.colon:SetFont("Fonts\\FRIZQT__.TTF", 18, "")
    
    -- 分钟选择器（可点击、可滚轮）
    dialog.minuteFrame = CreateFrame("Button", nil, dialog)
    dialog.minuteFrame:SetSize(40, 30)
    dialog.minuteFrame:SetPoint("LEFT", dialog.colon, "RIGHT", 5, 0)
    dialog.minuteFrame:EnableMouseWheel(true)
    
    -- 分钟显示文本
    dialog.minuteText = dialog.minuteFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    dialog.minuteText:SetPoint("CENTER")
    dialog.minuteText:SetText("00")
    dialog.minuteText:SetTextColor(1, 1, 1)
    dialog.minuteText:SetFont("Fonts\\FRIZQT__.TTF", 18, "")
    
    -- 点击输入
    dialog.minuteFrame:SetScript("OnClick", function()
        StaticPopup_Show("TAMERTIMER_INPUT_MINUTE")
    end)
    
    -- 鼠标滚轮
    dialog.minuteFrame:SetScript("OnMouseWheel", function(self, delta)
        local minute = tonumber(dialog.minuteText:GetText())
        if delta > 0 then
            minute = (minute + 1) % 60
        else
            minute = (minute - 1) % 60
            if minute < 0 then minute = 59 end
        end
        dialog.minuteText:SetText(string.format("%02d", minute))
    end)
    
    -- 悬停提示
    dialog.minuteFrame:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:SetText("点击输入 | 滚轮调整")
        GameTooltip:Show()
    end)
    dialog.minuteFrame:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    
    -- 分钟递增按钮
    dialog.minuteUp = CreateFrame("Button", nil, dialog)
    dialog.minuteUp:SetSize(30, 20)
    dialog.minuteUp:SetPoint("BOTTOM", dialog.minuteText, "TOP", 0, 2)
    dialog.minuteUp.text = dialog.minuteUp:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    dialog.minuteUp.text:SetPoint("CENTER")
    dialog.minuteUp.text:SetText("▲")
    dialog.minuteUp.text:SetTextColor(0.7, 0.7, 0.7)
    dialog.minuteUp:SetScript("OnClick", function()
        local minute = tonumber(dialog.minuteText:GetText())
        minute = (minute + 1) % 60
        dialog.minuteText:SetText(string.format("%02d", minute))
    end)
    
    -- 分钟递减按钮
    dialog.minuteDown = CreateFrame("Button", nil, dialog)
    dialog.minuteDown:SetSize(30, 20)
    dialog.minuteDown:SetPoint("TOP", dialog.minuteText, "BOTTOM", 0, -2)
    dialog.minuteDown.text = dialog.minuteDown:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    dialog.minuteDown.text:SetPoint("CENTER")
    dialog.minuteDown.text:SetText("▼")
    dialog.minuteDown.text:SetTextColor(0.7, 0.7, 0.7)
    dialog.minuteDown:SetScript("OnClick", function()
        local minute = tonumber(dialog.minuteText:GetText())
        minute = (minute - 1) % 60
        if minute < 0 then minute = 59 end
        dialog.minuteText:SetText(string.format("%02d", minute))
    end)
    
    -- 底部按钮栏
    dialog.buttonBar = CreateFrame("Frame", nil, dialog)
    dialog.buttonBar:SetSize(350, 50)
    dialog.buttonBar:SetPoint("BOTTOM")
    dialog.buttonBar.bg = dialog.buttonBar:CreateTexture(nil, "BACKGROUND")
    dialog.buttonBar.bg:SetAllPoints()
    dialog.buttonBar.bg:SetColorTexture(0.12, 0.14, 0.17, 0.60)
    
    -- 取消按钮
    dialog.cancelBtn = CreateFrame("Button", nil, dialog.buttonBar)
    dialog.cancelBtn:SetSize(80, 28)
    dialog.cancelBtn:SetPoint("RIGHT", -90, 0)
    dialog.cancelBtn.bg = dialog.cancelBtn:CreateTexture(nil, "BACKGROUND")
    dialog.cancelBtn.bg:SetAllPoints()
    dialog.cancelBtn.bg:SetColorTexture(0.3, 0.3, 0.3, 1)
    dialog.cancelBtn.text = dialog.cancelBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    dialog.cancelBtn.text:SetPoint("CENTER")
    dialog.cancelBtn.text:SetText("取消")
    dialog.cancelBtn.text:SetTextColor(1, 1, 1)
    dialog.cancelBtn:SetScript("OnClick", function() dialog:Hide() end)
    
    -- 确定按钮
    dialog.confirmBtn = CreateFrame("Button", nil, dialog.buttonBar)
    dialog.confirmBtn:SetSize(80, 28)
    dialog.confirmBtn:SetPoint("RIGHT", -5, 0)
    dialog.confirmBtn.bg = dialog.confirmBtn:CreateTexture(nil, "BACKGROUND")
    dialog.confirmBtn.bg:SetAllPoints()
    dialog.confirmBtn.bg:SetColorTexture(0.06, 0.73, 0.51, 1)
    dialog.confirmBtn.text = dialog.confirmBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    dialog.confirmBtn.text:SetPoint("CENTER")
    dialog.confirmBtn.text:SetText("设定")
    dialog.confirmBtn.text:SetTextColor(1, 1, 1)
    dialog.confirmBtn:SetScript("OnClick", function()
        local hour = dialog.hourText:GetText()
        local minute = dialog.minuteText:GetText()
        local timeStr = hour .. ":" .. minute
        TamerTimer_SetKillTimeByDateTime(TamerTimer_SetTimePet, TamerTimer_SelectedDay, timeStr)
        dialog:Hide()
    end)
    
    -- 显示对话框时的初始化
    dialog:SetScript("OnShow", function(self)
        TamerTimer_SelectedDay = 0
        self.todayBtn.bg:SetColorTexture(0.06, 0.73, 0.51, 1)
        self.yesterdayBtn.bg:SetColorTexture(0.3, 0.3, 0.3, 1)
        
        -- 设置为当前时间
        local now = date("*t")
        self.hourText:SetText(string.format("%02d", now.hour))
        self.minuteText:SetText(string.format("%02d", now.min))
        
        if TamerTimer_SetTimePet then
            self.petNameText:SetText(TamerTimer_SetTimePet)
        end
    end)
    
    return dialog
end

-- 编辑备注对话框
StaticPopupDialogs["TAMERTIMER_EDIT_NOTE"] = {
    text = "为 %s 添加备注：",
    button1 = "保存",
    button2 = "取消",
    hasEditBox = true,
    maxLetters = 100,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
    OnShow = function(self)
        local petName = TamerTimer_CurrentNotePet
        local currentNote = TamerTimerDB.pets[petName] and TamerTimerDB.pets[petName].notes or ""
        local editBox = _G[self:GetName().."EditBox"]
        if editBox then
            editBox:SetText(currentNote)
            editBox:SetFocus()
            editBox:HighlightText()
        end
    end,
    OnAccept = function(self)
        local petName = TamerTimer_CurrentNotePet
        -- 使用全局名称获取EditBox，确保万无一失
        local editBox = _G[self:GetName().."EditBox"]
        local note = editBox:GetText()
        -- 确保即使看起来没变化也保存
        TamerTimer_SaveNote(petName, note)
    end,
    EditBoxOnEnterPressed = function(self)
        local petName = TamerTimer_CurrentNotePet
        local note = self:GetText()
        TamerTimer_SaveNote(petName, note)
        self:GetParent():Hide()
    end,
    EditBoxOnEscapePressed = function(self)
        self:GetParent():Hide()
    end,
}

local FRAME_WIDTH = 400
local FRAME_HEIGHT = 550
local PET_ITEM_HEIGHT = 72 -- 还原高度，因为布局已优化

-- 创建添加宠物对话框
local function CreateAddPetDialog()
    local dialog = CreateFrame("Frame", "TamerTimerAddPetDialog", UIParent)
    dialog:SetSize(450, 500)
    dialog:SetPoint("CENTER")
    dialog:SetFrameStrata("DIALOG")
    dialog:SetMovable(true)
    dialog:EnableMouse(true)
    dialog:SetClampedToScreen(true)
    dialog:Hide()
    
    -- 背景 - 高透明度深蓝灰
    dialog.bg = dialog:CreateTexture(nil, "BACKGROUND")
    dialog.bg:SetAllPoints()
    dialog.bg:SetColorTexture(0.15, 0.17, 0.20, 0.50)
    
    -- 边框 - 高透明细微边框
    dialog.border = dialog:CreateTexture(nil, "BORDER")
    dialog.border:SetAllPoints()
    dialog.border:SetColorTexture(0.12, 0.14, 0.17, 0.20)
    
    -- 标题栏
    dialog.titleBar = CreateFrame("Frame", nil, dialog)
    dialog.titleBar:SetSize(450, 40)
    dialog.titleBar:SetPoint("TOP")
    dialog.titleBar.bg = dialog.titleBar:CreateTexture(nil, "BACKGROUND")
    dialog.titleBar.bg:SetAllPoints()
    dialog.titleBar.bg:SetColorTexture(0.12, 0.14, 0.17, 0.60)
    
    dialog.title = dialog.titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    dialog.title:SetPoint("LEFT", 16, 0)
    dialog.title:SetText("添加宠物")
    dialog.title:SetTextColor(1, 1, 1)
    
    -- 关闭按钮
    dialog.closeBtn = CreateFrame("Button", nil, dialog.titleBar, "UIPanelCloseButton")
    dialog.closeBtn:SetPoint("TOPRIGHT", -5, -5)
    dialog.closeBtn:SetSize(24, 24)
    dialog.closeBtn:SetScript("OnClick", function() dialog:Hide() end)
    
    -- 拖动
    dialog.titleBar:EnableMouse(true)
    dialog.titleBar:RegisterForDrag("LeftButton")
    dialog.titleBar:SetScript("OnDragStart", function() dialog:StartMoving() end)
    dialog.titleBar:SetScript("OnDragStop", function() dialog:StopMovingOrSizing() end)
    
    -- 提示文字
    dialog.hint = dialog:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    dialog.hint:SetPoint("TOP", 0, -50)
    dialog.hint:SetText("选择要添加到追踪列表的宠物：")
    dialog.hint:SetTextColor(0.71, 0.73, 0.76)
    
    -- 宠物列表滚动框
    dialog.scrollFrame = CreateFrame("ScrollFrame", nil, dialog, "UIPanelScrollFrameTemplate")
    dialog.scrollFrame:SetPoint("TOPLEFT", 10, -75)
    dialog.scrollFrame:SetPoint("BOTTOMRIGHT", -30, 60)
    
    -- 宠物列表容器
    dialog.petList = CreateFrame("Frame", nil, dialog.scrollFrame)
    dialog.petList:SetSize(400, 1)
    dialog.scrollFrame:SetScrollChild(dialog.petList)
    
    dialog.petButtons = {}
    dialog.selectedPet = nil
    
    -- 底部按钮区域
    dialog.buttonBar = CreateFrame("Frame", nil, dialog)
    dialog.buttonBar:SetSize(450, 50)
    dialog.buttonBar:SetPoint("BOTTOM")
    dialog.buttonBar.bg = dialog.buttonBar:CreateTexture(nil, "BACKGROUND")
    dialog.buttonBar.bg:SetAllPoints()
    dialog.buttonBar.bg:SetColorTexture(0.12, 0.14, 0.17, 0.60)
    
    -- 取消按钮
    dialog.cancelBtn = CreateFrame("Button", nil, dialog.buttonBar)
    dialog.cancelBtn:SetSize(100, 32)
    dialog.cancelBtn:SetPoint("RIGHT", -120, 0)
    dialog.cancelBtn:SetFrameStrata("DIALOG")
    
    dialog.cancelBtn.bg = dialog.cancelBtn:CreateTexture(nil, "ARTWORK")
    dialog.cancelBtn.bg:SetAllPoints()
    dialog.cancelBtn.bg:SetColorTexture(0.3, 0.3, 0.3, 1)
    
    dialog.cancelBtn.text = dialog.cancelBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    dialog.cancelBtn.text:SetPoint("CENTER")
    dialog.cancelBtn.text:SetText("取消")
    dialog.cancelBtn.text:SetTextColor(1, 1, 1)
    
    dialog.cancelBtn:EnableMouse(true)
    dialog.cancelBtn:SetScript("OnEnter", function(self)
        self.bg:SetColorTexture(0.4, 0.4, 0.4, 1)
    end)
    dialog.cancelBtn:SetScript("OnLeave", function(self)
        self.bg:SetColorTexture(0.3, 0.3, 0.3, 1)
    end)
    dialog.cancelBtn:SetScript("OnClick", function()
        dialog:Hide()
    end)
    
    -- 确定按钮
    dialog.confirmBtn = CreateFrame("Button", nil, dialog.buttonBar)
    dialog.confirmBtn:SetSize(100, 32)
    dialog.confirmBtn:SetPoint("RIGHT", -10, 0)
    dialog.confirmBtn:SetFrameStrata("DIALOG")
    
    dialog.confirmBtn.bg = dialog.confirmBtn:CreateTexture(nil, "ARTWORK")
    dialog.confirmBtn.bg:SetAllPoints()
    dialog.confirmBtn.bg:SetColorTexture(0.06, 0.73, 0.51, 1)
    
    dialog.confirmBtn.text = dialog.confirmBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    dialog.confirmBtn.text:SetPoint("CENTER")
    dialog.confirmBtn.text:SetText("确定")
    dialog.confirmBtn.text:SetTextColor(1, 1, 1)
    
    dialog.confirmBtn:EnableMouse(true)
    dialog.confirmBtn:SetScript("OnEnter", function(self)
        self.bg:SetColorTexture(0.08, 0.83, 0.61, 1)
    end)
    dialog.confirmBtn:SetScript("OnLeave", function(self)
        self.bg:SetColorTexture(0.06, 0.73, 0.51, 1)
    end)
    dialog.confirmBtn:SetScript("OnClick", function()
        if dialog.selectedPet then
            TamerTimer_AddPetToTracking(dialog.selectedPet)
            dialog:Hide()
        else
            print("|cffff0000[TamerTimer]|r 请先选择一个宠物")
        end
    end)
    
    -- 创建宠物列表项按钮
    local function CreatePetButton(parent, index)
        local btn = CreateFrame("Button", nil, parent)
        btn:SetSize(390, 50)
        btn:SetPoint("TOPLEFT", 5, -(index - 1) * 55)
        
        btn.bg = btn:CreateTexture(nil, "BACKGROUND")
        btn.bg:SetAllPoints()
        btn.bg:SetColorTexture(0.16, 0.18, 0.21, 0.45)
        
        btn.icon = btn:CreateTexture(nil, "ARTWORK")
        btn.icon:SetSize(36, 36)
        btn.icon:SetPoint("LEFT", 8, 0)
        btn.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
        
        btn.name = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        btn.name:SetPoint("LEFT", btn.icon, "RIGHT", 10, 8)
        btn.name:SetTextColor(1, 1, 1)
        
        btn.info = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        btn.info:SetPoint("LEFT", btn.icon, "RIGHT", 10, -8)
        btn.info:SetTextColor(0.71, 0.73, 0.76)
        
        btn:EnableMouse(true)
        btn:SetScript("OnEnter", function(self)
            if not self.selected then
                self.bg:SetColorTexture(0.20, 0.22, 0.25, 0.60)
            end
        end)
        btn:SetScript("OnLeave", function(self)
            if not self.selected then
                self.bg:SetColorTexture(0.16, 0.18, 0.21, 0.45)
            end
        end)
        btn:SetScript("OnClick", function(self)
            -- 取消其他按钮的选中状态
            for _, otherBtn in ipairs(dialog.petButtons) do
                otherBtn.selected = false
                otherBtn.bg:SetColorTexture(0.16, 0.18, 0.21, 0.45)
            end
            
            -- 选中当前按钮
            self.selected = true
            self.bg:SetColorTexture(0.06, 0.73, 0.51, 0.3)
            dialog.selectedPet = self.petName
        end)
        
        return btn
    end
    
    -- 刷新宠物列表
    dialog.RefreshPetList = function(self)
        -- 获取所有可用宠物
        local allPets = TamerTimer_GetAllPetNames()
        local availablePets = {}
        
        -- 过滤掉已经追踪的宠物
        for _, petName in ipairs(allPets) do
            if not TamerTimerDB.pets[petName] then
                table.insert(availablePets, petName)
            end
        end
        
        -- 按名称排序
        table.sort(availablePets)
        
        -- 创建或更新按钮
        for i, petName in ipairs(availablePets) do
            if not self.petButtons[i] then
                self.petButtons[i] = CreatePetButton(self.petList, i)
            end
            
            local btn = self.petButtons[i]
            local petInfo = TamerTimer_GetPetInfo(petName)
            
            btn.petName = petName
            btn.name:SetText(petName)
            btn.info:SetText(string.format("%s - %d级", petInfo.location, petInfo.level))
            btn.icon:SetTexture(petInfo.icon)
            btn.selected = false
            btn.bg:SetColorTexture(0.16, 0.18, 0.21, 0.45)
            btn:Show()
        end
        
        -- 隐藏多余的按钮
        for i = #availablePets + 1, #self.petButtons do
            self.petButtons[i]:Hide()
        end
        
        -- 重置选择
        self.selectedPet = nil
        
        -- 更新滚动高度
        local totalHeight = #availablePets * 55
        self.petList:SetHeight(math.max(totalHeight, 1))
        
        -- 如果没有可添加的宠物
        if #availablePets == 0 then
            if not self.emptyText then
                self.emptyText = self:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
                self.emptyText:SetPoint("CENTER", 0, 20)
                self.emptyText:SetTextColor(0.5, 0.5, 0.5)
            end
            self.emptyText:SetText("所有宠物都已添加到追踪列表")
            self.emptyText:Show()
        else
            if self.emptyText then
                self.emptyText:Hide()
            end
        end
    end
    
    -- 显示对话框时刷新列表
    dialog:SetScript("OnShow", function(self)
        self:RefreshPetList()
    end)
    
    return dialog
end


-- 创建主窗口
local function CreateMainFrame()
    local frame = CreateFrame("Frame", "TamerTimerFrame", UIParent)
    frame:SetSize(FRAME_WIDTH, FRAME_HEIGHT)
    
    -- Restore position
    if TamerTimerDB and TamerTimerDB.settings and TamerTimerDB.settings.windowPos then
        local pos = TamerTimerDB.settings.windowPos
        frame:SetPoint(pos.point, UIParent, pos.relativePoint, pos.x, pos.y)
    else
        frame:SetPoint("CENTER")
    end
    
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:SetClampedToScreen(true)
    frame:SetResizable(true)
    frame:Hide()
    
    -- 背景 - 高透明度深蓝灰
    frame.bg = frame:CreateTexture(nil, "BACKGROUND")
    frame.bg:SetAllPoints()
    frame.bg:SetColorTexture(0.15, 0.17, 0.20, 0.10)
    
    -- 边框 - 高透明细微边框
    frame.border = frame:CreateTexture(nil, "BORDER")
    frame.border:SetAllPoints()
    frame.border:SetColorTexture(0.12, 0.14, 0.17, 0.20)
    frame.border:SetDrawLayer("BORDER", -1)
    
    -- 标题栏
    frame.titleBar = CreateFrame("Frame", nil, frame)
    frame.titleBar:SetSize(FRAME_WIDTH, 40)
    frame.titleBar:SetPoint("TOP")
    
    -- 标题栏背景 - 深蓝灰，60%不透明度
    frame.titleBar.bg = frame.titleBar:CreateTexture(nil, "BACKGROUND")
    frame.titleBar.bg:SetAllPoints()
    frame.titleBar.bg:SetColorTexture(0.12, 0.14, 0.17, 0.20)
    
    -- 标题文字
    frame.title = frame.titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    frame.title:SetPoint("LEFT", 16, 0)
    frame.title:SetText("驯兽师计时器 TamerTimer")
    frame.title:SetTextColor(1, 1, 1)
    
    -- 追踪计数（标题栏右侧，靠在添加按钮左边）
    frame.countText = frame.titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    -- 注意：这里的锚点将在addBtn创建后更新
    frame.countText:SetTextColor(0.71, 0.73, 0.76)
    
    -- 关闭按钮（自定义扁平风格，最右侧）
    frame.closeBtn = CreateFrame("Button", nil, frame.titleBar)
    frame.closeBtn:SetSize(28, 28)
    frame.closeBtn:SetPoint("RIGHT", -6, 0)
    
    frame.closeBtn.bg = frame.closeBtn:CreateTexture(nil, "BACKGROUND")
    frame.closeBtn.bg:SetAllPoints()
    frame.closeBtn.bg:SetColorTexture(0.70, 0.15, 0.15, 1) -- 深红色背景
    
    frame.closeBtn.text = frame.closeBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    frame.closeBtn.text:SetPoint("CENTER", 0, 0)
    frame.closeBtn.text:SetText("×") -- 乘号作为关闭图标
    frame.closeBtn.text:SetTextColor(1, 1, 1)
    frame.closeBtn.text:SetFont("Fonts\\FRIZQT__.TTF", 22, "OUTLINE")
    
    frame.closeBtn:EnableMouse(true)
    frame.closeBtn:SetScript("OnEnter", function(self)
        self.bg:SetColorTexture(0.9, 0.2, 0.2, 1) -- 悬停变亮
    end)
    frame.closeBtn:SetScript("OnLeave", function(self)
        self.bg:SetColorTexture(0.70, 0.15, 0.15, 1)
    end)
    frame.closeBtn:SetScript("OnClick", function()
        frame:Hide()
    end)

    -- 添加宠物按钮（紧邻关闭按钮左侧）
    frame.addBtn = CreateFrame("Button", "TamerTimerAddButton", frame.titleBar)
    frame.addBtn:SetSize(28, 28)
    frame.addBtn:SetPoint("RIGHT", frame.closeBtn, "LEFT", -6, 0)
    
    frame.addBtn.bg = frame.addBtn:CreateTexture(nil, "BACKGROUND")
    frame.addBtn.bg:SetAllPoints()
    frame.addBtn.bg:SetColorTexture(0.96, 0.62, 0.04, 1)
    
    -- 加号文字（替代图标）
    frame.addBtn.text = frame.addBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    frame.addBtn.text:SetPoint("CENTER", 0, 1)
    frame.addBtn.text:SetText("+")
    frame.addBtn.text:SetTextColor(1, 1, 1)
    frame.addBtn.text:SetFont("Fonts\\FRIZQT__.TTF", 20, "OUTLINE")
    
    frame.addBtn:EnableMouse(true)
    frame.addBtn:SetScript("OnEnter", function(self)
        self.bg:SetColorTexture(1, 0.71, 0.14, 1)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        if TamerTimerFrame.isAddMode then
            GameTooltip:SetText("返回追踪列表")
        else
            GameTooltip:SetText("添加宠物")
        end
        GameTooltip:Show()
    end)
    frame.addBtn:SetScript("OnLeave", function(self)
        if TamerTimerFrame.isAddMode then
            self.bg:SetColorTexture(0.3, 0.3, 0.3, 1)
        else
            self.bg:SetColorTexture(0.96, 0.62, 0.04, 1)
        end
        GameTooltip:Hide()
    end)
    frame.addBtn:SetScript("OnClick", function()
        if TamerTimerFrame.isAddMode then
            TamerTimerFrame.isAddMode = false
            frame.addBtn.text:SetText("+")
            frame.addBtn.bg:SetColorTexture(0.96, 0.62, 0.04, 1)
            -- 切换回主界面
            TamerTimerFrame.tabBar:Hide()
            -- TamerTimer_UpdateUI 会处理容器的显示和隐藏以及位置重置
        else
            TamerTimerFrame.isAddMode = true
            frame.addBtn.text:SetText("«")
            frame.addBtn.bg:SetColorTexture(0.3, 0.3, 0.3, 1)
            TamerTimer_ShowAddPetList()
        end
    end)
    frame.addBtn:Show()
    
    -- 设置计数文本位置（紧邻添加按钮左侧）
    frame.countText:SetPoint("RIGHT", frame.addBtn, "LEFT", -10, 0)
    
    -- 移除旧的关闭按钮代码（已替换）

    
    -- 拖动
    frame.titleBar:EnableMouse(true)
    frame.titleBar:RegisterForDrag("LeftButton")
    frame.titleBar:SetScript("OnDragStart", function() frame:StartMoving() end)
    frame.titleBar:SetScript("OnDragStop", function() 
        frame:StopMovingOrSizing() 
        
        -- Save position
        local point, _, relativePoint, x, y = frame:GetPoint()
        TamerTimerDB.settings.windowPos = {
            point = point,
            relativePoint = relativePoint,
            x = x,
            y = y
        }
    end)
    
    
    -- 可调整大小的拖拽区域（右下角）
    frame.resizer = CreateFrame("Button", nil, frame)
frame.resizer:SetSize(16, 16)
    frame.resizer:SetPoint("BOTTOMRIGHT", -2, 2)
    frame.resizer:EnableMouse(true)
    frame.resizer:SetScript("OnMouseDown", function(self)
        frame:StartSizing("BOTTOMRIGHT")
    end)
    frame.resizer:SetScript("OnMouseUp", function(self)
        frame:StopMovingOrSizing()
        -- Save size with validation
        local width, height = frame:GetSize()
        
        -- Force fixed width
        width = FRAME_WIDTH
        
        -- Limit height range (300-800)
        if height < 300 then
            height = 300
        elseif height > 800 then
            height = 800
        end
        
        -- Apply limited size
        frame:SetSize(width, height)
        
        -- Save to DB
        if not TamerTimerDB.settings then
            TamerTimerDB.settings = {}
        end
        TamerTimerDB.settings.windowSize = {
            width = width,
            height = height
        }
    end)
    
    -- 调整大小图标
    frame.resizer.icon = frame.resizer:CreateTexture(nil, "OVERLAY")
    frame.resizer.icon:SetAllPoints()
    frame.resizer.icon:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    
    -- --- 标签栏 (用于添加模式) ---
    frame.tabBar = CreateFrame("Frame", nil, frame)
    frame.tabBar:SetSize(FRAME_WIDTH, 30)
    frame.tabBar:SetPoint("TOPLEFT", 0, -40)
    frame.tabBar:Hide()
    
    frame.tabs = {}
    local tabNames = { "全部", "旧世", "TBC", "WLK", "CTM", "MOP" }
    local tabKeys = { "All", "Classic", "TBC", "WLK", "CTM", "MOP" }
    TamerTimer_CurrentTab = "All"
    
    for i, name in ipairs(tabNames) do
        local tab = CreateFrame("Button", nil, frame.tabBar)
        tab:SetSize(60, 24)
        tab:SetPoint("LEFT", 10 + (i-1)*62, 0)
        
        tab.bg = tab:CreateTexture(nil, "BACKGROUND")
        tab.bg:SetAllPoints()
        tab.bg:SetColorTexture(0.3, 0.3, 0.3, 1)
        
        tab.text = tab:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        tab.text:SetPoint("CENTER")
        tab.text:SetText(name)
        tab.text:SetTextColor(1, 1, 1)
        
        tab.key = tabKeys[i]
        
        tab:SetScript("OnClick", function()
             TamerTimer_CurrentTab = tab.key
             -- Update Tab Visuals
             for _, t in ipairs(frame.tabs) do
                 if t.key == tab.key then
                     t.bg:SetColorTexture(0.96, 0.62, 0.04, 1) -- Active Orange
                 else
                     t.bg:SetColorTexture(0.3, 0.3, 0.3, 1)
                 end
             end
             TamerTimer_ShowAddPetList()
        end)
        
        table.insert(frame.tabs, tab)
    end
    
    -- 容器1：静态容器（无滚动条，用于少量宠物）
    frame.staticContainer = CreateFrame("Frame", nil, frame)
    frame.staticContainer:SetPoint("TOPLEFT", 8, -48)
    frame.staticContainer:SetPoint("BOTTOMRIGHT", -8, 8)
    
    frame.staticPetList = CreateFrame("Frame", nil, frame.staticContainer)
    frame.staticPetList:SetPoint("TOPLEFT")
    frame.staticPetList:SetSize(FRAME_WIDTH - 16, 1)
    
    -- 容器2：滚动容器（带滚动条，用于大量宠物 或 添加模式）
    -- 复用之前的 addScrollFrame，改名为 scrollContainer
    frame.scrollContainer = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
    frame.scrollContainer:SetPoint("TOPLEFT", 8, -48) -- 默认位置（主界面用）
    frame.scrollContainer:SetPoint("BOTTOMRIGHT", -28, 8)
    frame.scrollContainer:Hide()
    
    frame.scrollPetList = CreateFrame("Frame", nil, frame.scrollContainer)
    frame.scrollPetList:SetSize(FRAME_WIDTH - 40, 1)
    frame.scrollContainer:SetScrollChild(frame.scrollPetList)
    
    -- 保持对旧名称的引用以便过渡（可选，但最好直接替换）
    frame.scrollFrame = frame.staticContainer -- 兼容旧代码引用
    frame.petList = frame.staticPetList       -- 兼容旧代码引用
    
    frame.addScrollFrame = frame.scrollContainer -- 兼容添加模式引用
    frame.addPetListContainer = frame.scrollPetList -- 兼容添加模式引用
    frame.addScrollFrame:SetPoint("BOTTOMRIGHT", -28, 8)
    frame.addScrollFrame:Hide() -- 默认隐藏
    
    -- 添加列表容器
    frame.addPetListContainer = CreateFrame("Frame", nil, frame.addScrollFrame)
    frame.addPetListContainer:SetSize(FRAME_WIDTH - 40, 1)
    frame.addScrollFrame:SetScrollChild(frame.addPetListContainer)
    
    frame.petItems = {}
    
    -- 底部工具栏已移除，所有控件已集成到标题栏
    
    -- 恢复保存的窗口大小（在最后执行）
    if TamerTimerDB and TamerTimerDB.settings and TamerTimerDB.settings.windowSize then
        local size = TamerTimerDB.settings.windowSize
        -- 验证大小是否在有效范围内
        if size.height and size.height >= 300 and size.height <= 800 then
            -- 强制使用新的宽度 FRAME_WIDTH，只恢复高度
            frame:SetSize(FRAME_WIDTH, size.height)
        end
    end
    
    return frame
end

-- 创建宠物条目
local function CreatePetItem(parent, index)
    local item = CreateFrame("Button", nil, parent)
    item:SetSize(FRAME_WIDTH - 20, 72) -- 增加宽度，填满容器 (留一点左右间距)
    item:SetPoint("TOPLEFT", 0, -(index - 1) * (72 + 8))
    
    -- 背景 - 高透明度深蓝灰
    item.bg = item:CreateTexture(nil, "BACKGROUND")
    item.bg:SetAllPoints()
    item.bg:SetColorTexture(0.16, 0.18, 0.21, 0.45)
    item.bg:SetDrawLayer("BACKGROUND", 0)

    -- 圆角边框效果 (通过遮罩或多个材质模拟，这里简单用边框)
    item.border = item:CreateTexture(nil, "BORDER")
    item.border:SetAllPoints()
    item.border:SetColorTexture(0,0,0,0) -- Invisible usually
    
    -- 宠物图标 (左侧)
    item.icon = item:CreateTexture(nil, "ARTWORK")
    item.icon:SetSize(32, 32)
    item.icon:SetPoint("TOPLEFT", 12, -12)
    item.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    
    -- 宠物名称 (图标右侧)
    item.name = item:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    item.name:SetPoint("TOPLEFT", item.icon, "TOPRIGHT", 10, 0)
    item.name:SetTextColor(1, 1, 1)
    
    -- 位置/信息 (名称下方)
    item.location = item:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    item.location:SetPoint("TOPLEFT", item.name, "BOTTOMLEFT", 0, -2)
    item.location:SetTextColor(0.71, 0.73, 0.76)
    
    -- 备注文本 (名称右侧,黄色)
    item.noteText = item:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    item.noteText:SetPoint("LEFT", item.name, "RIGHT", 8, 0)
    item.noteText:SetJustifyH("LEFT")
    item.noteText:SetWordWrap(false)
    item.noteText:SetTextColor(1, 0.82, 0)
    item.noteText:SetFont("Fonts\\FRIZQT__.TTF", 12, "")

    -- --- 右上角小按钮 ---
    -- 删除按钮
    item.delBtn = CreateFrame("Button", nil, item)
    item.delBtn:SetSize(18, 18)
    item.delBtn:SetPoint("TOPRIGHT", -8, -8)
    
    -- 删除图标纹理
    item.delBtn.icon = item.delBtn:CreateTexture(nil, "ARTWORK")
    item.delBtn.icon:SetAllPoints()
    item.delBtn.icon:SetTexture("Interface\\Buttons\\UI-GroupLoot-Pass-Up")
    item.delBtn.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    
    item.delBtn:SetScript("OnEnter", function(self)
        self.icon:SetVertexColor(1, 0.3, 0.3)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("删除")
        GameTooltip:Show()
    end)
    item.delBtn:SetScript("OnLeave", function(self)
        self.icon:SetVertexColor(1, 1, 1)
        GameTooltip:Hide()
    end)
    item.delBtn:SetScript("OnClick", function()
        TamerTimerDB.pets[item.petName] = nil
        TamerTimer_UpdateUI()
    end)
    
    -- 设置时间按钮
    item.timeBtn = CreateFrame("Button", nil, item)
    item.timeBtn:SetSize(18, 18)
    item.timeBtn:SetPoint("RIGHT", item.delBtn, "LEFT", -4, 0)
    
    -- 时钟图标纹理
    item.timeBtn.icon = item.timeBtn:CreateTexture(nil, "ARTWORK")
    item.timeBtn.icon:SetAllPoints()
    item.timeBtn.icon:SetTexture("Interface\\Icons\\INV_Misc_PocketWatch_01")
    item.timeBtn.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    
    item.timeBtn:SetScript("OnEnter", function(self)
        self.icon:SetVertexColor(0.96, 0.62, 0.04)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("设置时间")
        GameTooltip:Show()
    end)
    item.timeBtn:SetScript("OnLeave", function(self)
        self.icon:SetVertexColor(1, 1, 1)
        GameTooltip:Hide()
    end)
    item.timeBtn:SetScript("OnClick", function()
        TamerTimer_SetTimePet = item.petName
        if not TamerTimer_SetTimeDialog then
            TamerTimer_SetTimeDialog = CreateSetTimeDialog()
        end
        TamerTimer_SetTimeDialog:Show()
    end)
    
    -- 重置按钮
    item.resetBtn = CreateFrame("Button", nil, item)
    item.resetBtn:SetSize(18, 18)
    item.resetBtn:SetPoint("RIGHT", item.timeBtn, "LEFT", -4, 0)
    
    -- 重置图标纹理
    item.resetBtn.icon = item.resetBtn:CreateTexture(nil, "ARTWORK")
    item.resetBtn.icon:SetAllPoints()
    item.resetBtn.icon:SetTexture("Interface\\Icons\\Ability_Repair")
    item.resetBtn.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    
    item.resetBtn:SetScript("OnEnter", function(self)
        self.icon:SetVertexColor(0.3, 0.8, 1)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("重置计时")
        GameTooltip:Show()
    end)
    item.resetBtn:SetScript("OnLeave", function(self)
        self.icon:SetVertexColor(1, 1, 1)
        GameTooltip:Hide()
    end)
    item.resetBtn:SetScript("OnClick", function()
        TamerTimer_ResetTimer(item.petName)
    end)
    
    -- 编辑备注按钮
    item.noteBtn = CreateFrame("Button", nil, item)
    item.noteBtn:SetSize(18, 18)
    item.noteBtn:SetPoint("RIGHT", item.resetBtn, "LEFT", -4, 0)
    
    -- 备注图标纹理
    item.noteBtn.icon = item.noteBtn:CreateTexture(nil, "ARTWORK")
    item.noteBtn.icon:SetAllPoints()
    item.noteBtn.icon:SetTexture("Interface\\Icons\\INV_Misc_Note_01")
    item.noteBtn.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    
    item.noteBtn:SetScript("OnEnter", function(self)
        self.icon:SetVertexColor(1, 0.9, 0.3)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("编辑备注")
        GameTooltip:Show()
    end)
    item.noteBtn:SetScript("OnLeave", function(self)
        self.icon:SetVertexColor(1, 1, 1)
        GameTooltip:Hide()
    end)
    item.noteBtn:SetScript("OnClick", function()
        TamerTimer_CurrentNotePet = item.petName
        StaticPopup_Show("TAMERTIMER_EDIT_NOTE", item.petName)
    end)
    
    -- 现在按钮创建好了，设置备注文本的右边界
    item.noteText:SetPoint("RIGHT", item.noteBtn, "LEFT", -8, 0)

    -- --- 第二行: 计时器 & 击杀按钮 ---
    
    -- 状态点 (已弃用，因为时间文本移到了进度条上)
    item.statusDot = item:CreateTexture(nil, "OVERLAY")
    item.statusDot:Hide() -- 隐藏
    -- item.statusDot:SetSize(8, 8)
    -- item.statusDot:SetPoint("BOTTOMLEFT", 8, 16)
    -- item.statusDot:SetTexture("Interface\\Common\\Indicator-Gray")
    
    -- 计时器文字 (移动到进度条居中，逻辑已后置)

    -- 击杀按钮 (Big Green Button)
    item.killBtn = CreateFrame("Button", nil, item, "UIPanelButtonTemplate")
    item.killBtn:SetSize(80, 24)
    item.killBtn:SetPoint("BOTTOMRIGHT", -8, 14) -- 向上移动，居中于上方按钮和下方进度条之间
    item.killBtn:SetText("击杀")
    
    -- Custom styling for Kill Button
    item.killBtn.Left:Hide() item.killBtn.Right:Hide() item.killBtn.Middle:Hide() -- Hide default textures
    item.killBtn.bg = item.killBtn:CreateTexture(nil, "BACKGROUND")
    item.killBtn.bg:SetAllPoints()
    item.killBtn.bg:SetColorTexture(0.06, 0.73, 0.51, 1) -- Green
    
    -- 添加击杀图标
    item.killBtn.icon = item.killBtn:CreateTexture(nil, "ARTWORK")
    item.killBtn.icon:SetSize(16, 16)
    item.killBtn.icon:SetPoint("LEFT", 8, 0)
    item.killBtn.icon:SetTexture("Interface\\Icons\\Ability_Rogue_Eviscerate")
    item.killBtn.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    
    -- 调整文字位置，留出图标空间
    item.killBtn:GetFontString():SetPoint("LEFT", item.killBtn.icon, "RIGHT", 4, 0)
    
    item.killBtn:SetNormalFontObject("GameFontHighlight")
    item.killBtn:SetScript("OnEnter", function(self) self.bg:SetColorTexture(0.08, 0.83, 0.61, 1) end)
    item.killBtn:SetScript("OnLeave", function(self) self.bg:SetColorTexture(0.06, 0.73, 0.51, 1) end)
    item.killBtn:SetScript("OnClick", function()
        if item.petName then
            TamerTimer:RecordKill(item.petName)
        end
    end)

    -- 进度条 (底部粗条 - 放大)
    item.progressBar = CreateFrame("StatusBar", nil, item)
    item.progressBar:SetHeight(16) -- 8 -> 16 (放大)
    item.progressBar:SetPoint("BOTTOMLEFT", 0, 0)
    item.progressBar:SetPoint("BOTTOMRIGHT", 0, 0)
    item.progressBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    item.progressBar:SetMinMaxValues(0, 100)
    item.progressBar:SetValue(0)
    
    -- 进度条背景
    item.progressBar.bg = item.progressBar:CreateTexture(nil, "BACKGROUND")
    item.progressBar.bg:SetAllPoints()
    item.progressBar.bg:SetColorTexture(0.1, 0.11, 0.12, 1)

    -- 计时器文字 (现在可以安全创建了，因为progressBar已存在)
    item.timerText = item.progressBar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    item.timerText:SetPoint("CENTER", 0, 1) -- 居中显示
    item.timerText:SetFont("Fonts\\ARIALN.TTF", 14, "OUTLINE") -- 12 -> 14 (放大)
    item.timerText:SetText("")
    item.timerText:SetTextColor(1, 1, 1)

    return item
end

-- 更新UI
function TamerTimer_UpdateUI()
    if not TamerTimerFrame then return end
    
    -- 如果正在添加模式，不要更新（避免覆盖添加列表）
    if TamerTimerFrame.isAddMode then
        return
    end
    
    -- 构建追踪列表
    local trackedPets = {}
    if TamerTimerDB and TamerTimerDB.pets then
        for petName, _ in pairs(TamerTimerDB.pets) do
            table.insert(trackedPets, petName)
        end
    end
    table.sort(trackedPets) -- 排序
    
    -- 更新计数
    if TamerTimerFrame.countText then
        TamerTimerFrame.countText:SetText(#trackedPets .. "/20")
    end

    -- 智能切换容器逻辑
    local useScroll = #trackedPets > 9
    local targetContainer, targetList
    
    if useScroll then
        -- 超过9个，使用滚动容器
        TamerTimerFrame.staticContainer:Hide()
        TamerTimerFrame.scrollContainer:Show()
        TamerTimerFrame.scrollContainer:SetPoint("TOPLEFT", 8, -48) -- 主界面位置
        
        targetContainer = TamerTimerFrame.scrollContainer
        targetList = TamerTimerFrame.scrollPetList
        
        -- 固定高度
        TamerTimerFrame:SetSize(FRAME_WIDTH, 800)
    else
        -- 9个及以下，使用静态容器
        TamerTimerFrame.scrollContainer:Hide()
        TamerTimerFrame.staticContainer:Show()
        
        targetContainer = TamerTimerFrame.staticContainer
        targetList = TamerTimerFrame.staticPetList
        
        -- 高度将在后面自适应计算
    end
    
    -- 强制应用宽度 (防止被Resizable改变或旧配置覆盖)
    TamerTimerFrame:SetWidth(FRAME_WIDTH)

    -- 创建或更新宠物条目
    for i, petName in ipairs(trackedPets) do
        if not TamerTimerFrame.petItems[i] then
            TamerTimerFrame.petItems[i] = CreatePetItem(targetList, i)
        else
            -- 复用已存在的条目，更新父容器
            TamerTimerFrame.petItems[i]:SetParent(targetList)
        end
        
        local item = TamerTimerFrame.petItems[i]
        -- 重新设置位置和大小
        item:ClearAllPoints()
        item:SetPoint("TOPLEFT", 0, -(i - 1) * (PET_ITEM_HEIGHT + 8))
        
        if useScroll then
            item:SetWidth(FRAME_WIDTH - 45) -- 避让滚动条
        else
            item:SetWidth(FRAME_WIDTH - 20) -- 全宽
        end

        local petInfo = TamerTimer_GetPetInfo(petName)
        
        -- Safe call to GetPetStatus
        local success, status = pcall(TamerTimer.GetPetStatus, TamerTimer, petName)
        if not success then
             status = { status="unknown", timerText="Error", progress=0, isAvailable=false }
        end
        
        -- 设置宠物信息
        item.petName = petName
        item.name:SetText(petName)
        item.location:SetText(petInfo and petInfo.location or "未知")
        item.icon:SetTexture(petInfo and petInfo.icon or "Interface\\Icons\\INV_Misc_QuestionMark")
        
        -- 显示备注（如果有）
        local petData = TamerTimerDB.pets[petName]
        if petData and petData.notes and petData.notes ~= "" then
            item.noteText:SetText("(" .. petData.notes .. ")")
            item.noteText:Show()
        else
            item.noteText:Hide()
        end
        
        -- 设置计时器
        item.timerText:SetText(status.timerText)
        item.progressBar:SetValue(status.progress)
        item.progressBar:Show()
        item.statusDot:Show()
        
        -- 设置颜色
        if status.isAvailable then
            item.timerText:SetTextColor(0.06, 0.73, 0.51) -- 绿色
            item.statusDot:SetTexture("Interface\\Common\\Indicator-Green")
            item.progressBar:SetStatusBarColor(0.06, 0.73, 0.51)
        else
            item.timerText:SetTextColor(0.71, 0.73, 0.76) -- 灰色
            item.statusDot:SetTexture("Interface\\Common\\Indicator-Gray")
            item.progressBar:SetStatusBarColor(0.96, 0.62, 0.04) -- 橙色
        end
        
        -- 显示所有功能按钮（追踪模式需要这些）
        item.delBtn:Show()
        item.timeBtn:Show()
        item.resetBtn:Show()
        item.noteBtn:Show()
        item.killBtn:Show()
        
        -- 重置点击事件（追踪模式下条目本身无需点击，使用按钮）
        item:SetScript("OnClick", nil)
        item:RegisterForClicks()
        
        item:Show()
    end
    
    -- 隐藏多余的条目
    for i = #trackedPets + 1, #TamerTimerFrame.petItems do
        TamerTimerFrame.petItems[i]:Hide()
    end
    
    -- 只在静态模式下自动调整高度
    if not useScroll then
        -- 更新滚动框高度
        local totalHeight = #trackedPets * (PET_ITEM_HEIGHT + 8)
        TamerTimerFrame.staticPetList:SetHeight(math.max(totalHeight, 1))
        
        -- 自动调整窗口高度以适应内容
        local titleBarHeight = 40
        local padding = 16
        local idealHeight = titleBarHeight + totalHeight + padding
        idealHeight = math.max(300, math.min(idealHeight, 800))
        
        local _, currentHeight = TamerTimerFrame:GetSize()
        if math.abs(currentHeight - idealHeight) > 5 then
            TamerTimerFrame:SetSize(FRAME_WIDTH, idealHeight)
            if TamerTimerDB and TamerTimerDB.settings then
                if not TamerTimerDB.settings.windowSize then
                    TamerTimerDB.settings.windowSize = {}
                end
                TamerTimerDB.settings.windowSize.height = idealHeight
            end
        end
    else
        -- 滚动模式下，更新内容高度
        local totalHeight = #trackedPets * (PET_ITEM_HEIGHT + 8)
        TamerTimerFrame.scrollPetList:SetHeight(math.max(totalHeight, 1))
    end
end

-- 显示可添加宠物列表
function TamerTimer_ShowAddPetList()
    if not TamerTimerFrame then return end
    
    -- 获取所有可用宠物
    local allPets = TamerTimer_GetAllPetNames()
    local availablePets = {}
    
    -- 隐藏静态容器，显示滚动容器（添加模式始终使用滚动容器）
    TamerTimerFrame.staticContainer:Hide()
    TamerTimerFrame.scrollContainer:Show()
    TamerTimerFrame.tabBar:Show()
    
    -- 调整滚动容器位置以适配标签栏
    TamerTimerFrame.scrollContainer:SetPoint("TOPLEFT", 8, -78)
    
    -- 添加模式固定高度，避免自动调整
    TamerTimerFrame:SetSize(FRAME_WIDTH, 600)

    -- 更新Tab高亮
    for _, t in ipairs(TamerTimerFrame.tabs) do
         if t.key == (TamerTimer_CurrentTab or "All") then
             t.bg:SetColorTexture(0.96, 0.62, 0.04, 1)
         else
             t.bg:SetColorTexture(0.3, 0.3, 0.3, 1)
         end
    end

    -- 过滤掉已经追踪的宠物，并应用Tab筛选
    for _, petName in ipairs(allPets) do
        if not TamerTimerDB.pets[petName] then
            local info = TamerTimer_GetPetInfo(petName)
            local show = false
            local currentTab = TamerTimer_CurrentTab or "All"
            
            if currentTab == "All" then
                show = true
            elseif info and info.expansion == currentTab then
                show = true
            end
            
            if show then
                table.insert(availablePets, petName)
            end
        end
    end
    
    -- 按名称排序
    table.sort(availablePets)
    
    -- 更新计数显示
    TamerTimerFrame.countText:SetText("可添加: " .. #availablePets .. " 个宠物")
    
    -- 创建或更新宠物条目
    for i, petName in ipairs(availablePets) do
        if not TamerTimerFrame.petItems[i] then
            TamerTimerFrame.petItems[i] = CreatePetItem(TamerTimerFrame.addPetListContainer, i)
        else
            -- 复用已存在的条目，需要更新父容器
            TamerTimerFrame.petItems[i]:SetParent(TamerTimerFrame.addPetListContainer)
        end
        
        local item = TamerTimerFrame.petItems[i]
        -- 重新设置位置和大小（添加界面有滚动条，需要窄一点）
        item:ClearAllPoints()
        item:SetPoint("TOPLEFT", 0, -(i - 1) * (PET_ITEM_HEIGHT + 8))
        item:SetWidth(FRAME_WIDTH - 45)
        
        local petInfo = TamerTimer_GetPetInfo(petName)
        
        -- 设置宠物信息
        item.petName = petName
        item.name:SetText(petName)
        
        -- 如果是灵魂兽，添加标记
        if petInfo.isSpirit then
            item.location:SetText(petInfo.location .. " [灵魂兽]")
            item.location:SetTextColor(0.6, 0.8, 1) -- 蓝色
        else
            item.location:SetText(petInfo.location)
            item.location:SetTextColor(0.71, 0.73, 0.76)
        end
        
        item.icon:SetTexture(petInfo and petInfo.icon or "Interface\\Icons\\INV_Misc_QuestionMark")
        
        -- 隐藏所有功能按钮（添加模式不需要这些）
        item.delBtn:Hide()
        item.timeBtn:Hide()
        item.resetBtn:Hide()
        item.noteBtn:Hide()
        item.killBtn:Hide()
        item.noteText:Hide()
        
        -- 设置为可点击添加的样式
        item.timerText:SetText("点击添加")
        item.timerText:SetTextColor(0.06, 0.73, 0.51) -- 绿色
        item.progressBar:SetValue(0)
        item.progressBar:Hide()
        item.statusDot:Hide()
        
        -- 重新注册点击事件（只接受左键）
        item:RegisterForClicks("LeftButtonUp")
        item:SetScript("OnClick", function(self, button)
            if button == "LeftButton" then
                TamerTimer_AddPetToTracking(self.petName)
                -- 添加后自动返回追踪列表
                TamerTimerFrame.isAddMode = false
                TamerTimerFrame.addBtn.text:SetText("+")
                TamerTimerFrame.addBtn.bg:SetColorTexture(0.96, 0.62, 0.04, 1)
                -- 切换回主界面
                TamerTimerFrame.addScrollFrame:Hide()
                TamerTimerFrame.scrollFrame:Show()
                TamerTimerFrame.tabBar:Hide()
                TamerTimer_UpdateUI()
            end
        end)
        
        -- 悬停效果
        item:SetScript("OnEnter", function(self)
            self.bg:SetColorTexture(0.20, 0.22, 0.25, 0.60)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText(self.petName, 1, 1, 1)
            local info = TamerTimer_GetPetInfo(self.petName)
            if info then
                GameTooltip:AddLine(string.format("位置: %s", info.location), 0.7, 0.7, 0.7)
                GameTooltip:AddLine(string.format("等级: %d", info.level), 0.7, 0.7, 0.7)
                GameTooltip:AddLine(string.format("刷新时间: %d-%d 小时", info.minRespawnHours, info.maxRespawnHours), 0.7, 0.7, 0.7)
                if info.isSpirit then
                    GameTooltip:AddLine("灵魂兽 - 需要兽王天赋", 0.6, 0.8, 1)
                end
            end
            GameTooltip:AddLine(" ", 1, 1, 1)
            GameTooltip:AddLine("左键点击添加到追踪列表", 0.06, 0.73, 0.51)
            GameTooltip:Show()
        end)
        item:SetScript("OnLeave", function(self)
            self.bg:SetColorTexture(0.16, 0.18, 0.21, 0.45)
            GameTooltip:Hide()
        end)
        
        item:Show()
    end
    
    -- 隐藏多余的条目
    for i = #availablePets + 1, #TamerTimerFrame.petItems do
        TamerTimerFrame.petItems[i]:Hide()
    end
    
    -- 更新添加列表容器高度
    local totalHeight = #availablePets * (PET_ITEM_HEIGHT + 8)
    TamerTimerFrame.addPetListContainer:SetHeight(math.max(totalHeight, 1))
    
    -- 如果没有可添加的宠物
    if #availablePets == 0 then
        TamerTimerFrame.countText:SetText("所有宠物都已添加")
    end
end

-- 初始化UI（由Core.lua在ADDON_LOADED后调用）
function TamerTimer_InitUI()
    if not TamerTimerFrame then
        TamerTimerFrame = CreateMainFrame()
        TamerTimerAddPetDialog = CreateAddPetDialog()
    end
end


