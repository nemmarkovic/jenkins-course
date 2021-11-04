pipeline {
    agent any
    
    parameters {
        string(
            name: 'ARTIFACT_NAME',
            defaultValue: 'pipeline.zip',
            description: 'zip file name'
        )
    }

    stages {
        stage('Download') {
            steps {
                echo (message: "Download")
                // clean workspace
                cleanWs()
                dir('pipeline/') {
                    git (
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
                                "target": "./"
                            }
                        ]
                    }'''
                )
                unzip(
                    zipFile: "./printer.zip",
                    dir: "pipeline/"
                    )
            }
        }
        stage('Build') {
            steps {
                echo (message: "Build")
                bat (
                    script: """
                        cd pipeline/
                        Makefile.cmd
                    """
                    )
            }
        }
        stage('Publish') {
            steps {
                echo (message: "Publish")
                script {
                    zip(
                        zipFile: "${ARTIFACT_NAME}",
                        archive: true,
                        dir: "pipeline/"
                    )
                }
                rtUpload (
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
                script {
                    bat 'exit 1'
                }
            }
        }
    }
    post {
        failure {
            mail (
                to: "drago.cavka@rt-rk.com",
                subject: "Jenkins build status",
                body: "Jenkins job ${env.JOB_NAME} with build ID ${env.BUILD_ID} has failed."
            )
        }
    }
}
