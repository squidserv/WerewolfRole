local ROLE = {}

ROLE.nameraw = "werewolf"
ROLE.name = "Werewolf"
ROLE.nameplural = "Werewolves"
ROLE.nameext = " A Werewolf"
ROLE.nameshort = "wrw"

ROLE.desc = [[You are a {role}
 You are a special T. When you are the last T alive you get 2x damage and healed but .5 speed.
Press {menukey} to receive your special equipment!]]

ROLE.team = ROLE_TEAM_TRAITOR

ROLE.shop = {}
ROLE.loadout = {EQUIP_KNIFE}

ROLE.startingcredits = 1

ROLE.startinghealth = nil
ROLE.maxhealth = nil

ROLE.isactive = function(ply)
    return ply:GetNWBool("WerewolfActive", false)
end

ROLE.selectionpredicate = nil
ROLE.shouldactlikejester = nil

ROLE.translations = {}

if SERVER then
    CreateConVar("ttt_werewolf_damage_bonus", 1)
    CreateConVar("ttt_werewolf_announce", 1)
    CreateConVar("ttt_werewolf_full_heal", 1)
    CreateConVar("ttt_werewolf_speed_penalty", 0.5)
    CreateConVar("ttt_werewolf_heal_bonus", 2)
    CreateConVar("ttt_werewolf_damage_reduction", 0)
end

ROLE.convars = {}
table.insert(ROLE.convars, {
    cvar = "ttt_werewolf_damage_bonus",
    type = ROLE_CONVAR_TYPE_NUM
})
table.insert(ROLE.convars, {
    cvar = "ttt_werewolf_damage_reduction",
    type = ROLE_CONVAR_TYPE_NUM
})
table.insert(ROLE.convars, {
    cvar = "ttt_werewolf_announce",
    type = ROLE_CONVAR_TYPE_BOOL
})
table.insert(ROLE.convars, {
    cvar = "ttt_werewolf_full_heal",
    type = ROLE_CONVAR_TYPE_BOOL
})
table.insert(ROLE.convars, {
    cvar = "ttt_werewolf_heal_bonus",
    type = ROLE_CONVAR_TYPE_NUM
})
table.insert(ROLE.convars, {
    cvar = "ttt_werewolf_damage_reduction",
    type = ROLE_CONVAR_TYPE_NUM
})

RegisterRole(ROLE)

if SERVER then
    AddCSLuaFile()

    hook.Add("TTTCanIdentifyCorpse", "ActivatedWerewolfIdentify", function(ply, corpse, was_traitor)
        if ply:IsActiveWerewolf() and ply:IsRoleActive() then
            if corpse:GetCredits() > 0 then
                corpse:SetCredits(0)
            end
            if ply:GetCredits() > 0 then
                ply:SetCredits(0)
            end
        end
    end)

    hook.Add("PlayerDeath", "ActivatedWerewolfPlayerDeath", function(victim, inflictor, attacker)
        local traitors = 0
        local werewolf
        for _, ply in ipairs(player.GetAll()) do
            if IsPlayer(ply) and not ply:IsSpec() and ply:Alive() then
                if ply:IsTraitorTeam() then traitors = traitors + 1 end
                if ply:IsActiveWerewolf() then
                    werewolf = ply
                    if ply:IsRoleActive() and ply:GetCredits() > 0 then
                        ply:SetCredits(0)
                        break
                    end
                end
            end
        end

        if traitors <= 1 and werewolf ~= nil and not werewolf:IsRoleActive() then
            werewolf:SetNWBool("WerewolfActive", true)
            werewolf:SetCredits(0)

            werewolf:PrintMessage(HUD_PRINTTALK, "You transform into a rampaging " .. ROLE_STRINGS_EXT[ROLE_WEREWOLF] .. "!")
            werewolf:PrintMessage(HUD_PRINTCENTER, "You transform into a rampaging " .. ROLE_STRINGS_EXT[ROLE_WEREWOLF] .. "!")

            if GetConVar("ttt_werewolf_announce"):GetBool() then
                for _, p in ipairs(player.GetAll()) do
                    if p ~= werewolf and p:Alive() and not p:IsSpec() then
                        p:PrintMessage(HUD_PRINTTALK, "The last traitor transforms into a rampaging " .. ROLE_STRINGS_EXT[ROLE_WEREWOLF] .. "!")
                        p:PrintMessage(HUD_PRINTCENTER, "The last traitor transforms into a rampaging " .. ROLE_STRINGS_EXT[ROLE_WEREWOLF] .. "!")
                    end
                end
            end

            werewolf:SetMaxHealth(werewolf:GetMaxHealth() * GetConVar("ttt_werewolf_heal_bonus"):GetFloat())

            if GetConVar("ttt_werewolf_full_heal"):GetBool() then
                werewolf:SetHealth(werewolf:GetMaxHealth())
            end
        end
    end)

    hook.Add("TTTSpeedMultiplier", "WerewolfSlow", function(ply, mults)
        if ply:IsActiveWerewolf() and ply:IsRoleActive() then
            table.insert(mults, GetConVar("ttt_werewolf_speed_penalty"):GetFloat())
        end
    end)

    hook.Add("ScalePlayerDamage", "WerewolfDamage", function(ply, hitgroup, dmginfo)
        local att = dmginfo:GetAttacker()
        if IsPlayer(att) and GetRoundState() >= ROUND_ACTIVE and dmginfo:IsBulletDamage()then
            if att:IsActiveWerewolf() and att:IsRoleActive() then
                local bonus = GetConVar("ttt_werewolf_damage_bonus"):GetFloat()
                dmginfo:ScaleDamage(1 + bonus)
            end

            if ply:IsActiveWerewolf() and ply:IsRoleActive() then
                local reduction = GetConVar("ttt_werewolf_damage_reduction"):GetFloat()
                dmginfo:ScaleDamage(1 - reduction)
            end
        end
    end)
end

if CLIENT then
    hook.Add("TTTTutorialRoleText", "WerewolfTutorialRoleText", function(role, titleLabel, roleIcon)
        if role == ROLE_WEREWOLF then
            local roleColorT = ROLE_COLORS(ROLE_TRAITOR)
            local html = "The " .. ROLE_STRINGS[ROLE_WEREWOLF] .. " is an <span style='color: rgb(" .. roleColorT.r .. ", " .. roleColorT.g .. ", " .. roleColorT.b .. ")'>traitor role</span> who rampages when they are the last <span style='color: rgb(" .. roleColorT.r .. ", " .. roleColorT.g .. ", " .. roleColorT.b .. ")'>traitor</span>."
            html = html .. "<ul style='position: relative; top: -15px;'>"
            html = html .. "<li> When the ".. ROLE_STRINGS[ROLE_WEREWOLF] .." rampages it gets increased bullet damage and health but gets a reduced walking speed and can no longer get credits."
            return html .. "</ul>"
        end
    end)
end