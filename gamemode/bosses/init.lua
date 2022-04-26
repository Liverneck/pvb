PVB.BossList = {}
local P = 0

Meta_BOSS = {}
Meta_BOSS.__index = Meta_BOSS

function PVB.RegisterBossClass(tbl)
	P = P + 1

	PVB.BossList[P] = tbl

	setmetatable(tbl, Meta_BOSS)
end

local BossFiles,_ = file.Find("pvb/gamemode/bosses/*", "LUA")
for _,File in pairs(BossFiles) do
	if File != "init.lua" then
		AddCSLuaFile(File)
		include(File)
	end
end
