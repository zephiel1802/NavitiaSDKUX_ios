#!/usr/bin/env groovy
pipeline {
    agent {
        node { label 'Tatie' }
    }
    stages {
        stage('Building & Testing') {
            steps {
                sh 'xcodebuild -scheme NavitiaSDKUITests -sdk iphonesimulator -destination \'platform=iOS Simulator,name=iPhone 6,OS=12.2\' test'
            }
        }
    }
    post {
        always {
            /* clean up our workspace */
            deleteDir()
                /* clean up tmp directory */
                dir("${workspace}@tmp") {
                    deleteDir()
                }
            /* clean up script directory */
            dir("${workspace}@script") {
                deleteDir()
            }
        }
    }
}
