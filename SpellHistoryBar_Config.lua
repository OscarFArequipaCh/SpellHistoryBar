-- ============================================================================
-- SpellHistoryBar_Config.lua
-- Módulo de Configuración y Gestión de Ajustes
-- ============================================================================

SpellHistoryBar.Config = SpellHistoryBar.Config or {}

-- Constantes de configuración por defecto
SpellHistoryBar.Config.DEFAULTS = {
    point = {"CENTER", UIParent, "CENTER", 0, -200},
    iconSize = 32,
    iconSpacing = 4,
    maxIcons = 8,
    fadeTime = 8,
    locked = true,
}

-- ============================================================================
-- Inicialización de Configuración
-- ============================================================================

function SpellHistoryBar.Config:Initialize()
    self:ApplyDefaults()
end

-- ============================================================================
-- Aplicar Valores por Defecto
-- ============================================================================

function SpellHistoryBar.Config:ApplyDefaults()
    local defaults = self.DEFAULTS
    
    if not SpellHistoryBarSettings.point then
        SpellHistoryBarSettings.point = {unpack(defaults.point)}
    end
    if not SpellHistoryBarSettings.iconSize then
        SpellHistoryBarSettings.iconSize = defaults.iconSize
    end
    if not SpellHistoryBarSettings.iconSpacing then
        SpellHistoryBarSettings.iconSpacing = defaults.iconSpacing
    end
    if not SpellHistoryBarSettings.maxIcons then
        SpellHistoryBarSettings.maxIcons = defaults.maxIcons
    end
    if not SpellHistoryBarSettings.fadeTime then
        SpellHistoryBarSettings.fadeTime = defaults.fadeTime
    end
    if SpellHistoryBarSettings.locked == nil then
        SpellHistoryBarSettings.locked = defaults.locked
    end
end

-- ============================================================================
-- Obtener Valor de Configuración
-- ============================================================================

function SpellHistoryBar.Config:GetValue(key)
    local value = SpellHistoryBarSettings[key]
    
    -- Convertir a número si es necesario
    if key == "iconSize" or key == "iconSpacing" or key == "maxIcons" or key == "fadeTime" then
        value = tonumber(value)
    end
    
    -- Usar valor por defecto si no existe
    if value == nil then
        value = self.DEFAULTS[key]
    end
    
    return value
end

-- ============================================================================
-- Guardar Valor de Configuración
-- ============================================================================

function SpellHistoryBar.Config:SetValue(key, value)
    SpellHistoryBarSettings[key] = value
end

-- ============================================================================
-- Guardar Posición del Frame
-- ============================================================================

function SpellHistoryBar.Config:SaveAnchor()
    if not SpellHistoryBar.UI or not SpellHistoryBar.UI:GetFrame() then
        return
    end
    
    local frame = SpellHistoryBar.UI:GetFrame()
    local point, _, relativePoint, xOffset, yOffset = frame:GetPoint()
    
    if point and relativePoint then
        SpellHistoryBarSettings.point = {point, "UIParent", relativePoint, xOffset, yOffset}
    end
end

-- ============================================================================
-- Obtener Punto de Anclaje Guardado
-- ============================================================================

function SpellHistoryBar.Config:GetSavedPoint()
    local point = SpellHistoryBarSettings.point or self.DEFAULTS.point
    
    -- Fix para configuraciones guardadas con "UIParent" como string
    if type(point[2]) == "string" and point[2] == "UIParent" then
        point = {point[1], UIParent, point[3], point[4], point[5]}
    elseif point[2] ~= UIParent then
        point = self.DEFAULTS.point
    end
    
    return point
end
