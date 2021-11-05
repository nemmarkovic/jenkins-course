pipeline{
    agent any
        stages{
            stage('Download'){
                steps{
                    //clean workspace step syntax
                    cleanWs()
                    //echo step
                    echo("Download")
                    //position into a folder
                    dir('jenkins_course'){
                        //git step syntax
                        git(
                            branch : 'pipeline',
                            url:'https://github.com/rtrk-jenkins-course/jenkins-course.git'
                            )   
                    }
                    //artifactory download step syntax
                    rtDownload(
                        serverId: 'srdjan-local-repo', // id of artifactory server
                        spec: '''{
                              "files":[
                              {
                                 "pattern":"*.zip",
                                 "target":"example-repo-local/pipeline/"
                              }
                              ]
                        }'''
                    )
                    //unzip step syntax
                        unzip(
                        zipFile: "example-repo-local/pipeline/printer.zip",
                        dir:"jenkins_course"
                    )
                }
            }
            stage('Build'){
                steps{
                    //echo step
                    echo("Build")
                    dir("jenkins_course") {
                    bat(
                        script: """
                            call Makefile.cmd
                        """
                        )
                    }
                }
            }
            stage('Publish'){
                steps{
                    //echo step
                    echo("Publish")
                    script{
                        //zip step syntax
                        zip(
                            zipFile:"${ARTIFACT_NAME}.zip",
                            archive:true,
                            dir:"jenkins_course"
                        )
                    }
                    //artifactory upload step syntax
                    rtUpload(
                        serverId: 'srdjan-local-repo',
                        spec:'''{
                            "files":[
                            {
                                "pattern":"${ARTIFACT_NAME}.zip",
                                "target":"example-repo-local/release/"
                            }
                            ]
                        }'''
                    )
                }
            }
        }
}