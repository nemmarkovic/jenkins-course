pipeline {
    agent any
    
    parameters{
        string(name: "ARTIFACT_NAME",
                defaultValue: "scenario-11-artifact.zip",
                description: "Final zip file."
        )
        booleanParam(name: "RETURN_VALUE",
                defaultValue: true
        )
    }
    
    stages {
        stage('Download'){
            steps{
                echo "Stage [Git] - Download"
                cleanWs()
                dir('pipeline') {
                    git(branch: "pipeline",
                        url: "https://github.com/rtrk-jenkins-course/jenkins-course.git"
                        )    
                }
                dir('example-repo-local') {
                    rtDownload(serverId: "local-artifactory",
                                spec: '''{
                                    "files": [
                                        {
                                            "pattern": "example-repo-local/printer.zip",
                                            "target": "./"
                                        }
                                    ]
                                }'''
                    )
                }
                unzip(zipFile: "example-repo-local/printer.zip",
                        dir: "pipeline"
                )
            }
        }
        stage("Build"){
            steps{
                echo("Stage [Git] - Build")
                dir('pipeline') {
                    bat(script: '''
                        Makefile.cmd
                    '''
		    )
                }
                script{
                    bat '''
                        if "%RETURN_VALUE%" == "true" (
                            exit 0
                        ) else (
                            exit 1
                        )
                    '''
                }
            }
        }
        stage("Publish"){
            steps {
                echo(message: "Stage [Git] - Publish")
                zip(zipFile: "${ARTIFACT_NAME}",
                    archive: true,
                    dir: "pipeline"
                )
                rtUpload(serverId: "local-artifactory",
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
    
    post{
        always{
            echo "RT-RK Jenkins-kurs Scenario 11"
        }
        success{
            echo "That's all folks!!!"
        }
        failure{
            mail(to: "milos.kovacevic2013@gmail.com",
                    subject: "Jenkins-Scenario-11",
                    body: """
                        The BUILD: ${env.BUILD_ID} for JOB: ${env.JOB_NAME} failed!
                        
                        Check console output at ${env.BUILD_URL} to view the results.
                    """
            )
        }
    }
}