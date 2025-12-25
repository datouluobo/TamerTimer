-- TamerTimer Core - 核心逻辑

-- 初始化数据库
if not TamerTimerDB then
    TamerTimerDB = {
        pets = {},
        settings = {
            enabled = true,
            showInGameUI = true,
            soundAlert = true,
        }
    }
end

-- 全局变量（需要在UI.lua中访问）
TamerTimer = CreateFrame("Frame")
local updateTimer = 0
local UPDATE_INTERVAL = 1 -- 每秒更新一次

-- 事件处理
TamerTimer:RegisterEvent("ADDON_LOADED")
TamerTimer:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
TamerTimer:RegisterEvent("PLAYER_LOGOUT")

TamerTimer:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local addonName = ...
        if addonName == "TamerTimer" then
            TamerTimer:OnAddonLoaded()
        end
    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        TamerTimer:OnCombatLog()
    elseif event == "PLAYER_LOGOUT" then
        TamerTimer:OnLogout()
    end
end)

-- 插件加载完成
function TamerTimer:OnAddonLoaded()
    print("|cff00ff00TamerTimer|r - 驯兽师计时器已加载")
    print("|cffaaaaaa输入 /tt、/tamt 或 /tamertimer 打开界面|r")
    
    -- 注册斜杠命令
    SLASH_TAMERTIMER1 = "/tt"
    SLASH_TAMERTIMER2 = "/tamt"
    SLASH_TAMERTIMER3 = "/tamertimer"
    SlashCmdList["TAMERTIMER"] = function(msg)
        TamerTimer:ToggleUI()
    end
    
    -- 初始化UI（确保在TamerTimerDB已加载后）
    TamerTimer_InitUI()
    
    -- 启动更新循环
    self:SetScript("OnUpdate", function(self, elapsed)
        TamerTimer:OnUpdate(elapsed)
    end)
end

-- 战斗日志处理
function TamerTimer:OnCombatLog()
    local timestamp, subEvent, _, sourceGUID, sourceName, _, _, destGUID, destName = CombatLogGetCurrentEventInfo()
    
    -- 检测单位死亡
    if subEvent == "UNIT_DIED" then
        -- 检查是否是玩家击杀
        if sourceGUID == UnitGUID("player") or sourceGUID == UnitGUID("pet") then
            -- 检查是否是稀有宠物
            if TamerTimer_IsRarePet(destName) then
                self:RecordKill(destName)
            end
        end
    end
end

-- 记录击杀
function TamerTimer:RecordKill(petName)
    local currentTime = time()
    local zone = GetZoneText()
    
    -- 保存到数据库
    TamerTimerDB.pets[petName] = {
        lastKillTime = currentTime,
        location = zone,
        killedBy = UnitName("player"),
        notes = TamerTimerDB.pets[petName] and TamerTimerDB.pets[petName].notes or ""  -- 保留原有备注
    }
    
    -- 提示玩家
    print("|cff00ff00[TamerTimer]|r 已记录 |cffff8000" .. petName .. "|r 的击杀时间")
    
    -- 更新UI
    if TamerTimerFrame and TamerTimerFrame:IsShown() then
        TamerTimer_UpdateUI()
    end
end

-- 手动添加宠物到追踪列表
function TamerTimer:AddPetToTracking(petName)
    -- 检查是否已经在追踪
    if TamerTimerDB.pets[petName] then
        return false
    end
    
    -- 检查是否是有效的宠物
    if not TamerTimer_GetPetInfo(petName) then
        return false
    end
    
    -- 添加到追踪列表（未知状态）
    TamerTimerDB.pets[petName] = {
        lastKillTime = nil,  -- 未知状态
        location = nil,
        killedBy = nil,
        notes = ""
    }
    
    -- 更新UI
    if TamerTimerFrame and TamerTimerFrame:IsShown() then
        TamerTimer_UpdateUI()
    end
    
    return true
end
_G.TamerTimer_AddPetToTracking = function(petName) return TamerTimer:AddPetToTracking(petName) end

-- 重置计时器
function TamerTimer:ResetTimer(petName)
    -- 检查宠物是否在追踪列表中
    if not TamerTimerDB.pets[petName] then
        return false
    end
    
    -- 重置为未知状态
    TamerTimerDB.pets[petName] = {
        lastKillTime = nil,
        location = nil,
        killedBy = nil,
        notes = TamerTimerDB.pets[petName].notes or ""  -- 保留备注
    }
    
    -- 更新UI
    if TamerTimerFrame and TamerTimerFrame:IsShown() then
        TamerTimer_UpdateUI()
    end
    
    return true
end
_G.TamerTimer_ResetTimer = function(petName) return TamerTimer:ResetTimer(petName) end

-- 保存备注
function TamerTimer:SaveNote(petName, note)
    -- 检查宠物是否在追踪列表中
    if not TamerTimerDB.pets[petName] then
        return false
    end
    
    -- 保存备注
    TamerTimerDB.pets[petName].notes = note or ""
    
    -- 更新UI
    if TamerTimerFrame and TamerTimerFrame:IsShown() then
        TamerTimer_UpdateUI()
    end
    
    return true
end
_G.TamerTimer_SaveNote = function(petName, note) return TamerTimer:SaveNote(petName, note) end


-- 手动设置击杀时间
function TamerTimer:SetKillTime(petName, hoursAgo)
    -- 检查宠物是否在追踪列表中
    if not TamerTimerDB.pets[petName] then
        return false
    end
    
    -- 计算击杀时间
    local killTime = time() - (hoursAgo * 3600)
    local zone = GetZoneText()
    
    -- 更新数据库
    TamerTimerDB.pets[petName].lastKillTime = killTime
    TamerTimerDB.pets[petName].location = TamerTimerDB.pets[petName].location or zone
    TamerTimerDB.pets[petName].killedBy = TamerTimerDB.pets[petName].killedBy or UnitName("player")
    
    -- 更新UI
    if TamerTimerFrame and TamerTimerFrame:IsShown() then
        TamerTimer_UpdateUI()
    end
    
    return true
end
_G.TamerTimer_SetKillTime = function(petName, hoursAgo) return TamerTimer:SetKillTime(petName, hoursAgo) end

-- 根据日期和时间设置击杀时间
function TamerTimer:SetKillTimeByDateTime(petName, dayOffset, timeStr)
    -- 检查宠物是否在追踪列表中
    if not TamerTimerDB.pets[petName] then
        return false
    end
    
    -- 解析时间字符串 (HH:MM)
    local hour, minute = string.match(timeStr, "(%d+):(%d+)")
    if not hour or not minute then
        print("|cffff0000[TamerTimer]|r 时间格式错误，请使用 HH:MM 格式（如 14:30）")
        return false
    end
    
    hour = tonumber(hour)
    minute = tonumber(minute)
    
    -- 验证时间范围
    if not hour or not minute or hour < 0 or hour > 23 or minute < 0 or minute > 59 then
        print("|cffff0000[TamerTimer]|r 时间范围错误，小时应在0-23，分钟应在0-59")
        return false
    end
    
    -- 获取当前时间
    local now = time()
    local nowDate = date("*t", now)
    
    -- 计算目标时间
    local targetDate = {
        year = nowDate.year,
        month = nowDate.month,
        day = nowDate.day - dayOffset, -- 0 = 今天, 1 = 昨天
        hour = hour,
        min = minute,
        sec = 0
    }
    
    local killTime = time(targetDate)
    local zone = GetZoneText()
    
    -- 更新数据库
    TamerTimerDB.pets[petName].lastKillTime = killTime
    TamerTimerDB.pets[petName].location = TamerTimerDB.pets[petName].location or zone
    TamerTimerDB.pets[petName].killedBy = TamerTimerDB.pets[petName].killedBy or UnitName("player")
    
    -- 更新UI
    if TamerTimerFrame and TamerTimerFrame:IsShown() then
        TamerTimer_UpdateUI()
    end
    
    return true
end
_G.TamerTimer_SetKillTimeByDateTime = function(petName, dayOffset, timeStr) return TamerTimer:SetKillTimeByDateTime(petName, dayOffset, timeStr) end



-- 定时更新
function TamerTimer:OnUpdate(elapsed)
    updateTimer = updateTimer + elapsed
    if updateTimer >= UPDATE_INTERVAL then
        updateTimer = 0
        
        -- 更新UI（如果打开）
        if TamerTimerFrame and TamerTimerFrame:IsShown() then
            TamerTimer_UpdateUI()
        end
    end
end

-- 登出保存
function TamerTimer:OnLogout()
    -- 数据会自动保存到SavedVariables
end

-- 切换UI显示
function TamerTimer:ToggleUI()
    if TamerTimerFrame then
        if TamerTimerFrame:IsShown() then
            TamerTimerFrame:Hide()
        else
            TamerTimerFrame:Show()
            TamerTimer_UpdateUI()
        end
    end
end
_G.TamerTimer_ToggleUI = function() TamerTimer:ToggleUI() end

-- 获取宠物状态
function TamerTimer:GetPetStatus(petName)
    local petData = TamerTimerDB.pets[petName]
    if not petData or not petData.lastKillTime then
        return {
            status = "unknown",
            timerText = "未知",
            progress = 0,
            isAvailable = false
        }
    end
    
    local petInfo = TamerTimer_GetPetInfo(petName)
    if not petInfo then
        return {
            status = "unknown",
            timerText = "未知",
            progress = 0,
            isAvailable = false
        }
    end
    
    local currentTime = time()
    local elapsed = currentTime - petData.lastKillTime
    local minRespawnSeconds = petInfo.minRespawnHours * 3600
    
    if elapsed < minRespawnSeconds then
        -- 倒计时状态
        local remaining = minRespawnSeconds - elapsed
        local hours = math.floor(remaining / 3600)
        local minutes = math.floor((remaining % 3600) / 60)
        local seconds = remaining % 60
        
        return {
            status = "countdown",
            timerText = string.format("%02d:%02d:%02d", hours, minutes, seconds),
            progress = (remaining / minRespawnSeconds) * 100, -- 从100%递减到0%
            isAvailable = false
        }
    else
        -- 蹲守状态 (Camping)
        local campingTime = elapsed - minRespawnSeconds
        local hours = math.floor(campingTime / 3600)
        local minutes = math.floor((campingTime % 3600) / 60)
        local seconds = campingTime % 60
        
        return {
            status = "camping",
            timerText = string.format("蹲守: %02d:%02d:%02d", hours, minutes, seconds),
            progress = 100, -- Full bar
            isAvailable = true
        }
    end
end
