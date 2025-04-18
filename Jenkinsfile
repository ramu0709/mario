pipeline {
    agent any

    environment {
        MAVEN_HOME = tool name: "Maven 3.9.9"
        DOCKER_HUB_USER = "ramu7"
        IMAGE_NAME = "application"
        WAR_NAME = "mario-game-1.0-SNAPSHOT"
        WAR_FILE = "target/${WAR_NAME}.war"
        TOMCAT_URL = "http://172.21.40.70:8082/manager/text/deploy?path=/&update=true"
    }

    stages {
        stage('✅ Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/ramu0709/mario.git',
                    credentialsId: '9c54f3a6-d28e-4f8f-97a3-c8e939dcc8ff'
            }
        }

        stage('⚙️ Build with Maven') {
            steps {
                sh "${MAVEN_HOME}/bin/mvn clean package"
            }
        }

        stage('🐳 Build Docker Image') {
            steps {
                script {
                    // Check if the ROOT.war exists and copy it if necessary
                    sh 'if [ ! -f target/ROOT.war ]; then cp target/${WAR_NAME}.war target/ROOT.war; fi'
                    
                    // Build Docker Image with Build Number
                    def imageName = "${DOCKER_HUB_USER}/${IMAGE_NAME}:${BUILD_NUMBER}"
                    docker.build(imageName)
                }
            }
        }

        stage('📤 Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                    script {
                        sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
                        def imageName = "${DOCKER_HUB_USER}/${IMAGE_NAME}:${BUILD_NUMBER}"
                        sh "docker push ${imageName}"
                    }
                }
            }
        }

        stage('🚀 Run Docker Container on Port 9075') {
            steps {
                script {
                    def imageName = "${DOCKER_HUB_USER}/${IMAGE_NAME}:${BUILD_NUMBER}"
                    sh 'docker stop application-${BUILD_NUMBER} || true'
                    sh 'docker rm application-${BUILD_NUMBER} || true'
                    sh "docker run -d --name application-${BUILD_NUMBER} -p 9075:8080 ${imageName}"
                }
            }
        }
    }

    post {
        success {
            echo "✅ Deployment successful!"
        }
        failure {
            echo "❌ Something went wrong!"
        }
        always {
            cleanWs()
        }
    }
}
