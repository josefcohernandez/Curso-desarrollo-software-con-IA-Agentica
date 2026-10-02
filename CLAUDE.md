# Curso-desarrollo-software-con-IA-Agentica

<!-- Este fichero se carga en cada sesión: solo lo que Claude no puede deducir del código.
     Menos de 200 líneas. Cada línea pasa la prueba "si la quito, ¿se equivocaría?". -->

Proceso: metodología común (`~/.claude/metodologia/METODOLOGIA.md`). Todo entra por PR desde un
worktree (`flujo abrir <issue>`), con título `tipo: descripción` en español. Una ampliación del
curso es `feat(vX.Y): …` o `docs(vX.Y): …`.

## Qué es

Curso en español, independiente de la herramienta, sobre el oficio de desarrollar software con
agentes de código (14 módulos A1-E4 y proyecto final; solo Markdown). Es un submódulo del monorepo
`cursos-libros-ia`, que lo usa para generar el libro.

## Comandos

- Verificación completa (la misma que la CI): `scripts/check.sh` (sintaxis, YAML/JSON y enlaces
  relativos con `scripts/check-enlaces.py`)

## Gotchas

- `README.md` es la fuente de verdad estructural: su árbol de carpetas lista todos los ficheros de
  teoría y ejercicios, y las duraciones de sus tablas deben coincidir con las de cada módulo.
- Los enlaces `../` desde la raíz (p. ej. `../CURSO_IA_AGENTICA.md`) apuntan al monorepo padre y
  no se comprueban aquí.

## Decisiones vigentes

<!-- Una línea por ADR: - [0001 · Título](docs/adr/0001-titulo.md): resumen en una frase. -->

- **Versiones = edición del curso.** Las releases `vX.Y.Z` (las crea la CI con `flujo publicar`)
  siguen la edición: mayor.menor = edición del README (ahora la 1.3), patch = correcciones sin
  edición nueva. La primera release será `v1.3.0`; una edición nueva sube la menor (o la mayor).
