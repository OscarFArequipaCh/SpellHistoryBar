-- ============================================================================
-- SpellHistoryBar_ConfigUI.lua
-- Módulo de Interfaz de Configuración (Ventana Settings)
-- ============================================================================

SpellHistoryBar.ConfigUI = SpellHistoryBar.ConfigUI or {}

-- Variables locales privadas
local configFrame = nil
local isConfigVisible = false

-- ============================================================================
-- Crear la Ventana de Configuración
-- ============================================================================

function SpellHistoryBar.ConfigUI:CreateConfigFrame()
    if configFrame then
        return configFrame
    end
    
    -- Frame principal de la ventana
    local frame = CreateFrame("Frame", "SpellHistoryBarConfigFrame", UIParent)
    frame:SetSize(400, 300)
    frame:SetPoint("CENTER", UIParent, "CENTER", 200, 0)
    frame:SetFrameStrata("DIALOG")
    frame:SetClampedToScreen(true)
    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:RegisterForDrag("LeftButton")
    
    -- Fondo de la ventana
    frame.bg = frame:CreateTexture(nil, "BACKGROUND")
    frame.bg:SetAllPoints(frame)
    frame.bg:SetTexture(0.1, 0.1, 0.1, 0.9)
    
    -- Borde de la ventana
    frame.border = frame:CreateTexture(nil, "BACKGROUND")
    frame.border:SetPoint("TOPLEFT", frame, "TOPLEFT", -1, 1)
    frame.border:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 1, -1)
    frame.border:SetTexture(0.5, 0.5, 0.5, 0.5)
    
    -- Barra de título (área de arrastre)
    frame.titleBar = frame:CreateTexture(nil, "ARTWORK")
    frame.titleBar:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
    frame.titleBar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
    frame.titleBar:SetHeight(25)
    frame.titleBar:SetTexture(0.2, 0.2, 0.2, 0.8)
    
    -- Texto del título
    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    frame.title:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -7)
    frame.title:SetText("SpellHistoryBar Config")
    frame.title:SetTextColor(1, 1, 1, 1)
    
    -- Botón de cerrar (X)
    frame.closeButton = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    frame.closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -5, -5)
    frame.closeButton:SetScript("OnClick", function(self)
        SpellHistoryBar:ToggleConfig()
    end)
    
    -- Scripts de movimiento
    frame:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)
    
    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)
    
    -- Mantener el frame oculto al inicio
    frame:Hide()
    
    configFrame = frame
    isConfigVisible = false
    
    return frame
end

-- ============================================================================
-- Obtener la Ventana de Configuración
-- ============================================================================

function SpellHistoryBar.ConfigUI:GetConfigFrame()
    if not configFrame then
        self:CreateConfigFrame()
    end
    return configFrame
end

-- ============================================================================
-- Alternar Visibilidad de la Ventana
-- ============================================================================

function SpellHistoryBar.ConfigUI:Toggle()
    if not configFrame then
        self:CreateConfigFrame()
    end
    
    if configFrame:IsShown() then
        configFrame:Hide()
        isConfigVisible = false
    else
        configFrame:Show()
        isConfigVisible = true
    end
end

-- ============================================================================
-- Obtener Estado de Visibilidad
-- ============================================================================

function SpellHistoryBar.ConfigUI:IsVisible()
    return isConfigVisible
end

-- ============================================================================
-- Mostrar la Ventana
-- ============================================================================

function SpellHistoryBar.ConfigUI:Show()
    if not configFrame then
        self:CreateConfigFrame()
    end
    
    if not configFrame:IsShown() then
        configFrame:Show()
        isConfigVisible = true
    end
end

-- ============================================================================
-- Ocultar la Ventana
-- ============================================================================

function SpellHistoryBar.ConfigUI:Hide()
    if configFrame and configFrame:IsShown() then
        configFrame:Hide()
        isConfigVisible = false
    end
end

-- ============================================================================
-- Agregar un Widget a la Ventana (para futuros usos)
-- ============================================================================

function SpellHistoryBar.ConfigUI:GetContentArea()
    -- Retorna el frame para agregar controles
    -- El área de contenido comienza después de la barra de título (altura 25)
    if not configFrame then
        self:CreateConfigFrame()
    end
    return configFrame
end

-- ============================================================================
-- Crear una Sección con Título (Utilidad para futuros sliders/botones)
-- ============================================================================

function SpellHistoryBar.ConfigUI:CreateSection(parent, title, yOffset)
    local section = CreateFrame("Frame", nil, parent)
    section:SetPoint("TOPLEFT", parent, "TOPLEFT", 10, yOffset)
    section:SetSize(parent:GetWidth() - 20, 30)
    
    local sectionTitle = section:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    sectionTitle:SetPoint("TOPLEFT", section, "TOPLEFT", 0, -5)
    sectionTitle:SetText(title)
    sectionTitle:SetTextColor(0.8, 0.8, 1, 1)
    
    return section
end
