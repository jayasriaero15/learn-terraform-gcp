pipeline {
    agent any
    tools {
        maven 'maven3'   // must match the name you configured in Jenkins Tools
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
        stage('Docker Build') {
            steps {
                //bat 'docker build -t gcr.io/project-af5a9a8c-a838-417b-891/myapp:$BUILD_NUMBER .'
		bat 'docker build -t gcr.io/project-af5a9a8c-a838-417b-891/myapp:%BUILD_NUMBER% .'
            }
        }
        stage('Push Image') {
            steps {
                //bat 'docker push gcr.io/project-af5a9a8c-a838-417b-891/myapp:$BUILD_NUMBER'
		bat 'docker push gcr.io/project-af5a9a8c-a838-417b-891/myapp:%BUILD_NUMBER%'
            }
        }
        stage('Helm Lint') {
            steps {
                bat 'helm lint charts/myapp'
            }
        }
        stage('Publish Helm Chart') {
            steps {
                bat 'helm package charts/myapp && helm push myapp-*.tgz oci://gcr.io/project-af5a9a8c-a838-417b-891/charts'
            }
        }
	stage('Deploy to GKE') {
	    steps {
    		bat 'helm upgrade --install myapp charts/myapp --namespace prod --set image.tag=%BUILD_NUMBER%'
	    }
	}

    }
    post {
        success {
            echo 'Build and push successful!'
        }
    }
}

