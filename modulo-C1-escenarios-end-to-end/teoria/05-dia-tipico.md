# Escenario: El Día Típico de un Desarrollador con IA

## El problema

Has aprendido los workflows individuales: onboarding, incidentes, greenfield, legacy. Pero una jornada de trabajo no es un solo workflow — es una mezcla de tareas de distinta naturaleza, duración y prioridad. La pregunta no es "¿cómo uso IA para una tarea?" sino "¿cómo organizo mi día para ser productivo con IA sin agotarme?"

---

## Cronograma de una jornada productiva

| Hora | Actividad | Uso de IA | Tipo de sesión |
|------|-----------|-----------|----------------|
| 09:00 | Revisar PRs del equipo | Pedir resumen de diffs grandes; verificar lógica compleja con el agente | Ligera |
| 09:30 | Standup: asignan 2 tickets | Usar el agente para explorar el contexto de cada ticket (archivos relevantes, tests existentes) | Ligera |
| 10:00 | Ticket 1: fix bug en API | Workflow de debugging: reproducir, aislar, fix, test. Sesión enfocada con el agente | **Profunda** |
| 11:00 | Nueva sesión o reset de contexto + Ticket 2: nueva feature | Workflow spec-first: entender requisitos, fase de planificación, diseñar approach, empezar TDD | **Profunda** |
| 12:30 | Almuerzo | Descanso total — cerrar la herramienta de IA | Descanso |
| 13:30 | Code review de PR de compañero | IA como segundo reviewer; verificar edge cases y regresiones | Ligera |
| 14:00 | Continuar ticket 2 | Sesión nueva, reinyectar contexto del spec. Implementar y testear | **Profunda** |
| 16:00 | Tests de integración fallan | Debugging con logs + agente. Investigación rápida, no sesión profunda | Ligera |
| 16:30 | PR + documentación | IA genera descripción de PR, actualiza docs, prepara changelog | Ligera |
| 17:00 | Planificar mañana | Anotar estado de tickets y contexto en `AGENTS.md`, `CLAUDE.md` o notas del repositorio para mañana | Ligera |

---

## Anatomía de los tipos de sesión

### Sesión profunda (40-90 minutos)

Es cuando resuelves un problema complejo de principio a fin. Requiere máxima atención porque supervisas activamente las decisiones del agente.

**Características**:
- Contexto sostenido durante toda la sesión
- Revisas cada diff antes de aceptar
- Ejecutas tests después de cada cambio
- Tomas decisiones de diseño activamente

**Cuándo usar**: fix bugs complejos, implementar features nuevas, refactoring importante.

**Límite**: máximo 2-3 sesiones profundas al día. Después de la tercera, tu capacidad de supervisión baja significativamente.

### Sesión ligera (10-30 minutos)

Tareas cortas y acotadas donde el riesgo de error es bajo. No requieren supervisión exhaustiva.

**Características**:
- Tarea bien definida y acotada
- Output fácil de verificar (un resumen, un draft de PR, una exploración)
- No modifica código crítico
- Puedes aceptar el resultado tras una revisión rápida

**Cuándo usar**: PR reviews, exploración de código, generación de documentación, planificación.

---

## Los 5 patrones de éxito del día a día

### 1. Sesión nueva o reset de contexto entre tickets: nunca mezclar contextos

```text
-- Terminas ticket 1 (bug fix en el módulo de pagos) --
-- Cierras la sesión actual o ejecutas el comando de limpieza de contexto --
-- Empiezas ticket 2 (feature en el módulo de usuarios) --
```

**Por qué es crítico**: el contexto del ticket 1 (archivos de pagos, lógica financiera) contamina las decisiones del ticket 2 (archivos de usuarios, lógica de permisos). El agente puede hacer referencia a archivos irrelevantes o aplicar patrones del módulo equivocado.

### 2. Fase de planificación para features de más de 1 hora

Si una tarea va a llevar más de una hora, invierte 10-15 minutos en planificar antes de escribir código:

```text
I need to implement [feature]. Before writing any code:
1. Read the relevant files and understand the current architecture
2. Propose a plan with: files to create/modify, approach, risks
3. Wait for my approval before implementing
```

**Beneficio**: evitas reescrituras completas cuando el agente va por un camino equivocado.

### 3. Tests antes de implementar

Para cualquier feature o fix, siempre en este orden:
1. Escribe (o pide) los tests que definen el comportamiento esperado
2. Verifica que los tests fallan (están testeando algo que aún no existe)
3. Implementa hasta que los tests pasen
4. Refactoriza si es necesario manteniendo los tests verdes

### 4. Revisar diffs antes de commit

Nunca hagas `git add .` y `git commit` sin antes revisar qué cambió:

```bash
git diff --stat    # ¿cuántos archivos y líneas cambiaron?
git diff           # ¿el contenido de los cambios tiene sentido?
```

**Señales de alarma**:
- Más archivos cambiados de los esperados
- Archivos fuera del scope de tu tarea
- Imports nuevos de dependencias que no acordaste
- Eliminación de código que no pediste

### 5. Máximo 2-3 sesiones profundas al día

La **fatiga de supervisión de IA** es real. Después de supervisar activamente código generado durante varias horas, tu capacidad de detectar errores baja notablemente.

**Señales de que estás fatigado**: aceptas diffs sin leerlos, no ejecutas tests, sientes que el agente "sabe lo que hace". Cuando las detectes: para, haz una pausa, cambia a una tarea ligera.

---

## Complemento al día interactivo: agentes cloud asíncronos (fire-and-forget)

Todo lo descrito hasta ahora asume un patrón **interactivo y síncrono**: tú estás delante de la sesión, supervisando cada paso, disponible para responder preguntas del agente. Desde 2025-2026, un patrón complementario ha ganado tracción real en el día a día de equipos profesionales: los **agentes cloud asíncronos**, también llamados fire-and-forget porque asignas la tarea y te desentiendes hasta que el agente entrega un resultado.

Ejemplos representativos de esta categoría: **Devin**, **Google Jules**, **Codex cloud** (el modo de ejecución en la nube de OpenAI Codex, distinto del CLI interactivo) y el **coding agent de GitHub Copilot** que trabaja directamente sobre issues.

### El flujo fire-and-forget

```text
1. Asignar la tarea (2-5 min de tu tiempo)
   → Escribes o seleccionas un issue/ticket con contexto suficiente
   → Asignas el issue al agente cloud (mención, label o comando específico
     de la plataforma)
   → El agente confirma que ha entendido el alcance (a veces con preguntas
     de clarificación antes de empezar)

2. Trabajo autónomo en sandbox aislado (minutos a varias horas)
   → El agente clona el repositorio en un entorno aislado (sandbox),
     no en tu máquina ni en la de nadie del equipo
   → Explora el codebase, planifica el cambio, implementa, ejecuta tests
   → No hay supervisión humana durante esta fase — es la diferencia
     fundamental con las sesiones interactivas de este capítulo
   → Tú sigues con otro trabajo: sesiones profundas, tareas ligeras,
     reuniones, u otro agente cloud en paralelo sobre otro ticket

3. Entrega de PR para revisión humana (tu tiempo de vuelta)
   → El agente abre un PR con descripción del cambio, cómo lo verificó,
     y (idealmente) enlace a los logs de su propio proceso de trabajo
   → El PR se revisa exactamente igual que cualquier otro PR generado
     por IA — todo lo aprendido en el Módulo A3 aplica sin excepciones
   → Si el resultado no es satisfactorio, puedes pedir iteración
     (comentario en el PR) o descartar y reformular la tarea
```

### Cuándo usar el patrón asíncrono vs. el interactivo

| Usa agente cloud asíncrono cuando... | Usa sesión interactiva cuando... |
|----------------------------------------|-------------------------------------|
| La tarea está bien acotada y descrita (un ticket claro, no una exploración abierta) | La tarea requiere decisiones de diseño en tiempo real que tú quieres tomar |
| Puedes permitirte esperar horas por el resultado sin bloquear tu trabajo | Necesitas el resultado en minutos |
| Quieres paralelizar: varios tickets trabajándose a la vez en sandboxes distintos | Solo puedes (o quieres) supervisar una cosa a la vez |
| El riesgo del cambio es bajo-medio (features acotadas, fixes bien definidos, tareas de mantenimiento) | El cambio toca código crítico donde prefieres supervisión paso a paso |

### Por qué complementa, no sustituye, el trabajo interactivo

El patrón asíncrono no reduce el rigor de revisión — lo desplaza en el tiempo. La ausencia de supervisión durante la ejecución hace que la revisión del PR final sea, si acaso, **más** exigente que en una sesión interactiva donde ya has visto los diffs intermedios. Trata cada PR de un agente cloud como si viniera de un colaborador remoto al que nunca has visto trabajar: confías en el resultado solo después de verificarlo, no antes.

**Patrón de uso realista en la jornada**: muchos equipos combinan ambos patrones en el mismo día — por ejemplo, asignan 2-3 tickets de mantenimiento o deuda técnica a un agente cloud a primera hora de la mañana (patrón fire-and-forget), mientras dedican sus sesiones interactivas profundas a la feature más compleja del sprint. A media tarde, revisan los PRs que el agente cloud entregó mientras trabajaban en otra cosa.

---

## Gestión del contexto a lo largo del día

| Momento | Acción de contexto |
|---------|-------------------|
| Inicio del día | Leer `AGENTS.md`, `CLAUDE.md` o notas del día anterior para recordar estado |
| Antes de cada ticket | Empezar con contexto limpio: nueva sesión o comando de reset |
| Tras 20+ minutos en una sesión | Evaluar si necesitas compactar, resumir o reiniciar contexto |
| Antes del almuerzo | Anotar estado actual del trabajo en un comentario o nota |
| Fin del día | Actualizar el archivo de instrucciones persistentes o las notas del repo con decisiones tomadas y estado de tickets |

---

## La jornada perfecta no existe

El cronograma de arriba es un ideal. En la realidad:

- Los incidentes interrumpen tu planificación
- Las reuniones no planificadas rompen sesiones profundas
- Algunos bugs se resisten más de lo esperado
- A veces llegas al final del día sin haber terminado ningún ticket

**Lo que sí puedes controlar**:
- Que cada sesión empiece con contexto limpio
- Que nunca hagas commit sin revisar el diff
- Que los tests existan antes de considerar algo "terminado"
- Que reconozcas cuándo estás fatigado y actúes en consecuencia

---

## Conexión con otros módulos

- Los workflows de cada tipo de tarea provienen de las teorías 01-04 de este mismo módulo
- La gestión de contexto aplica lo aprendido en el [Módulo A2](../../modulo-A2-limitaciones-fallos/README.md) sobre degradación por contexto saturado
- Las técnicas de prompting para sesiones ligeras (PR reviews, exploración) vienen del [Módulo A1](../../modulo-A1-prompting-efectivo/README.md)
- El workflow de debugging para las sesiones profundas viene del [Módulo A4](../../modulo-A4-debugging-sistematico/README.md)
