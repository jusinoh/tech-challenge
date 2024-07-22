# AWS Setup with Terraform: ALB and EC2 Instance

## This guide will walk you through setting up an AWS environment with an Application Load Balancer (ALB) and an EC2 instance serving a simple web page using Terraform. The setup includes configuring security groups to allow proper communication between the ALB and the EC2 instance.

## Prerequisites

- AWS account with necessary permissions
- AWS CLI installed and configured
- Terraform installed
- An existing SSH key pair in your AWS account (AWS CLI) or via CloudShell

### Step 1: Clone the Repository

First, clone the GitHub repository to your local machine.
```
git clone https://github.com/jusinoh/tech-challenge.git
cd tech-challenge/terraform
```

### Step 2: Update all necessary variables

### Step 3: Terraform Steps

```
terraform validate
```
- Confirm all the scripts do not have syntax errors

```
terraform plan
```
- Review the deployment and all configurations align with what is in scope and intended

```
terraform apply auto-approve
```
- Deploy the resources within AWS and approve the buildout without the yes or no interaction

### Step 4: Validate server is stoof up via AWS Direct Connect

- Visit the AWS Console and go into the EC2 management console
- Click the instance that was stood up via this deployment
- Click the Connect button on the right hand side
- Ensure you are logging in via the ec2-user and connect (this assumes that your role in the environment has the proper permissions to use AWS Direct Connect)
- Enter the following command at the cli to validate the web server stood up:
```
sudo systemctl status
```