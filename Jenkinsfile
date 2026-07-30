pipeline {
    agent any

    environment {
        KUBECONFIG = 'C:\\ProgramData\\Jenkins\\.jenkins\\.kube\\config'
        
        DOCKER_USER = 'sivajidwarampudi'
        IMAGE_NAME  = 'static-web-app'
        IMAGE_TAG   = 'latest'
        FULL_IMAGE  = "${DOCKER_USER}/${IMAGE_NAME}:${IMAGE_TAG}"
        K8S_CONTEXT = 'kind-kind'
        
        // Pass Docker Hub credentials stored securely in Jenkins
        DOCKER_HUB_CREDS = credentials('dockeruserid') 
    }

    stages {
        stage('Build Docker Image') {
            steps {
                echo "Building Docker image locally..."
                bat "docker build -t ${FULL_IMAGE} ."
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                echo "Logging in and pushing image to Docker Hub..."
                // Log in to Docker Hub using Jenkins environment variables
                bat "docker login -u %DOCKER_HUB_CREDS_USR% -p %DOCKER_HUB_CREDS_PSW%"
                bat "docker push ${FULL_IMAGE}"
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
            echo "Build, push, and deployment succeeded!"
        }
        failure {
            echo "Deployment failed. Check the logs above for details."
        }
    }
}