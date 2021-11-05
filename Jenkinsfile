// Scenario10

pipeline {
    agent any
    
    parameters {
        string (
           name : 'ARTIFACT_NAME',
           defaultValue: 'pipeline_param.zip',
           description: 'Upload pipeline.zip with different name'
        )
    }
    
    stages {
        stage('Download') {
           steps {
              echo (message: "Download stage!")
              
              cleanWs()
              
              // Download form git
              dir('pipeline') {
                  git (
                    branch: 'pipeline',
                    url: 'https://github.com/rtrk-jenkins-course/jenkins-course.git'
                  )
               }
               
               // Download from Artifactory
               rtDownload (
                  serverId: 'local_artifactory',
                  spec: '''{
                        "files":[
                           {
                            "pattern": "example-repo-local/printer.zip",
                            "target": "pipeline/"
                           }
                        ]
                  }'''
               )
               
               // Unzip printer.zip file
               unzip(
                  zipFile: "pipeline/printer.zip",
                  dir: "pipeline/"
               )
           } 
        }
        stage('Build') {
            steps {
               echo (message: "Build stage!")
               
               // Execute Makefile.cmd
               dir("pipeline") {
                   bat (
                      script: """
                         echo "Execute Makefile"
                         call Makefile.cmd
                      """
                   )
               }
            }
        }
        stage('Publish') {
            steps {
               echo (message: "Publish stage!") 
               
               // Zip pipeline folder
               script {
                   zip (
                      zipFile: "${ARTIFACT_NAME}",
                      archive: true,
                      dir: "pipeline/"
                   )
               }
               
               //script {bat ‘exit 1’} 
               
               // Upload to Artifactory
               rtUpload (
                  serverId: 'local_artifactory',
                  spec: '''{
                        "files":[
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
        failure {
            mail (
               to: "suzana.bozic@rt-rk.com",
               subject: "Jenkins job failure",
               body: "Job name: ${env.JOB_NAME}, build number: ${env.BUILD_ID}"
            )
        }
    }
}

