# Métricas de Productividad con IA

## Introducción

Medir el impacto de la IA en la productividad de un equipo es necesario pero delicado. Las métricas incorrectas no solo son inútiles — pueden generar incentivos perversos (optimizar para la métrica en lugar de para el resultado). Este capítulo te enseña qué medir, cómo medirlo, y qué trampas evitar.

---

## Las 6 Métricas que Sí Importan

| Métrica | Cómo medir | Útil para | Trampa a evitar |
|---------|------------|-----------|-----------------|
| **Cycle time** | Tiempo desde ticket asignado hasta PR mergeado | Productividad general | No atribuir toda la mejora a la IA |
| **PRs por semana** | Count de PRs mergeados por desarrollador | Throughput del equipo | Más PRs no es mejor si son PRs triviales |
| **Tasa de bugs post-merge** | Bugs reportados en código de la última semana | Calidad del código | Diferenciar bugs en código IA vs código humano |
| **Coste de tokens** | Gasto mensual en API / suscripciones | ROI y presupuesto | No optimizar coste sacrificando productividad |
| **Tiempo de onboarding** | Días hasta primer PR significativo de un nuevo miembro | Eficiencia del equipo | Confundir velocidad con comprensión real |
| **Satisfacción del equipo** | Survey periódico (escala 1-10) | Adopción sostenible | No ignorar feedback negativo |

---

## Detalle de Cada Métrica

### 1. Cycle Time

Es la métrica más representativa de productividad. Mide el tiempo total desde que un desarrollador empieza a trabajar en un ticket hasta que el PR se mergea.

```text
Cycle time = fecha_merge - fecha_inicio_trabajo
```

**Cómo comparar**: mide el cycle time promedio durante 4 semanas sin IA, luego 4 semanas con IA. Compara promedios.

**Cuidado**: el cycle time incluye tiempo de review, que no depende del desarrollador. Para aislar el impacto de la IA, mide también el "coding time" (desde primer commit hasta PR abierto).

### 2. PRs por Semana

Mide el throughput — cuánto trabajo completo sale del equipo cada semana.

**Cuidado**: si los desarrolladores empiezan a dividir PRs artificialmente para inflar esta métrica, deja de ser útil. Complementa con "tamaño medio de PR" para detectar este patrón.

### 3. Tasa de Bugs Post-Merge

El miedo más común es que la IA introduzca más bugs. Esta métrica lo verifica con datos.

```text
Tasa = bugs_encontrados_en_semana / PRs_mergeados_en_semana
```

**Cuidado**: necesitas un período de medición antes de la adopción de IA para tener un baseline. Sin baseline, los datos no dicen nada.

### 4. Coste de Tokens

El gasto en herramientas de IA es un dato necesario para calcular el ROI.

**Qué incluir**:
- Suscripciones mensuales (ej: $20/mes por desarrollador)
- Uso de API si aplica (tokens consumidos)
- Tiempo de administración de la herramienta

**Cuidado**: no optimizar el coste a costa de la productividad. Un desarrollador que ahorra 5 horas/semana y gasta $100/mes está generando un retorno enorme.

### 5. Tiempo de Onboarding

¿Cuánto tarda un nuevo miembro del equipo en hacer su primer PR significativo? Con un buen archivo de instrucciones del repositorio y la IA como asistente de exploración, este tiempo puede reducirse drásticamente.

**Cuidado**: rapidez en el primer PR no significa comprensión profunda del codebase. Complementa con entrevistas 1-on-1 para verificar que el nuevo miembro entiende la arquitectura.

### 6. Satisfacción del Equipo

Un survey breve (3-5 preguntas, escala 1-10) cada 2-4 semanas:

```markdown
1. ¿Cómo de productivo te sientes esta semana? (1-10)
2. ¿La herramienta de IA te ayudó o te estorbó? (1-10)
3. ¿Confías en la calidad del código que generas con IA? (1-10)
4. ¿Hay algo que te frustra del proceso actual? (texto libre)
```

**Cuidado**: si el feedback negativo se ignora consistentemente, la gente deja de responder. Actúa sobre el feedback o explica por qué no se puede actuar.

---

## Las 3 Métricas Vanidosas (No Medir)

| Métrica vanidosa | Por qué es inútil | Efecto perverso |
|------------------|-------------------|-----------------|
| **Líneas de código generadas por IA** | Más líneas no es mejor. A veces la mejor solución tiene menos líneas | Incentiva código verbose y duplicado |
| **Porcentaje de "código IA"** | Imposible de medir con precisión. ¿Cuenta si el dev editó el 50%? ¿Y el 10%? | Crea una falsa dicotomía "código IA vs código humano" |
| **Tiempo usando la herramienta** | Micromanagement puro. No correlaciona con productividad | Incentiva tener la herramienta abierta sin usarla realmente |

---

## Frameworks de Referencia del Sector

Las 6 métricas de este capítulo son un punto de partida pragmático, pero no las inventamos en el vacío — conviene conocer los frameworks estándar de la industria para no reinventar peor lo que ya existe, y para poder hablar el mismo idioma que otros equipos de ingeniería:

| Framework | Qué mide | Relación con las métricas de este módulo |
|-----------|----------|---------------------------------------------|
| **DORA (DevOps Research and Assessment)** | 4 métricas clave de rendimiento de entrega de software: deployment frequency, lead time for changes, change failure rate, time to restore service | El "cycle time" de este módulo es una variante simplificada del "lead time for changes" de DORA |
| **SPACE** | Framework multidimensional (Satisfaction, Performance, Activity, Communication, Efficiency) que explícitamente advierte contra medir productividad con una sola métrica | La combinación de "satisfacción del equipo" + métricas de throughput de este módulo sigue el espíritu de SPACE: nunca una métrica sola |
| **DX Core 4** | Framework de DX (la organización, no la sigla genérica) que combina velocidad, calidad, impacto de negocio y satisfacción del desarrollador en un cuadro de mando único | Equivalente en espíritu al dashboard recomendado más abajo, pero con validación a mayor escala en organizaciones enterprise |

**Recomendación práctica**: usa las 6 métricas de este capítulo para arrancar rápido, pero si tu organización ya usa DORA, SPACE o DX Core 4 para medir ingeniería en general, integra el impacto de la IA dentro de esos frameworks existentes en lugar de crear un sistema de medición paralelo. Tener dos sistemas de métricas que no se hablan entre sí genera más confusión que valor.

### El informe DORA "ROI of AI-Assisted Software Development" (2026)

El informe DORA de 2026 centrado específicamente en el ROI del desarrollo asistido por IA es, a fecha de este capítulo, una de las referencias más citadas del sector sobre este tema — trátalo como una tendencia reportada por una organización de referencia, no como una auditoría formal e independiente de tu propio contexto. Su conclusión central es incómoda pero importante: **la adopción de IA por sí sola no predice mejores resultados de entrega** — lo que predice mejores resultados es la combinación de adopción de IA con prácticas de ingeniería sólidas ya existentes (trunk-based development, feedback rápido, automatización de despliegue). En equipos con prácticas débiles, la IA amplifica el caos existente en lugar de corregirlo.

**Implicación práctica**: si tu equipo tiene problemas de calidad o de proceso antes de adoptar IA, esos problemas no desaparecen con la IA — normalmente empeoran, porque el volumen de cambios aumenta sin que la capacidad de absorberlos con calidad haya mejorado.

---

## La Paradoja de la Productividad con IA

### Más código y más PRs no es más valor entregado

Es tentador interpretar "más PRs por semana" y "más líneas de código generadas" como señales inequívocas de productividad. La evidencia de 2026 dice lo contrario en muchos contextos: son señales de **actividad**, no necesariamente de **valor entregado**. Este es el fenómeno que el sector empieza a llamar la **AI Productivity Paradox** (paradoja de la productividad con IA).

Dos datos concretos que ilustran la paradoja (cifras aproximadas reportadas por terceros a mediados de 2026, no auditorías formales — úsalas como orden de magnitud, no como estadística exacta):

| Dato | Fuente orientativa | Qué implica |
|------|---------------------|--------------|
| El **code churn** (código reescrito o revertido poco después de escribirse) se duplica en equipos con adopción intensiva de IA | Informe DORA 2026 | Parte del código generado no es una entrega estable — es trabajo que se deshace o rehace poco después |
| Los agentes de código escriben **~180% más código**, pero solo **~30% más software llega a producción** | Investigación MIT, cobertura de Forbes (2026) | Hay una desconexión creciente entre volumen de código generado y volumen de funcionalidad real que llega a los usuarios |

### Por qué ocurre

1. **El código se genera más rápido de lo que se revisa**: si la capacidad de code review no escala al mismo ritmo que la generación de código, el cuello de botella simplemente se mueve — de "escribir código" a "revisar y aprobar código" — y ese cuello de botella no siempre es visible en las métricas de throughput
2. **PRs más grandes o más numerosos no implican features terminadas**: un PR puede estar "mergeado" y no estar realmente terminado (falta configuración, falta testing en staging, falta el trabajo de integración)
3. **El código generado que no se usa sigue contando en las métricas de actividad**: líneas generadas, commits, PRs abiertos — ninguna de estas métricas distingue entre código que aporta valor y código que se descarta o queda sin desplegar

### Cómo protegerte de la paradoja en tu propio dashboard

- **No confíes solo en throughput** (PRs/semana, líneas generadas): complementa siempre con una métrica de resultado, no solo de actividad — funcionalidad efectivamente desplegada, tickets de negocio cerrados, o `deployment frequency` de DORA
- **Vigila el code churn**: si el porcentaje de código que se reescribe o revierte en las 2-4 semanas posteriores a su creación sube de forma sostenida, es una señal de que la velocidad aparente no se está traduciendo en trabajo estable
- **Diferencia "PR mergeado" de "feature en producción usada por usuarios reales"**: son eventos distintos y solo el segundo es la definición real de productividad

> **La pregunta que sustituye a "¿cuánto código generamos?"**: "¿cuánto de lo que generamos llega a producción y se queda ahí sin necesitar reescritura inmediata?"

---

## Dashboard Recomendado

Si quieres un dashboard visual para el equipo, estas son las métricas a incluir:

```text
┌─────────────────────────────────────────────────┐
│           Dashboard de Productividad IA         │
├───────────────┬─────────────────────────────────┤
│ Cycle time    │ 3.2 días (▼ 28% vs baseline)   │
│ PRs/semana    │ 12.5 (▲ 15% vs baseline)        │
│ Bugs post-merge│ 0.8/semana (= baseline)        │
│ Coste/mes     │ $500 (5 devs × $100)            │
│ Satisfacción  │ 7.8/10 (▲ desde 7.2)            │
│ Onboarding    │ 3 días (▼ desde 8 días)          │
└───────────────┴─────────────────────────────────┘
```

---

## Frecuencia de Medición

| Métrica | Frecuencia | Quién la revisa |
|---------|------------|-----------------|
| Cycle time | Semanal | Tech lead |
| PRs/semana | Semanal | Tech lead |
| Bugs post-merge | Semanal | Todo el equipo |
| Coste | Mensual | Engineering manager |
| Satisfacción | Quincenal | Todo el equipo |
| Onboarding | Por evento | Tech lead + HR |

---

## Navegación

| | |
|---|---|
| **Anterior** | [03-convenciones-equipo.md](03-convenciones-equipo.md) |
| **Siguiente** | [05-roi-management.md](05-roi-management.md) |
| **Módulo** | [README del módulo](../README.md) |
