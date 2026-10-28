-- ==============================================================================
-- PROJECT JAINA: POLYGLOT (CLIENT ADDON FOR WOW 3.3.5a)
-- ==============================================================================
-- AddOn cliente para gestión visual e interactiva de traducciones en tiempo real.
-- Permite visualizar el texto original en tooltips, alternar canales y cambiar idioma.
--
-- Autor: DarckRovert & Antigravity (Claude Mythos 5)
-- Versión: 1.0.0
-- ==============================================================================

local ADDON_NAME = "ProjectJaina_Polyglot"
local PREFIX = "PJ_POLYGLOT"

-- Configuración por defecto
local defaults = {
    enabled = true,
    showTooltips = true,
    showTags = true,
    preferredLocale = GetLocale() or "esES",
    channels = {
        whisper = true,
        party = true,
        raid = true,
        guild = true,
        world = true,
    }
}

ProjectJaina_PolyglotDB = ProjectJaina_PolyglotDB or defaults

-- ==============================================================================
-- 1. BÚFER CIRCULAR NUMÉRICO (ANTI-LEAK Y RESOLUCIÓN REAL DE CLAVES)
-- ==============================================================================
local CACHE_LIMIT = 200
local cacheCounter = 0
local messageCache = {} -- [id] = { src=srcTag, tgt=tgtTag, text=content, author=author, time=time, original=original }

-- ==============================================================================
-- 2. REGISTRO Y GESTIÓN DE HIPERENLACES INTERACTIVOS (|Hpolyglot:...|h)
-- ==============================================================================
-- Búfer de correlación resiliente anti-carrera de paquetes de red
local pendingOriginals = {}

-- Gestión Blizzlike de hiperenlaces con ItemRefTooltip nativo (Zero Cursor Leak)
local origSetItemRef = SetItemRef
SetItemRef = function(link, text, button, chatFrame)
    if link:sub(1, 9) == "polyglot:" then
        local id = tonumber(link:sub(10))
        local entry = id and messageCache[id]
        if entry and ItemRefTooltip then
            ItemRefTooltip:SetOwner(UIParent, "ANCHOR_PRESERVE")
            ItemRefTooltip:ClearLines()
            ItemRefTooltip:AddLine("|cff00ccffProject Jaina Polyglot|r", 1, 1, 1)
            ItemRefTooltip:AddLine(string.format("Emisor: |cffffffff%s|r  |cff808080(%s)|r", entry.author or "Desconocido", entry.time or ""), 0.8, 0.8, 0.8)
            ItemRefTooltip:AddLine(string.format("Traducción: |cff00ff00[%s]|r -> |cff00ccff[%s]|r (Tu cliente)", entry.src or "?", entry.tgt or "?"), 0.9, 0.9, 0.9)
            if entry.original and entry.original ~= "" then
                ItemRefTooltip:AddLine("Texto original:", 0.8, 0.8, 0.8)
                ItemRefTooltip:AddLine(entry.original, 1, 1, 0, true)
            else
                ItemRefTooltip:AddLine("Mensaje traducido:", 0.8, 0.8, 0.8)
                ItemRefTooltip:AddLine(entry.text or "", 1, 1, 1, true)
            end
            ItemRefTooltip:AddLine("|cff808080Traducción automática en vivo por JainaCore AI.|r", 0.5, 0.5, 0.5)
            ItemRefTooltip:Show()
        end
        return
    end
    return origSetItemRef(link, text, button, chatFrame)
end

-- ==============================================================================
-- 3. FILTRADO Y ENRIQUECIMIENTO DE MENSAJES DE CHAT
-- ==============================================================================
local function PolyglotChatFilter(self, event, msg, author, ...)
    if not ProjectJaina_PolyglotDB.enabled or not msg then
        return false, msg, author, ...
    end

    -- Detectar etiquetas de traducción enviadas por el servidor: [SRC->TGT]
    local srcTag, tgtTag, content = msg:match("|cff00ccff%[([%a%-]+)%->([%a%-]+)%]|r%s*(.*)")
    if srcTag and tgtTag and content then
        cacheCounter = (cacheCounter % CACHE_LIMIT) + 1
        messageCache[cacheCounter] = {
            src = srcTag,
            tgt = tgtTag,
            text = content,
            author = author,
            time = date("%H:%M:%S")
        }

        -- Consumo atómico de texto original si arribó antes por CHAT_MSG_ADDON
        local origText = author and pendingOriginals[author]
        if origText then pendingOriginals[author] = nil end
        messageCache[cacheCounter].original = origText

        local formattedTag = ""
        if ProjectJaina_PolyglotDB.showTags then
            -- Secuencia de escape canónica de WoW 3.3.5a (|c|H|h|h|r)
            formattedTag = string.format("|cff00ccff|Hpolyglot:%d|h[%s->%s]|h|r ", cacheCounter, srcTag, tgtTag)
        end

        local finalMsg = formattedTag .. content
        return false, finalMsg, author, ...
    end

    return false, msg, author, ...
end

-- Registrar filtros de eventos en los marcos de chat
local chatEvents = {
    "CHAT_MSG_SAY",
    "CHAT_MSG_YELL",
    "CHAT_MSG_WHISPER",
    "CHAT_MSG_WHISPER_INFORM",
    "CHAT_MSG_PARTY",
    "CHAT_MSG_PARTY_LEADER",
    "CHAT_MSG_RAID",
    "CHAT_MSG_RAID_LEADER",
    "CHAT_MSG_GUILD",
    "CHAT_MSG_CHANNEL",
}

for _, evt in ipairs(chatEvents) do
    ChatFrame_AddMessageEventFilter(evt, PolyglotChatFilter)
end

-- ==============================================================================
-- 4. RECEPTOR DE ADDON MESSAGES DEL SERVIDOR (PJ_POLYGLOT)
-- ==============================================================================
local frame = CreateFrame("Frame", "ProjectJaina_PolyglotFrame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("CHAT_MSG_ADDON")

frame:SetScript("OnEvent", function(self, event, prefix, msg, channel, sender)
    if event == "ADDON_LOADED" and prefix == ADDON_NAME then
        if not ProjectJaina_PolyglotDB then
            ProjectJaina_PolyglotDB = defaults
        end
        print("|cff00ccff[Project Jaina Polyglot]|r v1.0.0 cargado. Usa |cffffff00/polyglot|r o |cffffff00.translate|r.")
    elseif event == "CHAT_MSG_ADDON" and prefix == PREFIX then
        -- Guardar metadatos extendidos recibidos del servidor
        local kind, src, tgt, original = strsplit("\t", msg)
        if kind and original then
            if messageCache[cacheCounter] then
                messageCache[cacheCounter].original = original
            end
        end
    end
end)

-- ==============================================================================
-- 4. BOTÓN FLOTANTE DISCRETO EN EL CHAT (WIDGET 🌐)
-- ==============================================================================
local function CreateChatToggleButton()
    local btn = CreateFrame("Button", "PolyglotChatToggleBtn", ChatFrame1)
    btn:SetWidth(18)
    btn:SetHeight(18)
    btn:SetPoint("TOPRIGHT", ChatFrame1, "TOPRIGHT", -4, -4)
    btn:SetNormalTexture("Interface\\Icons\\Spell_Arcane_PortalDalaran")
    btn:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
    btn:GetNormalTexture():SetTexCoord(0.08, 0.92, 0.08, 0.92)

    btn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:ClearLines()
        GameTooltip:AddLine("|cff00ccffProject Jaina Polyglot|r", 1, 1, 1)
        local status = ProjectJaina_PolyglotDB.enabled and "|cff00ff00Activado|r" or "|cffff0000Desactivado|r"
        GameTooltip:AddLine("Traductor Universal: " .. status, 0.8, 0.8, 0.8)
        GameTooltip:AddLine("Clic: Alternar /polyglot menu", 1, 1, 0)
        GameTooltip:Show()
    end)

    btn:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    btn:SetScript("OnClick", function(self)
        ProjectJaina_PolyglotDB.enabled = not ProjectJaina_PolyglotDB.enabled
        local state = ProjectJaina_PolyglotDB.enabled and "|cff00ff00activada|r" or "|cffff0000desactivada|r"
        print("|cff00ccff[Project Jaina Polyglot]|r Traducción " .. state .. ".")
    end)
end

-- Intentar crear el botón tras cargar la interfaz
local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
initFrame:SetScript("OnEvent", function()
    CreateChatToggleButton()
    initFrame:UnregisterAllEvents()
end)

-- ==============================================================================
-- 5. COMANDO SLASH (/polyglot y /tr)
-- ==============================================================================
SLASH_POLYGLOT1 = "/polyglot"
SLASH_POLYGLOT2 = "/pjtr"
SlashCmdList["POLYGLOT"] = function(msg)
    local cmd, arg = msg:match("^(%S+)%s*(.*)$")
    cmd = cmd and cmd:lower() or "toggle"

    if cmd == "toggle" then
        ProjectJaina_PolyglotDB.enabled = not ProjectJaina_PolyglotDB.enabled
        local state = ProjectJaina_PolyglotDB.enabled and "|cff00ff00ACTIVADA|r" or "|cffff0000DESACTIVADA|r"
        print("|cff00ccff[Project Jaina Polyglot]|r Traducción " .. state .. ".")
    elseif cmd == "tags" then
        ProjectJaina_PolyglotDB.showTags = not ProjectJaina_PolyglotDB.showTags
        local state = ProjectJaina_PolyglotDB.showTags and "|cff00ff00visibles|r" or "|cffff0000ocultas|r"
        print("|cff00ccff[Project Jaina Polyglot]|r Etiquetas [SRC->TGT] " .. state .. ".")
    else
        print("|cff00ccff=== Project Jaina Polyglot ===|r")
        print("  |cffffff00/polyglot toggle|r - Activa o desactiva la traducción visual.")
        print("  |cffffff00/polyglot tags|r - Muestra u oculta las etiquetas [SRC->TGT].")
        print("  |cffffff00.translate <on|off|lang|status>|r - Control del servidor.")
    end
end
