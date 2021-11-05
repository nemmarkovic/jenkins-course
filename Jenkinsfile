pipeline {
    agent any
    
    parameters{
        string (
            name: 'ARTIFACT_NAME',
            defaultValue: 'BLA.zip',
            description: 'description of BLA'
        )
    }
    stages {
        stage("Download"){
            steps {
                echo ("Download stage")
                echo ("PARAMETER NAME : ${params.ARTIFACT_NAME}")
                //cleanWs()
                rtDownload(
                    serverId: 'local-artifactory',
                    spec: '''{
                        "files": [
                        {
                            "pattern": "example-repo-local/printer.zip",
                            "target": "./"
                        }
                        ]
                    }'''
                )
                dir('pipeline/'){
                    git (
                    branch: 'pipeline',
                    url: 'https://github.com/rtrk-jenkins-course/jenkins-course.git'
                    )
                }
                unzip(
                    zipFile: "printer.zip",
                    dir: "pipeline/"
                )
                script{
                    bat 'exit 1' //fail on purpose
                }
            }
        }
        stage("Build"){
            steps {
                echo ("Build stage")
                dir("pipeline"){
                    bat(
                        script: """
                            echo Kemala
                            call Makefile.cmd
                        """
                    )
                }
            }
        }
        stage("Publish"){
            steps {
                echo ("Publish stage")
                script {
                    zip (
                        zipFile: "${params.ARTIFACT_NAME}",
                        archive: true,
                        dir: "pipeline/"
                    )
                }
                rtUpload(
                    serverId: 'local-artifactory',
                    spec: """{
                        "files": [
                        {
                            "pattern": "${params.ARTIFACT_NAME}",
                            "target": "example-repo-local/release/release_artifact/"
                        }
                        ]
                    }"""
                )
            }
        }
    }
    post{
        always{
            echo("Finished!")
        }
        success{
            echo("Finished with success!")
        }
        failure{
            echo("Finished with failure!")
            mail (
                to: "kemala.muhamedagic@rt-rk.com",
                subject: "FAILURE!",
                body: "Job name is ${env.JOB_NAME}. Build number is ${env.BUILD_ID}."
            )
        }
    }
}
