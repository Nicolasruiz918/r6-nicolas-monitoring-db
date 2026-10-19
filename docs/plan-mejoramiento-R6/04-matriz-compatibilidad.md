# Matriz de compatibilidad

| Servicio | Esquema | Resultado esperado | Estado actual |
|---|---|---|---|
| anterior | original | Funciona | Implementado por diseño; ejecución pendiente |
| anterior | expandido | Funciona ignorando columna nueva | Implementado por diseño; ejecución pendiente |
| compatible | expandido | Lee/escribe texto y JSONB | Prueba unitaria; integración pendiente |
| compatible | backfilled | Conserva contrato | Prueba unitaria; integración pendiente |
| nuevo | preparado para contract | Funciona | Implementado en migración; ejecución pendiente |
| nuevo | contraído | Funciona sobre JSONB | Requiere ajuste de modelo/ejecución post-contract |
| anterior | contraído | Despliegue impedido | Política documentada; no desplegar |

La matriz de comportamiento está implementada; los escenarios PostgreSQL/HTTP solo se marcarán ejecutados cuando exista salida real de la prueba de integración.
