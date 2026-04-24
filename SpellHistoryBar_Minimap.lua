-- ============================================================================
-- SpellHistoryBar_Minimap.lua
-- Módulo del Botón del Minimapa
-- ============================================================================

SpellHistoryBar.Minimap = SpellHistoryBar.Minimap or {}

-- Variables locales
local minimapButton = nil
local isDragging = false
local dragStartAngle = 0
local minimapReadyFrame = nil

-- Constantes
local MINIMAP_RADIUS = 80  -- Radio alrededor del minimapa

-- ============================================================================
-- Crear Botón del Minimapa
-- ============================================================================

function SpellHistoryBar.Minimap:CreateButton()
    if minimapButton then
        return minimapButton
    end

    -- Asegurarse de que el minimapa ya está disponible
    if not Minimap or not Minimap:IsVisible() then
        return nil
    end

    -- Crear el frame del botón
    local button = CreateFrame("Button", "SpellHistoryBarMinimapButton", Minimap)
    button:SetFrameStrata("MEDIUM")
    button:SetWidth(32)
    button:SetHeight(32)
    button:SetFrameLevel(8)
    button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

    -- Textura del botón (circular)
    local texture = button:CreateTexture(nil, "BACKGROUND")
    texture:SetTexture("Interface\\Icons\\Spell_Holy_DivineSpirit")  -- Icono de hechizo, cambiar si quieres otro
    texture:SetWidth(20)
    texture:SetHeight(20)
    texture:SetPoint("CENTER", button, "CENTER", 0, 0)
    button.texture = texture

    -- Borde circular
    local border = button:CreateTexture(nil, "OVERLAY")
    border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    border:SetWidth(54)
    border:SetHeight(54)
    border:SetPoint("CENTER", button, "CENTER", 11, -11)
    button.border = border

    -- Posicionar inicialmente
    self:UpdatePosition()

    -- Scripts
    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:SetText("SpellHistoryBar")
        GameTooltip:AddLine("Click para abrir configuración", 1, 1, 1)
        GameTooltip:AddLine("Arrastra para mover", 1, 1, 1)
        GameTooltip:Show()
    end)

    button:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    button:SetScript("OnClick", function(self, button)
        if button == "LeftButton" then
            SpellHistoryBar:ToggleConfig()
        end
    end)

    button:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" then
            isDragging = true
            dragStartAngle = self:GetAngleFromMouse()
            self:SetScript("OnUpdate", function(self, elapsed)
                if isDragging then
                    local currentAngle = self:GetAngleFromMouse()
                    SpellHistoryBarSettings.minimap.angle = currentAngle
                    SpellHistoryBar.Minimap:UpdatePosition()
                end
            end)
        end
    end)

    button:SetScript("OnMouseUp", function(self, button)
        if button == "LeftButton" then
            isDragging = false
            self:SetScript("OnUpdate", nil)
            -- Guardar posición solo si se arrastró realmente
            local currentAngle = self:GetAngleFromMouse()
            if math.abs(currentAngle - dragStartAngle) > 5 then  -- Umbral para considerar arrastre
                SpellHistoryBarSettings.minimap.angle = currentAngle
            end
        end
    end)

    -- Función auxiliar para calcular ángulo desde mouse
    function button:GetAngleFromMouse()
        local mx, my = Minimap:GetCenter()
        local px, py = GetCursorPosition()
        local scale = Minimap:GetEffectiveScale()
        px, py = px / scale, py / scale
        local dx, dy = px - mx, py - my
        return math.deg(math.atan2(dy, dx))
    end

    minimapButton = button
    return button
end

-- ============================================================================
-- Actualizar Posición del Botón
-- ============================================================================

function SpellHistoryBar.Minimap:UpdatePosition()
    if not minimapButton then return end
    print("el angulo que se esta usando es:", SpellHistoryBarSettings.minimap.angle)
    local angle = SpellHistoryBarSettings.minimap and SpellHistoryBarSettings.minimap.angle or 45
    angle = angle % 360  -- Normalizar ángulo a 0-360
    local x = MINIMAP_RADIUS * math.cos(math.rad(angle))
    local y = MINIMAP_RADIUS * math.sin(math.rad(angle))
    
    minimapButton:ClearAllPoints()
    minimapButton:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

-- ============================================================================
-- Mostrar/Ocultar Botón
-- ============================================================================

function SpellHistoryBar.Minimap:Show()
    if not minimapButton then
        self:CreateButton()
    end
    minimapButton:Show()
end

function SpellHistoryBar.Minimap:Hide()
    if minimapButton then
        minimapButton:Hide()
    end
end

-- ============================================================================
-- Inicializar
-- ============================================================================

function SpellHistoryBar.Minimap:Initialize()
    -- Crear el botón solo cuando el minimapa exista realmente.
    if Minimap and Minimap:IsVisible() then
        self:CreateButton()
        self:UpdatePosition()
        self:Show()
        return
    end

    minimapReadyFrame = CreateFrame("Frame")
    minimapReadyFrame:RegisterEvent("PLAYER_LOGIN")
    minimapReadyFrame:SetScript("OnEvent", function(self, event)
        if event == "PLAYER_LOGIN" then
            SpellHistoryBar.Minimap:CreateButton()
            SpellHistoryBar.Minimap:UpdatePosition()
            SpellHistoryBar.Minimap:Show()
            self:UnregisterEvent("PLAYER_LOGIN")
        end
    end)
end