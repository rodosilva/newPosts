+++
date = '2025-10-15T20:05:33-05:00'
title = 'GitLab CI/CD Basics'
+++

## INTRODUCTION
This is a basic preview of what `GitLab CI/CD` is.
Everything is Configuration as Code and it is specified on a file named `.gitlab-ci.yml` located at the root of our repository.

`.gitlab-ci.yml` is going to run trough different `jobs` inside a `GitLab Runner`

We can get more details on the oficial [Documentation](https://docs.gitlab.com/topics/build_your_application/)

## KEYWORDS
Since it is configured on a `yaml` file, we need to know some `keywords` for the structure and instructions given to our `jobs`

| Keywords        | Short Description                                                                     |
| --------------- | ------------------------------------------------------------------------------------- |
| `variables`     | Used to list our variables                                                            |
| `stages`        | Used to define the different stages on our pipeline                                   |
| `image`         | Define the image that `Docker` is going to use for the run                            |
| `before_script` | Define a set of commands to be executed before `script`                               |
| `script`        | Set of commands to be executed                                                        |
| `services`      | To specify any additional Docker images that your scripts require to run successfully |
**_Note:_** For the complete list of `keywords`, click [HERE](https://docs.gitlab.com/ci/yaml/#needs)

## CI/CD VARIABLES AND SECRETS
Since we don't want to hard code tokens, passwords or secrets. We can use `CI/CD Variables`. Which are under `Settings -> CI/CD -> Variables`.

Those can be called by using something like `$SECRET_PASSWORD`

## EXAMPLE
Below we will se an example or use case.
It is just a `yaml` file to be considered as a reference. It shows 3 stages `test`, `build` and `deploy`.

```yaml
variables:
  IMAGE_NAME: nanajanashia/demo-app
  IMAGE_TAG: python-app-1.0

stages:
  - test
  - build
  - deploy

run_tests:
  stage: test
  image: python:3.9-slim-buster
  before_script:
    - apt-get update && apt-get install make
  script:
    - make test


build_image:
  stage: build
  image: docker:20.10.16
  services:
    - docker:20.10.16-dind
  variables:
    DOCKER_TLS_CERTDIR: "/certs"
  before_script:
    - docker login -u $REGISTRY_USER -p $REGISTRY_PASS
  script:
    - docker build -t $IMAGE_NAME:$IMAGE_TAG .
    - docker push $IMAGE_NAME:$IMAGE_TAG


deploy:
  stage: deploy
  before_script:
    - chmod 400 $SSH_KEY
  script:
    - ssh -o StrictHostKeyChecking=no -i $SSH_KEY root@161.35.223.117 "
        docker login -u $REGISTRY_USER -p $REGISTRY_PASS &&
        docker ps -aq | xargs docker stop | xargs docker rm &&
        docker run -d -p 5000:5000 $IMAGE_NAME:$IMAGE_TAG"

```

**_Note:_** Example based on this [repo](https://gitlab.com/nanuchi/gitlab-cicd-crash-course)



