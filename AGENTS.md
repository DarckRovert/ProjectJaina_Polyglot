# 🤖 Directrices de Contexto para Agentes — ProjectJaina_Polyglot

> **Documento Maestro de Arquitectura y Memoria Operativa**  
> **Ámbito:** `Client\Interface\AddOns\ProjectJaina_Polyglot\`  
> **Líder:** DarckRovert | **Staff L9:** Claude Mythos 5  

---

## Leyes Inviolables:
1. **Uso Exclusivo de ItemRefTooltip:** Jamás usar `GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")` para hipervínculos de chat; esto ancla el tooltip al cursor y bloquea la interfaz de usuario.
2. **Papeleta de Retorno:** Siempre verificar la compatibilidad de Lua 5.1 puro. No utilizar sintaxis ni APIs de Retail (`C_Timer`, etc.).\n