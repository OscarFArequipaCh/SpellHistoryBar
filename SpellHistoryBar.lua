-- ============================================================================
-- SpellHistoryBar.lua
-- Archivo Inicializador Principal
-- ============================================================================

-- Asegurar que la tabla global existe
SpellHistoryBar = SpellHistoryBar or {}
SpellHistoryBarSettings = SpellHistoryBarSettings or {}

-- ============================================================================
-- API PÚBLICA DE SpellHistoryBar
-- ============================================================================

function SpellHistoryBar:Get(key)
    return SpellHistoryBar.Config:GetValue(key)
end

function SpellHistoryBar:Set(key, value)
    SpellHistoryBar.Config:SetValue(key, value)
    self:Refresh()
end

function SpellHistoryBar:Refresh()
    SpellHistoryBar.UI:UpdateFrame()
end

function SpellHistoryBar:ToggleConfig()
    SpellHistoryBar.ConfigUI:Toggle()
end

-- ============================================================================
-- INICIALIZACIÓN DEL ADDON
-- ============================================================================

function SpellHistoryBar:Initialize()
    -- Cargar configuración
    SpellHistoryBar.Config:Initialize()
    
    -- Crear frame UI
    SpellHistoryBar.UI:InitializeFrame()
    
    -- Inicializar botón del minimapa
    SpellHistoryBar.Minimap:Initialize()
    
    -- Actualizar visual
    self:Refresh()
    
    -- Registrar eventos en el frame
    local frame = SpellHistoryBar.UI:GetFrame()
    if frame then
        frame:RegisterEvent("ADDON_LOADED")
        frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
        
        frame:SetScript("OnEvent", function(self, event, ...)
            if event == "ADDON_LOADED" then
                local addonName = ...
                if addonName == "SpellHistoryBar" then
                    SpellHistoryBar.Config:Initialize()
                    SpellHistoryBar:Refresh()
                    return
                end
            elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
                SpellHistoryBar.Core:ProcessCombatLogEvent(...)
            end
        end)
    end
end

-- ============================================================================
-- REGISTRO DE COMANDOS SLASH
-- ============================================================================

SlashCmdList.SPELLHISTORYBAR = function(msg)
    SpellHistoryBar.Commands:HandleCommand(msg)
end
SLASH_SPELLHISTORYBAR1 = "/shb"

-- ============================================================================
-- INICIAR ADDON
-- ============================================================================

SpellHistoryBar:Initialize()
