# Metodología Ágil - Gestión por Tareas con GitHub Projects

## Introducción

Este documento describe la metodología ágil implementada en el proyecto de microservicios de e-commerce, basada en una gestión por tareas utilizando GitHub Projects como herramienta principal de organización y seguimiento. La metodología se estructuró en sprints de una semana de duración, adaptándose a las necesidades específicas del desarrollo de una arquitectura de microservicios en Kubernetes.

## Marco Metodológico

### Filosofía Adoptada
Nuestra metodología combina principios de **Scrum** y **Kanban**, adaptados para un entorno de desarrollo de microservicios:

- **Orientación a Tareas**: Cada funcionalidad se descompone en tareas específicas y manejables
- **Sprints Cortos**: Ciclos de una semana para mayor agilidad y feedback rápido
- **Transparencia**: Visibilidad completa del progreso a través de GitHub Projects
- **Colaboración**: Trabajo en equipo con responsabilidades compartidas
- **Mejora Continua**: Retrospectivas regulares para optimizar el proceso

### Principios Fundamentales

#### 1. **Task-Driven Development**
```
Epic → User Story → Tasks → Subtasks
```
- Cada funcionalidad se descompone en tareas atómicas
- Las tareas son independientes y pueden ser asignadas a diferentes desarrolladores
- Estimación basada en complejidad y tiempo de las tareas

#### 2. **Sprints Semanales**
- **Duración**: 7 días calendario (5 días hábiles)
- **Objetivo**: Entregar valor incremental cada semana
- **Flexibilidad**: Adaptación rápida a cambios y feedback

#### 3. **Integración Continua**
- Cada tarea completada se integra inmediatamente
- Testing automatizado en cada commit
- Deployment continuo a entornos de desarrollo y staging

## Gestión de Tareas

### Estructura de Tareas en GitHub Projects

#### Campos Personalizados
```yaml
Task Fields:
  - Title: [Título descriptivo de la tarea]
  - Description: [Descripción detallada]
```

#### Estados de Tareas
1. **Backlog**: Tarea definida pero no iniciada
2. **In Progress**: Tarea en desarrollo activo
3. **Ready**: Tarea completada, en revisión de código
4. **Done**: Tarea completada y validada

### Criterios de Definición

#### Definition of Done (DoD)
Una tarea se considera completada cuando:
- [ ] Código implementado según especificaciones
- [ ] Pruebas unitarias escritas y pasando
- [ ] Code review completado y aprobado
- [ ] Documentación actualizada
- [ ] Desplegado en entorno de desarrollo
- [ ] Criterios de aceptación validados
- [ ] No hay bugs críticos pendientes

## Herramientas y Configuración

### GitHub Projects - Configuración

#### Board Layout
```
┌─────────────┬─────────────┬─────────────┬─────────────┐
│   Backlog   │ In Progress │    Ready    │    Done     │
├─────────────┼─────────────┼─────────────┼─────────────┤
│ Task 001    │ Task 003    │ Task 008    │ Task 009    │
│ Task 002    │ Task 005    │             │ Task 010    │
│ Task 005    │             │             │             │
│ Task 007    │             │             │             │
└─────────────┴─────────────┴─────────────┴─────────────┘
```

#### Vistas Configuradas
1. **Sprint Board**: Vista Kanban por sprint actual
2. **Backlog**: Lista de todas las tareas pendientes
3. **By Assignee**: Tareas agrupadas por desarrollador

## Flujo de Trabajo

### Flujo Diario de Desarrollo

#### 1. Morning Standup (9:00 AM - 15 min)
```
Agenda:
- ¿Qué hiciste ayer?
- ¿Qué harás hoy?
- ¿Hay algún impedimento?
- Revisión rápida del board
```

#### 2. Desarrollo y Actualización de Tareas
```bash
# Flujo típico de una tarea
1. Mover tarea a "In Progress"
2. Crear branch: git checkout -b feature/task-1.1-gke-setup
3. Desarrollar funcionalidad
4. Commit frecuentes con referencia: git commit -m "feat: configure GKE cluster #1"
5. Push y crear PR
6. Tarea se mueve automáticamente a "In Review"
7. Code review y merge
8. Tarea se mueve automáticamente a "Done"
```

## Ceremonias Ágiles

### Daily Standup
- **Duración**: 15 minutos
- **Horario**: 9:00 AM
- **Formato**: Presencial/Virtual
- **Participantes**: Todo el equipo de desarrollo

**Estructura**:
```
Por cada miembro del equipo:
1. Progreso desde ayer
2. Plan para hoy
3. Impedimentos o bloqueos

Revisión del board:
- Tareas en progreso
- Tareas bloqueadas
- Próximas tareas a iniciar
```

### Sprint Planning
- **Duración**: 1 hora
- **Frecuencia**: Inicio de cada sprint (lunes)
- **Participantes**: Equipo completo + Product Owner

**Agenda**:
```
1. Revisión de objetivos del sprint (10 min)
2. Refinamiento del backlog (20 min)
3. Estimación de tareas (15 min)
4. Asignación de tareas (10 min)
5. Identificación de riesgos (5 min)
```

### Sprint Review
- **Duración**: 30 minutos
- **Frecuencia**: Final de cada sprint (viernes)
- **Participantes**: Equipo + Stakeholders

**Formato**:
```
1. Demo de funcionalidades (20 min)
   - Mostrar tareas completadas
   - Validar criterios de aceptación
   - Feedback inmediato
```

### Sprint Retrospective
- **Duración**: 30 minutos
- **Frecuencia**: Final de cada sprint (viernes)

**Técnica Utilizada**: Start-Stop-Continue
```
START (¿Qué deberíamos empezar a hacer?)
- Nuevas prácticas o herramientas
- Mejoras identificadas

STOP (¿Qué deberíamos dejar de hacer?)
- Prácticas que no agregan valor
- Impedimentos recurrentes

CONTINUE (¿Qué deberíamos seguir haciendo?)
- Prácticas que funcionan bien
- Fortalezas del equipo
```

## Roles y Responsabilidades

### Product Owner
- **Responsabilidades**:
  - Definir y priorizar el backlog
  - Escribir criterios de aceptación
  - Validar funcionalidades completadas
  - Tomar decisiones sobre el producto

- **Participación en Ceremonias**:
  - Sprint Planning: Obligatoria
  - Sprint Review: Obligatoria
  - Daily Standup: Opcional
  - Retrospective: No participa

### Scrum Master /
- **Responsabilidades**:
  - Facilitar ceremonias ágiles
  - Remover impedimentos
  - Coaching del equipo en prácticas ágiles
  - Mantener métricas y reportes

- **Actividades Diarias**:
  - Actualizar board de GitHub Projects
  - Identificar y resolver bloqueos
  - Facilitar comunicación entre equipo
  - Monitorear progreso del sprint

### Development Team

#### Backend Developer
- **Responsabilidades**:
  - Desarrollar microservicios
  - Escribir pruebas unitarias

- **Tareas Típicas**:
  - Implementar servicios de negocio
  - Configurar circuit breakers
  - Integrar con service discovery

#### DevOps Engineer
- **Responsabilidades**:
  - Configurar infraestructura
  - Mantener pipelines CI/CD
  - Monitoreo y observabilidad
  - Gestión de deployments

- **Tareas Típicas**:
  - Configurar Kubernetes
  - Mantener Jenkins pipelines
  - Configurar monitoreo
  - Gestionar secrets y configuraciones

## Evidencia del Proyecto

### GitHub Projects Board - Vista Real del Proyecto

La siguiente imagen muestra el board real de GitHub Projects utilizado durante el desarrollo del proyecto, donde se puede observar la implementación práctica de nuestra metodología ágil:

![GitHub Projects Board - Metodología Ágil](/ecommerce-microservice-backend-app/docs/images/image-1.png)

Esta captura demuestra la implementación exitosa de nuestra metodología de gestión por tareas, mostrando cómo GitHub Projects facilitó la transparencia y organización del trabajo durante el desarrollo del proyecto de microservicios.

![GitHub Projects Board - Metodología Ágil](/ecommerce-microservice-backend-app/docs/images/image-2.png)