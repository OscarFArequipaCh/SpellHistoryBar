-- ============================================================================
-- SpellHistoryBar_Commands.lua
-- Módulo de Comandos Slash
-- ============================================================================

SpellHistoryBar.Commands = SpellHistoryBar.Commands or {}

-- ============================================================================
-- Imprimir Mensaje en Chat
-- ============================================================================

function SpellHistoryBar.Commands:PrintMessage(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00SpellHistoryBar:|r " .. msg)
end

-- ============================================================================
-- Mostrar Ayuda
-- ============================================================================

function SpellHistoryBar.Commands:ShowHelp()
    self:PrintMessage("Comandos disponibles:")
    self:PrintMessage("/shb - abre o cierra la ventana de configuración")
    self:PrintMessage("/shb help - muestra este mensaje")
    self:PrintMessage("/shb move - alterna el modo de movimiento")
    self:PrintMessage("/shb size <16-64> - ajusta el tamaño de los iconos")
    self:PrintMessage("/shb max <1-10> - ajusta la cantidad máxima de iconos")
    self:PrintMessage("/shb reset - restaurar valores predeterminados")
end

-- ============================================================================
-- Ajustar Tamaño de Iconos
-- ============================================================================

function SpellHistoryBar.Commands:SetIconSize(size)
    size = tonumber(size) or 0
    size = math.max(16, math.min(64, size))
    
    SpellHistoryBar:Set("iconSize", size)
    self:PrintMessage("Tamaño de icono ajustado a " .. size)
end

-- ============================================================================
-- Ajustar Cantidad Máxima de Iconos
-- ============================================================================

function SpellHistoryBar.Commands:SetMaxIcons(value)
    value = tonumber(value) or 0
    value = math.max(1, math.min(10, value))
    
    SpellHistoryBar:Set("maxIcons", value)
    self:PrintMessage("Máximo de iconos ajustado a " .. value)
end

-- ============================================================================
-- Alternar Bloqueo/Desbloqueo de la Barra
-- ============================================================================

function SpellHistoryBar.Commands:ToggleLock()
    local isLocked = SpellHistoryBar:Get("locked")
    SpellHistoryBar:Set("locked", not isLocked)
    
    if SpellHistoryBar:Get("locked") then
        self:PrintMessage("Barra bloqueada. Usa /shb move para desbloquear.")
    else
        self:PrintMessage("Barra desbloqueada. Arrastra la barra para moverla.")
    end
end

-- ============================================================================
-- Resetear Configuración
-- ============================================================================

function SpellHistoryBar.Commands:ResetConfiguration()
    SpellHistoryBarSettings = {}
    SpellHistoryBar.Config:Initialize()
    SpellHistoryBar:Refresh()
    SpellHistoryBarSettings.point = nil  -- No guardar la posición por defecto
    self:PrintMessage("Configuración restaurada a valores predeterminados.")
end

-- ============================================================================
-- Procesar Comando
-- ============================================================================

function SpellHistoryBar.Commands:HandleCommand(msg)
    local command, arg = msg:match("^(%S*)%s*(.-)%s*$")
    command = command:lower()
    
    if command == "" then
        SpellHistoryBar:ToggleConfig()
    elseif command == "help" then
        self:ShowHelp()
    elseif command == "move" then
        self:ToggleLock()
    elseif command == "size" then
        if arg == "" then
            self:PrintMessage("Uso: /shb size <16-64>")
        else
            self:SetIconSize(arg)
        end
    elseif command == "max" then
        if arg == "" then
            self:PrintMessage("Uso: /shb max <1-10>")
        else
            self:SetMaxIcons(arg)
        end
    elseif command == "reset" then
        self:ResetConfiguration()
    else
        self:PrintMessage("Comando desconocido. Usa /shb help.")
    end
end
