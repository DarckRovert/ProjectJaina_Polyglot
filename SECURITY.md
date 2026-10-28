# 🛡️ Política de Seguridad — ProjectJaina_Polyglot

**Proyecto:** Project Jaina  
**Estándar:** Staff Software Engineer L9 (Mythos 5)  

---

## 1. Sanitización de Strings y Anti-Exploit
- Todo texto recibido del servidor o ingresado por usuarios pasa por un filtro de eliminación de secuencias de escape no autorizadas (`|c`, `|r`, `|H`, `|h`, `|T`).
- Las cajas de texto de entrada están blindadas contra desbordamiento de búfer y secuencias nulas (`\0`).

## 2. Aislamiento de Memoria
- El búfer circular `pendingOriginals` implementa auto-limpieza periódica mediante `table.remove` para prevenir fugas de memoria en sesiones largas (>24 horas).\n