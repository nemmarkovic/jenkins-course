//Pipeline structure
pipeline  {
    agent any
    parameters{
        string(
            name: 'ARTIFACT_NAME',
            defaultValue: 'no_name',
            description: 'name of the created artifact'
            )
    }
    stages   {
        stage('Download'){
            steps{
                cleanWs()
                echo ("Download")
                dir('pipeline'){
                    git(
                        branch: 'pipeline',
                        url: 'https://github.com/rtrk-jenkins-course/jenkins-course.git'
                        )
                        
                }
                rtDownload(
                    serverId: 'local-artifactory',
                    spec: '''{
                             "files": [
                                        {
                                         "pattern": "example-repo-local/printer.zip",
                                         "target": "pipeline/"
                                        }
                                     ]
                          }'''
                    )
                unzip(
                        zipFile: "pipeline/printer.zip",
                        dir: "pipeline"
                    )
            }
        }
        stage('Build'){
             steps{
                echo ("Build")
                bat( 
                    
                    script: """
                            cd pipeline/
                            call Makefile.cmd
                    
                    """
                    )
            }
        }
        stage('Publish'){
             steps{
                 
                echo ("Publish")
                script{
                    zip(
                        
                        bat 'exit 1'
                        
                        zipFile: "${ARTIFACT_NAME}",
                        archive: true,
                        dir: "pipeline/"
                    )
                }
                rtUpload(
                    serverId: 'local-artifactory',
                    spec: '''{
                        "files": [
                            {
                            "pattern": "${ARTIFACT_NAME}",
                            "target": "example-repo-local/release/"
                            }
                        ]
                        
                    }'''
                    
                    
                    
                    )
                
            }
        }
    }
    post {
        always{
            echo("Finished!")
        }
        success{
            echo("Finished with success!")
        }
        failure{
            echo("Finished with failure!")
            mail (
                to: "Srdjan.Vujanic@rt-rk.com",
                subject: "FAILURE!",
                body: "Job name is ${env.JOB_NAME}. Build number is ${env.BUILD_ID}."
            )
        }
        
    
    }
    
}


