pipeline {
    agent any

    environment {
        KUBECONFIG = 'C:\\ProgramData\\Jenkins\\.jenkins\\.kube\\config'
        
        DOCKER_USER = 'sivajidwarampudi'
        IMAGE_NAME  = 'static-web-app'
        IMAGE_TAG   = 'latest'
        FULL_IMAGE  = "${DOCKER_USER}/${IMAGE_NAME}:${IMAGE_TAG}"
        K8S_CONTEXT = 'kind-kind'

        // Provide the absolute path to your kind executable
        KIND_EXE   = 'C:\\kind\\kind.exe'  // <--- Update this to your exact kind.exe path
    }

    stages {
        stage('Pull Latest Image') {
            steps {
                echo "Pulling latest image from Docker Hub..."
                bat "docker pull ${FULL_IMAGE}"
            }
        }

        stage('Load Image to Kind') {
            steps {
                echo "Loading Docker image into Kind cluster..."
                bat "\"${KIND_EXE}\" load docker-image ${FULL_IMAGE} --name kind"
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                echo "Applying Kubernetes manifests..."
                bat "kubectl apply -f k8s.yaml --context=${K8S_CONTEXT}"
                bat "kubectl rollout restart deployment/static-web-deployment --context=${K8S_CONTEXT}"
            }
        }

        stage('Verify Deployment') {
            steps {
                echo "Checking pod and service status..."
                bat "kubectl rollout status deployment/static-web-deployment --context=${K8S_CONTEXT}"
                bat "kubectl get pods --context=${K8S_CONTEXT}"
                bat "kubectl get svc static-web-service --context=${K8S_CONTEXT}"
            }
        }
    }

    post {
        always {
            echo "Pipeline run completed."
        }
        success {
            echo "Deployment to Kind cluster succeeded!"
        }
        failure {
            echo "Deployment failed. Check the logs above for details."
        }
    }
}