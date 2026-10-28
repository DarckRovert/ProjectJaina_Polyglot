# 🏛️ Modelo de Gobernanza — ProjectJaina_Polyglot

**Líder del Proyecto & Autor:** DarckRovert (Ingame: `Elnazzareno`)  
**Staff AI Engineer:** Antigravity L9 (Mythos 5)  
**Servidor Destino:** [Project Jaina](https://darckrovert.github.io/ProjectJaina_Web/)  
**Entorno de Ejecución:** World of Warcraft 3.3.5a (Build 12340) | Interfaz: `30300`  

---

## 1. Misión y Alcance
Facilitar la comunicación global entre jugadores de diferentes nacionalidades dentro del ecosistema Project Jaina sin interrumpir el rendimiento gráfico del juego.

### Invariantes de Ingeniería:
1. **Cero Taint en FrameXML:** El hookeo de canales de chat no debe interferir con subsistemas protegidos de combate.
2. **Límite de Red de 255 Bytes:** Ningún mensaje emitido o procesado puede exceder 255 bytes en `SendAddonMessage`.
3. **Resiliencia ante Desconexión:** Si el servidor de traducción no responde o se reinicia, el chat tradicional de WoW continúa funcionando al 100% sin retrasos.\n