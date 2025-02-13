pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "basma227/flask-weather-app"
        DOCKER_TAG = "latest"
        DOCKER_HUB_CREDENTIALS = "docker-hub-credentials"
        GITHUB_CREDENTIALS = "github-credentials"
    }

    stages {
        stage('Checkout Code') {
            steps {
                script {
                    checkout([
                        $class: 'GitSCM',
                        branches: [[name: '*/main']], 
                        userRemoteConfigs: [[
                            url: 'https://github.com/Basma-90/practice.git',
                            credentialsId: env.GITHUB_CREDENTIALS
                        ]]
                    ])
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: env.DOCKER_HUB_CREDENTIALS, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
                }
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                sshagent(credentials: ['ansible']) {
                    sh '''
                        chmod 600 /var/lib/jenkins/workspace/final/vagrant_key
                        ansible-playbook -i /var/lib/jenkins/workspace/final/inventory.yaml /var/lib/jenkins/workspace/final/playbook.yaml -u vagrant -vvv
                    '''
                }
            }
        }
    }

   post {
    success {
        script {
            try {
                emailext subject: "✅ Jenkins Pipeline Succeeded: ${env.JOB_NAME}",
                         body: """
                         🎉 Great news! Your Jenkins pipeline **${env.JOB_NAME}** completed successfully!
                         - Build Number: **${env.BUILD_NUMBER}**
                         - Check the logs here: ${env.BUILD_URL}
                         """,
                         recipientProviders: [[$class: 'CulpritsRecipientProvider']],
                         to: "basmasabry33333@gmail.com"
            } catch (Exception e) {
                echo "Email sending failed: ${e.getMessage()}"
            }
        }
    }

    failure {
        script {
            try {
                emailext subject: "❌ Jenkins Pipeline Failed: ${env.JOB_NAME}",
                         body: """
                         ❌ Oops! The Jenkins pipeline **${env.JOB_NAME}** failed!
                         - Build Number: **${env.BUILD_NUMBER}**
                         - Check the logs here: ${env.BUILD_URL}
                         """,
                         recipientProviders: [[$class: 'CulpritsRecipientProvider']],
                         to: "basmasabry33333@gmail.com"
            } catch (Exception e) {
                echo "Email sending failed: ${e.getMessage()}"
            }
        }
    }
}

}
