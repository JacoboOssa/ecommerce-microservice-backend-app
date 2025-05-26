pipeline {
    agent any

    tools {
        maven 'withMaven'
        jdk 'JDK_11'
    }

    environment {
        DOCKERHUB_USER = 'jacoboossag'
        DOCKER_CREDENTIALS_ID = 'docker_hub_pwd'
        SERVICES = 'api-gateway cloud-config favourite-service order-service payment-service product-service proxy-client service-discovery shipping-service user-service locust'
        K8S_NAMESPACE = 'ecommerce'
    }

    stages {
        stage('Init') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'master') {
                        env.SPRING_PROFILE = 'prod'
                        env.IMAGE_TAG = 'prod'
                        env.DEPLOYMENT_SUFFIX = '-prod'

                    } else if (env.BRANCH_NAME == 'release') {
                        env.SPRING_PROFILE = 'stage'
                        env.IMAGE_TAG = 'stage'
                        env.DEPLOYMENT_SUFFIX = '-stage'

                    } else {
                        env.SPRING_PROFILE = 'dev'
                        env.IMAGE_TAG = 'dev'
                        env.DEPLOYMENT_SUFFIX = '-dev'
                    }

                    echo "Branch: ${env.BRANCH_NAME}"
                    echo "Namespace: ${env.K8S_NAMESPACE}"
                    echo "Spring profile: ${env.SPRING_PROFILE}"
                    echo "Image tag: ${env.IMAGE_TAG}"
                    echo "Deployment suffix: ${env.DEPLOYMENT_SUFFIX}"
                }
            }
        }

        stage('Ensure Namespace') {
            steps {
                script {
                    def ns = env.K8S_NAMESPACE
                    sh "kubectl get namespace ${ns} || kubectl create namespace ${ns}"
                }
            }
        }

        stage('Checkout') {
            steps {
                git branch: "${env.BRANCH_NAME}", url: 'https://github.com/JacoboOssa/ecommerce-microservice-backend-app'
            }
        }

        stage('Verify Tools') {
            steps {
                sh 'java -version'
                sh 'mvn -version'
                sh 'docker --version'
                sh 'kubectl config current-context'

            }
        }
        // Debo quitar el paralell
        //Debo cambiar a que solo se ejecuten cuando se pushea a dev (PR a dev - desde feature/*)
        //Deberia construir dependiendo de la rama, esto se haria en el dockerfile solo le paso el perfil a esta env SPRING_PROFILES_ACTIVE
        // stage('Unit Tests') {
        //     parallel {
        //         stage('Unit Tests') {
        //             when {
        //                 anyOf {
        //                     branch 'dev'
        //                     branch 'master'
        //                     branch 'release'
        //                     expression { env.BRANCH_NAME.startsWith('feature/') }
        //                 }
        //             }
        //             steps {
        //                 script {
        //                     echo "🔍 Running Unit Tests for ${env.BRANCH_NAME}"
        //                     sh "mvn test -pl product-service"
        //                     sh "mvn test -pl user-service"
        //                 }
        //             }
        //         }
        //     }
        // }

        // //Debo probar esto solo cuando vaya de stage a master
        // stage('Integration Tests') {
        //     parallel {
        //         stage('Integration Tests') {
        //             when {
        //                 anyOf {
        //                     branch 'master'
        //                     expression { env.BRANCH_NAME.startsWith('feature/') }
        //                     allOf {
        //                         not { branch 'master' }
        //                         not { branch 'release' }
        //                     }
        //                 }
        //             }
        //             steps {
        //                 script {
        //                     echo "🧪 Running Integration Tests for ${env.BRANCH_NAME}"
        //                     sh "mvn verify -pl product-service"
        //                     sh "mvn verify -pl user-service"
        //                 }
        //             }
        //         }
        //     }
        // }



        // Debo probar esto solo cuando vaya de stage a master
        // stage('E2E Tests') {
        //             parallel {
        //                 stage('E2E Tests') {
        //                     when {
        //                         anyOf {
        //                             branch 'master'
        //                             expression { env.BRANCH_NAME.startsWith('feature/') }
        //                             allOf {
        //                                 not { branch 'master' }
        //                                 not { branch 'release' }
        //                             }
        //                         }
        //                     }
        //                     steps {
        //                         script {
        //                             echo "🧪 Running Integration Tests for ${env.BRANCH_NAME}"
        //                             sh "mvn verify -pl e2e-tests"
        //                         }
        //                     }
        //                 }
        //             }
        //         }

        //Debo agregar el stage para locust, deberia probar con las imagenes desplegas en kubernetes, hacer
        //el deploy de las imagenes en el cluster y luego ejecutar locust, probar, tener una metrica que pase
        //el test eliminar esos deploy y pods con tag stage y luego subir los de prod

        stage('Build Services') {
            when {
                anyOf {
                    branch 'master'
                    branch 'release'
                }
            }
            steps {
                sh "mvn clean package -DskipTests"
            }
        }

        stage('Build Docker Images') {
            when { branch 'master' }
            steps {
                script {
                    SERVICES.split().each { service ->
                        sh "docker buildx build --platform linux/amd64,linux/arm64 -t ${DOCKERHUB_USER}/${service}:${IMAGE_TAG} ./${service}"
                    }
                }
            }
        }

        stage('Push Docker Images') {
            when { branch 'master' }
            steps {
                withCredentials([string(credentialsId: "${DOCKER_CREDENTIALS_ID}", variable: 'docker_hub_pwd')]) {
                    sh "docker login -u ${DOCKERHUB_USER} -p ${docker_hub_pwd}"
                    script {
                        SERVICES.split().each { service ->
                            sh "docker push ${DOCKERHUB_USER}/${service}:${IMAGE_TAG}"
                        }
                    }
                }
            }
        }
        
        stage('Levantar contenedores para pruebas') {
            steps {
                script {
                    sh '''
                    docker network create ecommerce-test || true
                    echo "🚀 Levantando ZIPKIN..."
                    docker run -d --name zipkin-container --network ecommerce-test -p 9411:9411 openzipkin/zipkin

                    echo "🚀 Levantando EUREKA..."
                    docker run -d --name service-discovery-container --network ecommerce-test -p 8761:8761 \\
                        -e SPRING_PROFILES_ACTIVE=dev \\
                        -e SPRING_ZIPKIN_BASE_URL=http://zipkin-container:9411 \\
                        jacoboossag/service-discovery:${IMAGE_TAG}

                    until curl -s http://localhost:8761/actuator/health | grep '"status":"UP"' > /dev/null; do
                        echo "⌛ Esperando EUREKA..."
                        sleep 5
                    done

                    echo "🚀 Levantando CLOUD-CONFIG..."
                    docker run -d --name cloud-config-container --network ecommerce-test -p 9296:9296 \\
                        -e SPRING_PROFILES_ACTIVE=dev \\
                        -e SPRING_ZIPKIN_BASE_URL=http://zipkin-container:9411 \\
                        -e EUREKA_CLIENT_SERVICEURL_DEFAULTZONE=http://service-discovery-container:8761/eureka/ \\
                        -e EUREKA_INSTANCE=cloud-config-container \\
                        jacoboossag/cloud-config:${IMAGE_TAG}

                    until curl -s http://localhost:9296/actuator/health | grep '"status":"UP"' > /dev/null; do
                        echo "⌛ Esperando CLOUD-CONFIG..."
                        sleep 5
                    done

                    echo "🚀 Levantando ORDER-SERVICE..."
                    docker run -d --name order-service-container --network ecommerce-test -p 8300:8300 \\
                        -e SPRING_PROFILES_ACTIVE=dev \\
                        -e SPRING_ZIPKIN_BASE_URL=http://zipkin-container:9411 \\
                        -e SPRING_CONFIG_IMPORT=optional:configserver:http://cloud-config-container:9296 \\
                        -e EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE=http://service-discovery-container:8761/eureka \\
                        -e EUREKA_INSTANCE=order-service-container \\
                        jacoboossag/order-service:${IMAGE_TAG}

                    until [ "$(curl -s http://localhost:8300/order-service/actuator/health | jq -r '.status')" = "UP" ]; do
                        echo "⌛ Esperando ORDER-SERVICE..."
                        sleep 5
                    done


                    echo "🚀 Levantando PAYMENT..."
                    docker run -d --name payment-service-container --network ecommerce-test -p 8400:8400 \\
                        -e SPRING_PROFILES_ACTIVE=dev \\
                        -e SPRING_ZIPKIN_BASE_URL=http://zipkin-container:9411 \\
                        -e SPRING_CONFIG_IMPORT=optional:configserver:http://cloud-config-container:9296 \\
                        -e EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE=http://service-discovery-container:8761/eureka \\
                        -e EUREKA_INSTANCE=payment-service-container \\
                        jacoboossag/payment-service:${IMAGE_TAG}
                    
                    until [ "$(curl -s http://localhost:8400/payment-service/actuator/health | jq -r '.status')" = "UP" ]; do
                        echo "⌛ Esperando PAYMENT-SERVICE..."
                        sleep 5
                    done

                    echo "🚀 Levantando PRODUCT..."
                    docker run -d --name product-service-container --network ecommerce-test -p 8500:8500 \\
                        -e SPRING_PROFILES_ACTIVE=dev \\
                        -e SPRING_ZIPKIN_BASE_URL=http://zipkin-container:9411 \\
                        -e SPRING_CONFIG_IMPORT=optional:configserver:http://cloud-config-container:9296 \\
                        -e EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE=http://service-discovery-container:8761/eureka \\
                        -e EUREKA_INSTANCE=product-service-container \\
                        jacoboossag/product-service:${IMAGE_TAG}

                    until [ "$(curl -s http://localhost:8500/product-service/actuator/health | jq -r '.status')" = "UP" ]; do
                        echo "⌛ Esperando PRODUCT-SERVICE..."
                        sleep 5
                    done


                    echo "🚀 Levantando SHIPPING..."
                    docker run -d --name shipping-service-container --network ecommerce-test -p 8600:8600 \\
                        -e SPRING_PROFILES_ACTIVE=dev \\
                        -e SPRING_ZIPKIN_BASE_URL=http://zipkin-container:9411 \\
                        -e SPRING_CONFIG_IMPORT=optional:configserver:http://cloud-config-container:9296 \\
                        -e EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE=http://service-discovery-container:8761/eureka \\
                        -e EUREKA_INSTANCE=shipping-service-container \\
                        jacoboossag/shipping-service:${IMAGE_TAG}

                    until [ "$(curl -s http://localhost:8600/shipping-service/actuator/health | jq -r '.status')" = "UP" ]; do
                        echo "⌛ Esperando SHIPPING-SERVICE..."
                        sleep 5
                    done

                    echo "🚀 Levantando USER..."
                    docker run -d --name user-service-container --network ecommerce-test -p 8700:8700 \\
                        -e SPRING_PROFILES_ACTIVE=dev \\
                        -e SPRING_ZIPKIN_BASE_URL=http://zipkin-container:9411 \\
                        -e SPRING_CONFIG_IMPORT=optional:configserver:http://cloud-config-container:9296 \\
                        -e EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE=http://service-discovery-container:8761/eureka \\
                        -e EUREKA_INSTANCE=user-service-container \\
                        jacoboossag/user-service:${IMAGE_TAG}

                    until [ "$(curl -s http://localhost:8700/user-service/actuator/health | jq -r '.status')" = "UP" ]; do
                        echo "⌛ Esperando USER-SERVICE..."
                        sleep 5
                    done

                    echo "🚀 Levantando FAVOURITE..."
                    docker run -d --name favourite-service-container --network ecommerce-test -p 8800:8800 \\
                        -e SPRING_PROFILES_ACTIVE=dev \\
                        -e SPRING_ZIPKIN_BASE_URL=http://zipkin-container:9411 \\
                        -e SPRING_CONFIG_IMPORT=optional:configserver:http://cloud-config-container:9296 \\
                        -e EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE=http://service-discovery-container:8761/eureka \\
                        -e EUREKA_INSTANCE=favourite-service-container \\
                        jacoboossag/favourite-service:${IMAGE_TAG}

                    until [ "$(curl -s http://localhost:8800/favourite-service/actuator/health | jq -r '.status')" = "UP" ]; do
                        echo "⌛ Esperando FAVOURITE-SERVICE..."
                        sleep 5
                    done

                    echo "✅ Todos los contenedores están arriba y saludables."
                    '''
                }
            }
        }


        stage('Run Load Tests with Locust') {
            when { branch 'master' }
            steps {
                script {
                    sh '''
                    echo "🚀 Levantando Locust..."
                    docker run -d --name locust --network ecommerce-test -p 8089:8089 jacoboossag/locust:${IMAGE_TAG}
                    
                    
                    echo "🎯 Ejecutando prueba de carga desde Locust..."
                    
                    //Ejecutar Locust en modo HEADLESS (sin UI) directamente si lo prefieres
                    docker run --rm --network ecommerce-test jacoboossag/locust:${IMAGE_TAG} \
                    -f /locust/locustfile.py \
                    --host http://favourite-service:8800 \
                    --headless -u 10 -r 2 -t 1m
                    
                    echo "✅ Prueba completada"
                    '''
                }
            }
        }
        
        stage('Detener y eliminar contenedores') {
            steps {
                script {
                    sh '''
                    echo "🛑 Deteniendo y eliminando contenedores..."

                    docker rm -f locust || true
                    docker rm -f favourite-service-container || true
                    docker rm -f user-service-container || true
                    docker rm -f shipping-service-container || true
                    docker rm -f product-service-container || true
                    docker rm -f payment-service-container || true
                    docker rm -f order-service-container || true
                    docker rm -f cloud-config-container || true
                    docker rm -f service-discovery-container || true
                    docker rm -f zipkin-container || true

                    echo "🧹 Todos los contenedores eliminados"
                '''
                }
            }
        }




        // stage('Deploy Common Config') {
        //     when { branch 'master' }
        //     steps {
        //         sh "kubectl apply -f k8s/common-config.yaml -n ${K8S_NAMESPACE}"
        //     }
        // }

        // stage('Deploy Core Services') {
        //     when { branch 'master' }
        //     steps {
        //         sh "kubectl apply -f k8s/zipkin/ -n ${K8S_NAMESPACE}"
        //         sh "kubectl rollout status deployment/zipkin -n ${K8S_NAMESPACE} --timeout=200s"

        //         sh "kubectl apply -f k8s/service-discovery/ -n ${K8S_NAMESPACE}"
        //         sh "kubectl set image deployment/service-discovery service-discovery=${DOCKERHUB_USER}/service-discovery:${IMAGE_TAG} -n ${K8S_NAMESPACE}"
        //         sh "kubectl rollout status deployment/service-discovery -n ${K8S_NAMESPACE} --timeout=200s"

        //         sh "kubectl apply -f k8s/cloud-config/ -n ${K8S_NAMESPACE}"
        //         sh "kubectl set image deployment/cloud-config cloud-config=${DOCKERHUB_USER}/cloud-config:${IMAGE_TAG} -n ${K8S_NAMESPACE}"
        //         sh "kubectl rollout status deployment/cloud-config -n ${K8S_NAMESPACE} --timeout=300s"
        //     }
        // }

        // stage('Deploy Microservices') {
        //     when { branch 'master' }
        //     steps {
        //         script {
        //             echo '👻👻👻👻👻👻'
        //         }
        //     }
        // }
    }

    post {
        success {
            script {
                echo "✅ Pipeline completed successfully for ${env.BRANCH_NAME} branch."
                echo "📊 Environment: ${env.SPRING_PROFILE}"

                if (env.BRANCH_NAME == 'master') {
                    echo "🚀 Production deployment completed successfully!"
                } else if (env.BRANCH_NAME == 'release') {
                    echo "🎯 Staging deployment completed successfully!"
                } else {
                    echo "🔧 Development tests completed successfully!"
                }
            }
        }
        failure {
            script {
                echo "❌ Pipeline failed for ${env.BRANCH_NAME} branch."
                echo "🔍 Check the logs for details."
                echo "📧 Notify the development team about the failure."
            }
        }
        unstable {
            script {
                echo "⚠️ Pipeline completed with warnings for ${env.BRANCH_NAME} branch."
                echo "🔍 Some tests may have failed. Review test reports."
            }
        }
    }    
}