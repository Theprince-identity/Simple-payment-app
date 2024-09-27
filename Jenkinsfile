pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'theprinceidentity/simple-payment-app' // Update with your Docker Hub username
        K8S_DEPLOYMENT_FILE = 'deployment.yaml' // Your Kubernetes deployment file
        DOCKER_CREDENTIALS_ID = 'dockerhub-credentials' // Jenkins credentials ID for Docker Hub
        K8S_TOKEN_ID = 'k8s-token' // Jenkins Secret Text ID for Kubernetes token
        K8S_SERVER_URL = 'https://127.0.0.1:32771'
    }

    stages {
        stage('Checkout') {
            steps {
                // Pull the code from the repository
                git 'https://github.com/Theprince-identity/Simple-payment-app.git' // Update with your repository URL
            }
        }
        
        stage('Build') {
            steps {
                script {
                    // Build the Docker image
                    sh 'docker build -t $DOCKER_IMAGE .'
                }
            }
        }
        
        stage('Push') {
            steps {
                script {
                    // Log in to Docker Hub
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
                    }
                    // Push the Docker image to Docker Hub
                    sh 'docker push $DOCKER_IMAGE'
                }
            }
        }
        
        stage('Deploy') {
            steps {
                script {
                    // Get the Kubernetes token from Jenkins Secret Text
                    withCredentials([string(credentialsId: K8S_TOKEN_ID, variable: 'K8S_TOKEN')]) {
                        // Set the Kubernetes context
                        sh '''
                            kubectl config set-credentials jenkins --token=$K8S_TOKEN
                            kubectl config set-context --current --user=jenkins
                        '''
                    }
                    // Deploy to Kubernetes
                    sh 'kubectl apply -f $K8S_DEPLOYMENT_FILE --insecure-skip-tls-verify --validate=false'
                }
            }
        }
    }
    
    post {
        always {
            // Clean up workspace after build
            cleanWs()
        }
    }
}

