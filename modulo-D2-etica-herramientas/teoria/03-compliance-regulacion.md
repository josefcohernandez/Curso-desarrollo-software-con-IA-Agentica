# Compliance y Sectores Regulados

## Introducción

Si trabajas en un sector regulado — banca, salud, gobierno, seguros — no basta con "tener cuidado". Existen regulaciones específicas que afectan cómo puedes usar IA en tu proceso de desarrollo. Este capítulo cubre las principales regulaciones y los controles que necesitas implementar.

---

## GDPR y Datos Personales

### Cuándo aplica

El GDPR (General Data Protection Regulation) aplica si tu software procesa datos de personas en la Unión Europea, independientemente de dónde esté tu empresa.

### Implicaciones para desarrollo con IA

| Aspecto | Implicación |
|---------|-------------|
| **Código fuente con schemas** | Si tus schemas de base de datos contienen campos de datos personales (nombre, email, DNI), el agente los ve |
| **Fixtures con datos reales** | Si los datos de test incluyen datos personales reales, estás enviando PII a un tercero |
| **Localización de datos** | El proveedor de IA debe cumplir con los requisitos de localización de datos del GDPR |
| **Derecho al olvido** | ¿Puede el proveedor borrar datos que recibió en un prompt? Verificar |

### Controles recomendados

1. Sanitizar todos los fixtures y datos de ejemplo antes de que el agente los lea
2. Verificar que el proveedor de IA tiene certificación GDPR o equivalente
3. Usar opciones de geo-restricción si están disponibles (ej: Anthropic ofrece `inference_geo: "eu-only"`)
4. Documentar el uso de IA en el registro de actividades de tratamiento (ROPA)

---

## SOC 2 / ISO 27001

### Cuándo aplica

Si tu empresa tiene certificación SOC 2 o ISO 27001, el uso de cualquier herramienta nueva debe evaluarse dentro del marco de gestión de riesgos.

### Implicaciones para desarrollo con IA

| Control | Acción requerida |
|---------|-----------------|
| **Inventario de proveedores** | Añadir el proveedor de IA al inventario de terceros |
| **Evaluación de riesgos** | Documentar riesgos de enviar código a un servicio externo |
| **Control de acceso** | Definir quién puede usar la herramienta y con qué datos |
| **Logging** | Registrar uso de la herramienta (no el contenido, pero sí quién, cuándo, con qué frecuencia) |
| **Revisión periódica** | Incluir la herramienta de IA en las revisiones de seguridad trimestrales |

### Template de evaluación para SOC 2

```markdown
## Evaluación de Riesgo — Herramienta de IA para Desarrollo

### Proveedor
- Nombre: [proveedor]
- Tipo de servicio: Asistente de desarrollo con IA
- Datos procesados: código fuente, configuraciones de desarrollo

### Riesgos identificados
1. Exposición de código fuente propietario a tercero
2. Posible inclusión de secrets en prompts
3. Código generado con vulnerabilidades de seguridad

### Controles implementados
1. Política de deny para archivos sensibles (.env, .pem, credentials)
2. Formación del equipo sobre higiene de prompts
3. SAST obligatorio en CI/CD para código generado
4. Code review obligatorio para todo código (IA y humano)

### Riesgo residual: [Bajo / Medio / Alto]
### Aprobado por: [Nombre, Fecha]
```

---

## Sectores Específicos

### Banca y Finanzas (PCI-DSS)

PCI-DSS regula el manejo de datos de tarjetas de crédito. Si tu código procesa, almacena o transmite datos de tarjetas:

| Requisito | Implicación |
|-----------|-------------|
| Requisito 6.5 | El código que maneja datos de tarjetas debe ser revisado manualmente, no solo por IA |
| Requisito 6.6 | Revisión de código o WAF obligatorio antes de producción |
| Requisito 3.4 | Datos de tarjetas nunca deben aparecer en logs ni en prompts al agente |
| Requisito 8 | Control de acceso: la herramienta de IA no debe tener acceso a entornos PCI |

**Regla práctica**: en módulos de tu código que manejan datos PCI, usa la IA solo para scaffolding y tests. La lógica de negocio que toca datos de tarjetas se revisa manualmente.

### Salud (HIPAA)

HIPAA (Health Insurance Portability and Accountability Act) protege datos de pacientes (PHI - Protected Health Information):

| Aspecto | Requisito |
|---------|-----------|
| **BAA** | Necesitas un Business Associate Agreement con el proveedor de IA si le envías PHI |
| **PHI en código** | Los schemas, fixtures y logs no deben contener datos de pacientes reales |
| **Audit trail** | El uso de IA en código que procesa PHI debe estar documentado |
| **Minimum necessary** | Solo enviar al agente el mínimo código necesario para la tarea |

**Regla práctica**: nunca envíes datos de pacientes reales al agente. Usa datos sintéticos para desarrollo y testing.

### Automotriz y Aviación (Safety-Critical)

Si desarrollas software safety-critical (sistemas de control de vehículos, aviación, dispositivos médicos):

- El código generado por IA **no puede** sustituir la verificación formal requerida por estándares como ISO 26262 o DO-178C
- La IA puede ayudar a generar borradores, pero el proceso de verificación y validación no cambia
- Documentar explícitamente qué partes del código tuvieron asistencia de IA

---

## Checklist de Compliance por Sector

```markdown
## Compliance — Uso de IA en Desarrollo

### General (todos los sectores)
- [ ] Proveedor de IA añadido al inventario de terceros
- [ ] Política de uso de IA documentada y comunicada
- [ ] Archivos sensibles excluidos del acceso del agente
- [ ] Code review obligatorio para todo código

### GDPR
- [ ] Datos personales sanitizados en fixtures y ejemplos
- [ ] Proveedor cumple con localización de datos
- [ ] Uso documentado en el ROPA

### SOC 2 / ISO 27001
- [ ] Evaluación de riesgos completada y aprobada
- [ ] Logging de uso implementado
- [ ] Incluido en revisiones de seguridad periódicas

### PCI-DSS
- [ ] Agente sin acceso a entornos PCI
- [ ] Revisión manual obligatoria para código que maneja tarjetas
- [ ] Datos de tarjetas nunca en prompts ni en logs

### HIPAA
- [ ] BAA firmado con el proveedor (o uso sin PHI)
- [ ] Datos sintéticos para desarrollo y test
- [ ] Audit trail del uso de IA en código PHI

### CRA (productos con software conectado)
- [ ] Metadatos de commit que registran asistencia de IA en cambios significativos
- [ ] SBOM actualizado con dependencias introducidas por agentes
- [ ] Code review humano obligatorio para componentes críticos
- [ ] Proceso de notificación de incidentes de seguridad activo
```

---

## EU AI Act (Reglamento Europeo de Inteligencia Artificial)

### Contexto y cronología

El EU AI Act es la primera regulación integral de IA a nivel mundial. Su implementación es gradual:

| Fecha | Hito |
|-------|------|
| **Febrero 2025** | Empiezan a aplicar prohibiciones y obligaciones iniciales de alfabetización en IA |
| **Agosto 2025** | Empiezan a aplicar obligaciones para modelos de IA de propósito general (GPAI) |
| **Agosto 2026** | Entra en vigor una parte importante del régimen operativo para sistemas y proveedores |
| **Agosto 2027** | Despliegue completo del calendario principal del AI Act |

Fuente orientativa: portal oficial del AI Act Service Desk de la UE y FAQ de la Comisión Europea.

### Relevancia para desarrollo con IA agéntica

Las herramientas de generación de código con IA (como Claude Code, Codex, Copilot o Cursor) **no son automáticamente "alto riesgo"** por el mero hecho de generar código. La clasificación depende del uso previsto y del sistema final en el que se integran. Aun así, hay escenarios donde sí afecta:

| Escenario | Impacto |
|-----------|---------|
| **Desarrollo de software para dispositivos médicos** | Si usas IA para generar código de un dispositivo médico (alto riesgo), la organización puede necesitar cumplir con los requisitos del AI Act |
| **Infraestructura crítica** | Código generado por IA para sistemas de control de energía, agua o transporte cae bajo escrutinio regulatorio |
| **Desarrollo general** | Impacto relativamente bajo, pero conviene documentar el uso de IA y seguir el calendario regulatorio |

### Requisitos clave

1. **Transparencia**: los usuarios deben ser informados cuando interactúan con un sistema de IA. En el contexto de desarrollo, esto refuerza la práctica de documentar qué código fue generado o asistido por IA.

2. **Sandboxes regulatorios**: los estados miembros de la UE deben establecer sandboxes regulatorios para IA, lo que puede crear oportunidades para experimentar con herramientas de IA en entornos controlados.

3. **Documentación técnica**: para sistemas de alto riesgo, se requiere documentación detallada del ciclo de vida del sistema, incluyendo las herramientas usadas en su desarrollo.

### Implicación práctica

Para la mayoría de los equipos de desarrollo, el EU AI Act **no cambia drásticamente el día a día**. La excepción son equipos enterprise en sectores regulados (salud, infraestructura crítica, seguridad) que deben:

- Evaluar si el software que desarrollan cae bajo la clasificación de "alto riesgo"
- Documentar el uso de herramientas de IA en el proceso de desarrollo
- Mantener trazabilidad del código generado por IA vs. escrito manualmente
- Consultar con el equipo legal para determinar obligaciones específicas

> **Fecha clave**: el 2 de agosto de 2026 entra en aplicación plena una parte importante del régimen operativo del AI Act para sistemas y proveedores. Si tu organización aún no ha hecho la evaluación de clasificación de riesgo, este es el momento de priorizarla.

---

## Cyber Resilience Act (CRA)

### Qué es y por qué es diferente al AI Act

El **Cyber Resilience Act (CRA)** es el reglamento europeo de ciberseguridad para productos con elementos digitales (software y hardware conectado). A diferencia del AI Act, que regula sistemas de IA, el CRA regula **el producto final que pones en el mercado**, sin importar cómo se construyó. Esto lo hace la pieza regulatoria más directamente ligada a "código generado por IA en producción": el CRA no pregunta si usaste un agente para escribir el código, pregunta si el producto que vendes es seguro y quién responde por ello.

El CRA entró en vigor en 2024 con una aplicación escalonada; las obligaciones de notificación de incidentes y las obligaciones sustantivas completas se despliegan en 2026 y 2027 respectivamente. Aplica a cualquier fabricante que ponga en el mercado de la UE productos de software con conexión a red, directa o indirecta.

### La responsabilidad del "fabricante" no cambia si el código lo escribió un agente

El principio central del CRA es simple y contundente: **el fabricante es responsable de la ciberseguridad del producto durante todo su ciclo de vida, independientemente de qué herramienta o proceso se usó para construirlo**. Si tu equipo usa Claude Code, Codex, Cursor o cualquier otro agente para generar parte o la totalidad del código, la responsabilidad legal sigue siendo de tu organización como fabricante — no del proveedor del modelo, ni del agente, ni de un "el código lo escribió la IA" como defensa.

| Pregunta habitual | Respuesta bajo el CRA |
|--------------------|------------------------|
| "¿La IA es responsable si el código generado tiene una vulnerabilidad explotada?" | No. El fabricante (tu empresa) es responsable, igual que si el código lo hubiera escrito una persona |
| "¿El CRA aplica solo a código escrito manualmente?" | No. Aplica al producto final, sin distinción del proceso de desarrollo |
| "¿Usar IA reduce mis obligaciones de seguridad?" | No. Si acaso, las aumenta: debes poder demostrar debida diligencia sobre el código generado por IA |

### Trazabilidad: qué código fue generado o influenciado por IA

El CRA exige documentación técnica y procesos de gestión de vulnerabilidades a lo largo del ciclo de vida del producto. En la práctica, esto empuja a los equipos que usan IA agéntica hacia una trazabilidad más rigurosa de qué partes del código fueron generadas o influenciadas por un agente:

| Práctica de trazabilidad | Cómo implementarla |
|---------------------------|---------------------|
| **Metadatos de commit** | Incluir en el mensaje de commit o en trailers estructurados si el cambio fue generado por IA, con qué herramienta y bajo qué revisión humana (ej: `Co-authored-by: Claude <noreply@anthropic.com>` o un trailer propio `AI-Assisted: true`) |
| **Atribución de modelo** | Registrar qué modelo y versión generó código crítico (autenticación, criptografía, gestión de sesiones), útil si aparece una vulnerabilidad de clase conocida en ese modelo |
| **SBOM (Software Bill of Materials)** | El CRA refuerza la exigencia de SBOM; en un contexto de IA agéntica, esto incluye las dependencias que el agente introdujo, no solo las que el humano añadió deliberadamente |
| **Registro de revisión humana** | Documentar que el código generado por IA en componentes críticos pasó por code review humano, no solo por tests automáticos |

**Regla práctica**: no necesitas etiquetar cada línea de código como "IA" o "humano" — eso es inviable y poco útil. Sí necesitas poder responder, ante una auditoría o un incidente, "¿qué proceso de revisión pasó este componente antes de producción?" y "¿qué modelo/herramienta participó en generarlo?" para componentes de alto riesgo (auth, pagos, gestión de datos sensibles).

### Checklist de preparación CRA

```markdown
## Preparación CRA — Uso de IA en Desarrollo

- [ ] Política de commits que registra asistencia de IA en cambios significativos
- [ ] SBOM actualizado que incluye dependencias introducidas por agentes de IA
- [ ] Proceso de gestión de vulnerabilidades con canal de notificación (CRA exige reporte de incidentes activamente explotados en plazos ajustados)
- [ ] Code review humano obligatorio para componentes críticos, independientemente de quién/qué generó el código
- [ ] Documentación técnica del producto actualizada con el rol de herramientas de IA en el proceso de desarrollo
```

---

## NIST AI RMF (AI Risk Management Framework)

El **NIST AI Risk Management Framework** (marco de gestión de riesgos de IA del instituto estadounidense NIST) es una referencia voluntaria — no una ley — pero es ampliamente adoptada como estándar de facto por organizaciones que necesitan demostrar diligencia debida en el uso de IA, incluidas empresas europeas que operan también en EE. UU.

El framework se organiza en cuatro funciones: **Govern** (gobernanza y políticas), **Map** (identificar el contexto y los riesgos), **Measure** (medir el impacto y los riesgos identificados) y **Manage** (mitigar y responder). Para un equipo de desarrollo que usa agentes de código, la relevancia práctica está en:

- **Govern**: tener una política explícita de qué agentes están aprobados y para qué tareas
- **Map**: identificar en qué partes del código el uso de IA introduce mayor riesgo (seguridad, sesgo, cumplimiento)
- **Measure**: aplicar controles medibles como los del checklist CRA anterior
- **Manage**: tener un proceso de respuesta si un componente generado por IA falla en producción

No sustituye al CRA ni al AI Act, pero es un marco útil para estructurar internamente cómo tu organización documenta y gestiona el uso de IA en desarrollo, especialmente si operas en varios mercados regulatorios a la vez.

---

## Navegación

| | |
|---|---|
| **Anterior** | [02-privacidad-datos.md](02-privacidad-datos.md) |
| **Siguiente** | [04-responsible-disclosure.md](04-responsible-disclosure.md) |
| **Módulo** | [README del módulo](../README.md) |
