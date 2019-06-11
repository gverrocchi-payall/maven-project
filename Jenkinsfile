pipeline {
    environment {
        customImage = ''
    }
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
                // sh "docker build . -t tomcatwebapp:${env.BUILD_ID}"
                // sh "docker push gianv9/tomcatwebapp:${env.BUILD_ID}"
                script {
                    customImage = docker.build("gianv9/tomcatwebapp:${env.BUILD_ID}")
                }
            }
            // post {
            //     success {
            //         echo 'Now Archiving...'
            //         archiveArtifacts artifacts: '**/target/*.war'
            //     }
            // }
        }

        stage("Push"){
            steps{
                script {
                    echo "====== PUSHING BUILT IMAGE TO REPOSITORY ======"
                    // https://index.docker.io/v2/
                    docker.withRegistry('', 'dockerhub') {

                        /* Push the container to the custom Registry */
                        customImage.push()
                    }
                }
            }
        }

        stage ('Deployment'){
            parallel{
                stage ('Deploy to Staging'){
                    steps {
                        // sh "scp -o StrictHostKeyChecking=no -i /home/jenkins/tomcat-demo.pem **/target/*.war ec2-user@${params.tomcat_dev}:/var/lib/tomcat8/webapps"
                        sh "scp -o StrictHostKeyChecking=no -i /home/jenkins/tomcat-demo.pem docker-compose.yml ec2-user@${params.tomcat_dev}:/home/ec2-user/docker-compose.yml"
                        sh "ssh -o StrictHostKeyChecking=no -i /home/jenkins/tomcat-demo.pem ec2-user@${params.tomcat_dev} 'BUILD_ID=${env.BUILD_ID} docker-compose up -d'"
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