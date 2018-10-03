pipeline {
    /*
    agent { docker { image 'build_container:v.04' 
                    args '-u root '} }
    */
    agent any
    stages {
        stage('git_fetch') {
            
            steps{
                /*git init
                    git remote add origin https://github.com/geo-geo1551/geo-ecs-demo.git
                    git fetch --depth 1
                    git checkout -t origin/master 
                    rm -rf .git
                    git clone --depth 1 https://github.com/geo-geo1551/geo-ecs-demo.git .
                    */
                    
                    // Create a File object representing the folder '.git'
               // def folder = new File( '.git' )
                script{
                    // If it doesn't exist
                    if( fileExists('.git') ){
                        sh'''
                        git fetch --depth 1
                        '''
                    }
                    else {
                        sh '''
                        git init
                        git remote add origin https://github.com/geo-geo1551/geo-ecs-demo.git
                        git fetch --depth 1
                        git checkout -t origin/master 
                        '''
                    }
                }
                
            }

            
        }
        stage('apply_terraform') {
            environment {
               AWS_ACCESS_KEY_ID     = credentials('jenkins-aws-secret-key-id')
               AWS_SECRET_ACCESS_KEY = credentials('jenkins-aws-secret-access-key')
           }
            steps {
                
                
                //sh 'apt install -y git'
                //sh 'git clone --depth 1 https://github.com/geo-geo1551/geo-ecs-demo.git'
               
               /* 
                sh 'aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID'
                sh 'aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY'
                sh 'aws configure set default.region eu-west-1'
                sh 'aws configure set default.output json'
                 cd /home/developer/.jenkins/workspace/test/geo-ecs-demo
                    pwd
                */
                sh '''
                   
                    terraform init -input=false
                    terraform plan -out=tfplan -input=false
                '''
              //  sh 'terraform apply -input=false tfplan'
            }
        }
    }
}