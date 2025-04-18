pipeline {
    agent any

    environment {
        MAVEN_HOME = tool name: "Maven 3.9.9"
        PATH = "${MAVEN_HOME}/bin:${env.PATH}"
        DOCKER_HUB_USER = "ramu7"
        IMAGE_NAME = "application"
        WAR_NAME = "maven-web-application"
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

        stage('⚙️ Build WAR') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('🐳 Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_HUB_USER}/${IMAGE_NAME}:23 ."
                }
            }
        }

        stage('📤 Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('', 'docker-credentials-id') {
                        sh "docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:23"
                    }
                }
            }
        }

        stage('🚀 Run Docker Container on Port 9073') {
            steps {
                script {
                    sh """
                        docker stop ${IMAGE_NAME}-23 || true
                        docker rm ${IMAGE_NAME}-23 || true
                        docker run -d --name ${IMAGE_NAME}-23 -p 9073:8080 ${DOCKER_HUB_USER}/${IMAGE_NAME}:23
                    """
                }
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
