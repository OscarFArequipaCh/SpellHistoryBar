-- ============================================================================
-- SpellHistoryBar_UI.lua
-- Módulo de Interfaz de Usuario y Gestión Visual
-- ============================================================================

SpellHistoryBar.UI = SpellHistoryBar.UI or {}

-- Variables locales privadas para el frame
local mainFrame = nil

-- ============================================================================
-- Inicializar Frame Principal
-- ============================================================================

function SpellHistoryBar.UI:InitializeFrame()
    if mainFrame then
        return mainFrame
    end
    
    local frame = CreateFrame("frame", "SpellHistoryBarFrame", UIParent)
    frame:SetSize(300, 40)
    frame:SetFrameStrata("MEDIUM")
    frame:SetClampedToScreen(true)
    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:RegisterForDrag("LeftButton")
    
    -- Crear tabla de iconos si no existe
    if not frame.icons then
        frame.icons = {}
    end
    
    -- Fondo del frame
    frame.bg = frame:CreateTexture(nil, "BACKGROUND")
    frame.bg:SetAllPoints(frame)
    frame.bg:SetTexture(0, 0, 0, 0.25)
    
    -- Título del frame
    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    frame.title:SetPoint("CENTER", frame, "CENTER", 0, 0)
    frame.title:SetText("SpellHistoryBar")
    frame.title:SetTextColor(1, 1, 1, 0.85)
    
    -- Script de arrastre - inicio
    frame:SetScript("OnDragStart", function(self)
        if not SpellHistoryBar:Get("locked") then
            self:StartMoving()
        end
    end)
    
    -- Script de arrastre - fin
    frame:SetScript("OnDragStop", function(self)
        if not SpellHistoryBar:Get("locked") then
            self:StopMovingOrSizing()
            SpellHistoryBar.Config:SaveAnchor()
        end
    end)
    
    -- Script de actualización por fotograma
    frame:SetScript("OnUpdate", function(self, elapsed)
        if SpellHistoryBar.Core then
            SpellHistoryBar.Core:OnFrameUpdate(elapsed)
        end
    end)
    
    mainFrame = frame
    return frame
end

-- ============================================================================
-- Obtener Referencia al Frame Principal
-- ============================================================================

function SpellHistoryBar.UI:GetFrame()
    return mainFrame
end

-- ============================================================================
-- Obtener Tabla de Iconos
-- ============================================================================

function SpellHistoryBar.UI:GetIcons()
    if mainFrame then
        return mainFrame.icons
    end
    return {}
end

-- ============================================================================
-- Actualizar Frame Completo
-- ============================================================================

function SpellHistoryBar.UI:UpdateFrame()
    if not mainFrame then
        return
    end
    
    local iconSize = SpellHistoryBar:Get("iconSize")
    local spacing = SpellHistoryBar:Get("iconSpacing")
    local maxIcons = SpellHistoryBar:Get("maxIcons")
    local point = SpellHistoryBar.Config:GetSavedPoint()
    
    -- Calcular tamaño del frame
    local width = math.max(iconSize, (iconSize + spacing) * maxIcons - spacing)
    local height = iconSize
    
    -- Aplicar tamaño y posición
    mainFrame:SetSize(width, height)
    mainFrame:ClearAllPoints()
    mainFrame:SetPoint(unpack(point))
    
    -- Actualizar fondo
    if mainFrame.bg then
        mainFrame.bg:SetAllPoints(mainFrame)
    end
    
    -- Aplicar estado de bloqueo
    if SpellHistoryBar:Get("locked") then
        mainFrame:EnableMouse(false)
    else
        mainFrame:EnableMouse(true)
    end
    
    -- Actualizar posición de iconos
    self:UpdateIcons()
end

-- ============================================================================
-- Actualizar Posición de Iconos
-- ============================================================================

function SpellHistoryBar.UI:UpdateIcons()
    if not mainFrame then
        return
    end
    
    local icons = mainFrame.icons
    local iconSize = SpellHistoryBar:Get("iconSize")
    local spacing = SpellHistoryBar:Get("iconSpacing")
    
    for i, icon in ipairs(icons) do
        icon:ClearAllPoints()
        icon:SetPoint("LEFT", mainFrame, "LEFT", (i - 1) * (iconSize + spacing), 0)
        icon:SetSize(iconSize, iconSize)
    end
end

-- ============================================================================
-- Crear Icono de Hechizo
-- ============================================================================

function SpellHistoryBar.UI:CreateIcon(texture)
    if not mainFrame then
        return nil
    end
    
    local iconSize = SpellHistoryBar:Get("iconSize")
    local icon = mainFrame:CreateTexture(nil, "ARTWORK")
    
    icon:SetSize(iconSize, iconSize)
    icon:SetTexture(texture)
    icon:SetAlpha(1)
    icon.time = GetTime()
    
    return icon
end

-- ============================================================================
-- Añadir Icono a la Barra
-- ============================================================================

function SpellHistoryBar.UI:AddIconToBar(icon)
    if not mainFrame then
        return
    end
    
    table.insert(mainFrame.icons, 1, icon)
    
    local maxIcons = SpellHistoryBar:Get("maxIcons")
    if #mainFrame.icons > maxIcons then
        mainFrame.icons[#mainFrame.icons]:Hide()
        table.remove(mainFrame.icons)
    end
    
    self:UpdateIcons()
end

-- ============================================================================
-- Limpiar Iconos Desvanecidos
-- ============================================================================

function SpellHistoryBar.UI:RemoveIconAtIndex(index)
    if not mainFrame then
        return
    end
    
    if mainFrame.icons[index] then
        mainFrame.icons[index]:Hide()
        table.remove(mainFrame.icons, index)
        self:UpdateIcons()
    end
end
