pipeline{
    agent any

    stages{
        stage("Checkout SCM"){
            steps{
                checkout scm
                sh 'ls'
                sh 'ansible --version'
            }
        }
    }
}