# Planes de Rollback para CI/CD - Proyecto E-Commerce Microservicios


## 1. Introducción

### 1.1 Objetivo
Este documento define los planes de rollback para el proyecto de microservicios de e-commerce desplegado en Google Kubernetes Engine (GKE), estableciendo procedimientos claros para revertir cambios en caso de fallos durante el proceso de CI/CD.

### 1.2 Alcance
Los planes de rollback cubren:
- Infraestructura como Código (Terraform)
- Aplicaciones de microservicios
- Configuraciones de Kubernetes
- Pipelines de Jenkins
- Configuraciones de red y seguridad

### 1.3 Principios de Rollback
- **Rapidez**: Minimizar el tiempo de inactividad
- **Seguridad**: Preservar la integridad de los datos
- **Trazabilidad**: Documentar todas las acciones de rollback
- **Automatización**: Preferir procesos automatizados cuando sea posible
- **Validación**: Verificar el estado del sistema post-rollback

---

## 2. Clasificación de Rollbacks

### 2.1 Por Tipo de Componente

#### Rollback de Aplicación
- **Alcance**: Microservicios individuales
- **Tiempo de Ejecución**: 5-15 minutos
- **Impacto**: Limitado al servicio específico
- **Automatización**: Alta

#### Rollback de Infraestructura
- **Alcance**: Cluster de Kubernetes, recursos de GCP
- **Tiempo de Ejecución**: 15-45 minutos
- **Impacto**: Potencialmente alto
- **Automatización**: Media

#### Rollback de Configuración
- **Alcance**: ConfigMaps, Secrets, Service Discovery
- **Tiempo de Ejecución**: 2-10 minutos
- **Impacto**: Variable según configuración
- **Automatización**: Alta

### 2.2 Por Severidad

#### Rollback de Emergencia
- **Criterios**: Servicios críticos caídos, pérdida de datos inminente
- **SLA**: < 5 minutos para iniciar
- **Aprobación**: Automática o verbal del Change Owner
- **Documentación**: Post-rollback (24 horas)

#### Rollback Estándar
- **Criterios**: Degradación de performance, funcionalidades no críticas
- **SLA**: < 30 minutos para iniciar
- **Aprobación**: Change Owner + Technical Reviewer
- **Documentación**: Pre y post-rollback

#### Rollback Planificado
- **Criterios**: Rollback preventivo, ventana de mantenimiento
- **SLA**: Según ventana programada
- **Aprobación**: Proceso completo de Change Management
- **Documentación**: Completa y detallada

---

## 3. Estrategias de Rollback por Ambiente

### 3.1 Ambiente de Desarrollo (dev)
```yaml
Estrategia: Recreación completa
Tiempo de Tolerancia: 30 minutos
Datos Críticos: No
Automatización: 100%
```

**Procedimiento:**
1. Ejecutar pipeline de rollback automático
2. Recrear desde branch dev anterior
3. Validar funcionalidad básica

### 3.2 Ambiente de Staging (stage)
```yaml
Estrategia: Blue-Green Deployment
Tiempo de Tolerancia: 15 minutos
Datos Críticos: Datos de prueba
Automatización: 90%
```

**Procedimiento:**
1. Cambiar tráfico al ambiente anterior (Blue)
2. Validar funcionalidad completa
3. Mantener ambiente fallido para análisis

### 3.3 Ambiente de Producción (main)
```yaml
Estrategia: Rolling Update Reverso
Tiempo de Tolerancia: 5 minutos
Datos Críticos: Sí
Automatización: 70%
```

**Procedimiento:**
1. Rollback inmediato a versión anterior
2. Validación de integridad de datos
3. Comunicación a stakeholders
4. Análisis post-mortem

---

## 4. Rollback de Microservicios

### 4.1 Rollback Individual de Microservicio

#### Prerrequisitos
```bash
# Verificar versiones disponibles
kubectl get deployments -n ecommerce
kubectl rollout history deployment/user-service -n ecommerce
kubectl rollout history deployment/product-service -n ecommerce
```

#### Procedimiento Manual
```bash
# 1. Identificar versión actual y anterior
kubectl get deployment user-service -n ecommerce -o yaml | grep image:

# 2. Ejecutar rollback
kubectl rollout undo deployment/user-service -n ecommerce

# 3. Monitorear progreso
kubectl rollout status deployment/user-service -n ecommerce

# 4. Verificar pods
kubectl get pods -l app=user-service -n ecommerce

# 5. Validar health check
kubectl exec -it $(kubectl get pod -l app=user-service -n ecommerce -o jsonpath='{.items[0].metadata.name}') -- curl localhost:8080/actuator/health
```

### 4.2 Rollback de Múltiples Microservicios

#### Escenario: Rollback Completo del Sistema
```bash
#!/bin/bash
# rollback-all-services.sh

SERVICES=("user-service" "product-service" "order-service" "payment-service" "shipping-service" "favourite-service")
NAMESPACE="ecommerce"
TIMEOUT="300s"

echo "Iniciando rollback completo del sistema..."

for SERVICE in "${SERVICES[@]}"; do
    echo "Rollback de $SERVICE..."
    
    # Ejecutar rollback
    kubectl rollout undo deployment/$SERVICE -n $NAMESPACE
    
    # Esperar completar
    kubectl rollout status deployment/$SERVICE -n $NAMESPACE --timeout=$TIMEOUT
    
    if [ $? -eq 0 ]; then
        echo "✅ $SERVICE rollback exitoso"
    else
        echo "❌ $SERVICE rollback falló"
        exit 1
    fi
done

echo "Rollback completo del sistema finalizado"
```

### 4.3 Rollback de Servicios de Infraestructura

#### Service Discovery (Eureka)
```bash
# Rollback del servicio de descubrimiento
kubectl rollout undo deployment/service-discovery -n infrastructure

# Verificar que los servicios se re-registren
kubectl logs -f deployment/service-discovery -n infrastructure
```

#### API Gateway
```bash
# Rollback del API Gateway
kubectl rollout undo deployment/api-gateway -n infrastructure

# Verificar rutas y balanceadores
kubectl get ingress -n infrastructure
```

#### Cloud Config
```bash
# Rollback del servidor de configuración
kubectl rollout undo deployment/cloud-config -n infrastructure

# Verificar que los servicios obtengan configuración
kubectl logs -f deployment/cloud-config -n infrastructure
```

---

## 5. Rollback de Infraestructura

### 5.1 Rollback de Terraform

#### Preparación
```bash
# Verificar estado actual
terraform state list
terraform show

# Crear backup del estado actual
terraform state pull > backup-$(date +%Y%m%d-%H%M%S).tfstate
```

#### Rollback a Versión Anterior
```bash
# Opción 1: Rollback usando Git
git log --oneline -10  # Identificar commit anterior
git checkout <commit-hash>
terraform plan
terraform apply

# Opción 2: Rollback usando estado específico
terraform state push backup-previous-state.tfstate
terraform plan
terraform apply
```

#### Rollback de Cluster GKE
```bash
# Verificar versiones disponibles
gcloud container get-server-config --region=us-central1

# Rollback a versión anterior del cluster
# Nota: Esto debe hacerse con extremo cuidado
terraform plan -var="kubernetes_version=1.27.8-gke.1067004"
terraform apply
```

### 5.2 Rollback de Configuraciones de Red

#### VPC y Subnets
```bash
# Rollback de configuraciones de red
cd terraform/networking
git checkout HEAD~1 -- main.tf
terraform plan
terraform apply
```

#### Firewall Rules
```bash
# Rollback de reglas de firewall
cd terraform/security
terraform state list | grep google_compute_firewall
terraform plan -target=google_compute_firewall.allow_internal
terraform apply -target=google_compute_firewall.allow_internal
```

---

## 6. Rollback de Configuraciones

### 6.1 ConfigMaps y Secrets

#### Rollback de ConfigMaps
```bash
# Listar versiones de ConfigMaps
kubectl get configmaps -n ecommerce

# Rollback usando backup
kubectl apply -f configmap-backup-20250127.yaml

# Verificar que los pods reciban la nueva configuración
kubectl rollout restart deployment/user-service -n ecommerce
```

#### Rollback de Secrets
```bash
# Rollback de secrets (con precaución)
kubectl get secrets -n ecommerce

# Aplicar backup de secrets
kubectl apply -f secrets-backup-20250127.yaml

# Reiniciar servicios que usan los secrets
kubectl rollout restart deployment/payment-service -n ecommerce
```

### 6.2 Rollback de Helm Charts

#### Identificar Releases
```bash
# Listar releases de Helm
helm list -n monitoring

# Ver historial de releases
helm history prometheus -n monitoring
```

#### Ejecutar Rollback
```bash
# Rollback a versión anterior
helm rollback prometheus 1 -n monitoring

# Verificar estado post-rollback
helm status prometheus -n monitoring
```

---


## 8. Procedimientos de Emergencia

### 8.1 Rollback de Emergencia Completo

#### Trigger de Emergencia
- Pérdida de servicio > 5 minutos
- Corrupción de datos detectada
- Vulnerabilidad de seguridad crítica
- Fallo en servicios de infraestructura críticos

#### Procedimiento de Emergencia
```bash
#!/bin/bash
# emergency-rollback.sh

echo "INICIANDO ROLLBACK DE EMERGENCIA"
echo "Timestamp: $(date)"

# 1. Rollback de todos los microservicios
echo "Rollback de microservicios..."
./rollback-all-services.sh

# 2. Rollback de servicios de infraestructura
echo "Rollback de infraestructura..."
kubectl rollout undo deployment/api-gateway -n infrastructure
kubectl rollout undo deployment/service-discovery -n infrastructure
kubectl rollout undo deployment/cloud-config -n infrastructure

# 3. Verificar estado del cluster
echo "Verificando estado del cluster..."
kubectl get pods -A | grep -v Running

# 4. Ejecutar health checks
echo "Ejecutando health checks..."
./health-check-all.sh

# 5. Notificar
echo "Enviando notificaciones..."
curl -X POST -H 'Content-type: application/json' \
  --data '{"text":"🚨 ROLLBACK DE EMERGENCIA EJECUTADO - Sistema restaurado"}' \
  $SLACK_WEBHOOK_URL

echo "ROLLBACK DE EMERGENCIA COMPLETADO"
```

### 8.2 Comunicación de Emergencia

#### Plantilla de Comunicación
```
ASUNTO: [EMERGENCIA] Rollback Ejecutado - Sistema E-Commerce

Estimado equipo,

Se ha ejecutado un rollback de emergencia en el sistema de e-commerce debido a:
- Motivo: [DESCRIPCIÓN DEL PROBLEMA]
- Hora de inicio: [TIMESTAMP]
- Hora de finalización: [TIMESTAMP]
- Servicios afectados: [LISTA DE SERVICIOS]

Estado actual:
- ✅ Rollback completado exitosamente
- ✅ Servicios restaurados y operacionales
- ✅ Health checks pasando

Próximos pasos:
1. Análisis post-mortem programado para [FECHA]
2. Revisión de logs y métricas
3. Plan de corrección y re-despliegue

Contacto: [RESPONSABLE]
```

---

## 9. Validación Post-Rollback

### 9.1 Health Checks Automatizados

#### Script de Validación Completa
```bash
#!/bin/bash
# health-check-all.sh

SERVICES=("user-service" "product-service" "order-service" "payment-service" "shipping-service" "favourite-service")
INFRASTRUCTURE=("api-gateway" "service-discovery" "cloud-config")
NAMESPACE_APP="ecommerce"
NAMESPACE_INFRA="infrastructure"

echo "Iniciando validación post-rollback..."

# Verificar microservicios
for SERVICE in "${SERVICES[@]}"; do
    echo "Verificando $SERVICE..."
    
    # Verificar pods
    READY_PODS=$(kubectl get pods -l app=$SERVICE -n $NAMESPACE_APP -o jsonpath='{.items[*].status.conditions[?(@.type=="Ready")].status}' | grep -c True)
    TOTAL_PODS=$(kubectl get pods -l app=$SERVICE -n $NAMESPACE_APP --no-headers | wc -l)
    
    if [ "$READY_PODS" -eq "$TOTAL_PODS" ] && [ "$TOTAL_PODS" -gt 0 ]; then
        echo "✅ $SERVICE: $READY_PODS/$TOTAL_PODS pods ready"
    else
        echo "❌ $SERVICE: $READY_PODS/$TOTAL_PODS pods ready"
    fi
    
    # Health check HTTP
    SERVICE_URL=$(kubectl get svc $SERVICE -n $NAMESPACE_APP -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    if [ ! -z "$SERVICE_URL" ]; then
        HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://$SERVICE_URL/actuator/health)
        if [ "$HTTP_STATUS" -eq 200 ]; then
            echo "✅ $SERVICE: Health check OK"
        else
            echo "❌ $SERVICE: Health check failed (HTTP $HTTP_STATUS)"
        fi
    fi
done

# Verificar servicios de infraestructura
for SERVICE in "${INFRASTRUCTURE[@]}"; do
    echo "Verificando $SERVICE..."
    
    READY_PODS=$(kubectl get pods -l app=$SERVICE -n $NAMESPACE_INFRA -o jsonpath='{.items[*].status.conditions[?(@.type=="Ready")].status}' | grep -c True)
    TOTAL_PODS=$(kubectl get pods -l app=$SERVICE -n $NAMESPACE_INFRA --no-headers | wc -l)
    
    if [ "$READY_PODS" -eq "$TOTAL_PODS" ] && [ "$TOTAL_PODS" -gt 0 ]; then
        echo "✅ $SERVICE: $READY_PODS/$TOTAL_PODS pods ready"
    else
        echo "❌ $SERVICE: $READY_PODS/$TOTAL_PODS pods ready"
    fi
done

echo "Validación post-rollback completada"
```

### 9.2 Pruebas Funcionales

#### Pruebas de Integración Post-Rollback
```bash
#!/bin/bash
# integration-tests-post-rollback.sh

API_GATEWAY_URL=$(kubectl get svc api-gateway -n infrastructure -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

echo "Ejecutando pruebas de integración..."

# Test 1: Registro de usuario
echo "Test 1: Registro de usuario"
RESPONSE=$(curl -s -X POST http://$API_GATEWAY_URL/users \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser","email":"test@example.com","password":"password123"}')

if echo $RESPONSE | grep -q "id"; then
    echo "✅ Test 1 passed"
else
    echo "❌ Test 1 failed"
fi

# Test 2: Consulta de productos
echo "Test 2: Consulta de productos"
RESPONSE=$(curl -s http://$API_GATEWAY_URL/products)

if echo $RESPONSE | grep -q "\["; then
    echo "✅ Test 2 passed"
else
    echo "❌ Test 2 failed"
fi

# Test 3: Creación de pedido
echo "Test 3: Creación de pedido"
RESPONSE=$(curl -s -X POST http://$API_GATEWAY_URL/orders \
  -H "Content-Type: application/json" \
  -d '{"userId":1,"products":[{"productId":1,"quantity":2}]}')

if echo $RESPONSE | grep -q "orderId"; then
    echo "✅ Test 3 passed"
else
    echo "❌ Test 3 failed"
fi

echo "Pruebas de integración completadas"
```

---

## 10. Monitoreo y Alertas

### 10.1 Métricas Clave Post-Rollback

#### Métricas de Sistema
- CPU y memoria de pods
- Latencia de respuesta de APIs
- Tasa de errores HTTP
- Disponibilidad de servicios

#### Métricas de Negocio
- Transacciones completadas
- Usuarios activos
- Pedidos procesados
- Pagos exitosos

---

## 11. Documentación y Reportes

### 11.1 Plantilla de Reporte de Rollback

```markdown
# Reporte de Rollback

## Información General
- **Fecha y Hora**: [TIMESTAMP]
- **Tipo de Rollback**: [Emergencia/Estándar/Planificado]
- **Ejecutado por**: [NOMBRE]
- **Duración Total**: [TIEMPO]

## Motivo del Rollback
- **Problema Identificado**: [DESCRIPCIÓN]
- **Impacto**: [DESCRIPCIÓN DEL IMPACTO]
- **Severidad**: [Critical/High/Medium/Low]

## Componentes Afectados
- **Microservicios**: [LISTA]
- **Infraestructura**: [LISTA]
- **Configuraciones**: [LISTA]

## Procedimiento Ejecutado
1. [PASO 1]
2. [PASO 2]
3. [PASO 3]
...

## Validación Post-Rollback
- **Health Checks**: [RESULTADO]
- **Pruebas Funcionales**: [RESULTADO]
- **Métricas de Sistema**: [RESULTADO]

## Lecciones Aprendidas
- [LECCIÓN 1]
- [LECCIÓN 2]
- [LECCIÓN 3]

## Acciones de Seguimiento
- [ ] [ACCIÓN 1]
- [ ] [ACCIÓN 2]
- [ ] [ACCIÓN 3]
```

### 11.2 Métricas de Rollback

#### KPIs de Rollback
- **MTTR (Mean Time To Recovery)**: Tiempo promedio de recuperación
- **RTO (Recovery Time Objective)**: Objetivo de tiempo de recuperación
- **RPO (Recovery Point Objective)**: Objetivo de punto de recuperación
- **Tasa de Éxito de Rollback**: Porcentaje de rollbacks exitosos
---

## 12. Mejores Prácticas y Recomendaciones

### 12.1 Prevención de Rollbacks

#### Estrategias de Prevención
- **Testing Exhaustivo**: Pruebas automatizadas completas
- **Deployment Gradual**: Canary deployments y blue-green
- **Monitoring Proactivo**: Alertas tempranas de problemas
- **Feature Flags**: Desactivación rápida de funcionalidades

#### Preparación para Rollbacks
- **Backup Automático**: Antes de cada deployment
- **Versionado Consistente**: Etiquetado claro de versiones
- **Documentación Actualizada**: Procedimientos siempre actualizados
- **Pruebas de Rollback**: Validación periódica de procedimientos

#### Rollback Progresivo
```bash
# Rollback progresivo por porcentajes
kubectl patch deployment user-service -p '{"spec":{"replicas":3}}'  # 100% old
kubectl patch deployment user-service -p '{"spec":{"replicas":2}}'  # 66% old, 33% new
kubectl patch deployment user-service -p '{"spec":{"replicas":1}}'  # 33% old, 66% new
kubectl patch deployment user-service -p '{"spec":{"replicas":0}}'  # 100% new
```

---

## 14. Anexos

### 14.1 Comandos de Referencia Rápida

```bash
# Rollback rápido de deployment
kubectl rollout undo deployment/[SERVICE-NAME] -n [NAMESPACE]

# Verificar estado de rollback
kubectl rollout status deployment/[SERVICE-NAME] -n [NAMESPACE]

# Listar historial de deployments
kubectl rollout history deployment/[SERVICE-NAME] -n [NAMESPACE]

# Rollback a versión específica
kubectl rollout undo deployment/[SERVICE-NAME] --to-revision=[REVISION] -n [NAMESPACE]

# Verificar pods después del rollback
kubectl get pods -l app=[SERVICE-NAME] -n [NAMESPACE]

# Health check rápido
kubectl exec -it [POD-NAME] -n [NAMESPACE] -- curl localhost:8080/actuator/health
```

### 14.2 Checklist de Rollback

#### Pre-Rollback
- [ ] Identificar causa raíz del problema
- [ ] Determinar alcance del rollback
- [ ] Notificar a stakeholders
- [ ] Crear backup del estado actual
- [ ] Verificar disponibilidad de versión anterior

#### Durante Rollback
- [ ] Ejecutar procedimiento documentado
- [ ] Monitorear progreso en tiempo real
- [ ] Documentar acciones tomadas
- [ ] Comunicar estado a stakeholders
- [ ] Validar cada paso antes de continuar

#### Post-Rollback
- [ ] Ejecutar health checks completos
- [ ] Verificar funcionalidad del sistema
- [ ] Confirmar integridad de datos
- [ ] Actualizar monitoreo y alertas
- [ ] Documentar lecciones aprendidas
- [ ] Planificar corrección y re-despliegue
