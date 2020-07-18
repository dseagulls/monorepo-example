# Monorepo
This repo is to demonstrate the entire CI/CD pipeline & infrastructure for a microservice project.

This project has 3 goals.

1. The only dependency to build this project is docker
    - Testing, Building, Deploying should be done in containers that can be run anywhere
2. Where possible, stay agnostic from tools
    - Example: Use Jenkins to run containers that build verses building directly in Jenkins
3. Everything is done incrementally
    - Release small changes instead of releasing large features

## Structure

This repo will follow a defined structure, services should exist in the root and anything non-service related is in the _management folder

    .
    ├── _management             # Anything not directly related to a service
    │   ├── aks-cluster         # Terraform to create AKS cluster
    │   │   ├── definition.yml  # Definition file to specify that this folder is terraform files
    │   ├── nginx-ingress       # Helm chart to deploy an nginx ingress
    │   ├── helm-deploy         # Dockerfile to create image to deploy helm charts
    │   └── README.md               
    ├── ServiceA                # Folder containing everything related to `ServiceA`
    │   ├── definition.yml      # Definition file to specify that this folder is a dockerfile
    ├── ServiceB                # Folder containing everything related to `ServiceB`
    └── README.md

## Infrastructure

Everything will be built in Azure, a later goal will be to make this deployable to various cloud services.

Current technology used in this project is

1. Docker
2. Terraform
3. AKS (Azure Kubernetes Service)
