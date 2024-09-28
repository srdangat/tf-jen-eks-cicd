pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = "us-east-1"
    }
    stages {
        stage('Checkout Source Code') {
            steps {
                script {
                    checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/srdangat/tf-jen-eks-cicd.git']])
                }
            }
        }
        stage('Initialize Terraform') {
            steps {
                script {
                    dir('eks') {
                        sh 'terraform init'
                    }
                }
            }
        }
        stage('Format Terraform Configuration') {
            steps {
                script {
                    dir('eks') {
                        sh 'terraform fmt'
                    }
                }
            }
        }
        stage('Validate Terraform Configuration') {
            steps {
                script {
                    dir('eks') {
                        sh 'terraform validate'
                    }
                }
            }
        }
        stage('Terraform Plan Preview') {
            steps {
                script {
                    dir('eks') {
                        sh 'terraform plan'
                    }
                    input(message: "Are you sure to proceed?", ok: "Proceed")
                }
            }
        }
        stage('Create/Destroy EKS Cluster') {
            steps {
                script {
                    dir('eks') {
                        sh 'terraform $action --auto-approve'
                    }
                }
            }
        }
        stage('Deploy Nginx Application to EKS') {
            steps {
                script {
                    dir('eks/manifests') {
                        sh 'aws eks update-kubeconfig --name my-eks-cluster'
                        sh 'kubectl apply -f deployment.yaml'
                        sh 'kubectl apply -f service.yaml'
                    }
                }
            }
        }
    }
}
