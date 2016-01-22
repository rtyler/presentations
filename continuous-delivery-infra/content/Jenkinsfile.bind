#!groovy

def imageName = 'jenkinsciinfra/bind'
def imageTag = new Date().format('YMd_HmS')

node('docker') {
    checkout scm

    stage 'Build'
    def whale = docker.build("${imageName}:${imageTag}")

    stage 'Deploy'
    whale.push()
}
