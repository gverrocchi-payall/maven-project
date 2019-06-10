pipeline {
    agent any

    tools{
        maven 'Local Maven'
        jdk 'Local JDK'
        'org.jenkinsci.plugins.docker.commons.tools.DockerTool' 'Local Docker'
    }

    parameters {
         string(name: 'tomcat_dev', defaultValue: '3.217.57.80', description: 'Staging Server')
         string(name: 'tomcat_prod', defaultValue: '54.175.43.178', description: 'Production Server')
    }

    triggers {
         pollSCM('* * * * *')
     }

stages{
        stage('Build'){
            steps {
                sh 'mvn clean package'
                sh "docker build . -t tomcatwebapp:${env.BUILD_ID}"
            }
            post {
                success {
                    echo 'Now Archiving...'
                    archiveArtifacts artifacts: '**/target/*.war'
                }
            }
        }

        stage ('Deployments'){
            parallel{
                stage ('Deploy to Staging'){
                    steps {
                        sh "scp -o StrictHostKeyChecking=no -i /home/jenkins/tomcat-demo.pem **/target/*.war ec2-user@${params.tomcat_dev}:/var/lib/tomcat8/webapps"
                    }
                }

                stage ("Deploy to Production"){
                    steps {
                        timeout(time:5, unit:'DAYS'){ 
                            // this means that if the job is not approved within 5 days it will fail
                            input message: "Approve PRODUCTION Deployment?"
                        }
                        sh "scp -o StrictHostKeyChecking=no -i /home/jenkins/tomcat-demo.pem **/target/*.war ec2-user@${params.tomcat_prod}:/var/lib/tomcat8/webapps"
                    }
                }
            }
        }
    }
}