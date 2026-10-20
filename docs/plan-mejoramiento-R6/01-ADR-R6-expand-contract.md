# ADR R6 — Evolucionar `specific_actions` sin romper el servicio

**Estado:** Aceptada e implementada parcialmente; ejecución de ambientes pendiente. **Fecha:** 2026-10-19.

## Decisión

Agregar `specific_actions_v2 JSONB` con el documento `{ "version": 1, "actions": [{ "text": "..." }] }`. El texto se conserva literalmente, incluyendo Unicode, saltos de línea y caracteres especiales. Después del backfill y la validación de equivalencia, el changeset CONTRACT elimina la columna antigua y renombra la nueva.

## Alternativas

- Separar acciones en filas: aporta consultas individuales, pero no preserva inequívocamente el texto histórico sin definir reglas de segmentación.
- Reemplazar directamente `TEXT` por `JSONB`: rompe el backend antiguo y no permite EXPAND.
- Mantener solo `TEXT`: no resuelve la evolución estructural.

Se eligió JSONB porque permite evolucionar el documento y mantiene una transformación reversible y determinista.

## Compatibilidad y rollback

El backend mantiene el contrato público como texto. En EXPAND/BACKFILL la versión antigua ignora la columna nueva; la versión compatible escribe JSONB cuando existe y lee JSONB como texto. El rollback de EXPAND elimina la columna nueva. El rollback de CONTRACT recrea una columna TEXT a partir del primer elemento del documento; solo es seguro porque CONTRACT exige un documento de una acción con texto exactamente equivalente.

## Consecuencias

Existe una ventana temporal con dos representaciones y costo de doble escritura. A cambio, se evita una caída y se obtiene una migración auditable. La prueba de concurrencia y los cuatro rollbacks Docker deben ejecutarse en un entorno local aislado antes de presentar el criterio R6.d como aprobado.
