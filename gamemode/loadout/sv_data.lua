local DefaultTable = {
	{["tfa_cso_ak47"] = 1},			//Default
	{},												//Rarity 1
	{},												//Rarity 2
	{},												//Rarity 3
	{},												//Rarity 4
	{["weapon_fists"] = 1},							//Mele
	{["weapon_medkit"] = 1},						//Extra
	{/*["models/player/urban.mdl"] = {1, "Urban"}*/},	//Skins
}

function PVB:GetItems(ply)
	return util.TableToJSON(PVB.Config.DefaultItems)
end

function PVB:SaveData(ply)
	if IsValid(ply) then
		ply:SetPData("PVB_Items", table.concat(ply.PVB_Items, ";"))
		return
	end
	for k,v in pairs(player.GetAll()) do
		PrintTable(v.PVB_Items)
		v:SetPData("PVB_Items", table.concat(v.PVB_Items, ";"))
	end
end

function PVB:GiveWeapon(ply, weaponName, rarity)
	rarity = rarity + 1 //cause numbers start at 1 apparently and break everything
	if(!ply:IsBot()) then
		playersCurrent = util.JSONToTable(PVB:GetItems(ply))
		
		table.Add(weaponName,table.Inherit(playersCurrent[rarity],{[weaponName] = 1}))
		
		
		//table.Add(playersCurrent[rarity][weaponName],1)
		//table.Add(weaponName,table.Inherit(playersCurrent[rarity],{weaponName = 1}))

		table.remove(playersCurrent[rarity], 0)
		//table.RemoveByValue(playersCurrent[rarity], "BaseClass" )
		
		
		ply:SetPData("PVB_Items", util.TableToJSON(playersCurrent))
		print("[PVBGAMEMODE] Has just given " .. ply:Nick() .. " a " .. weaponName  .. " of rarity id: " .. rarity .. ".")
	end
end


hook.Add("PlayerInitialSpawn", "PVB.LoadData", function(ply)
	ply.PVB_Items = PVB.Config.DefaultItems
end)
