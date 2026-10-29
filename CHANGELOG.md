# 📋 Registro de Cambios — ProjectJaina_Polyglot

Todos los cambios notables de este proyecto están documentados en este archivo siguiendo el estándar [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/).

---

## [1.0.0] — 2026-10-28
### Lanzamiento Oficial v1.0.0 — Traductor Universal de Chat Bidireccional en Vivo
- **Núcleo de Traducción Neural (`ProjectJaina_Polyglot.lua`):**
  - Intercepción y procesamiento transparente de mensajes en canales globales y locales (`WHISPER`, `PARTY`, `GUILD`, `RAID`, `SAY`, `YELL`, `CHANNEL`).
  - Inyección no invasiva de tokens de hipervínculo en el chat (`[EN->ES]`, `[ES->EN]`, etc.) con formato nativo de enlace.
  - Renderizado de traducciones mediante la infraestructura segura de `ItemRefTooltip` sin contaminar `GameTooltip` ni interferir con el cursor del mouse.
  - Búfer asíncrono de correlación (`pendingOriginals`) para evitar condiciones de carrera entre el mensaje de chat original y el paquete de traducción entrante.
- **Protocolo de Red Cliente-Servidor (`99_UniversalChat_Translator.lua`):**
  - Canal de comunicación de AddOn bajo el prefijo `PJ_POLYGLOT`.
  - Deserialización segura de tramas de traducción con protección contra inyecciones y sanitización de caracteres especiales.
  - Soporte multilingüe completo (Español, Inglés, Portugués, Ruso, Francés, Alemán y más).
- **Comandos Slash Nativos:**
  - Registrados `/polyglot` y `/pjp` con subcomandos `on`, `off`, `target <idioma>` y `clear`.
- **Persistencia de Configuración:**
  - Almacenamiento seguro en `SavedVariables: ProjectJaina_PolyglotDB` (estado habilitado, idioma de destino, historial de sesión).
- **Homologación Documental L9:**
  - Incorporados `AGENTS.md`, `API.md`, `GOVERNANCE.md`, `ECOSYSTEM_REGISTRY.md`, `INSTALL.md`, `NOTICE.md`, `LICENSE` y `SECURITY.md`.
