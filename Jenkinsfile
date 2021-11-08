pipeline
{
   agent any
   stages 
   {
         stage("Download")
        {
            steps
            {
                 echo (message : "Download stage")
                // clean workspavce syntax
                cleanWs()
                dir('folder')
                {
                    git(branch : 'pipeline', 
                        url    : 'https://github.com/rtrk-jenkins-course/jenkins-course.git')

                    rtDownload (serverId: "artifactory_server",
                            spec    : 
                             '''{
                                 "files": 
                                 [
                                    {
                                        "pattern" : "example-repo-local/printer.zip",
                                        "target"  : "printer.zip"
                                    }
                                 ]
                                 
                             }''' )
                }

                // unzip file
                unzip ( zipFile : "folder/printer.zip", // which file to unzip
                dir             : "folder")            // where to place unzipped files

            }
        }
      
        stage("Build")
        {
            steps
            {
               echo (message : "Build stage")
               dir('folder')
               {
                    bat  ( script: """ call Makefile.cmd """)
                }
            }
        }
      
        stage("Publish")
        {
            steps
            {
                script
                {
                    echo (message : "Publish stage")
                    zip(zipFile: "${ARTIFACT_NAME}.zip",
                        archive: "true",
                        dir    : "folder")
                }

                rtUpload( serverId : "artifactory_server",
                          spec     : '''{
                                        "files": [
                                            {
                                                "pattern" : "${ARTIFACT_NAME}.zip",
                                                "target"  : "example-repo-local"
                                            }
                                         ]
                                     }'''
                        )
                bat  ( script: """ Exit 1 """)
            }
        }
    }
    
    // post section
    post 
    {
        always{ echo (message : "POSTBUILD stage")}
        success
        {
            mail(to     : "nebojsa.markovic@rt-rk.com",
                 subject: "build results",
                 body   : "build SUCCESS")
        }
        failure
        {
            mail(to     : "nebojsa.markovic@rt-rk.com",
                 subject: "build results",
                 body   : "Job name: ${env.JOB_NAME}. Build number: ${env.BUILD_ID}.")
        }
        unstable
        {
            echo (message : "UNSTABILE build")
        }
           
    }
}



