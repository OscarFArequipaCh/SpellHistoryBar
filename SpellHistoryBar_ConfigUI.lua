-- ============================================================================
-- SpellHistoryBar_ConfigUI.lua
-- Módulo de Interfaz de Configuración (Ventana Settings)
-- ============================================================================

SpellHistoryBar.ConfigUI = SpellHistoryBar.ConfigUI or {}

-- Variables locales privadas
local configFrame = nil
local isConfigVisible = false

-- Controles de la UI
local iconSizeSlider = nil
local maxIconsSlider = nil
local fadeTimeSlider = nil
local lockedCheckbox = nil
local resetButton = nil

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
    frame.border:SetTexture(0.5, 0.5, 0.5, 0.1)
    
    -- Barra de título (área de arrastre)
    frame.titleBar = frame:CreateTexture(nil, "ARTWORK")
    frame.titleBar:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
    frame.titleBar:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
    frame.titleBar:SetHeight(25)
    frame.titleBar:SetTexture(0, 0, 0, 0.8)
    
    -- Texto del título
    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    frame.title:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -7)
    frame.title:SetText("SpellHistoryBar Config")
    frame.title:SetTextColor(1, 1, 1, 1)
    
    -- Botón de cerrar (X)
    frame.closeButton = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    frame.closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -5, 3)
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
    
    -- Poblar la ventana con controles
    self:PopulateConfigFrame(frame)
    
    -- Mantener el frame oculto al inicio
    frame:Hide()
    
    configFrame = frame
    isConfigVisible = false
    
    return frame
end

-- ============================================================================
-- Poblar la Ventana de Configuración con Controles
-- ============================================================================

function SpellHistoryBar.ConfigUI:PopulateConfigFrame(frame)
    local yOffset = -45  -- Empezar debajo de la barra de título
    
    -- Slider para iconSize
    iconSizeSlider = self:CreateSlider(frame, "Tamaño de Iconos", 16, 64, yOffset, "iconSize")
    yOffset = yOffset - 60
    
    -- Slider para maxIcons
    maxIconsSlider = self:CreateSlider(frame, "Máximo de Iconos", 1, 10, yOffset, "maxIcons")
    yOffset = yOffset - 60
    
    -- Slider para fadeTime
    fadeTimeSlider = self:CreateSlider(frame, "Tiempo de Desvanecimiento (seg)", 1, 20, yOffset, "fadeTime")
    yOffset = yOffset - 60
    
    -- Checkbox para locked
    lockedCheckbox = self:CreateCheckbox(frame, "Desbloquear Barra", yOffset, "locked")
    yOffset = yOffset - 40
    
    -- Botón de reset
    resetButton = self:CreateResetButton(frame, yOffset)
end

-- ============================================================================
-- Crear un Slider
-- ============================================================================

function SpellHistoryBar.ConfigUI:CreateSlider(parent, label, minVal, maxVal, yOffset, key)
    local slider = CreateFrame("Slider", nil, parent, "OptionsSliderTemplate")
    slider:SetPoint("TOPLEFT", parent, "TOPLEFT", 20, yOffset)
    slider:SetWidth(300)
    slider:SetHeight(20)
    slider:SetMinMaxValues(minVal, maxVal)
    slider:SetValueStep(1)
    
    -- Etiqueta del slider
    local sliderLabel = slider:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    sliderLabel:SetPoint("BOTTOMLEFT", slider, "TOPLEFT", 0, 5)
    sliderLabel:SetText(label)
    sliderLabel:SetTextColor(1, 1, 1, 1)
    
    -- Texto del valor actual
    local valueText = slider:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    valueText:SetPoint("BOTTOMRIGHT", slider, "TOPRIGHT", 0, 5)
    valueText:SetTextColor(1, 0.8, 0, 1)
    
    -- Función para actualizar el texto del valor
    local function UpdateValueText()
        valueText:SetText(math.floor(slider:GetValue()))
    end
    
    -- Script OnValueChanged
    slider:SetScript("OnValueChanged", function(self, value)
        UpdateValueText()
        SpellHistoryBar:Set(key, math.floor(value))
    end)
    
    -- Inicializar valor
    UpdateValueText()
    
    return slider
end

-- ============================================================================
-- Crear un Checkbox
-- ============================================================================

function SpellHistoryBar.ConfigUI:CreateCheckbox(parent, label, yOffset, key)
    local checkbox = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
    checkbox:SetPoint("TOPLEFT", parent, "TOPLEFT", 20, yOffset)
    checkbox:SetWidth(25)
    checkbox:SetHeight(25)
    
    -- Etiqueta del checkbox
    local checkboxLabel = checkbox:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    checkboxLabel:SetPoint("LEFT", checkbox, "RIGHT", 5, 0)
    checkboxLabel:SetText(label)
    checkboxLabel:SetTextColor(1, 1, 1, 1)
    
    -- Script OnClick
    checkbox:SetScript("OnClick", function(self)
        SpellHistoryBar:Set(key, not self:GetChecked())
    end)
    
    return checkbox
end

-- ============================================================================
-- Crear Botón de Reset
-- ============================================================================

function SpellHistoryBar.ConfigUI:CreateResetButton(parent, yOffset)
    local button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    button:SetPoint("TOPLEFT", parent, "TOPLEFT", 20, yOffset)
    button:SetWidth(150)
    button:SetHeight(25)
    button:SetText("Valores por Defecto")
    
    -- Script OnClick
    button:SetScript("OnClick", function(self)
        SpellHistoryBar.Commands:ResetConfiguration()
        SpellHistoryBar.ConfigUI:UpdateControls()
    end)
    
    return button
end

-- ============================================================================
-- Actualizar Controles con Valores Actuales
-- ============================================================================

function SpellHistoryBar.ConfigUI:UpdateControls()
    if not configFrame then return end
    
    -- Actualizar sliders
    if iconSizeSlider then
        iconSizeSlider:SetValue(SpellHistoryBar:Get("iconSize"))
    end
    if maxIconsSlider then
        maxIconsSlider:SetValue(SpellHistoryBar:Get("maxIcons"))
    end
    if fadeTimeSlider then
        fadeTimeSlider:SetValue(SpellHistoryBar:Get("fadeTime"))
    end
    
    -- Actualizar checkbox
    if lockedCheckbox then
        lockedCheckbox:SetChecked(not SpellHistoryBar:Get("locked"))
    end
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
        self:Hide()
    else
        self:Show()
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
        self:UpdateControls()  -- Actualizar controles con valores actuales
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
