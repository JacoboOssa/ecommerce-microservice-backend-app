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
    // JAVA_HOME = tool 'JDK_17'
    // PATH = "${JAVA_HOME}/bin:${env.PATH}"
    // scannerHome = tool 'lil-sonar-tool'
    }

    stages {
        stage('Scanning Branch') {
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

        stage('Build Services (creating .jar files)') {
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

        //         // run sonarqube test
        //         stage('Run Sonarqube') {
        //             tools {
        //                 jdk 'JDK_17'
        //             }
        // //          environment {
        // //              JAVA_HOME = tool 'JDK_17'
        // //              PATH = "${JAVA_HOME}/bin:${env.PATH}"
        // //              scannerHome = tool 'lil-sonar-tool'
        // //          }
        //             steps {
        //                 withSonarQubeEnv(credentialsId: 'useSonarQube', installationName: 'lil sonar installation') {
        //                 sh 'java -version'
        //                 sh "${scannerHome}/bin/sonar-scanner -Dsonar.java.binaries=target"
        //                 }
        //             }
        //         }
//         stage('Run SonarQube Analysis') {
//             tools {
//                 jdk 'JDK_17'
//             }
//             environment {
//                 JAVA_HOME = tool 'JDK_17'
//                 PATH = "${JAVA_HOME}/bin:${env.PATH}"
//                 scannerHome = tool 'lil-sonar-tool'
//             }
//             steps {
//                 script {
//                     def javaServices = [
//                         'api-gateway',
//                         'cloud-config',
//                         'favourite-service',
//                         'order-service',
//                         'payment-service',
//                         'product-service',
//                         'proxy-client',
//                         'service-discovery',
//                         'shipping-service',
//                         'user-service',
//                         'e2e-tests'
//                     ]
//
//                     withSonarQubeEnv(credentialsId: 'useSonarQube', installationName: 'lil sonar installation') {
//                         javaServices.each { service ->
//                             dir(service) {
//                                 sh "${scannerHome}/bin/sonar-scanner " +
//                                 "-Dsonar.projectKey=${service} " +
//                                 "-Dsonar.projectName=${service} " +
//                                 '-Dsonar.sources=src ' +
//                                 '-Dsonar.java.binaries=target/classes'
//                             }
//                         }
//
//                         dir('locust') {
//                             sh "${scannerHome}/bin/sonar-scanner " +
//                             '-Dsonar.projectKey=locust ' +
//                             '-Dsonar.projectName=locust ' +
//                             '-Dsonar.sources=test'
//                         }
//                     }
//                 }
//             }
//         }

//         stage('Trivy Vulnerability Scan & Report') {
//             environment{
//                 TRIVY_PATH = '/opt/homebrew/bin'
//             }
//             steps {
//                 script {
// //                     def trivyPathBin = "/opt/homebrew/bin/trivy"
//                     env.PATH = "${TRIVY_PATH}:${env.PATH}"
//
//
//                     def services = [
//                         'api-gateway',
//                         'cloud-config',
//                         'favourite-service',
//                         'order-service',
//                         'payment-service',
//                         'product-service',
//                         'proxy-client',
//                         'service-discovery',
//                         'shipping-service',
//                         'user-service'
//                     ]
//
// //                     def outputDir = 'trivy-reports'
//                     sh "mkdir -p trivy-reports"
//
//                     services.each { service ->
// //                         def imageTag = "jacoboossag/${service}:prod"
//                         def reportPath = "trivy-reports/${service}.html"
//
// //                         echo "🔍 Escaneando imagen ${imageTag} con Trivy..."
//                         sh"""
//                             trivy image --format template \\
//                             --template "@/opt/homebrew/Cellar/trivy/0.63.0/share/trivy/templates/html.tpl" \\
//                             --severity HIGH,CRITICAL \\
//                             -o ${reportPath} \\
//                             ${DOCKERHUB_USER}/${service}:${IMAGE_TAG}
//                         """
//                     }
//
//                     publishHTML(target: [
//                     allowMissing: true,
//                     alwaysLinkToLastBuild: true,
//                     keepAll: true,
//                     reportDir: 'trivy-reports',
//                     reportFiles: '*.html',
//                     reportName: 'Trivy Scan Report'
//                     ])
//                 }
//             }
//         }

//         stage('Build Docker Images of each service') {
//             when {
//                 anyOf {
//                     branch 'dev'
//                     branch 'stage'
//                     branch 'master'
//                 }
//             }
//             steps {
//                 script {
//                     SERVICES.split().each { service ->
//                         sh "docker buildx build --platform linux/amd64,linux/arm64 -t ${DOCKERHUB_USER}/${service}:${IMAGE_TAG} --build-arg SPRING_PROFILES_ACTIVE=${SPRING_PROFILES_ACTIVE} --push ./${service}"
//                     }
//                 }
//             }
//         }
//
//         stage('Push Docker Images to Docker Hub') {
//             when {
//                 anyOf {
//                     branch 'dev'
//                     branch 'stage'
//                     branch 'master'
//                 }
//             }
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

        stage('Unit Tests') {
            when { branch 'dev' }
            steps {
                script {
                    ['user-service', 'product-service'].each {
                        sh "mvn test -pl ${it}"
                    }
                }
                junit '**/target/surefire-reports/*.xml'
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
                junit '**/target/failsafe-reports/TEST-*.xml'
            }
        }

        stage('E2E Tests') {
            when { branch 'stage' }
            steps {
                script {
                    sh 'mvn verify -pl e2e-tests'
                }
                junit 'e2e-tests/target/failsafe-reports/*.xml'
            }
        }

        stage('Start containers for load and stress testing') {
            when { branch 'master' }
            steps {
                script {
                    sh '''
                    docker network create ecommerce-test || true

                    docker run -d --name zipkin-container --network ecommerce-test -p 9411:9411 openzipkin/zipkin

                    docker run -d --name service-discovery-container --network ecommerce-test -p 8761:8761 \\
                    -e SPRING_PROFILES_ACTIVE=stage \\
                    -e SPRING_ZIPKIN_BASE_URL=http://zipkin-container:9411 \\
                    jacoboossag/service-discovery:${IMAGE_TAG}

                    until curl -s http://localhost:8761/actuator/health | grep '"status":"UP"' > /dev/null; do
                        echo "Waiting for service discovery to be ready..."
                        sleep 10
                    done

                    docker run -d --name cloud-config-container --network ecommerce-test -p 9296:9296 \\
                    -e SPRING_PROFILES_ACTIVE=stage \\
                    -e SPRING_ZIPKIN_BASE_URL=http://zipkin-container:9411 \\
                    -e EUREKA_CLIENT_SERVICEURL_DEFAULTZONE=http://service-discovery-container:8761/eureka/ \\
                    -e EUREKA_INSTANCE=cloud-config-container \\
                    jacoboossag/cloud-config:${IMAGE_TAG}

                    until curl -s http://localhost:9296/actuator/health | grep '"status":"UP"' > /dev/null; do
                        echo "Waiting for cloud config to be ready..."
                        sleep 10
                    done

                    docker run -d --name order-service-container --network ecommerce-test -p 8300:8300 \\
                    -e SPRING_PROFILES_ACTIVE=stage \\
                    -e SPRING_ZIPKIN_BASE_URL=http://zipkin-container:9411 \\
                    -e SPRING_CONFIG_IMPORT=optional:configserver:http://cloud-config-container:9296 \\
                    -e EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE=http://service-discovery-container:8761/eureka \\
                    -e EUREKA_INSTANCE=order-service-container \\
                    jacoboossag/order-service:${IMAGE_TAG}

                    until [ "$(curl -s http://localhost:8300/order-service/actuator/health | jq -r '.status')" = "UP" ]; do
                        echo "Waiting for order service to be ready..."
                        sleep 10
                    done

                    docker run -d --name payment-service-container --network ecommerce-test -p 8400:8400 \\
                    -e SPRING_PROFILES_ACTIVE=stage \\
                    -e SPRING_ZIPKIN_BASE_URL=http://zipkin-container:9411 \\
                    -e SPRING_CONFIG_IMPORT=optional:configserver:http://cloud-config-container:9296 \\
                    -e EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE=http://service-discovery-container:8761/eureka \\
                    -e EUREKA_INSTANCE=payment-service-container \\
                    jacoboossag/payment-service:${IMAGE_TAG}

                    until [ "$(curl -s http://localhost:8400/payment-service/actuator/health | jq -r '.status')" = "UP" ]; do
                        echo "Waiting for payment service to be ready..."
                        sleep 10
                    done

                    docker run -d --name product-service-container --network ecommerce-test -p 8500:8500 \\
                    -e SPRING_PROFILES_ACTIVE=stage \\
                    -e SPRING_ZIPKIN_BASE_URL=http://zipkin-container:9411 \\
                    -e SPRING_CONFIG_IMPORT=optional:configserver:http://cloud-config-container:9296 \\
                    -e EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE=http://service-discovery-container:8761/eureka \\
                    -e EUREKA_INSTANCE=product-service-container \\
                    jacoboossag/product-service:${IMAGE_TAG}

                    until [ "$(curl -s http://localhost:8500/product-service/actuator/health | jq -r '.status')" = "UP" ]; do
                        echo "Waiting for product service to be ready..."
                        sleep 10
                    done

                    docker run -d --name shipping-service-container --network ecommerce-test -p 8600:8600 \\
                    -e SPRING_PROFILES_ACTIVE=stage \\
                    -e SPRING_ZIPKIN_BASE_URL=http://zipkin-container:9411 \\
                    -e SPRING_CONFIG_IMPORT=optional:configserver:http://cloud-config-container:9296 \\
                    -e EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE=http://service-discovery-container:8761/eureka \\
                    -e EUREKA_INSTANCE=shipping-service-container \\
                    jacoboossag/shipping-service:${IMAGE_TAG}

                    until [ "$(curl -s http://localhost:8600/shipping-service/actuator/health | jq -r '.status')" = "UP" ]; do
                        echo "Waiting for shipping service to be ready..."
                        sleep 10
                    done

                    docker run -d --name user-service-container --network ecommerce-test -p 8700:8700 \\
                    -e SPRING_PROFILES_ACTIVE=stage \\
                    -e SPRING_ZIPKIN_BASE_URL=http://zipkin-container:9411 \\
                    -e SPRING_CONFIG_IMPORT=optional:configserver:http://cloud-config-container:9296 \\
                    -e EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE=http://service-discovery-container:8761/eureka \\
                    -e EUREKA_INSTANCE=user-service-container \\
                    jacoboossag/user-service:${IMAGE_TAG}

                    until [ "$(curl -s http://localhost:8700/user-service/actuator/health | jq -r '.status')" = "UP" ]; do
                        echo "Waiting for user service to be ready..."
                        sleep 10
                    done

                    docker run -d --name favourite-service-container --network ecommerce-test -p 8800:8800 \\
                    -e SPRING_PROFILES_ACTIVE=stage \\
                    -e SPRING_ZIPKIN_BASE_URL=http://zipkin-container:9411 \\
                    -e SPRING_CONFIG_IMPORT=optional:configserver:http://cloud-config-container:9296 \\
                    -e EUREKA_CLIENT_SERVICE_URL_DEFAULTZONE=http://service-discovery-container:8761/eureka \\
                    -e EUREKA_INSTANCE=favourite-service-container \\
                    jacoboossag/favourite-service:${IMAGE_TAG}

                    until [ "$(curl -s http://localhost:8800/favourite-service/actuator/health | jq -r '.status')" = "UP" ]; do
                        echo "Waiting for favourite service to be ready..."
                        sleep 10
                    done

                    '''
                }
            }
        }

        stage('Run Load Tests with Locust') {
            when { branch 'stage' }
            steps {
                script {
                    sh '''

                    mkdir -p locust-reports

                    docker run --rm --network ecommerce-test \\
                    -v $PWD/locust-reports:/mnt/locust \\
                    jacoboossag/locust:${IMAGE_TAG} \\
                    -f test/order-service/locustfile.py \\
                    --host http://order-service-container:8300 \\
                    --headless -u 10 -r 2 -t 1m \\
                    --only-summary \\
                    --html /mnt/locust/order-service-report.html

                    docker run --rm --network ecommerce-test \\
                    -v $PWD/locust-reports:/mnt/locust \\
                    jacoboossag/locust:${IMAGE_TAG} \\
                    -f test/payment-service/locustfile.py \\
                    --host http://payment-service-container:8400 \\
                    --headless -u 10 -r 1 -t 1m \\
                    --only-summary \\
                    --html /mnt/locust/payment-service-report.html

                    docker run --rm --network ecommerce-test \\
                    -v $PWD/locust-reports:/mnt/locust \\
                    jacoboossag/locust:${IMAGE_TAG} \\
                    -f test/favourite-service/locustfile.py \\
                    --host http://favourite-service-container:8800 \\
                    --headless -u 10 -r 2 -t 1m \\
                    --only-summary \\
                    --html /mnt/locust/favourite-service-report.html

                    '''
                }
            }
        }

        stage('Run Stress Tests with Locust') {
            when { branch 'stage' }
            steps {
                script {
                    sh '''

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

        stage('OWASP ZAP Scan') {
            when { branch 'master' }
            steps {
                script {
                    echo '==> Iniciando escaneos con OWASP ZAP'

                    def targets = [
                [name: 'order-service', url: 'http://order-service-container:8300/order-service'],
                [name: 'payment-service', url: 'http://payment-service-container:8400/payment-service'],
                [name: 'product-service', url: 'http://product-service-container:8500/product-service'],
                [name: 'shipping-service', url: 'http://shipping-service-container:8600/shipping-service'],
                [name: 'user-service', url: 'http://user-service-container:8700/user-service'],
                [name: 'favourite-service', url: 'http://favourite-service-container:8800/favourite-service']
            ]

                    targets.each { service ->
                        def reportFile = "report-${service.name}.html"
                        echo "==> Escaneando ${service.name} (${service.url})"
                        sh """
                    docker run --rm \
                        --network ecommerce-test \
                        -v ${env.WORKSPACE}:/zap/wrk \
                        zaproxy/zap-stable \
                        zap-full-scan.py \
                        -t ${service.url} \
                        -r ${reportFile} \
                        -I
                """
                    }
                }
            }
        }

        stage('Publicar Reportes de Seguridad') {
            when { branch 'master' }
            steps {
                echo '==> Archivando reportes HTML de ZAP'
                archiveArtifacts artifacts: 'report-*.html', fingerprint: true
            }
        }

        stage('Stop and Remove Containers') {
            when { branch 'master' }
            steps {
                script {
                    sh '''
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

                    docker rm -f zap-container || true

                    docker network rm ecommerce-test || true

                    '''
                }
            }
        }

//         stage('Waiting approval for deployment') {
//             when { branch 'master' }
//             steps {
//                 script {
//                     emailext(
//                         to: '$DEFAULT_RECIPIENTS',
//                         subject: "Action Required: Approval Needed for Deploy of Build #${env.BUILD_NUMBER}",
//                         body: """\
//                         Hello dead man (daniel) and Goat Ossa,
//                         The build #${env.BUILD_NUMBER} for branch *${env.BRANCH_NAME}* has completed and is pending approval for deployment.
//                         Please review the changes and approve or abort
//                         You can access the build details here:
//                         ${env.BUILD_URL}
//                         """
//                     )
//
//                     input message: 'Approve deployment to production (kubernetes) ?', ok: 'Deploy'
//                 }
//             }
//         }
//
//         stage('Simulate deployment to production') {
//             when { branch 'master' }
//             steps {
//                 script {
//                     echo "Simulating deployment to production with tag ${IMAGE_TAG} and profile ${SPRING_PROFILES_ACTIVE}"
//                 }
//             }
//         }

    // stage('Create namespace for deployments') {
    //     when { branch 'master' }
    //     steps {
    //         sh "kubectl get namespace ${K8S_NAMESPACE} || kubectl create namespace ${K8S_NAMESPACE}"
    //     }
    // }
    //
    //         stage('Deploy common config for microservices') {
    //             when { branch 'master' }
    //             steps {
    //                 sh "kubectl apply -f k8s/common-config.yaml -n ${K8S_NAMESPACE}"
    //             }
    //         }
    //
    //         stage('Deploy Core Services') {
    //             when { branch 'master' }
    //             steps {
    //                 sh "kubectl apply -f k8s/zipkin/ -n ${K8S_NAMESPACE}"
    //                 sh "kubectl rollout status deployment/zipkin -n ${K8S_NAMESPACE} --timeout=200s"
    //
    //                 sh "kubectl apply -f k8s/service-discovery/ -n ${K8S_NAMESPACE}"
    //                 sh "kubectl set image deployment/service-discovery service-discovery=${DOCKERHUB_USER}/service-discovery:${IMAGE_TAG} -n ${K8S_NAMESPACE}"
    //                 sh "kubectl set env deployment/service-discovery SPRING_PROFILES_ACTIVE=${SPRING_PROFILES_ACTIVE} -n ${K8S_NAMESPACE}"
    //                 sh "kubectl rollout status deployment/service-discovery -n ${K8S_NAMESPACE} --timeout=200s"
    //
    //                 sh "kubectl apply -f k8s/cloud-config/ -n ${K8S_NAMESPACE}"
    //                 sh "kubectl set image deployment/cloud-config cloud-config=${DOCKERHUB_USER}/cloud-config:${IMAGE_TAG} -n ${K8S_NAMESPACE}"
    //                 sh "kubectl set env deployment/cloud-config SPRING_PROFILES_ACTIVE=${SPRING_PROFILES_ACTIVE} -n ${K8S_NAMESPACE}"
    //                 sh "kubectl rollout status deployment/cloud-config -n ${K8S_NAMESPACE} --timeout=300s"
    //             }
    //         }
    //
    //         stage('Deploy Microservices') {
    //             when { branch 'master' }
    //             steps {
    //                 script {
    //                     def appServices = ['user-service', 'product-service', 'order-service', 'favourite-service', 'payment-service']
    //
    //                     for (svc in appServices) {
    //                         def image = "${DOCKERHUB_USER}/${svc}:${IMAGE_TAG}"
    //
    //                         sh "kubectl apply -f k8s/${svc}/ -n ${K8S_NAMESPACE}"
    //                         sh "kubectl set image deployment/${svc} ${svc}=${image} -n ${K8S_NAMESPACE}"
    //                         sh "kubectl set env deployment/${svc} SPRING_PROFILES_ACTIVE=${SPRING_PROFILES_ACTIVE} -n ${K8S_NAMESPACE}"
    //                         sh "kubectl rollout status deployment/${svc} -n ${K8S_NAMESPACE} --timeout=200s"
    //                     }
    //                 }
    //             }
    //         }
    //
    //         stage('Generate release notes') {
    //             when {
    //                 branch 'master'
    //             }
    //             steps {
    //                 sh '''
    //                 /opt/homebrew/bin/convco changelog > RELEASE_NOTES.md
    //                 '''
    //                 archiveArtifacts artifacts: 'RELEASE_NOTES.md', fingerprint: true
    //             }
    //         }
    }

    post {
        success {
            script {
                echo "Pipeline completed successfully for ${env.BRANCH_NAME} branch."

                if (env.BRANCH_NAME == 'master') {
                    echo 'Production deployment completed successfully!'
                } else if (env.BRANCH_NAME == 'stage') {
                    echo 'Staging deployment completed successfully!'
                    publishHTML([
                        reportDir: 'locust-reports',
                        reportFiles: 'order-service-report.html, payment-service-report.html, favourite-service-report.html, order-service-stress-report.html, payment-service-stress-report.html, favourite-service-stress-report.html',
                        reportName: 'Locust Stress Test Reports',
                        keepAll: true
                    ])
                } else {
                    echo 'Development tests completed successfully!'
                }
            }
        }
        failure {
            emailext(
                attachLog: true,
                body: '$DEFAULT_CONTENT',
                subject: '$DEFAULT_SUBJECT',
                to: '$DEFAULT_RECIPIENTS',
            )
        }
    }
}
