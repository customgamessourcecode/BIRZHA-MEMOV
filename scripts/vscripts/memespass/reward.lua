if MEMESPASS == nil then
MEMESPASS = class({})
end

MEMESPASS_REWARD_TABLE = {}
MEMESPASS_REWARD_NAME = {}
MEMESPASS_REWARD_TABLE[1] = "reward1" -- Абибасы
MEMESPASS_REWARD_TABLE[2] = "reward2" -- Фраза Кадета
MEMESPASS_REWARD_TABLE[3] = "reward3" -- Эффект фонтана
MEMESPASS_REWARD_TABLE[4] = "reward4" -- Фраза Йобаный рот
MEMESPASS_REWARD_TABLE[5] = "reward5" -- Эффект Балдежа 1
MEMESPASS_REWARD_TABLE[6] = "reward6" -- Фраза Да это жеско
MEMESPASS_REWARD_TABLE[7] = "reward7" -- Эффект смерти
MEMESPASS_REWARD_TABLE[8] = "reward8" -- Графити KappaPride
MEMESPASS_REWARD_TABLE[9] = "reward9" -- Фраза  Нихуя не понял, но очень интересно
MEMESPASS_REWARD_TABLE[10] = "reward10" -- Эффект спиннера
MEMESPASS_REWARD_TABLE[11] = "reward11" -- Уникальный эффект
MEMESPASS_REWARD_TABLE[12] = "reward12" -- Фраза Жрать жри его
MEMESPASS_REWARD_TABLE[14] = "reward14" -- Графити Орех
MEMESPASS_REWARD_TABLE[15] = "reward15" -- Аркана на невера
MEMESPASS_REWARD_TABLE[17] = "reward17" -- Фраза Ярик Бочок потик
MEMESPASS_REWARD_TABLE[19] = "reward19" -- Фраза Dread Черепаха
MEMESPASS_REWARD_TABLE[20] = "reward20" -- Эффект Балдежа 2
MEMESPASS_REWARD_TABLE[22] = "reward22" -- Фраза Кадета 2
MEMESPASS_REWARD_TABLE[24] = "reward24" -- Фраза Папича Хэээлп
MEMESPASS_REWARD_TABLE[25] = "reward25" -- Эффект Пидорской Бабочки
MEMESPASS_REWARD_TABLE[27] = "reward27" -- Фраза
MEMESPASS_REWARD_TABLE[29] = "reward29" -- Граффити RoflanEbalo
MEMESPASS_REWARD_TABLE[30] = "reward30" -- Модель На версуту
MEMESPASS_REWARD_TABLE[32] = "reward32" -- Фраза Ты поторопись у нас щас обед
MEMESPASS_REWARD_TABLE[35] = "reward35" -- Эффект Уебатора
MEMESPASS_REWARD_TABLE[36] = "reward36" -- Граффити Penguin
MEMESPASS_REWARD_TABLE[40] = "reward40" -- Эффект Балдежа 3
MEMESPASS_REWARD_TABLE[44] = "reward44" -- Фраза я крокодил
MEMESPASS_REWARD_TABLE[45] = "reward45" -- Модель На Сильвера
MEMESPASS_REWARD_TABLE[50] = "reward50" -- Фраза голосование
MEMESPASS_REWARD_TABLE[55] = "reward55" -- Chicken frostmourne
MEMESPASS_REWARD_TABLE[57] = "reward57" -- Граффити Рикардо милос
MEMESPASS_REWARD_TABLE[100] = "reward100" -- Рейтинговый усилитель

CustomNetTables:SetTableValue("memespass", "rewards", {reward = MEMESPASS_REWARD_TABLE})

for lvl,name in pairs (MEMESPASS_REWARD_TABLE) do
MEMESPASS_REWARD_NAME[name] = lvl
end

function IsUnlockedInPass(id, reward)
local table = CustomNetTables:GetTableValue("birzhainfo", tostring(id))
	if table then
	local hero_lvl = CustomNetTables:GetTableValue("birzhainfo", tostring(id)).lvl
		if hero_lvl >= MEMESPASS_REWARD_NAME[reward] then
		return true
		end
	end
return nil
end

	
	
	
	
	
	
	
	
	
	
	
	