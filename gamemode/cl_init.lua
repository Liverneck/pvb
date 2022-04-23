//cl only
include("shared.lua")

local fadetime = CreateClientConVar("adn_fadetime", "0.75", true, false, "")

surface.CreateFont("ArcticDamageNum", {
    font = "Bahnschrift", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
    extended = false,
    size = ScreenScale(8),
    weight = 1000,
    antialias = true,
})

surface.CreateFont("ArcticDamageNum_Shadow", {
    font = "Bahnschrift", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
    extended = false,
    size = ScreenScale(8),
    blursize = 4,
    weight = 1000,
    antialias = true,
})

ArcticDamageNumbers = {
    -- {
    --     pos = Vector(0, 0, 0),
    --     life = 1,
    --     num = 15,
    -- }
}

hook.Add("HUDPaint", "Arctic_DamageNum", function()
    local nextadm = {}

    for _, i in pairs(ArcticDamageNumbers) do

        cam.Start3D()

        local spos = i.pos:ToScreen()
        local x = spos.x
        local y = spos.y

        cam.End3D()

        cam.Start2D()

        surface.SetFont("ArcticDamageNum_Shadow")

        local width = surface.GetTextSize(tostring(i.num))

        surface.SetTextColor(0, 0, 0, 255 * i.life)
        surface.SetTextPos(x - (width / 2), y)
        surface.DrawText(tostring(i.num))

        surface.SetFont("ArcticDamageNum")

        surface.SetTextColor(255, 255 - i.num, 255 - i.num, 255 * i.life)
        surface.SetTextPos(x - (width / 2), y)
        surface.DrawText(tostring(i.num))

        i.pos = i.pos + Vector(0, 0, RealFrameTime() * 32)

        i.pos = i.pos + (i.vec * RealFrameTime() * 8)

        i.life = i.life - RealFrameTime() * (1 / fadetime:GetFloat())

        if i.life > 0 then
            table.insert(nextadm, i)
        end

        cam.End2D()
    end

    ArcticDamageNumbers = nextadm
end)

net.Receive("arctic_damagenum", function(len, ply)
    local pos = net.ReadVector()
    local dmg = net.ReadFloat()

    if fadetime:GetFloat() <= 0 then return end

    pos = pos

    dmg = math.Round(dmg, 1)

    table.insert(ArcticDamageNumbers, {
        pos = pos,
        life = 1,
        num = dmg,
        vec = VectorRand()
    })
end)
