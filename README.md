# 🌐 ProjectJaina_Polyglot — Traductor Universal de Chat en Vivo
## Eliminación Completa de Barreras Idiomáticas para World of Warcraft 3.3.5a

**Proyecto:** [Project Jaina](https://darckrovert.github.io/ProjectJaina_Web/)  
**AddOn:** `ProjectJaina_Polyglot`  
**Cliente:** World of Warcraft: Wrath of the Lich King (3.3.5a, Build 12340)  
**Estándar de Ingeniería:** Staff Software Engineer L9 (Claude Mythos 5)  
**Versión:** 1.0.0  
**Fecha de Publicación:** Octubre 2026  

---

## 🎯 1. Visión y Capacidades Principales

`ProjectJaina_Polyglot` es el componente cliente oficial de traducción en tiempo real de **Project Jaina**. Conecta de forma transparente el chat local del jugador con el motor neural del servidor (`99_UniversalChat_Translator.lua`), permitiendo una experiencia de juego multilingüe fluida (Español, Inglés, Portugués, Ruso, Francés, Alemán y más).

### Características Clave:
1. **Traducción Bidireccional Transparente:**
   - Intercepta y traduce mensajes entrantes de canales estándar (`WHISPER`, `PARTY`, `GUILD`, `RAID`, `SAY`, `YELL`, `CHANNEL`).
2. **Hipervínculo No Invasivo con Tooltip Nativo:**
   - Inyecta tokens interactivos en el chat con formato: `[EN->ES]`.
   - Utiliza la infraestructura segura de `ItemRefTooltip` para permitir clic e inspección sin contaminar `GameTooltip` ni fijar el cursor del mouse.
3. **Búfer de Correlación Asíncrono (`pendingOriginals`):**
   - Resuelve condiciones de carrera entre la llegada del paquete original y la respuesta traducida del servidor.
4. **Cero Dependencias Externas:**
   - Desarrollado en Lua 5.1 puro para WoW 3.3.5a sin requerir frameworks pesados como Ace3.

---

## 🏗️ 2. Estructura del Addon

| Archivo | Rol Arquitectónico |
| :--- | :--- |
| `ProjectJaina_Polyglot.toc` | Descriptor del AddOn (Interface 30300, SavedVariables, metadatos). |
| `ProjectJaina_Polyglot.lua` | Núcleo de traducción, filtro de ChatFrame, manejo de `CHAT_MSG_ADDON` y enlaces `ItemRefTooltip`. |
| `API.md` | Especificación del protocolo de red `PJ_POLYGLOT`. |
| `GOVERNANCE.md` | Modelo de gobernanza L9, roles y directrices de desarrollo. |
| `ECOSYSTEM_REGISTRY.md` | Registro de componentes y dependencias de Project Jaina. |
| `SECURITY.md` | Políticas de sanitización y aislamiento de FrameXML. |
| `Tests/validate_polyglot.py` | Suite de pruebas unitarias y de integridad estática. |

---

## ⚡ 3. Comandos Slash

| Comando | Acción |
| :--- | :--- |
| `/polyglot` o `/pjp` | Muestra el estado del motor y la ayuda interactiva. |
| `/polyglot on` / `off` | Habilita o deshabilita la traducción en tiempo real. |
| `/polyglot target <idioma>` | Establece el idioma de destino (ej: `es`, `en`, `pt`). |
| `/polyglot clear` | Limpia la caché temporal de mensajes en memoria. |

---

## 🛡️ 4. Licencia y Cumplimiento

Distribuido bajo la Licencia **MIT**. Cumple al 100% con la **Blizzard Custom UI Policy (2009)**.\n