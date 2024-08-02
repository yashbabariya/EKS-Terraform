# EKS-Terraform
#### Deploy  all this below AWS services and Databases using terraform modules.
1. VPC
2. Subnet
3. IGW
4. NAT
5. RouteTables
6. Security-Group
7. EKS cluster
8. NodeGroups
9. Add-on
10. IAM roles
11. IAM-oidc-provider
12. ALB controller
13. EBS-csi-driver
14. Mongodb
15. Rabbitmq
16. redis
17. postgresql 

### Prerequisites?
* Before you begin, ensure you meet the following prerequisites:
1. You have installed Terraform. (https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
2. You have an AWS account. (https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/)

#### Configuration
* You need to manage the variables in the vars.tfvars file. This file contains the configuration for all deployed resources. Be sure to input your specific values for your resources.

### Quick Start
1. Clone the repository:
```
git clone <repository-url>
```
2. aws configure:
```
aws configure --profile=default
aws_access_key_id:
aws_secret_access_key:
region:
```
3. Initialize terraform:
```
terraform init
```
4. Validate the changes:
```
terraform validate
```
5. Reformat your configuration in the standard style:
```
terraform fmt
```
6. Plan the changes:
```
terraform plan -var-file=vars.tfvars
```
7. Apply the changes:
```
terraform apply -var-file=vars.tfvars
```
To confirm the changes, type yes and press ENTER.

#### Clean Up
Once the resources are no longer needed, you can use Terraform to destroy them:
```
terraform destroy -var-file=vars.tfvars
```
To confirm the destroy process, type yes and press ENTER.
