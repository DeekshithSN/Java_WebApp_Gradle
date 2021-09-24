currentBuild.displayName = "Spring_gradle # "+currentBuild.number
        
pipeline{
        agent any  
        environment { 
            VERSION = "${env.BUILD_ID}-${env.GIT_COMMIT}"
            }
        
        stages{
              stage('Quality Gate Statuc Check'){

               agent {
                  docker {
                  image 'openjdk:11'
                }
            }
                steps{
                  script{
                    withSonarQubeEnv('sonarserver') { 
                      sh "chmod +x gradlew"
                      sh "java -version"
                      sh "./gradlew sonarqube"
                       }
                      timeout(time: 1, unit: 'HOURS') {
                      def qg = waitForQualityGate()
                      if (qg.status != 'OK') {
                           error "Pipeline aborted due to quality gate failure: ${qg.status}"
                      }
                    }
                  }
                }  
              }
		    stage('docker image creation stage'){
                steps{
                    script{
                        withCredentials([string(credentialsId: 'docker_password', variable: 'docker_password')]) {
			
                        sh '''
                        docker build -t 34.125.27.120:8083/springapp:${VERSION} .
                        docker login -u admin -p $docker_password 34.125.27.120:8083
                        docker push 34.125.27.120:8083/springapp:${VERSION}
                        ''' 
                        }
                    }
                }

            }

        stage('checking misconfigurations of k8s manifest using datree'){
          steps{
            script{
              dir ("kubernetes/"){
                sh 'helm datree test myapp'
              }
            }
          }
        }
		
      stage('pushing helm charts to artifactory'){
	steps{
	  script{
		  sh '''
		  
		  '''
            }
	  }
        }
	  	
      }
    }
