SpellHistoryBar = SpellHistoryBar or {}
SpellHistoryBarSettings = SpellHistoryBarSettings or {}

-- Frame principal
local SHB = CreateFrame("frame", "SpellHistoryBarFrame", UIParent)
SHB:SetSize(300, 40)
SHB:SetPoint("CENTER", UIParent, "CENTER", 0, -200)
SHB:SetFrameStrata("MEDIUM")
SHB:SetClampedToScreen(true)
SHB:EnableMouse(true)
SHB:SetMovable(true)
SHB:RegisterForDrag("LeftButton")

local DEFAULTS = {
    point = {"CENTER", UIParent, "CENTER", 0, -200},
    iconSize = 32,
    iconSpacing = 4,
    maxIcons = 8,
    fadeTime = 8,
    locked = true,
}

local icons = {}
local recentSpells = {}
local CONTROL_SPELLS = SpellHistoryBar.CONTROL_SPELLS or {}
local BLACKLIST_SPELLS = SpellHistoryBar.BLACKLIST_SPELLS or {}
local PROJECTILE_SPELLS = SpellHistoryBar.PROJECTILE_SPELLS or {}
local CAST_START_SPELLS = SpellHistoryBar.CAST_START_SPELLS or {}

local function PrintMessage(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00SpellHistoryBar:|r " .. msg)
end

local function ApplyDefaults()
    if not SpellHistoryBarSettings.point then
        SpellHistoryBarSettings.point = {unpack(DEFAULTS.point)}
    end
    if not SpellHistoryBarSettings.iconSize then
        SpellHistoryBarSettings.iconSize = DEFAULTS.iconSize
    end
    if not SpellHistoryBarSettings.iconSpacing then
        SpellHistoryBarSettings.iconSpacing = DEFAULTS.iconSpacing
    end
    if not SpellHistoryBarSettings.maxIcons then
        SpellHistoryBarSettings.maxIcons = DEFAULTS.maxIcons
    end
    if not SpellHistoryBarSettings.fadeTime then
        SpellHistoryBarSettings.fadeTime = DEFAULTS.fadeTime
    end
    if SpellHistoryBarSettings.locked == nil then
        SpellHistoryBarSettings.locked = DEFAULTS.locked
    end
end

local function SaveAnchor()
    local point, _, relativePoint, xOffset, yOffset = SHB:GetPoint()
    if point and relativePoint then
        SpellHistoryBarSettings.point = {point, "UIParent", relativePoint, xOffset, yOffset}
    end
end

local function GetSetting(name)
    local value = SpellHistoryBarSettings[name]
    if name == "iconSize" or name == "iconSpacing" or name == "maxIcons" or name == "fadeTime" then
        value = tonumber(value)
    end
    if value == nil then
        value = DEFAULTS[name]
    end
    return value
end

local function UpdateIcons()
    local iconSize = GetSetting("iconSize")
    local spacing = GetSetting("iconSpacing")

    for i, icon in ipairs(icons) do
        icon:ClearAllPoints()
        icon:SetPoint("LEFT", SHB, "LEFT", (i-1) * (iconSize + spacing), 0)
        icon:SetSize(iconSize, iconSize)
    end
end

local function UpdateFrame()
    local iconSize = GetSetting("iconSize")
    local spacing = GetSetting("iconSpacing")
    local maxIcons = GetSetting("maxIcons")
    local point = SpellHistoryBarSettings.point or DEFAULTS.point

    -- Fix for saved settings with "UIParent" as string
    if type(point[2]) == "string" and point[2] == "UIParent" then
        point = {point[1], UIParent, point[3], point[4], point[5]}
    elseif point[2] ~= UIParent then
        point = DEFAULTS.point
    end

    local width = math.max(iconSize, (iconSize + spacing) * maxIcons - spacing)
    local height = iconSize
    SHB:SetSize(width, height)
    SHB:SetPoint(unpack(point))
    if SHB.bg then
        SHB.bg:SetAllPoints(SHB)
    end
    if SpellHistoryBarSettings.locked then
        SHB:EnableMouse(false)
    else
        SHB:EnableMouse(true)
    end
    UpdateIcons()
end

local function CreateIcon(texture)
    local iconSize = GetSetting("iconSize")
    local icon = SHB:CreateTexture(nil, "ARTWORK")
    icon:SetSize(iconSize, iconSize)
    icon:SetTexture(texture)
    icon:SetAlpha(1)
    icon.time = GetTime()
    return icon
end

local function AddSpell(spellID)
    if BLACKLIST_SPELLS[spellID] then
        return
    end

    if recentSpells[spellID] and GetTime() - recentSpells[spellID] < 0.5 then
        return
    end
    recentSpells[spellID] = GetTime()
    local texture = GetSpellTexture(spellID)
    if not texture then
        return
    end
    local icon = CreateIcon(texture)
    table.insert(icons, 1, icon)
    local maxIcons = GetSetting("maxIcons")
    if #icons > maxIcons then
        icons[#icons]:Hide()
        table.remove(icons)
    end
    UpdateIcons()
end

local function OnUpdate(self, elapsed)
    local now = GetTime()
    local fadeTime = GetSetting("fadeTime")
    for i = #icons, 1, -1 do
        local icon = icons[i]
        local age = now - icon.time
        if age > fadeTime then
            icon:Hide()
            table.remove(icons, i)
            UpdateIcons()
        else
            icon:SetAlpha(1 - (age / fadeTime))
        end
    end
end

local function ShowHelp()
    PrintMessage("Comandos disponibles:")
    PrintMessage("/shb help - muestra este mensaje")
    PrintMessage("/shb move - alterna el modo de movimiento")
    PrintMessage("/shb size <16-64> - ajusta el tamaño de los iconos")
    PrintMessage("/shb max <1-10> - ajusta la cantidad máxima de iconos")
    PrintMessage("/shb reset - restaurar valores predeterminados")
end

local function SetIconSize(size)
    size = tonumber(size) or 0
    size = math.max(16, math.min(64, size))
    SpellHistoryBarSettings.iconSize = size
    UpdateFrame()
    PrintMessage("Tamaño de icono ajustado a " .. size)
end

local function SetMaxIcons(value)
    value = tonumber(value) or 0
    value = math.max(1, math.min(10, value))
    SpellHistoryBarSettings.maxIcons = value
    UpdateFrame()
    PrintMessage("Máximo de iconos ajustado a " .. value)
end

local function ToggleMove()
    SpellHistoryBarSettings.locked = not SpellHistoryBarSettings.locked
    UpdateFrame()
    if SpellHistoryBarSettings.locked then
        PrintMessage("Barra bloqueada. Usa /shb move para desbloquear.")
    else
        PrintMessage("Barra desbloqueada. Arrastra la barra para moverla.")
    end
end

SlashCmdList.SPELLHISTORYBAR = function(msg)
    local command, arg = msg:match("^(%S*)%s*(.-)%s*$")
    command = command:lower()
    if command == "" or command == "help" then
        ShowHelp()
    elseif command == "move" then
        ToggleMove()
    elseif command == "size" then
        if arg == "" then
            PrintMessage("Uso: /shb size <16-64>")
        else
            SetIconSize(arg)
        end
    elseif command == "max" then
        if arg == "" then
            PrintMessage("Uso: /shb max <1-10>")
        else
            SetMaxIcons(arg)
        end
    elseif command == "reset" then
        SpellHistoryBarSettings = {}
        ApplyDefaults()
        UpdateFrame()
        PrintMessage("Configuración restaurada a valores predeterminados.")
    else
        PrintMessage("Comando desconocido. Usa /shb help.")
    end
end
SLASH_SPELLHISTORYBAR1 = "/shb"

-- Visual de la barra
SHB.bg = SHB:CreateTexture(nil, "BACKGROUND")
SHB.bg:SetAllPoints(SHB)
SHB.bg:SetTexture(0, 0, 0, 0.25)

SHB.title = SHB:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
SHB.title:SetPoint("CENTER", SHB, "CENTER", 0, 0)
SHB.title:SetText("SpellHistoryBar")
SHB.title:SetTextColor(1, 1, 1, 0.85)

SHB:SetScript("OnDragStart", function(self)
    if not SpellHistoryBarSettings.locked then
        self:StartMoving()
    end
end)

SHB:SetScript("OnDragStop", function(self)
    if not SpellHistoryBarSettings.locked then
        self:StopMovingOrSizing()
        SaveAnchor()
    end
end)

SHB:SetScript("OnUpdate", OnUpdate)

ApplyDefaults()
UpdateFrame()

SHB:RegisterEvent("ADDON_LOADED")
SHB:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
SHB:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local addonName = ...
        if addonName == "SpellHistoryBar" then
            ApplyDefaults()
            UpdateFrame()
            return
        end
    end

    local timestamp, subevent, hideCaster,
          sourceGUID, sourceName, sourceFlags, sourceRaidFlags,
          destGUID, destName, destFlags, destRaidFlags,
          spellID, spellName = ...

    if not sourceGUID or sourceGUID ~= UnitGUID("player") then
        return
    end

    if subevent == "SPELL_CAST_SUCCESS"
    or subevent == "SPELL_HEAL"
    or subevent == "SPELL_SUMMON"
    or (subevent == "SPELL_CAST_START" and CAST_START_SPELLS[spellID])
    or (subevent == "SPELL_DAMAGE" and not PROJECTILE_SPELLS[spellID]) then
        if spellID and spellID > 0 then
            AddSpell(spellID)
        end
    end

    if CONTROL_SPELLS[spellID] and subevent == "SPELL_AURA_APPLIED" then
        if spellID and spellID > 0 then
            AddSpell(spellID)
        end
    end
end)
