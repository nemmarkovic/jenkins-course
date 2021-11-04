// pipeline structure
pipeline {
    agent any
    
    stages{
        stage('Download'){
            steps{ 
                echo (message: "Stage - Download [GIT]")
            }
        }
        stage('Build'){
            steps{ 
                echo (message: "Stage - Build [GIT]")
            }
        }   
        stage('Publish'){
            steps{ 
                echo (message: "Stage - Publish [GIT]")
            }
        }   
    }
}