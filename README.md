
# Wallester DevOps Engineer Challenge

This repository uses Terraform, CloudFormation, and Helm chart configurations to provision and manage infrastructure and application deployments for the Wallester DevOps Engineer Challenge, leveraging GitHub Actions.

## Repository Overview

- **Helm Chart**:
`helm/my-k8s-deployment` Helm chart installs K8s resources needed to run the my-k8s-deployment application. 
  - Sets up a Deployment, Service, HPA and Ingress to expose the app through an HTTPS enabled ALB. 
  - EKS cluster uses the AWS Load Balancer Controller and ExternalDNS to automatically create the necessary components to make the app accessible over the internet.
  - Deploys busybox:latest and nginx:1.27.2 containers.
  - Adds the label app:my-app to the Pods/Deployment.
  - Uses a Hello-World ConfigMap to replace the default default Nginx webpage.
  - Configured the Pods to be accessible only from the IP address 88.196.208.91/32 using the Security Group created by the ELB module.
  - Configured to run the PODs without priviledge access (non-root user, read-only filesystem and all capabilities dropped).
  - Using Horizontal Pod Autoscaler (HPA) for POD autoscaling based on resource utilizations (cpu:40%, mem:80%).

- **CloudFormation Template**:
Created `bootstrap.yaml` Cloudformation template to boostrap S3 bucket, dynamodb table creation. These resources will be used by the Terraform code as prerequisites.

- **Terraform**:
`infra` contains Terraform code to provision infrastructure in AWS account. 
  - Points to a separate repository which has version controlled Terraform modules: https://github.com/sarithekanayake/wallester-idp-modules
  - Deploys an EC2 instance with high availability for Task 01, and creates an EKS cluster along with other required services for Task 02.
  - base_values folder contains `my-k8s-deployment.yaml` file which uses for my-k8s-deployment Helm chart.

- **GitHub Action Workflow**:
`.github/workflows/main.yml` use as the GitHub pipeline for bootstrapping (S3 Bucket, DynamoDB), infrastructure creation and application deployment using Terraform. 



## Prerequisites

- GitHub account (https://gitlab.com/)
- AWS account (https://console.aws.amazon.com/)
- AWS CLI installed (https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- kubectl CLI installed (https://kubernetes.io/docs/tasks/tools/)
- A regular IAM user for use with GitHub Actions, configured with AWS_ACCESS_KEY_ID and SECRET_ACCESS_KEY

## How-to

### On GitHub official website
    1. Login into your GitHub account.
    2. Fork this repository to your GitHub space. 
    3. You will be automatically navigated to your forked GitHub repository.
    4. Navigate to `Secrets and variables` in Settings tab.
    5. Drop down `Secrets and variables` and select `Actions`.
    6. Click on `New repository secret`.
    7. Create variables called `AWS_ACCESS_KEY_ID` and `SECRET_ACCESS_KEY` using the credentials of the GitHub Action IAM user.
    8. Navigate to `Secrets and variables` again.
    9. Click on `New repository variable`.
    10. Create variables called `AWS_REGION`, `S3BUCKETNAME`, `DYNAMODB_TABLE`, `TF_KEY` with the correct values.
            Ex:
                AWS_REGION = eu-west-1
                S3BUCKETNAME = sarith-wallester-challenge-tf-bucket (use an unique name)
                DYNAMODB_TABLE = terraform-tfstate
                TF_KEY = terraform.tfstate

    11. Open the `terraform.tfvars` file and update the values based on your setup.
    12. Commit the changes to the `master` branch.
    13. Commit should trigger a new workflow execution.
    14. Wait for the workflow to complete.
    


### On the local machine
 
    1. Open up a new terminal window.
    2. Run `aws eks update-kubeconfig --region <region-code> --name <cluster-name>`. Replace the region and name of the EKS cluster with correct values.
    3. Now, should be able to interact with the EKS cluster using kubectl.
    4. To check HPA, use a load testing tool like `hey` to simulate traffic. ex: `hey -z 60s -c 50 https://wallester.sarithe.online`
    5. To check Cluster Autoscaler, deploy a workload that exceeds the capacity of the current nodes.



### Browser 
Visit https://wallester.sarithe.online (or the associated domain name) to access my-k8s-deployment application. The connection will automatically redirect to https://, as the application is configured with TLS/SSL. Certificate is issued by Amazon and managed through AWS Certificate Manager.