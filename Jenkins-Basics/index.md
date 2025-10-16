+++
date = '2025-10-15T20:54:50-05:00'
title = 'Jenkins Pipeline Basics'
+++

## JENKINS PIPELINE TEMPLATE
What is a `Jenkinsfile`?
It is a text file that contains instructions, templates, definitions.

It needs some `plugins` or pointers to those `plugins` in order to work. So it can establish connections to AWS, AZURE, etc

**Template:**
```
pipeline {
  agent any
  
  stages {
    stage('Build') {
      steps {
        echo 'Building...'
      }
    }
    stage('Test') {
      steps {
        echo 'Testing...'
      }
    }
    stage('Deploy') {
      steps {
        echo 'Deploying...'
      }
    }
  }
}
```

- `pipeline`: Task that you are trying to accomplish
- `agent any`: Build Agent
- `Stages`: This are the stages
- `Steps`: The work that is being done in the `pipeline`

### Multi Stage Pipeline
![](Pasted%20image%2020251015210510.png)

## JENKINSFILE EXAMPLE
File named `Jenkinsfile`

This is just an example that could be considered as reference:

```
pipeline {
  agent any
  tools {
    go 'go-1.17'
  }
  
  environment {
    GO111MODULE='on'
  }
  
  stages {
    stage('Test') {
      steps {
        git 'https://github.com/AdminTurnedDevOps/go-webapp-sample.git'
        sh 'go test ./..'
      }
    }
    stage('Build') {
      steps {
        git 'https://github.com/AdminTurnedDevOps/go-webapp-sample.git'
        sh 'go build .'
      }
    }
    stage('Run') {
      steps {
        sh 'cd /var/lib/jenkins/workspace/go-full-pipeline && go-webapp-sample &'
      }
    }
  }
}
```

For building our image we could use:
```
stages {
  stage ('Building our image') {
    steps {
      script {
        app = docker.build("adminturneddevops/go-webapp-sample")
      }
    }
  }
}
```

**Considerations:**
- All pipelines are under `/var/lib/jenkins/workspace/` and in this case the name is `go-full-pipeline`
- Using Plugins `GO`and `Docker`
