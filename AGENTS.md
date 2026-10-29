# 🤖 Directrices para Agentes de IA — ProjectJaina_Polyglot

> **Documento Maestro de Arquitectura, Restricciones y Memoria Operativa**  
> **Ámbito:** `Client\Interface\AddOns\ProjectJaina_Polyglot\`  
> **Persona:** 'Claude Mythos 5' — Staff Software Engineer (L9)  

---

## 1. Leyes Inviolables de Implementación en Chat

1. **Uso Exclusivo de ItemRefTooltip:**
   Jamás utilizar `GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")` para hipervínculos de chat; esto ancla el marco al puntero del mouse y bloquea la interfaz de usuario en combate. Debe emplearse `ItemRefTooltip:SetOwner(UIParent, "ANCHOR_PRESERVE")`.
2. **Compatibilidad Estricta con Lua 5.1 Puro:**
   No utilizar sintaxis ni APIs de Retail (`C_Timer`, `C_ChatBubbles`, `table.pack`, etc.). Todos los temporizadores deben implementarse mediante `CreateFrame("Frame")` y scripts `OnUpdate`.
3. **Cero Taint en FrameXML:**
   Los filtros de eventos de chat (`ChatFrame_AddMessageEventFilter`) deben retornar siempre `false, msg, author, ...` para no interrumpir el procesamiento Blizzlike de otros AddOns ni desencadenar taints en subsistemas protegidos.
4. **Límite de Red de 255 Bytes:**
   Cualquier mensaje emitido por `SendAddonMessage` no puede exceder 255 bytes en total.
