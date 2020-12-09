pipeline {
    agent any
    parameters{
        string(
            name:'ARTIFACT_NAME',
            defaultValue:'pipeline.zip',
            description:'opis'
        )
    }
    stages{
        stage('Download'){
            steps{
                echo (message:"Download stage.")
                cleanWs()
                dir("pipeline"){
                    git(
                    branch:'pipeline',
                    url:'https://github.com/rtrk-jenkins-course/jenkins-course.git')
                }
                rtDownload (
                    serverId: 'local-artifactory',
                    spec: '''{
                          "files": [
                            {
                              "pattern": "example-repo-local/ printer.zip",
                              "target": "pipeline/"
                            }
                          ]
                    }'''
                )
                unzip(
                    zipFile:"pipeline/printer.zip",
                    dir:"pipeline/")
            }
            
        }
        stage('Build'){
            steps{
                echo (message:"Build stage.")
                dir("pipeline"){
                    bat(
                script:"""
                Makefile.cmd
                """)
                }
            }
            
        }
        stage('Publish'){
            steps{
                echo (message:"Publish stage.")
               script{
                zip (
                    zipFile:"${ARTIFACT_NAME}",
                    archive:true,
                    dir:"pipeline/")
               }
               
               rtUpload (
                    serverId: 'local-artifactory',
                    spec: '''{
                          "files": [
                            {
                              "pattern": "pipeline.zip",
                              "target": "example-repo-local/release/"
                            }
                          ]
                    }'''
                )
                script {
                    bat (
                        script: """
                            exit 1
                        """
                    )
                } 
            }
           
        }
    }
    post{
        failure{
            mail(
                to:"stanko.tadic@rt-rk.com",
                subject:"Jenkins",
                body:"Build ${env.BUILD_ID} of ${env.JOB_NAME} failed."
                )
        }
    }
}