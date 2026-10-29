# 🛡️ Política de Seguridad — ProjectJaina_Polyglot

**Proyecto:** Project Jaina  
**Estándar:** Staff Software Engineer L9 (Mythos 5)  

---

## 1. Sanitización de Strings y Anti-Exploit
- Todo texto recibido del servidor o procesado por el filtro de chat se valida para impedir la inyección de secuencias de escape no autorizadas que puedan alterar la consola o ejecutar macros maliciosas.
- Las etiquetas de hipervínculo `|Hpolyglot:<id>|h` están estrictamente delimitadas por IDs numéricos enteros para prevenir inyecciones de código en `SetItemRef`.

## 2. Aislamiento de Memoria
- El búfer circular `messageCache` implementa auto-reciclaje acotado a 200 entradas para prevenir fugas de memoria en sesiones prolongadas (>24 horas continuas).
