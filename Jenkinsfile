pipeline {
    agent any

    parameters {
        string (
            name: 'ARTIFACT_NAME',
            defaultValue: 'pipeline',
            description: 'The name of the artifacted .zip file'
        )
    }

    stages {
        stage('Download') {
            steps {
                echo 'Stage Dowload ...'
                cleanWs()
                dir('pipeline') {
                    git branch: 'pipeline', credentialsId: 'eea9e239-77fa-4bda-81d7-9b25441e091f', url: 'https://github.com/rtrk-jenkins-course/jenkins-course.git'
                    rtDownload (
                        serverId: 'local-artifactory',
                        spec: '''{
                                "files": [
                                 {
                                    "pattern": "example-repo-local/printer.zip",
                                    "target": "printer.zip"
                                 }
                                ]
                        }'''
                    )
                    unzip (
                        zipFile: "printer.zip",
                        dir: "."
                    )
                    
                }
            }
        }
        stage('Build') {
            steps {
                echo 'Stage Build ...'
                dir('pipeline') {
                    bat (
                        script: """
                            Makefile.cmd
                        """
                    )
                }
            }
        }
        stage('Publish') {
            steps {
                echo 'Stage Publish ...'
                script {
                    zip (
                        zipFile: "pipeline.zip",
                        archive: true,
                        dir: "pipeline"
                    )
                    bat 'exit 1'
                }
                rtUpload (
                        serverId: 'local-artifactory',
                        spec: '''{
                                "files": [
                                 {
                                    "pattern": "pipeline.zip",
                                    "target": "example-repo-local/release/${ARTIFACT_NAME}.zip"
                                 }
                                ]
                        }'''
                    )
            }
        }
    }
    post {
        failure {
            mail (
                to: "maksimvuleta@gmail.com",
                subject: "Jenkins job failed.",
                body: "The jenkins job ${env.JOB_NAME} with ID ${env.BUILD_ID} failed."
                )
        }
    }
}
