# 📡 Especificación de API y Protocolo — ProjectJaina_Polyglot

**Prefijo de Red:** `PJ_POLYGLOT`  
**Canales Soportados:** `WHISPER`, `PARTY`, `GUILD`, `RAID`, `BATTLEGROUND`  
**Versión de Protocolo:** 1.0.0  

---

## 1. Estructura de Paquetes de Red (`CHAT_MSG_ADDON`)

El motor de traducción intercambia mensajes delimitados por tabuladores (`\t`) para maximizar la densidad de información dentro del límite estricto de **255 bytes por paquete**:

### Formato de Servidor -> Cliente (Traducción Recibida)
```
TRANSLATED\t<sourceLang>\t<targetLang>\t<correlationId>\t<translatedText>
```

- `sourceLang`: Código ISO de 2 letras (ej: `en`, `es`, `fr`, `ru`).
- `targetLang`: Idioma de destino solicitado por el cliente.
- `correlationId`: Hash numérico para sincronizar con el texto original en el búfer local.
- `translatedText`: Texto traducido sanitizado para FrameXML.

---

## 2. Formato de Hipervínculos en Chat

```lua
|cff00ccff|Hpolyglot:<correlationId>|h[<sourceLang>-><targetLang>]|h|r <textoTraducido>
```

Al hacer clic en el enlace, el hook nativo de `SetItemRef` activa:
```lua
ItemRefTooltip:SetOwner(UIParent, "ANCHOR_PRESERVE")
ItemRefTooltip:AddLine("Project Jaina — Traductor Universal", 0.0, 0.8, 1.0)
ItemRefTooltip:AddLine("Original: " .. originalText, 1, 1, 1, true)
ItemRefTooltip:Show()
```

---

## 3. Persistencia (`SavedVariables: ProjectJaina_PolyglotDB`)

```lua
ProjectJaina_PolyglotDB = {
    enabled = true,
    targetLanguage = "es",
    autoDetect = true,
    channelFilters = {
        WHISPER = true,
        PARTY = true,
        GUILD = true,
        RAID = true,
        SAY = true,
        YELL = true
    }
}
```\n