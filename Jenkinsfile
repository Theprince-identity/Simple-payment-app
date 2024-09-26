pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'theprinceidentity/simple-payment-app:latest'  // Docker Hub image name
        DOCKER_CREDENTIALS_ID = 'dockerhub-credentials'  // Jenkins credential ID for Docker Hub
        K8S_API_SERVER = 'https://192.168.49.2:8443'  // Kubernetes API server URL
        K8S_TOKEN = credentials('k8s-token')  // Jenkins credential ID for your service account token
        CA_CERT = credentials('ca-cert')  // Optional: If not using, you can skip this
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image
                    docker.build(DOCKER_IMAGE)
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    // Push the Docker image to Docker Hub
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_CREDENTIALS_ID) {
                        docker.image(DOCKER_IMAGE).push()
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Deploy to Kubernetes using kubectl directly
                    sh """
                    kubectl config set-cluster my-cluster --server=${K8S_API_SERVER}
                    kubectl config set-credentials jenkins --token=${K8S_TOKEN}
                    kubectl config set-context jenkins-context --cluster=my-cluster --user=jenkins
                    kubectl config use-context jenkins-context
                    kubectl apply -f deployment.yaml --insecure-skip-tls-verify --validate=false # Path to your Kubernetes deployment file
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}
