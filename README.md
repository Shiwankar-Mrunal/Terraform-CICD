# CI_CD_Pipeline

## Folder Structure :

```
Terraform-CICD/
│
├── .github/
│ └── workflows/
│ ├── AppServiceCD-deploy.yml # GitHub Actions workflow for deploying App Service
│ ├── MicroserviceCI.yml # CI workflow for microservices
│ └── Terraform-CICD.yml # Combined Terraform and CICD workflow
│
├── ci-app/
│ └── app.py # Flask application code for deployment
│
├── Terraform_pipeline/
│ ├── modules/
│ │ ├── variables.tf # Terraform variables module
│ │ └── webapp.tf # Terraform module defining web app resources
│ ├── main.tf # Main Terraform configuration file
│ ├── provider.tf # Terraform Azure provider configuration
│ ├── tfplan.out # Terraform plan output file (auto-generated)
│ └── variable.tf # Input variables for Terraform pipeline
│
├── Dockerfile # Docker configuration file for containerizing the app
│
└── README.md # Project documentation and instructions

```


## Dockerfile

## Base Image
Uses Python 3.11 official image as the starting point.
### Set Working Directory
Sets /app inside the container as the folder where commands will run.
### Copy Dependencies File
Copies requirement.txt (list of Python packages) into the container.
### Install Dependencies
Runs pip install to install all packages listed in requirement.txt.
### Copy Application Code
Copies all files from your ci-app/ folder into the container’s /app directory.
### Environment Variables
PYTHONDONTWRITEBYTECODE=1 prevents Python from creating .pyc files (cache).
PYTHONUNBUFFERED=1 makes Python output logs immediately without buffering.
### Run the App
When the container starts, it runs the Flask app by executing python app.py.

## main.tf
This Terraform code creates an Azure Resource Group using given name and location variables. Inside this group, it provisions an Azure Container Registry with a specified name. The registry uses the Basic pricing tier and enables admin access. It inherits the location of the resource group. A tag marks the environment as "production."

## provider.tf
This Terraform configuration specifies the AzureRM provider version 3.70.0 to manage Azure resources. The provider block initializes Azure settings with default features enabled.

## variable.tf
These variables define input values for the Terraform configuration, including the resource group name (myrg), location (myloc), Azure Container Registry name (myarc), and web app name (web_app_name). They allow the configuration to be flexible and reusable.

## modules
### webapp.tf
- App Service Plan (azurerm_app_service_plan.app1)

- Creates a Windows App Service Plan in the specified resource group and location.

- Uses Basic tier (B1) for hosting web apps.

- Web App (azure_app_service.my_web_app1)

- Deploys a web application linked to the App Service Plan.

- Uses the same resource group and location.

-Configuration for Docker container deployment and app settings is commented out.


## app.py
```
This Python code creates a simple Flask web application that returns "Hello from Azure Web App!" at the root URL. It reads the port number from the environment variable PORT (set by Azure) or defaults to 5000. The app runs on all network interfaces (0.0.0.0) so it’s accessible externally.
```

## Terraform-CICD.yml
```
This GitHub Actions workflow automates Terraform-based Azure infrastructure deployment. It triggers on pushes to the main branch, sets up Terraform 1.5.0, and runs init, fmt, validate, and plan on the Terraform pipeline folder. The workflow uploads the plan as an artifact and automatically applies it when changes are pushed to the main branch, provisioning Azure resources.
```
## MicroserviceCI.yml
```
This GitHub Actions workflow sets up a CI pipeline for a Python microservice.

Build Job: Checks out code, sets up Python 3.8, installs dependencies, lints with flake8, runs unit tests with Pytest, performs a security scan with Bandit, and builds a Docker image.

Build-and-Push Job: Logs into Azure, authenticates with Azure Container Registry (ACR), tags the Docker image, and pushes it to the ACR.
```
## AppServiceCD-deploy.yml

```
This GitHub Actions workflow defines a CD pipeline to deploy a Dockerized Python app to Azure App Service.

Logs into Azure using service principal credentials.

Pulls the Docker image from Azure Container Registry (ACR).

Configures the Azure Web App to use this image and restarts the app to apply the deployment.

```
