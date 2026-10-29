# 📡 Especificación de API y Protocolo — ProjectJaina_Polyglot

**Prefijo de Red:** `PJ_POLYGLOT`  
**Backend:** `99_UniversalChat_Translator.lua` (Eluna Engine)  
**Versión:** 1.0.0  
**Transporte:** `SendAddonMessage` / `CHAT_MSG_ADDON` (Canal: `WHISPER` / Servidor)  

---

## 1. Estructura de Paquetes de Red (`CHAT_MSG_ADDON`)

El motor de traducción intercambia mensajes delimitados por tabuladores (`\t`) para maximizar la densidad de información dentro del límite estricto de **255 bytes por paquete**:

### Formato de Servidor -> Cliente (Texto Original de Respaldo)
```text
<kind>\t<sourceLang>\t<targetLang>\t<originalMsg>
```

- `<kind>`: Canal del mensaje traducido (`WHISPER`, `PARTY`, `GUILD`, `RAID`, `SAY`, `YELL`, `CHANNEL`).
- `<sourceLang>`: Código ISO de idioma detectado (ej: `en`, `pt`, `fr`, `ru`).
- `<targetLang>`: Idioma de destino entregado al cliente (ej: `es`).
- `<originalMsg>`: Texto original sin traducir emitido por el remitente, utilizado para alimentar el tooltip interactivo.

---

## 2. Formato de Hipervínculos en Chat

Los mensajes filtrados por `PolyglotChatFilter` inyectan secuencias de escape canónicas de WoW 3.3.5a:
```lua
|cff00ccff|Hpolyglot:<cacheId>|h[<sourceLang>-><targetLang>]|h|r <textoTraducido>
```

Al hacer clic en el enlace, el hook nativo de `SetItemRef` activa:
```lua
ItemRefTooltip:SetOwner(UIParent, "ANCHOR_PRESERVE")
ItemRefTooltip:ClearLines()
ItemRefTooltip:AddLine("|cff00ccffProject Jaina Polyglot|r", 1, 1, 1)
ItemRefTooltip:AddLine(string.format("Emisor: |cffffffff%s|r  |cff808080(%s)|r", entry.author, entry.time), 0.8, 0.8, 0.8)
ItemRefTooltip:AddLine(string.format("Traducción: |cff00ff00[%s]|r -> |cff00ccff[%s]|r", entry.src, entry.tgt), 0.9, 0.9, 0.9)
ItemRefTooltip:AddLine("Texto original:", 0.8, 0.8, 0.8)
ItemRefTooltip:AddLine(entry.original or entry.text, 1, 1, 0, true)
ItemRefTooltip:AddLine("|cff808080Traducción automática en vivo por JainaCore AI.|r", 0.5, 0.5, 0.5)
ItemRefTooltip:Show()
```

---

## 3. Esquema de Persistencia (`SavedVariables: ProjectJaina_PolyglotDB`)

```lua
ProjectJaina_PolyglotDB = {
    enabled = true,            -- Estado global del traductor visual
    showTooltips = true,       -- Mostrar inspección al interactuar
    showTags = true,           -- Mostrar etiquetas [SRC->TGT]
    preferredLocale = "esES",  -- Configuración regional del cliente
    channels = {
        whisper = true,
        party = true,
        raid = true,
        guild = true,
        world = true,
    }
}
```

---

## 4. Gestión de Memoria (`messageCache`)

Para evitar fugas de memoria en sesiones de juego continuas, el AddOn implementa un búfer circular acotado:
* `CACHE_LIMIT = 200`
* `cacheCounter = (cacheCounter % CACHE_LIMIT) + 1`
* Las entradas viejas son sobreescritas automáticamente sin fragmentación de heap de Lua.
