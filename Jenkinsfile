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
                    echo "Detected branch: ${env.BRANCH_NAME}"
                    def profileConfig = [
                        master : ['prod', '-prod'],
                        stage: ['stage', '-stage']
                    ]
                    def config = profileConfig.get(env.BRANCH_NAME, ['dev', '-dev'])

                    env.SPRING_PROFILES_ACTIVE = config[0]
                    env.IMAGE_TAG = config[0]
                    env.DEPLOYMENT_SUFFIX = config[1]

                    env.IS_MASTER = env.BRANCH_NAME == 'master' ? 'true' : 'false'
                    env.IS_STAGE = env.BRANCH_NAME == 'stage' ? 'true' : 'false'
                    env.IS_DEV = env.BRANCH_NAME == 'dev' ? 'true' : 'false'
                    env.IS_FEATURE = env.BRANCH_NAME.startsWith('feature/') ? 'true' : 'false'

                    echo "Spring profile: ${env.SPRING_PROFILES_ACTIVE}"
                    echo "Image tag: ${env.IMAGE_TAG}"
                    echo "Deployment suffix: ${env.DEPLOYMENT_SUFFIX}"
                    echo "Flags: IS_MASTER=${env.IS_MASTER}, IS_STAGE=${env.IS_STAGE}, IS_DEV=${env.IS_DEV}, IS_FEATURE=${env.IS_FEATURE}"
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

        //Stage gral
        stage('Build Services') {
            when {
                anyOf {
                    branch 'dev'
                    branch 'stage'
                    branch 'master'
                }
            }
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Images') {
            when {
                anyOf {
                    branch 'dev'
                    branch 'stage'
                    branch 'master'
                }
            }
            steps {
                script {
                    SERVICES.split().each { service ->
                        sh "docker build -t ${DOCKERHUB_USER}/${service}:${IMAGE_TAG} --build-arg SPRING_PROFILES_ACTIVE=${SPRING_PROFILES_ACTIVE} ./${service}"
                    }
                }
            }
        }

        stage('Push Docker Images') {
            when {
                anyOf {
                    branch 'dev'
                    branch 'stage'
                    branch 'master'
                }
            }
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

                stage('Unit Tests') {
                        when { branch 'dev' }
                    steps {
                        script {
                            ['user-service', 'product-service'].each {
                                sh "mvn test -pl ${it}"
                            }
                        }
                    }
                }

                stage('Integration Tests') {
                    when { branch 'stage' }
                        steps {
                            script {
                                ['user-service', 'product-service'].each {
                                    sh "mvn verify -pl ${it}"
                                }
                            }
                        }
                }

                stage('E2E Tests') {
                    when { branch 'stage' }
                    steps {
                        script {
                            echo "🧪 Running Integration Tests for ${env.BRANCH_NAME}"
                            sh 'mvn verify -pl e2e-tests'
                        }
                    }
                }

        stage('Levantar contenedores para pruebas') {
                    when { branch 'stage' }
                    steps {
                        script {
                            sh '''
                            docker network create ecommerce-test || true
                            echo "🚀 Levantando ZIPKIN..."
                            docker run -d --name zipkin-container --network ecommerce-test -p 9411:9411 openzipkin/zipkin

                            echo "🚀 Levantando EUREKA..."
                            docker run -d --name service-discovery-container --network ecommerce-test -p 8761:8761 \\
                                -e SPRING_PROFILES_ACTIVE=stage \\
                                -e SPRING_ZIPKIN_BASE_URL=http://zipkin-container:9411 \\
                                jacoboossag/service-discovery:${IMAGE_TAG}

                            until curl -s http://localhost:8761/actuator/health | grep '"status":"UP"' > /dev/null; do
                                echo "⌛ Esperando EUREKA..."
                                sleep 5
                            done

                            echo "🚀 Levantando CLOUD-CONFIG..."
                            docker run -d --name cloud-config-container --network ecommerce-test -p 9296:9296 \\
                                -e SPRING_PROFILES_ACTIVE=stage \\
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
                                -e SPRING_PROFILES_ACTIVE=stage \\
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
                                -e SPRING_PROFILES_ACTIVE=stage \\
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
                                -e SPRING_PROFILES_ACTIVE=stage \\
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
                                -e SPRING_PROFILES_ACTIVE=stage \\
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
                                -e SPRING_PROFILES_ACTIVE=stage \\
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
                                -e SPRING_PROFILES_ACTIVE=stage \\
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
                    when { branch 'stage' }
                    steps {
                        script {
                            sh '''
                            echo "🚀 Levantando Locust para order-service..."

                            mkdir -p locust-reports

                            docker run --rm --network ecommerce-test \\
                            -v $PWD/locust-reports:/mnt/locust \\
                            jacoboossag/locust:${IMAGE_TAG} \\
                            -f test/order-service/locustfile.py \\
                            --host http://order-service-container:8300 \\
                            --headless -u 10 -r 2 -t 1m \\
                            --only-summary \\
                            --html /mnt/locust/order-service-report.html

                            echo "🚀 Levantando Locust para payment-service..."

                            docker run --rm --network ecommerce-test \\
                            -v $PWD/locust-reports:/mnt/locust \\
                            jacoboossag/locust:${IMAGE_TAG} \\
                            -f test/payment-service/locustfile.py \\
                            --host http://payment-service-container:8400 \\
                            --headless -u 10 -r 1 -t 1m \\
                            --only-summary \\
                            --html /mnt/locust/payment-service-report.html

                            echo "🚀 Levantando Locust para favourite-service..."

                            docker run --rm --network ecommerce-test \\
                            -v $PWD/locust-reports:/mnt/locust \\
                            jacoboossag/locust:${IMAGE_TAG} \\
                            -f test/favourite-service/locustfile.py \\
                            --host http://favourite-service-container:8800 \\
                            --headless -u 10 -r 2 -t 1m \\
                            --only-summary \\
                            --html /mnt/locust/favourite-service-report.html

                            echo "✅ Pruebas completadas"
                            '''
                        }
                    }
                }

                stage('Run Stress Tests with Locust') {
                    when { branch 'stage' }
                    steps {
                        script {
                            sh '''
                            echo "🔥 Levantando Locust para prueba de estrés..."

                            docker run --rm --network ecommerce-test \\
                            -v $PWD/locust-reports:/mnt/locust \\
                            jacoboossag/locust:${IMAGE_TAG} \\
                            -f test/order-service/locustfile.py \\
                            --host http://order-service-container:8300 \\
                            --headless -u 50 -r 5 -t 1m \\
                            --only-summary \\
                            --html /mnt/locust/order-service-stress-report.html

                            docker run --rm --network ecommerce-test \\
                            -v $PWD/locust-reports:/mnt/locust \\
                            jacoboossag/locust:${IMAGE_TAG} \\
                            -f test/payment-service/locustfile.py \\
                            --host http://payment-service-container:8400 \\
                            --headless -u 50 -r 5 -t 1m \\
                            --only-summary \\
                            --html /mnt/locust/payment-service-stress-report.html

                            docker run --rm --network ecommerce-test \\
                            -v $PWD/locust-reports:/mnt/locust \\
                            jacoboossag/locust:${IMAGE_TAG} \\
                            -f test/favourite-service/locustfile.py \\
                            --host http://favourite-service-container:8800 \\
                            --headless -u 50 -r 5 -t 1m \\
                            --only-summary \\
                            --html /mnt/locust/favourite-service-stress-report.html


                            echo "✅ Pruebas de estrés completadas"
                            '''
                        }
                    }
                }

                stage('Detener y eliminar contenedores') {
                    when { branch 'stage' }
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


//         //STAGE GRAL PERO SE LE DEBE AGREGAR EL PERFIL
//         stage('Build Docker Images') {
//             when { branch 'master' }
//             steps {
//                 script {
//                     SERVICES.split().each { service ->
//                         sh "docker buildx build --platform linux/amd64,linux/arm64 -t ${DOCKERHUB_USER}/${service}:${IMAGE_TAG} ./${service}"
//                     }
//                 }
//             }
//         }

//         //STAGE GRAL
//         stage('Push Docker Images') {
//             when { branch 'master' }
//             steps {
//                 withCredentials([string(credentialsId: "${DOCKER_CREDENTIALS_ID}", variable: 'docker_hub_pwd')]) {
//                     sh "docker login -u ${DOCKERHUB_USER} -p ${docker_hub_pwd}"
//                     script {
//                         SERVICES.split().each { service ->
//                             sh "docker push ${DOCKERHUB_USER}/${service}:${IMAGE_TAG}"
//                         }
//                     }
//                 }
//             }
//         }

        stage('Ensure Namespace') {
        when{branch 'master'}
            steps {
                sh "kubectl get namespace ${K8S_NAMESPACE} || kubectl create namespace ${K8S_NAMESPACE}"
            }
        }

        stage('Deploy Common Config') {
            when { branch 'master' }
            steps {
                sh "kubectl apply -f k8s/common-config.yaml -n ${K8S_NAMESPACE}"
            }
        }

        stage('Deploy Core Services') {
            when { branch 'master' }
            steps {
                sh "kubectl apply -f k8s/zipkin/ -n ${K8S_NAMESPACE}"
                sh "kubectl rollout status deployment/zipkin -n ${K8S_NAMESPACE} --timeout=200s"

                sh "kubectl apply -f k8s/service-discovery/ -n ${K8S_NAMESPACE}"
                sh "kubectl set image deployment/service-discovery service-discovery=${DOCKERHUB_USER}/service-discovery:${IMAGE_TAG} -n ${K8S_NAMESPACE}"
                sh "kubectl set env deployment/service-discovery SPRING_PROFILES_ACTIVE=${SPRING_PROFILES_ACTIVE} -n ${K8S_NAMESPACE}"
                sh "kubectl rollout status deployment/service-discovery -n ${K8S_NAMESPACE} --timeout=200s"


                sh "kubectl apply -f k8s/cloud-config/ -n ${K8S_NAMESPACE}"
                sh "kubectl set image deployment/cloud-config cloud-config=${DOCKERHUB_USER}/cloud-config:${IMAGE_TAG} -n ${K8S_NAMESPACE}"
                sh "kubectl set env deployment/cloud-config SPRING_PROFILES_ACTIVE=${SPRING_PROFILES_ACTIVE} -n ${K8S_NAMESPACE}"
                sh "kubectl rollout status deployment/cloud-config -n ${K8S_NAMESPACE} --timeout=300s"
            }
        }

//                 stage('Deploy Microservices') {
//                     when { anyOf { branch 'stage'; branch 'master' } }
//                     steps {
//                         script {
//                             SERVICES.split().each { svc ->
//                                 if (!['user-service', ].contains(svc)) {
//                                     bat "kubectl apply -f k8s\\${svc} -n ${K8S_NAMESPACE}"
//                                     bat "kubectl set image deployment/${svc} ${svc}=${DOCKERHUB_USER}/${svc}:${IMAGE_TAG} -n ${K8S_NAMESPACE}"
//                                     bat "kubectl set env deployment/${svc} SPRING_PROFILES_ACTIVE=${SPRING_PROFILES_ACTIVE} -n ${K8S_NAMESPACE}"
//                                     bat "kubectl rollout status deployment/${svc} -n ${K8S_NAMESPACE} --timeout=300s"
//                                 }
//                             }
//                         }
//                     }
//                 }

        stage('Deploy Microservices') {
            when { branch 'master' }
            steps {
                script {
                    def appServices = ['user-service', 'product-service', 'order-service','favourite-service','payment-service','shipping-service']

                    for (svc in appServices) {
                        def image = "${DOCKERHUB_USER}/${svc}:${IMAGE_TAG}"

                        sh "kubectl apply -f k8s/${svc}/ -n ${K8S_NAMESPACE}"
                        sh "kubectl set image deployment/${svc} ${svc}=${image} -n ${K8S_NAMESPACE}"
                        sh "kubectl set env deployment/${svc} SPRING_PROFILES_ACTIVE=${SPRING_PROFILES_ACTIVE} -n ${K8S_NAMESPACE}"
                        sh "kubectl rollout status deployment/${svc} -n ${K8S_NAMESPACE} --timeout=200s"
                    }
                }
            }
        }


        stage('Generate and Archive Release Notes') {
            when {
                branch 'master'
            }
            steps {
                sh '''
                echo "📝 Generando Release Notes con convco..."
                /opt/homebrew/bin/convco changelog > RELEASE_NOTES.md
                '''
                archiveArtifacts artifacts: 'RELEASE_NOTES.md', fingerprint: true
            }
        }
    }

    post {
        success {
            script {
                echo "✅ Pipeline completed successfully for ${env.BRANCH_NAME} branch."
                echo "📊 Environment: ${env.SPRING_PROFILE}"

                if (env.BRANCH_NAME == 'master') {
                    echo '🚀 Production deployment completed successfully!'
                } else if (env.BRANCH_NAME == 'stage') {
                    echo '🎯 Staging deployment completed successfully!'
                    publishHTML([
                        reportDir: 'locust-reports',
                        reportFiles: 'order-service-report.html, payment-service-report.html, favourite-service-report.html',
                        reportName: 'Locust Stress Test Reports',
                        keepAll: true
                    ])
                } else {
                    echo '🔧 Development tests completed successfully!'
                }
            }
        }
        failure {
            script {
                echo "❌ Pipeline failed for ${env.BRANCH_NAME} branch."
                echo '🔍 Check the logs for details.'
                echo '📧 Notify the development team about the failure.'
            }
        }
        unstable {
            script {
                echo "⚠️ Pipeline completed with warnings for ${env.BRANCH_NAME} branch."
                echo '🔍 Some tests may have failed. Review test reports.'
            }
        }
    }
}
