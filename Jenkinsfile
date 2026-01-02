pipeline {
    agent any
    tools {
        maven 'maven'
    }

    stages {
        stage('Git Clone') {
            steps {
                script {
                    checkout([$class: 'GitSCM',
                        branches: [[name: 'main']],
                        userRemoteConfigs: [[url: 'https://github.com/RIMEZNADY/TP30.git']]
                    ])
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    // Vérifier si pom.xml est à la racine ou dans un sous-dossier
                    if (fileExists('pom.xml')) {
                        sh 'mvn clean install'
                    } else if (fileExists('POV-JAVA/pom.xml')) {
                        dir('POV-JAVA') {
                            sh 'mvn clean install'
                        }
                    } else {
                        // Chercher automatiquement le pom.xml
                        def pomPath = sh(script: 'find . -maxdepth 2 -name "pom.xml" -type f | head -1', returnStdout: true).trim()
                        if (pomPath) {
                            def projectDir = pomPath.replace('/pom.xml', '').replace('./', '')
                            if (projectDir && projectDir != '.') {
                                dir(projectDir) {
                                    sh 'mvn clean install'
                                }
                            } else {
                                sh 'mvn clean install'
                            }
                        } else {
                            error 'Aucun pom.xml trouvé dans le projet'
                        }
                    }
                }
            }
        }

        stage('Create Docker Image') {
            steps {
                script {
                    // Utiliser le même répertoire que pour le build
                    def buildDir = '.'
                    if (!fileExists('pom.xml')) {
                        if (fileExists('POV-JAVA/pom.xml')) {
                            buildDir = 'POV-JAVA'
                        } else {
                            def pomPath = sh(script: 'find . -maxdepth 2 -name "pom.xml" -type f | head -1', returnStdout: true).trim()
                            if (pomPath) {
                                buildDir = pomPath.replace('/pom.xml', '').replace('./', '')
                                if (!buildDir || buildDir == '.') {
                                    buildDir = '.'
                                }
                            }
                        }
                    }
                    dir(buildDir) {
                        sh 'docker build -t lachgar/pos .'
                    }
                }
            }
        }

        stage('Run') {
            steps {
                script {
                    sh 'docker stop test-pos || true'
                    sh 'docker rm test-pos || true'
                    sh 'docker run --name test-pos -d -p 8585:8282 lachgar/pos'
                }
            }
        }
    }
}
