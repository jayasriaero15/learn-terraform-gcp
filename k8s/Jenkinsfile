pipeline {
agent any
tools {
    maven 'maven3'
}

environment {
    GCP_PROJECT = 'project-af5a9a8c-a838-417b-891'
    REGION = 'asia-south2'
    REPOSITORY = 'myrepo'
    IMAGE_NAME = 'myapp'
}

stages {

    stage('Checkout') {
        steps {
            git 'https://github.com/jayasriaero15/k8s.git'
        }
    }

    stage('Build') {
        steps {
            bat 'mvn clean package -DskipTests'
        }
    }

    stage('Authenticate to GCP via WIF') {
        steps {
            withCredentials([file(credentialsId: 'gcp-wif-config', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {

                bat '''
                    echo ============================================
                    echo Authenticating to Google Cloud using WIF...
                    echo ============================================

                    echo Credential File:
                    echo %GOOGLE_APPLICATION_CREDENTIALS%

                    gcloud auth login --cred-file=%GOOGLE_APPLICATION_CREDENTIALS%

                    gcloud config set project %GCP_PROJECT%

                    gcloud auth list

                    gcloud projects list

                    gcloud auth configure-docker %REGION%-docker.pkg.dev --quiet
                '''
            }
        }
    }

    stage('Docker Build') {
        steps {
            bat '''
                docker build -t %REGION%-docker.pkg.dev/%GCP_PROJECT%/%REPOSITORY%/%IMAGE_NAME%:%BUILD_NUMBER% .
            '''
        }
    }

    stage('Push Image') {
        steps {
            bat '''
                docker push %REGION%-docker.pkg.dev/%GCP_PROJECT%/%REPOSITORY%/%IMAGE_NAME%:%BUILD_NUMBER%
            '''
        }
    }

    stage('Helm Lint') {
        steps {
            bat 'helm lint charts/myapp'
        }
    }

    stage('Publish Helm Chart') {
        steps {
            bat '''
                helm package charts/myapp

                helm registry login -u oauth2accesstoken -p "$(gcloud auth print-access-token)" https://%REGION%-docker.pkg.dev

                helm push myapp-*.tgz oci://%REGION%-docker.pkg.dev/%GCP_PROJECT%/charts
            '''
        }
    }

    stage('Deploy to GKE') {
        steps {
            bat '''
                gcloud container clusters get-credentials YOUR_CLUSTER_NAME --region %REGION%

                helm upgrade --install myapp charts/myapp ^
                --namespace prod ^
                --create-namespace ^
                --set image.tag=%BUILD_NUMBER%
            '''
        }
    }
}

post {
    success {
        echo '✅ Build, authentication, and deployment successful!'
    }

    failure {
        echo '❌ Pipeline failed. Check logs for details.'
    }
}
}

