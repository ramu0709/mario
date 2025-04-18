pipeline {
    agent any

    environment {
        MAVEN_HOME = tool name: "Maven 3.9.9"
        DOCKER_HUB_USER = "ramu7"
        IMAGE_NAME = "application"
        BUILD_NUMBER = env.BUILD_NUMBER  // Jenkins build number
        WAR_NAME = "mario-game-1.0-SNAPSHOT"
        WAR_FILE = "target/${WAR_NAME}.war"
    }

    stages {
        stage('✅ Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/ramu0709/mario.git', credentialsId: '9c54f3a6-d28e-4f8f-97a3-c8e939dcc8ff'
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
                    // Rename WAR file to ROOT.war for Tomcat
                    sh 'cp target/mario-game-1.0-SNAPSHOT.war target/ROOT.war'

                    // Build Docker image with build number
                    docker.build("${DOCKER_HUB_USER}/${IMAGE_NAME}:${BUILD_NUMBER}")
                }
            }
        }

        stage('📤 Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                    script {
                        sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
                        sh "docker push ${DOCKER_HUB_USER}/${IMAGE_NAME}:${BUILD_NUMBER}"
                    }
                }
            }
        }

        stage('🚀 Run Docker Container on Port 9075') {
            steps {
                script {
                    // Stop and remove the previous container if it exists
                    sh 'docker stop application-23 || true'
                    sh 'docker rm application-23 || true'

                    // Run the Docker container with the new image
                    sh "docker run -d --name application-23 -p 9075:8080 ${DOCKER_HUB_USER}/${IMAGE_NAME}:${BUILD_NUMBER}"
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
