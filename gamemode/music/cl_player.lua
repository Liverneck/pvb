local ActiveSong = ActiveSong or nil

//Temp changed boss music to false by default until further notice
local EnableSongs = CreateClientConVar("pvb_enablebossmusic", 0, true, false, "Set to 0 to disable music, 1 to enable music. Clientside only.")

cvars.AddChangeCallback("pvb_enablebossmusic", function(cvar, old, new)
	local BossInt = PVB.TRANSMITTER:GetBossInt()
	if tonumber(new) != 0 and BossInt == -1 then return end
	if tonumber(new) == 0 then
		PVB:FadeMusic()
	else
		PVB:ChangeMusic(true, BossInt)
	end
end, "PVB.OnMusicToggled")

local ActiveSong = ActiveSong or 1
local cache = {} or nil
function PVB:ChangeMusic(Play, BossID)
	if Play and EnableSongs:GetBool() and BossID != -1 then
		local SongList = PVB.BossList[BossID].Music
		ActiveSong = math.random(#SongList)
		if type(SongList[ActiveSong]) != "IGModAudioChannel" then
			if string.Left(SongList[ActiveSong], 4) != "http" then
				sound.PlayFile("sound/"..SongList[ActiveSong], "noblock mono", function(stationmusic)
					if IsValid(stationmusic) then
						cache = SongList[ActiveSong]
						SongList[ActiveSong] = stationmusic
						stationmusic:EnableLooping(true)
						stationmusic:SetVolume( 5 )
						stationmusic:Play()
					end
				end)
			else
				sound.PlayURL( songurl, "noblock mono", function(station)
					if IsValid(station) then
						cache = SongList[ActiveSong]
						station:EnableLooping(true)
						station:SetVolume( 5 )
						station:Play()
					end
				end)
			end
		else
			sound.PlayFile("sound/"..cache, "noblock mono", function(stationmusic)
				if IsValid(stationmusic) then
					SongList[ActiveSong] = cache
					cache = stationmusic
					stationmusic:EnableLooping(true)
					stationmusic:SetVolume( 5 )
					stationmusic:Play()
				end
			end)
		end
	end
end

net.Receive("PVB.UpdateMusicState", function(len)
	local DoSong = net.ReadBool()
	local BossID = PVB.TRANSMITTER:GetBossInt()
	PVB:ChangeMusic(DoSong, BossID)
end)

hook.Add("InitPostEntity", "PVB.Music.OnJoin", function()
	timer.Simple(0, function()
		local BossID = PVB.TRANSMITTER:GetBossInt()
		PVB:ChangeMusic(true, BossID)
	end)
end)

hook.Add("PlayerSay","PVB.MusicToggleCommand", function(  ply, text,  teamChat )
	if(ply == LocalPlayer()) then
		if(text == "!music") then
			if(EnableSongs:GetInt() == 1) then
				RunConsoleCommand( "pvb_enablebossmusic 0")
			
			end
			if(EnableSongs:GetInt() == 0) then
				RunConsoleCommand( "pvb_enablebossmusic 0")
			end
			print("Music Toggled")
		end
	end
end)