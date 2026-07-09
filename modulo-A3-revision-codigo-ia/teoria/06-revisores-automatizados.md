# Revisores de código automatizados por agentes: una capa adicional, no un sustituto

## Una categoría de herramienta que no existía cuando aprendiste a hacer code review

Todo lo que has visto en este módulo asume un patrón implícito: un humano lee un diff generado por un agente y decide si lo aprueba. Desde 2025, ha crecido con fuerza una categoría de herramienta que automatiza precisamente esa primera lectura: **revisores de código impulsados por agentes de IA** que se ejecutan automáticamente sobre cada PR, antes de que un humano lo mire.

Ejemplos representativos a mediados de 2026:

| Herramienta | Qué hace | Dónde se integra |
|-------------|----------|-------------------|
| **CodeRabbit** | Comenta línea a línea en el PR, genera un resumen del cambio, sugiere fixes aplicables con un clic | GitHub, GitLab, Bitbucket vía app/bot |
| **Greptile** | Indexa el codebase completo para dar contexto arquitectónico a sus comentarios de review, no solo el diff aislado | GitHub, integraciones CI |
| **Self-review de Copilot** | El propio Copilot revisa su código o el de otros antes de que llegue a un humano | GitHub PRs |
| **Claude Code Review** | Modo de revisión que aplica el mismo modelo usado para generar código a la tarea de auditarlo, con foco en checklist configurable por el equipo | Integración GitHub Actions / CLI |

## Por qué esto no contradice todo lo que has aprendido en este módulo

La tentación es interpretar estas herramientas como "ya no hace falta revisar código a mano, otra IA lo revisa por mí". Esa lectura es exactamente el tipo de rubber stamp del que hablamos en el fichero 01, solo que un nivel más arriba: en lugar de aceptar código generado por IA sin revisarlo, se acepta la revisión hecha por IA sin cuestionarla.

La forma correcta de entender estas herramientas es como una **capa adicional en el pipeline de revisión, no como un sustituto de ninguna de las capas anteriores**:

```text
Código generado por el agente
        ↓
Capa 1: Revisor automatizado (CodeRabbit, Greptile, self-review)
   → Detecta patrones mecánicos: estilo, complejidad, vulnerabilidades conocidas,
     inconsistencias con el resto del codebase, tests faltantes obvios
        ↓
Capa 2: Revisión humana (lo que enseña el resto de este módulo)
   → Verifica lógica de negocio, contexto que la herramienta no tiene,
     decisiones de diseño, y todo lo que un revisor automatizado no puede evaluar
        ↓
Merge
```

Quitar la Capa 2 porque la Capa 1 "ya revisó" es el mismo error de sesgo de autoridad descrito en el fichero 01 — solo que ahora el sesgo de autoridad se deposita en el revisor automatizado en lugar de en el generador.

## Qué hacen bien estos revisores (cuándo confiar)

Los revisores automatizados son consistentemente buenos en tareas **mecánicas y de patrón**, exactamente el tipo de verificación que un humano cansado tiende a saltarse:

- **Detectar inconsistencias de estilo** con el resto del codebase (nombres, estructura de imports, convenciones de error handling)
- **Señalar vulnerabilidades de clases conocidas**: SQL injection, secrets hardcodeados, dependencias con CVEs
- **Verificar cobertura de tests** para el código nuevo del diff
- **Contexto de codebase completo** (en herramientas como Greptile que indexan el repo entero): detectar que una función ya existe en otro módulo, algo que un revisor humano con poco tiempo puede pasar por alto
- **Consistencia de aplicación**: a diferencia de un humano, no varía su rigor por fatiga o presión de deadline

## Qué no hacen bien (cuándo no confiar sin verificación humana)

- **Contexto de negocio**: un revisor automatizado no sabe que "los items en estado `draft` no deben sumarse al total" salvo que esa regla esté explícitamente documentada en el código o en instrucciones del proyecto — el mismo tipo de error del ejemplo del fichero 01 se le puede escapar igual que a un agente generador
- **Decisiones de arquitectura**: puede señalar que una función es compleja, pero no puede decidir si esa complejidad está justificada por el dominio del problema
- **Falsos positivos en cascada**: si el revisor automatizado tiene un sesgo o error sistemático (por ejemplo, marcar como problema un patrón que tu equipo usa deliberadamente), ese error se repite en cada PR, generando fatiga de alertas que lleva a ignorar también las alertas válidas
- **El mismo modelo, el mismo punto ciego**: si usas el mismo modelo para generar y para revisar (por ejemplo, Claude generando y Claude revisando sin instrucciones específicas de auditoría adversarial), el revisor puede compartir los mismos sesgos y omisiones que el generador — es el motivo por el que el patrón Writer/Reviewer de otros módulos de este curso insiste en usar contextos o roles separados

## Regla práctica de adopción

```markdown
## Checklist: ¿Cuánto confiar en un revisor automatizado?

- [ ] ¿El comentario señala un patrón mecánico verificable (estilo, vulnerabilidad conocida,
      test faltante)? → Alta confianza, aplica el fix si es razonable
- [ ] ¿El comentario hace una afirmación sobre lógica de negocio o intención del cambio?
      → Verifica tú mismo, el revisor no tiene ese contexto
- [ ] ¿El revisor automatizado y el generador de código son el mismo modelo sin roles
      diferenciados? → Trata la revisión con más escepticismo, puede compartir puntos ciegos
- [ ] ¿Llevas más de 2 semanas con el revisor automatizado activo? → Audita cuántos de sus
      comentarios se descartan sin acción: una tasa alta de descarte indica ruido, no señal
```

**La conclusión del módulo se mantiene intacta**: la responsabilidad final de lo que se mergea sigue siendo humana, sin importar cuántas capas de IA hayan participado en generarlo o revisarlo antes.

---

[← Anterior: Deuda técnica silenciosa](05-deuda-tecnica-silenciosa.md) | [Volver al índice del módulo](../README.md)
