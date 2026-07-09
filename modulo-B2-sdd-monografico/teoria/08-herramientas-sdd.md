# 08 — Implementaciones Concretas de SDD

## SDD como filosofía vs. SDD como producto

Todo lo que has visto en este módulo — entrevista, SPEC.md, implementación por fases, verificación — es una **filosofía de trabajo**, no una herramienta concreta. Puedes practicarla con cualquier agente de código simplemente siguiendo el flujo y usando plantillas propias, como has hecho en los ejercicios.

Pero desde 2025, esa misma filosofía se ha ido empaquetando en herramientas y frameworks específicos que automatizan parte del flujo: generan la estructura de ficheros, fuerzan el orden de las fases, e integran la spec directamente en el editor o el CLI. Este capítulo es un panorama breve de las implementaciones más relevantes a mediados de 2026.

**Idea central que no debes perder**: estas herramientas son **implementaciones** de la filosofía SDD que ya conoces, no metodologías alternativas. Si entiendes el ciclo entrevista → spec → implementación → verificación, entender cualquiera de estas herramientas es cuestión de mapear sus comandos a las fases que ya dominas.

---

## GitHub Spec Kit

**Spec Kit** es el framework de SDD de código abierto (licencia MIT) más adoptado a mediados de 2026. Es deliberadamente **portable**: no está atado a un agente concreto, sino que expone un conjunto de comandos y plantillas que funcionan sobre unos 30 agentes y hosts distintos (Claude Code, Copilot, Cursor, Codex, Windsurf, Gemini CLI, entre otros).

### El flujo de Spec Kit

```text
/constitution  → Define los principios y restricciones no negociables del proyecto
                 (equivalente a las reglas globales de tu AGENTS.md / CLAUDE.md)

/specify       → Genera la especificación funcional a partir de una descripción
                 (equivalente a la fase de Entrevista + SPEC.md de este módulo)

/plan          → Traduce la spec en un plan técnico: stack, arquitectura, estructura
                 (equivalente a ARCHITECTURE.md en el flujo greenfield)

/tasks         → Descompone el plan en tareas verificables y ordenadas por dependencias
                 (equivalente a la implementación por fases)

/implement     → Ejecuta las tareas con el agente, una a una o por fase
                 (equivalente a la fase de Implementación)
```

### Mapeo directo con lo aprendido en este módulo

| Fase de Spec Kit | Fase de SDD (este módulo) |
|-------------------|----------------------------|
| `/constitution` | Convenciones de proyecto y restricciones (equivalente a las reglas del archivo de instrucciones del repositorio) |
| `/specify` | Fase 1 (Entrevista) + Fase 2 (SPEC.md) |
| `/plan` | ARCHITECTURE.md (ver [06-sdd-en-contexto.md](06-sdd-en-contexto.md), sección greenfield) |
| `/tasks` | Implementación por fases |
| `/implement` | Fase 3 (Implementación) |

Lo que Spec Kit no automatiza explícitamente es la Fase 4 (Verificación con Writer/Reviewer) — sigue siendo responsabilidad del equipo aplicar el patrón de verificación cruzada que viste en [05-fase-verificacion.md](05-fase-verificacion.md).

**Cuándo usarlo**: si tu equipo trabaja con varias herramientas de IA distintas (algunos usan Claude Code, otros Cursor) y quieres un flujo SDD uniforme entre todos sin atarte a los comandos propietarios de un único agente.

---

## AWS Kiro

**Kiro** es un IDE de Amazon, fork de VS Code, diseñado desde cero como **spec-native**: a diferencia de un editor tradicional donde la spec es un fichero opcional que el equipo decide mantener, en Kiro la especificación es un artefacto de primera clase integrado en el propio flujo del editor. Al crear una nueva feature, Kiro genera automáticamente tres documentos vinculados: `requirements.md`, `design.md` y `tasks.md`, y mantiene la trazabilidad entre ellos y el código a medida que este cambia.

### Diferencia clave con el flujo manual de este módulo

| Aspecto | SDD manual (este módulo) | Kiro |
|---------|---------------------------|------|
| Dónde vive la spec | Fichero SPEC.md en el repositorio, mantenido por convención del equipo | Integrada en el IDE, con UI dedicada para navegar requirements/design/tasks |
| Sincronización spec-código | Manual — el equipo debe recordar actualizar la spec | Asistida por el IDE, que detecta divergencias entre spec y código |
| Portabilidad | Alta (son ficheros Markdown estándar) | Media — atado al ecosistema Kiro/AWS |

**Cuándo usarlo**: equipos ya integrados en el ecosistema AWS que quieren que la disciplina de spec-first esté forzada por la herramienta en lugar de depender de la disciplina del equipo.

---

## Otras implementaciones: Tessl y BMAD-METHOD

Dos alternativas menos extendidas pero relevantes para conocer el panorama:

- **Tessl**: plantea un modelo donde la especificación, no el código fuente, es el artefacto que se versiona y mantiene como fuente de verdad — el código se trata como un artefacto "compilado" a partir de la spec, regenerable si es necesario. Es la propuesta más radical de las tres: lleva el principio de "spec como single source of truth" (ver [01-filosofia-sdd.md](01-filosofia-sdd.md)) a su extremo lógico.

- **BMAD-METHOD**: framework open source que estructura el trabajo con IA agéntica a través de "agentes" con roles fijos (analista, PM, arquitecto, cada uno con su propia plantilla de documento), inspirado explícitamente en flujos de equipos de producto tradicionales. Es más prescriptivo que Spec Kit en cuanto a roles, pero cubre las mismas fases conceptuales.

No profundizamos en estas dos porque su adopción es más nicho, pero si tu equipo evalúa herramientas de SDD conviene saber que existen y que resuelven el mismo problema con énfasis distintos: Tessl en la relación spec-código, BMAD-METHOD en la división de roles.

---

## Tabla comparativa resumida

| Herramienta | Tipo | Portabilidad | Énfasis particular |
|-------------|------|---------------|----------------------|
| **GitHub Spec Kit** | CLI + plantillas, open source (MIT) | Alta — ~30 agentes soportados | Comandos estandarizados sobre cualquier agente |
| **AWS Kiro** | IDE completo (fork de VS Code) | Baja — ecosistema propio | Spec como ciudadano de primera clase en el editor |
| **Tessl** | Plataforma de spec-to-code | Media | La spec como fuente de verdad versionada, el código como artefacto derivado |
| **BMAD-METHOD** | Framework de roles + plantillas, open source | Alta | Roles fijos inspirados en equipos de producto |

---

## La conclusión que importa

Ninguna de estas herramientas te enseña algo que no hayas aprendido ya en este módulo. Lo que aportan es **automatización y estructura** sobre un flujo que puedes ejecutar manualmente con cualquier agente y un par de plantillas Markdown, como has hecho en los ejercicios de este módulo.

La decisión de adoptar una de estas herramientas no es "¿aprendo SDD o aprendo Spec Kit?" — es "¿quiero que la disciplina de spec-first la imponga la herramienta, o prefiero mantenerla yo mismo con plantillas propias y más flexibilidad?". Ambas respuestas son legítimas; lo que no es negociable es el principio de fondo: **ninguna feature no trivial se implementa sin especificación previa cuando el implementador es un agente**.

---

> **Referencia cruzada**: la comparativa de herramientas de desarrollo con IA en general (más allá de SDD) se cubre en el [Módulo D2 - Ética, Responsabilidad y Panorama de Herramientas](../../modulo-D2-etica-herramientas/teoria/05-comparativa-herramientas.md).
