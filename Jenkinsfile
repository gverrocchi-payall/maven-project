// MY LEARNING CONFIG
pipeline{
    // agent{
    //     label "node"
    // }
    agent any

    stages{
        stage("Build"){
            steps{
                echo "========executing Build========"
                sh 'mvn clean package'
            }
            post{
                // always{
                //     echo "========always========"
                // }
                success{
                    echo "========Build executed successfully========"
                    echo "Now Archiving..."
                    archiveArtifacts artifacts: '**/target/*.war'
                }
                // failure{
                //     echo "========A execution failed========"
                // }
            }
        }
    }
    // post{
    //     always{
    //         echo "========always========"
    //     }
    //     success{
    //         echo "========pipeline executed successfully ========"
    //     }
    //     failure{
    //         echo "========pipeline execution failed========"
    //     }
    // }
}


// ==============ORIGINAL REPO FILE===============

// pipeline {
//     agent any

//     parameters {
//          string(name: 'tomcat_dev', defaultValue: '35.166.210.154', description: 'Staging Server')
//          string(name: 'tomcat_prod', defaultValue: '34.209.233.6', description: 'Production Server')
//     }

//     triggers {
//          pollSCM('* * * * *')
//      }

// stages{
//         stage('Build'){
//             steps {
//                 sh 'mvn clean package'
//             }
//             post {
//                 success {
//                     echo 'Now Archiving...'
//                     archiveArtifacts artifacts: '**/target/*.war'
//                 }
//             }
//         }

//         stage ('Deployments'){
//             parallel{
//                 stage ('Deploy to Staging'){
//                     steps {
//                         sh "scp -i /home/jenkins/tomcat-demo.pem **/target/*.war ec2-user@${params.tomcat_dev}:/var/lib/tomcat7/webapps"
//                     }
//                 }

//                 stage ("Deploy to Production"){
//                     steps {
//                         sh "scp -i /home/jenkins/tomcat-demo.pem **/target/*.war ec2-user@${params.tomcat_prod}:/var/lib/tomcat7/webapps"
//                     }
//                 }
//             }
//         }
//     }
// }
