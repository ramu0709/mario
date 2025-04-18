pipeline {
    agent any

    environment {
        MAVEN_HOME = tool name: "Maven 3.9.9"
        DOCKER_HUB_USER = "ramu7"
        IMAGE_NAME = "application"
        WAR_NAME = "mario-game"
        WAR_FILE = "target/${WAR_NAME}.war"
        TOMCAT_URL = "http://172.21.40.70:8082/manager/text/deploy?path=/&update=true"
    }

    stages {
        stage('✅ Checkout Code') {
            steps {
                git branch: 'main',
                    credentialsId: '9c54f3a6-d28e-4f8f-97a3-c8e939dcc8ff',
                    url: 'https://github.com/ramu0709/mario.git'
            }
        }

        stage('📦 Build with Maven') {
            steps {
                sh "${MAVEN_HOME}/bin/mvn clean package"
            }
        }

        stage('🐳 Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:23 ."
            }
        }

        stage('📤 Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                    sh "docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:23"
                }
            }
        }

        stage('🚀 Run Docker Container on Port 9073') {
            steps {
                sh '''
                    docker stop application-23 || true
                    docker rm application-23 || true
                    docker run -d --name application-23 -p 9073:8080 ramu7/application:23
                '''
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        failure {
            echo '❌ Something went wrong!'
        }
    }
}
