-- TamerTimer Database - 稀有宠物数据库

TamerTimer_PetDatabase = {
    -- 经典稀有宠物
    ["断牙"] = {
        location = "荒芜之地",
        minRespawnHours = 8,
        maxRespawnHours = 10,
        level = 37,
        icon = "Interface\\Icons\\Ability_Hunter_Pet_Cat",
        expansion = "Classic"
    },
    ["碎齿"] = {
        location = "莫高雷",
        minRespawnHours = 5,
        maxRespawnHours = 6,
        level = 80,
        icon = "Interface\\Icons\\Ability_Hunter_Pet_Wolf",
        expansion = "Classic"
    },
    ["破碎者"] = {
        location = "银松森林",
        minRespawnHours = 6,
        maxRespawnHours = 8,
        level = 80,
        icon = "Interface\\Icons\\Ability_Hunter_Pet_Bear",
        expansion = "Classic"
    },
    ["老藓皮"] = {
        location = "希尔斯布莱德丘陵",
        minRespawnHours = 8,
        maxRespawnHours = 12,
        level = 80,
        icon = "Interface\\Icons\\Ability_Hunter_Pet_Turtle",
        expansion = "Classic"
    },
    ["鬼爪"] = {
        location = "洛克莫丹",
        minRespawnHours = 6,
        maxRespawnHours = 8,
        level = 80,
        icon = "Interface\\Icons\\Ability_Hunter_Pet_Crab",
        expansion = "Classic"
    },
    ["萨瓦什"] = {
        location = "贫瘠之地",
        minRespawnHours = 8,
        maxRespawnHours = 10,
        level = 80,
        icon = "Interface\\Icons\\Ability_Hunter_Pet_Ravager",
        expansion = "Classic"
    },
    ["拉克西里"] = { -- Blue Tiger
        location = "冬泉谷",
        minRespawnHours = 8,
        maxRespawnHours = 12,
        level = 57,
        icon = "Interface\\Icons\\Ability_Hunter_Pet_Cat",
        expansion = "Classic"
    },
    ["修玛"] = { -- Black Lion
        location = "贫瘠之地",
        minRespawnHours = 8,
        maxRespawnHours = 12,
        level = 23,
        icon = "Interface\\Icons\\Ability_Hunter_Pet_Cat",
        expansion = "Classic"
    },
    ["希安-罗塔姆"] = { -- White Lion
        location = "冬泉谷",
        minRespawnHours = 8,
        maxRespawnHours = 12,
        level = 60,
        icon = "Interface\\Icons\\Ability_Hunter_Pet_Cat",
        expansion = "Classic"
    },
    
    -- 燃烧的远征 (TBC)
    ["努拉莫克"] = { -- Chimaera
        location = "虚空风暴",
        minRespawnHours = 6,
        maxRespawnHours = 10,
        level = 70,
        icon = "Interface\\Icons\\Ability_Hunter_Pet_Chimera",
        expansion = "TBC"
    },

    -- 巫妖王之怒 (80级) 灵魂兽
    ["洛卡纳哈"] = {
        location = "索拉查盆地",
        minRespawnHours = 8,
        maxRespawnHours = 12,
        level = 80,
        icon = "Interface\\Icons\\Ability_Druid_PrimalTenacity",
        isSpirit = true,
        expansion = "WLK"
    },
    ["阿克图瑞斯"] = {
        location = "灰熊丘陵",
        minRespawnHours = 10,
        maxRespawnHours = 12,
        level = 80,
        icon = "Interface\\Icons\\Ability_Hunter_Pet_Bear",
        isSpirit = true,
        expansion = "WLK"
    },
    ["逐日"] = {
        location = "风暴峭壁",
        minRespawnHours = 6,
        maxRespawnHours = 12,
        level = 80,
        icon = "Interface\\Icons\\Ability_Hunter_Pet_Wolf",
        isSpirit = true,
        expansion = "WLK"
    },
    ["古德利亚"] = {
        location = "祖达克",
        minRespawnHours = 6,
        maxRespawnHours = 12,
        level = 80,
        icon = "Interface\\Icons\\Ability_Hunter_Pet_Cat",
        isSpirit = true,
        expansion = "WLK"
    },
    ["暴龙王克鲁什"] = { -- King Krush
        location = "索拉查盆地",
        minRespawnHours = 6,
        maxRespawnHours = 12,
        level = 80,
        icon = "Interface\\Icons\\Ability_Hunter_Pet_Raptor",
        expansion = "WLK"
    },
    ["奥图纳"] = { -- Aotona
        location = "索拉查盆地",
        minRespawnHours = 6,
        maxRespawnHours = 12,
        level = 80,
        icon = "Interface\\Icons\\Ability_Hunter_Pet_Owl",
        expansion = "WLK"
    },
    
    -- 大灾变 (85级) 灵魂兽
    ["班萨罗斯"] = {
        location = "海加尔山",
        minRespawnHours = 8,
        maxRespawnHours = 12,
        level = 85,
        icon = "Interface\\Icons\\Ability_Hunter_Pet_Owl",
        isSpirit = true,
        expansion = "CTM"
    },
    ["鬼脚蟹"] = {
        location = "瓦斯琪尔",
        minRespawnHours = 8,
        maxRespawnHours = 12,
        level = 85,
        icon = "Interface\\Icons\\Ability_Hunter_Pet_Crab",
        isSpirit = true,
        expansion = "CTM"
    },
    ["卡洛玛"] = {
        location = "暮光高地",
        minRespawnHours = 6,
        maxRespawnHours = 12,
        level = 85,
        icon = "Interface\\Icons\\Ability_Hunter_Pet_Wolf",
        isSpirit = true,
        expansion = "CTM"
    },
    ["安卡"] = {
        location = "海加尔山",
        minRespawnHours = 6, -- Updated per request
        maxRespawnHours = 12,
        level = 85,
        icon = "Interface\\Icons\\Ability_Hunter_Pet_Cat",
        isSpirit = true,
        expansion = "CTM"
    },
    ["玛格瑞亚"] = {
        location = "海加尔山",
        minRespawnHours = 6, -- Updated per request
        maxRespawnHours = 12,
        level = 85,
        icon = "Interface\\Icons\\Ability_Hunter_Pet_Cat",
        isSpirit = true,
        expansion = "CTM"
    },
    ["桑巴斯"] = {
        location = "暮光高地",
        minRespawnHours = 8,
        maxRespawnHours = 12,
        level = 85,
        icon = "Interface\\Icons\\Ability_Hunter_Pet_Cat",
        expansion = "CTM"
    },
    ["泰罗佩内"] = {
        location = "海加尔山",
        minRespawnHours = 8,
        maxRespawnHours = 12,
        level = 85,
        icon = "Interface\\Icons\\Ability_Hunter_Pet_Turtle",
        expansion = "CTM"
    },
    ["梅迪克西斯"] = {
        location = "奥丹姆",
        minRespawnHours = 6,
        maxRespawnHours = 12,
        level = 85,
        icon = "Interface\\Icons\\Ability_Hunter_Pet_Scorpid",
        expansion = "CTM"
    },
    ["翡翠牙"] = {
        location = "深岩之洲",
        minRespawnHours = 6,
        maxRespawnHours = 12,
        level = 85,
        icon = "Interface\\Icons\\Ability_Hunter_Pet_Spider",
        expansion = "CTM"
    },
    ["斯卡尔"] = {
        location = "熔火前线",
        minRespawnHours = 4,
        maxRespawnHours = 8,
        level = 85,
        icon = "Interface\\Icons\\Ability_Hunter_Pet_Cat",
        expansion = "CTM"
    },
    ["卡尔金"] = {
        location = "熔火前线",
        minRespawnHours = 4,
        maxRespawnHours = 8,
        level = 85,
        icon = "Interface\\Icons\\Ability_Hunter_Pet_Crab",
        expansion = "CTM"
    },
    ["德斯蒂拉克"] = {
        location = "熔火前线",
        minRespawnHours = 4,
        maxRespawnHours = 12,
        level = 85,
        icon = "Interface\\Icons\\Ability_Hunter_Pet_Spider",
        expansion = "CTM"
    },
    
    -- 熊猫人之谜 (90级) 灵魂兽
    ["咕米"] = {
        location = "昆莱山",
        minRespawnHours = 6,
        maxRespawnHours = 12,
        level = 90,
        icon = "Interface\\Icons\\inv_pet_porcupine",
        isSpirit = true,
        expansion = "MOP"
    },
    ["德古"] = {
        location = "四风谷",
        minRespawnHours = 6,
        maxRespawnHours = 12,
        level = 90,
        icon = "Interface\\Icons\\inv_pet_porcupine",
        isSpirit = true,
        expansion = "MOP"
    },
    ["胡提亚"] = {
        location = "翡翠林",
        minRespawnHours = 6,
        maxRespawnHours = 12,
        level = 90,
        icon = "Interface\\Icons\\inv_pet_porcupine",
        isSpirit = true,
        expansion = "MOP"
    },
    
    -- 其他
    ["洛克"] = {
        location = "萨塔拉斯",
        minRespawnHours = 6,
        maxRespawnHours = 12,
        level = 85,
        icon = "Interface\\Icons\\Ability_Hunter_Pet_CoreHound",
        expansion = "Classic"
    },
    ["巴恩"] = {
        location = "艾尔文森林",
        minRespawnHours = 4,
        maxRespawnHours = 6,
        level = 85,
        icon = "Interface\\Icons\\Ability_Hunter_Pet_Spider",
        expansion = "Classic"
    },
}

-- 根据名称获取宠物信息
function TamerTimer_GetPetInfo(petName)
    return TamerTimer_PetDatabase[petName]
end

-- 检查是否是稀有宠物
function TamerTimer_IsRarePet(petName)
    return TamerTimer_PetDatabase[petName] ~= nil
end

-- 获取所有宠物名称列表
function TamerTimer_GetAllPetNames()
    local names = {}
    for name, _ in pairs(TamerTimer_PetDatabase) do
        table.insert(names, name)
    end
    return names
end
