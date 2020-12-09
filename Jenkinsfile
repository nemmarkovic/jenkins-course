pipeline {
    agent any
    parameters{
                string(
                    name:"ARTIFACT_NAME",
                    defaultValue:"pipeline.zip",
                    description:"Final artifact name"
                    )
            }
    stages {
        stage('Download') {
            steps {
               cleanWs()
               dir('pipeline'){
               git (
                   branch:'pipeline',
                   url:'https://github.com/rtrk-jenkins-course/jenkins-course.git'
                  
                   )
                }
                rtDownload(
                    serverId:'101',
                    spec:'''{
                        "files":[{"pattern":"example-repo-local/printer.zip",
                        "target":"./"}]
                    }'''
                )
                unzip(
                    zipFile:"printer.zip",
                    dir:"pipeline/"
                    )
            }
        }
        stage('Build') {
            steps {
                echo (message: "Build")
                 dir('pipeline'){
                bat (
                script: '''
                Makefile.cmd
                '''
                )
                 }
            }
        }
        stage('Publish') {
            
            steps {
                echo (message: "Publish")
                script{
                zip(
                    zipFile:"${ARTIFACT_NAME}",
                    archive:true,
                    dir:"pipeline"
                    )
                }
                rtUpload(
                    serverId:'101',
                    spec:'''{
                        "files":[{"pattern":"${ARTIFACT_NAME}",
                        "target":"example-repo-local/release/${ARTIFACT_NAME}"}]
                    }'''
                )
            }
        }
    }
    post{
        failure{
            mail(
                to:"bubo2102@gmail.com",
                subject:"Jenkins report for ${env.JOB_NAME}",
                body:"Job failed build:${env.BUILD_ID}"
            )
        }
    }
}
