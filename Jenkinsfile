pipeline {
    agent any

    environment {
        // Force kubectl to use the copied config file
        KUBECONFIG = 'C:\\ProgramData\\Jenkins\\.jenkins\\.kube\\config'
    }

    stages {
        stage('Build Docker Image') {
            steps {
                bat 'docker build -t static-web-app:latest .'
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                bat 'kubectl apply -f k8s.yaml'
            }
        }

        stage('Verify Deployment') {
            steps {
                bat 'kubectl get pods'
                bat 'kubectl get svc static-web-service'
            }
        }
    }
}