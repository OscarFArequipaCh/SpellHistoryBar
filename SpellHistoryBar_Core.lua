-- ============================================================================
-- SpellHistoryBar_Core.lua
-- Módulo Principal - Lógica de Detección de Hechizos y Actualización
-- ============================================================================

SpellHistoryBar.Core = SpellHistoryBar.Core or {}

-- Estado interno del módulo
local internalState = {
    recentSpells = {},
}

-- Cargar referencias a las tablas de hechizos (se cargan desde SpellHistoryBarSpellLists.lua)
local CONTROL_SPELLS = SpellHistoryBar.CONTROL_SPELLS or {}
local BLACKLIST_SPELLS = SpellHistoryBar.BLACKLIST_SPELLS or {}
local PROJECTILE_SPELLS = SpellHistoryBar.PROJECTILE_SPELLS or {}
local CAST_START_SPELLS = SpellHistoryBar.CAST_START_SPELLS or {}

-- ============================================================================
-- Añadir Hechizo a la Barra
-- ============================================================================

function SpellHistoryBar.Core:AddSpell(spellID)
    -- Comprobar si el hechizo está en la lista negra
    if BLACKLIST_SPELLS[spellID] then
        return
    end
    
    -- Evitar duplicados muy rápidos (mismo hechizo en menos de 0.5 segundos)
    if internalState.recentSpells[spellID] and GetTime() - internalState.recentSpells[spellID] < 0.5 then
        return
    end
    
    -- Registrar tiempo del hechizo
    internalState.recentSpells[spellID] = GetTime()
    
    -- Obtener textura del hechizo
    local texture = GetSpellTexture(spellID)
    if not texture then
        return
    end
    
    -- Crear icono usando el módulo UI
    local icon = SpellHistoryBar.UI:CreateIcon(texture)
    if not icon then
        return
    end
    
    -- Añadir icono a la barra
    SpellHistoryBar.UI:AddIconToBar(icon)
end

-- ============================================================================
-- Actualizar Frame (Desvanecimiento de Iconos)
-- ============================================================================

function SpellHistoryBar.Core:OnFrameUpdate(elapsed)
    local now = GetTime()
    local fadeTime = SpellHistoryBar:Get("fadeTime")
    local icons = SpellHistoryBar.UI:GetIcons()
    
    -- Iterar en orden inverso para permitir eliminación segura
    for i = #icons, 1, -1 do
        local icon = icons[i]
        local age = now - icon.time
        
        -- Si el icono ha alcanzado su tiempo de vida máximo
        if age > fadeTime then
            SpellHistoryBar.UI:RemoveIconAtIndex(i)
        else
            -- Actualizar transparencia (fade out)
            icon:SetAlpha(1 - (age / fadeTime))
        end
    end
end

-- ============================================================================
-- Procesar Evento del Combat Log
-- ============================================================================

function SpellHistoryBar.Core:ProcessCombatLogEvent(...)
    local timestamp, subevent, hideCaster,
          sourceGUID, sourceName, sourceFlags, sourceRaidFlags,
          destGUID, destName, destFlags, destRaidFlags,
          spellID, spellName = ...
    
    -- Filtrar: solo hechizos del jugador
    if not sourceGUID or sourceGUID ~= UnitGUID("player") then
        return
    end
    
    -- Detectar hechizos exitosos
    if subevent == "SPELL_CAST_SUCCESS"
    or subevent == "SPELL_HEAL"
    or subevent == "SPELL_SUMMON"
    or (subevent == "SPELL_CAST_START" and CAST_START_SPELLS[spellID])
    or (subevent == "SPELL_DAMAGE" and not PROJECTILE_SPELLS[spellID]) then
        if spellID and spellID > 0 then
            self:AddSpell(spellID)
        end
    end
    
    -- Detectar auras de control (CC effects)
    if CONTROL_SPELLS[spellID] and subevent == "SPELL_AURA_APPLIED" then
        if spellID and spellID > 0 then
            self:AddSpell(spellID)
        end
    end
end

-- ============================================================================
-- Limpiar Estado (Opcional)
-- ============================================================================

function SpellHistoryBar.Core:ClearRecentSpells()
    wipe(internalState.recentSpells)
end
