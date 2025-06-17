# Estrategia de Branching para CI/CD

**Fecha:** 2025-06-12  
**Responsable:** Equipo de Desarrollo

---

## 1. Objetivo

Definir la estrategia de control de versiones y flujo de trabajo en Git para el proyecto, con el fin de:

- Facilitar un desarrollo colaborativo, ordenado y estable.
- Integrarse correctamente con el pipeline de CI/CD gestionado en Jenkins.
- Garantizar la estabilidad de los entornos de Stage y Producción.
- Simplificar la gestión de hotfixes y nuevas funcionalidades en un esquema de microservicios unificados en un único repositorio.

---

## 2. Modelo de Branching

Se utilizará el modelo **GitFlow simplificado**, adaptado a las características del proyecto:

- Equipo reducido (2 personas)
- Microservicios en monorepo
- Despliegues automatizados por rama vía Jenkins
- El versionado de microservicios se gestiona automáticamente en el pipeline de Jenkins

---

## 3. Ramas principales

### 3.1. main

- Representa el código estable desplegado o listo para producción.
- Sólo admite cambios mediante Pull Requests (PR).
- Todos los hotfixes deben ser mergeados a main.
- Jenkins despliega automáticamente el contenido de esta rama al entorno de Producción.

### 3.2. stage

- Rama estable de pre-producción (entorno Stage).
- Utilizada para validar integraciones y pruebas antes de subir a Producción.
- Jenkins despliega automáticamente al entorno Stage.

### 3.3. dev

- Rama de desarrollo activo donde se integran las features completadas.
- Utilizada como rama base para la integración continua de nuevas funcionalidades.
- Permite validar la integración de múltiples features antes de pasar a stage.
- Facilita la colaboración entre desarrolladores al tener un punto común de integración.

---

## 4. Ramas de desarrollo

### 4.1. feature/{nombre-de-la-feature}

- Se crean a partir de dev.
- Utilizadas para desarrollar nuevas funcionalidades, mejoras o refactorizaciones.
- Al finalizar el desarrollo:
  - Se realiza un PR hacia dev.
  - El código pasa por validaciones de CI (tests, lint, coverage, build).
- Ejemplo de nombres:
  - feature/agregar-login
  - feature/nuevo-endpoint-pedidos

---

## 5. Ramas de corrección

### 5.1. hotfix/{nombre-del-hotfix}

- Se crean directamente desde main cuando ocurre un incidente en Producción.
- Permiten corregir errores críticos sin interferir con el flujo de desarrollo.
- Al finalizar:
  - Se realiza PR hacia main.
  - Una vez mergeado, se integra el mismo cambio manualmente a dev y stage (para mantener coherencia).
- Ejemplos:
  - hotfix/corregir-token-expirado
  - hotfix/error-500-pagos

---

## 6. Flujo de Trabajo Resumido

feature/* --> dev --> stage --> main  
                        ↘  
                    hotfix/* --> main

---

## 7. Integración con CI/CD

### Herramientas utilizadas:

- Jenkins (CI/CD pipelines)
- GitHub (repositorio y control de PRs)
- Terraform (Infraestructura como código)
- GitHub Projects (gestión de tareas)

### Automatización de Despliegues:

| Rama  | Entorno de despliegue | Automatización |
|-------|------------------------|-----------------|
| main  | Producción             | Jenkins         |
| stage | Stage                  | Jenkins         |
| dev   | Desarrollo/Testing     | Jenkins ejecuta CI |
| feature/* | No despliega automáticamente | Jenkins ejecuta CI |

### Validaciones de PR:

- Todos los PR deben pasar:
  - Ejecución de tests automáticos
  - Validación de lint y calidad de código
  - Build completo

### Seguridad en ramas:

- main: protegida — solo admite PR.
- stage: sin protección de PR obligatoria, pero se recomienda revisión voluntaria.
- dev: sin protección de PR obligatoria, pero se recomienda revisión voluntaria.
- feature/* y hotfix/*: sin restricciones.

### Versionado de microservicios:

- Aunque no se utiliza versionado semántico en Git, **cada microservicio está versionado individualmente a través de Jenkins**.
- Jenkins asigna versiones automáticas durante la ejecución de los pipelines de build y despliegue.
- El control de versiones es gestionado en el pipeline y aplicado a las imágenes de contenedores u otros artefactos generados.

---

## 8. Políticas adicionales

- Se requiere aprobación de revisores obligatoria en los PR.
- Los pipelines de Jenkins ya cuentan con políticas de bloqueo en caso de fallos en los tests o el build.
- Los cambios de hotfix deben integrarse manualmente a dev y stage después de ser aplicados en main.

---

## 9. Diagrama General

feature/* --> dev --> stage --> main  
                        ↘  
                    hotfix/* --> main

---

## 10. Consideraciones Finales

Este flujo está diseñado para:

- Permitir rapidez de desarrollo con control básico de calidad.
- Evitar bloqueos administrativos innecesarios en un equipo pequeño.
- Mantener entornos sincronizados y estables.
- Responder rápidamente ante incidentes críticos.
- Facilitar la integración continua mediante la rama dev como punto de convergencia.

## 11. Repo de git 
![GitHub  - Ramas](/ecommerce-microservice-backend-app/docs/images/image-3.png)