# 🌐 ProjectJaina_Polyglot — Traductor Universal de Chat en Vivo
## Eliminación Completa de Barreras Idiomáticas para World of Warcraft 3.3.5a

[![GitHub](https://img.shields.io/badge/GitHub-DarckRovert%2FProjectJaina__Polyglot-black?logo=github)](https://github.com/DarckRovert/ProjectJaina_Polyglot)
[![Ecosystem](https://img.shields.io/badge/Project%20Jaina-3.3.5a%20(Build%2012340)-blue)](https://darckrovert.github.io/ProjectJaina_Web/)
[![Standard](https://img.shields.io/badge/Governance-L9%20Staff%20Engineer-gold)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**Proyecto:** Project Jaina ([darckrovert.github.io/ProjectJaina_Web](https://darckrovert.github.io/ProjectJaina_Web/))  
**AddOn:** `ProjectJaina_Polyglot`  
**Cliente:** World of Warcraft: Wrath of the Lich King (3.3.5a, Build 12340)  
**Estándar:** Staff Software Engineer L9 (Claude Mythos 5)  
**Versión:** 1.0.0  

---

## 🎯 1. Misión y Capacidades Principales

`ProjectJaina_Polyglot` es el componente cliente oficial de traducción en tiempo real de **Project Jaina**. Conecta de forma transparente el chat local del jugador con el motor neural del servidor (`99_UniversalChat_Translator.lua`), permitiendo una experiencia de juego multilingüe fluida (Español, Inglés, Portugués, Ruso, Francés, Alemán y más).

### Características Clave:
1. **Traducción Bidireccional Transparente:**
   - Intercepta y traduce mensajes entrantes de canales estándar (`WHISPER`, `PARTY`, `GUILD`, `RAID`, `SAY`, `YELL`, `CHANNEL`).
2. **Hipervínculo No Invasivo con Tooltip Nativo:**
   - Inyecta tokens interactivos en el chat con formato canónico: `|cff00ccff|Hpolyglot:<id>|h[SRC->TGT]|h|r <textoTraducido>`.
   - Utiliza la infraestructura segura de `ItemRefTooltip` para permitir clic e inspección del texto original sin contaminar `GameTooltip` ni fijar el cursor del mouse.
3. **Búfer de Correlación Asíncrono (`pendingOriginals`):**
   - Resuelve condiciones de carrera entre la llegada del paquete original y la respuesta traducida del servidor.
4. **Búfer Circular Numérico Anti-Memory Leak:**
   - Capacidad estricta de 200 entradas en memoria con reemplazo circular automático para sesiones prolongadas.
5. **Widget de Control Rápido:**
   - Botón discreto integrado en la esquina superior derecha del marco principal de chat (`ChatFrame1`) para alternar la traducción con un solo clic.
6. **Cero Dependencias Externas:**
   - Desarrollado en Lua 5.1 puro para WoW 3.3.5a sin requerir frameworks pesados como Ace3.

---

## 📂 2. Estructura de Archivos del AddOn

| Archivo | Rol Arquitectónico |
| :--- | :--- |
| [`ProjectJaina_Polyglot.toc`](ProjectJaina_Polyglot.toc) | Descriptor del AddOn (Interface `30300`, versión `1.0.0`, SavedVariables). |
| [`ProjectJaina_Polyglot.lua`](ProjectJaina_Polyglot.lua) | Núcleo de traducción, filtro de ChatFrame, manejo de `CHAT_MSG_ADDON` y enlaces `ItemRefTooltip`. |
| [`API.md`](API.md) | Especificación del protocolo de red `PJ_POLYGLOT` y delimitadores por tabulación. |
| [`AGENTS.md`](AGENTS.md) | Directrices para agentes de IA y restricciones del motor de chat de WoW 3.3.5a. |
| [`GOVERNANCE.md`](GOVERNANCE.md) | Políticas de gobernanza, accesibilidad multilingüe y cero taints en combate. |
| [`ECOSYSTEM_REGISTRY.md`](ECOSYSTEM_REGISTRY.md) | Registro de dependencias cliente-servidor y bindings de Eluna. |
| [`SECURITY.md`](SECURITY.md) | Sanitización de secuencias de escape de chat y aislamiento de memoria. |
| [`INSTALL.md`](INSTALL.md) | Guía de instalación y comandos de prueba. |
| [`NOTICE.md`](NOTICE.md) | Declaración de cumplimiento con Blizzard Custom UI Policy (2009). |
| [`CHANGELOG.md`](CHANGELOG.md) | Registro histórico de cambios y versiones. |
| [`LICENSE`](LICENSE) | Términos de licenciamiento de código abierto MIT. |
| [`Tests/validate_polyglot.py`](Tests/validate_polyglot.py) | Suite de verificación estática de sintaxis y compatibilidad con 3.3.5a. |

---

## ⚡ 3. Comandos de Consola (Slash Commands)

| Comando | Acción |
| :--- | :--- |
| `/polyglot toggle` o `/pjtr` | Activa o desactiva la traducción visual en el cliente. |
| `/polyglot tags` | Muestra u oculta las etiquetas `[SRC->TGT]` antes del texto traducido. |
| `.translate <on\|off\|lang\|status>` | Comando del servidor Eluna para configurar tu idioma preferido o consultar estado. |

---

## 🛡️ 4. Licencia y Cumplimiento

Distribuido bajo la Licencia **MIT**. Cumple al 100% con la **Blizzard Custom UI Policy (2009)**. No lee ni modifica memoria del proceso ejecutable (`Wow.exe`).
