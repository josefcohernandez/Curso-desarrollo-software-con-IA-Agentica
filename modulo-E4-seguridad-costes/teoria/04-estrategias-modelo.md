# Estrategias de Selección de Modelo

## Introducción

"¿Qué modelo debo usar?" es la pregunta más frecuente al empezar con IA agéntica. La respuesta correcta nunca es "el más potente" ni "el más barato". Es: **depende de la tarea**. Este capítulo te da un framework de decisión de 5 preguntas para elegir el modelo correcto cada vez, y te enseña a configurar fallbacks y effort levels para maximizar la relación calidad/coste.

> **Nota de generalización**: todos los proveedores relevantes de modelos para desarrollo (Anthropic, OpenAI, Google) organizan su catálogo en la misma lógica de fondo: un **tier de razonamiento** (máxima capacidad, mayor coste y latencia), un **tier equilibrado** (el que cubre la mayoría del trabajo diario) y un **tier rápido** (velocidad y coste mínimo, capacidad limitada). Este capítulo usa la nomenclatura de Claude como ejemplo principal por ser la más detallada de explicar con effort levels, pero el framework de decisión aplica igual con cualquier proveedor — solo cambia el nombre del modelo que ocupa cada tier.

---

## No Existe "El Mejor Modelo"

### La paradoja del modelo único

Usar siempre el modelo del tier de razonamiento (el más potente y caro) es como enviar un camión de 18 ruedas a hacer todas las entregas, incluidas las del supermercado a una manzana. Funciona, pero es ineficiente. Usar siempre el modelo del tier rápido (el más barato) es como intentar mover una casa con una bicicleta. También funciona... a veces.

### La realidad del desarrollo diario

El 60-70% de las tareas de desarrollo son rutinarias: implementar un endpoint siguiendo un patrón existente, escribir tests, refactorizar nombres, formatear código. Para estas tareas, un modelo del **tier equilibrado** con effort medium es suficiente. Solo el 10-15% requiere razonamiento profundo (**tier de razonamiento**). Y un 20-25% son consultas rápidas donde el **tier rápido** sobra.

### Los tres tiers, con ejemplos de varios proveedores

| Tier | Qué prioriza | Ejemplo en Claude | Ejemplo en GPT | Ejemplo en Gemini |
|------|---------------|--------------------|-----------------|---------------------|
| **Razonamiento** | Máxima capacidad de análisis y trade-offs | Opus | GPT-5.x en modo de razonamiento alto (tier "pro"/"thinking") | Gemini tier "Pro" con thinking budget alto |
| **Equilibrado** | Balance capacidad/coste para el trabajo diario | Sonnet | GPT-5.x tier estándar | Gemini tier "Flash" con thinking activado |
| **Rápido** | Velocidad y coste mínimo | Haiku | GPT-5.x tier "mini"/"nano" | Gemini tier "Flash-Lite" |

No profundizamos en las particularidades de cada proveedor — lo relevante es que **la decisión de qué tier usar es independiente del proveedor**; solo el nombre exacto del modelo cambia. Verifica siempre el catálogo vigente de tu proveedor, porque los nombres y capacidades de cada tier evolucionan con frecuencia.

---

## Framework de Decisión: 5 Preguntas

Antes de enviar un prompt, hazte estas 5 preguntas:

| # | Pregunta | Si la respuesta es SÍ | Tier recomendado | Ejemplo en Claude |
|---|----------|----------------------|--------------------|---------------------|
| 1 | ¿La tarea requiere razonamiento profundo? (arquitectura, algoritmos complejos, decisiones con trade-offs) | Necesitas máxima capacidad | **Tier de razonamiento**, effort high/max | Opus |
| 2 | ¿Es una tarea repetitiva o bien definida? (CRUD, tests, refactor de nombres) | No necesitas razonamiento profundo | **Tier equilibrado**, effort medium | Sonnet |
| 3 | ¿Es exploración o búsqueda de información? (¿qué hace esta función?, ¿dónde está X?) | Necesitas velocidad y bajo coste | **Tier rápido**, effort low | Haiku |
| 4 | ¿Es crítica para producción? (pagos, auth, datos sensibles) | Necesitas calidad + review humano | **Tier de razonamiento** + revisión manual | Opus |
| 5 | ¿Es un lote de 100+ tareas? (migración, batch processing) | Necesitas coste mínimo por tarea | **Tier rápido** o equilibrado en low, nunca el tier de razonamiento | Haiku o Sonnet low |

### Diagrama de decisión

```text
¿Requiere razonamiento profundo?
├── SÍ → ¿Es crítico para producción?
│        ├── SÍ → Tier de razonamiento + effort max + review humano
│        └── NO → Tier de razonamiento + effort high
└── NO → ¿Es exploración/búsqueda?
         ├── SÍ → Tier rápido + effort low
         └── NO → ¿Es batch (100+ tareas)?
                  ├── SÍ → Tier rápido o equilibrado + effort low
                  └── NO → Tier equilibrado + effort medium
```

---

## Effort Levels y su Impacto Real

Los effort levels controlan cuánto "piensa" el modelo antes de responder. No todos los modelos soportan todos los niveles. `effort` es el nombre concreto que usan Claude y Codex para este parámetro; OpenAI expone un concepto equivalente como `reasoning_effort` en su API, y Gemini lo llama `thinking budget` (un presupuesto de tokens de razonamiento en lugar de niveles nombrados). El concepto de fondo — controlar cuánto razonamiento extra invierte el modelo antes de responder — es transferible entre proveedores aunque el parámetro exacto cambie de nombre.

| Effort | Comportamiento | Velocidad | Coste | Cuándo usarlo |
|--------|---------------|-----------|-------|---------------|
| **low** | Respuesta inmediata, mínimo razonamiento | Muy rápido | Mínimo | Preguntas factuales, ediciones simples, búsqueda |
| **medium** | Balance velocidad/calidad | Rápido | Moderado | Desarrollo habitual, tests, refactors simples |
| **high** (default) | Razonamiento profundo | Moderado | Alto | Bugs complejos, features con lógica de negocio |
| **max** (solo tier de razonamiento, ej. Opus) | Razonamiento extendido, extended thinking | Lento | Muy alto | Diseño de arquitectura, decisiones críticas |

### Cómo configurar effort levels

El siguiente ejemplo usa Claude Code como referencia concreta; en otras herramientas el flag y el nombre del parámetro cambian, pero el concepto (tier de modelo + nivel de razonamiento) es el mismo.

```bash
# En Claude Code, por sesión
claude --model sonnet --effort medium "Implementa el endpoint GET /api/users"

# En Claude Code, por defecto en settings
# ~/.claude/settings.json
```

```json
{
  "model": "sonnet",
  "effort": "medium"
}
```

### Ejemplo de diferencia real

La misma pregunta con diferentes effort levels:

```text
Prompt: "¿Debería usar Redis o PostgreSQL para las sesiones de usuario?"

effort low: "Redis, porque es más rápido para datos de sesión."
(5 segundos, ~200 tokens output)

effort medium: "Redis es mejor para sesiones por velocidad y TTL nativo. 
PostgreSQL si necesitas persistencia y ya lo tienes configurado."
(10 segundos, ~500 tokens output)

effort high: "Depende de tus requisitos. Análisis comparativo: [tabla con 
8 criterios: velocidad, persistencia, escalabilidad, complejidad operativa, 
TTL, clustering, coste, consistencia]. Recomendación para tu caso: ..."
(30 segundos, ~1500 tokens output)

effort max: "Análisis de arquitectura completo con diagramas, trade-offs 
a largo plazo, plan de migración, métricas de decisión, y recomendación 
fundamentada con referencias."
(90 segundos, ~4000 tokens output)
```

---

## Fallback Model

### Qué es

Un fallback model es un modelo de respaldo que se usa automáticamente cuando el modelo principal no está disponible (por sobrecarga, mantenimiento o rate limits). El mecanismo existe, con nombres distintos, en la mayoría de herramientas y APIs de los principales proveedores.

### Configuración

```bash
# En Claude Code (ejemplo concreto; el flag exacto varía por herramienta)
claude --model opus --fallback-model sonnet "Diseña la arquitectura..."

# Si Opus (tier de razonamiento) no está disponible, usa Sonnet (tier equilibrado) automáticamente
```

### Estrategia de fallback recomendada

| Tier principal | Fallback | Ejemplo en Claude | Cuándo usar el fallback |
|-----------------|----------|---------------------|------------------------|
| Razonamiento | Equilibrado | Opus → Sonnet | El tier de razonamiento no disponible o rate limited |
| Equilibrado | Rápido | Sonnet → Haiku | El tier equilibrado sobrecargado (raro pero posible) |
| Rápido | N/A | Haiku | El tier rápido casi siempre está disponible |

### Cuándo NO usar fallback

- Tareas de seguridad crítica: si necesitas el tier de razonamiento, espera a que esté disponible
- Diseño de arquitectura: la diferencia de calidad entre el tier de razonamiento y el equilibrado es significativa aquí
- Cuando la consistencia es clave: cambiar de modelo en mitad de una tarea puede producir resultados inconsistentes

---

## Combinando Estrategias: Ejemplos Prácticos

Los siguientes ejemplos usan nomenclatura de Claude (Opus/Sonnet/Haiku) por concreción, pero el mismo sprint es igual de válido sustituyendo cada modelo por su tier equivalente en GPT o Gemini.

### Sprint típico de desarrollo

```text
Lunes - Planificación:
  ✓ Diseño de feature → Opus effort high ($3)
  ✓ Desglose en tareas → Sonnet effort medium ($0.50)

Martes a Jueves - Implementación:
  ✓ Explorar codebase → Haiku effort low ($0.10/consulta)
  ✓ Implementar endpoints → Sonnet effort medium ($1.50/endpoint)
  ✓ Escribir tests → Sonnet effort medium ($0.80/módulo)
  ✓ Debug complejo → Opus effort high ($2)

Viernes - Review y deploy:
  ✓ Security review → Opus effort high ($3)
  ✓ Fix de vulnerabilidades → Sonnet effort medium ($0.50)
  ✓ Documentación → Haiku effort low ($0.20)

Total sprint: ~$15-25 por desarrollador
```

### Batch processing (migración de 200 archivos)

```text
❌ MAL: Opus para cada archivo → $200+
✓ BIEN: Haiku para archivos simples, Sonnet para los complejos → $20-30
```

---

## Resumen

- Usa el framework de 5 preguntas antes de cada tarea para elegir el tier correcto, sea cual sea tu proveedor
- El 60-70% de las tareas de desarrollo solo necesitan el **tier equilibrado** (ej. Sonnet) con effort medium
- El **tier de razonamiento** (ej. Opus) es para razonamiento profundo y decisiones críticas; no para tareas rutinarias
- El **tier rápido** (ej. Haiku) es para exploración rápida y batch processing; no para lógica de negocio compleja
- Configura fallback models para evitar bloqueos cuando el modelo principal no está disponible
- Los effort levels (o su equivalente por proveedor: `reasoning_effort` en OpenAI, `thinking budget` en Gemini) son tan importantes como la elección del tier: un modelo del tier equilibrado con effort high puede superar a uno del tier de razonamiento con effort low en muchas tareas
- El framework es agnóstico de proveedor: lo que cambia entre Claude, GPT y Gemini es el nombre de cada tier, no la lógica de decisión
