# Part 1 - Flask and Express on a Single EC2 Instance

## Objective

Deploy a Flask backend and Express frontend on a single AWS EC2 instance using Terraform.

## Technologies Used

- Terraform
- AWS EC2
- Ubuntu
- Python
- Flask
- Node.js
- Express
- AWS Security Groups

## Architecture

Internet
   |
   v
AWS EC2 Instance
   |
   +---- Flask Backend - Port 5000
   |
   +---- Express Frontend - Port 3000

## Terraform Resources

Terraform creates:

- AWS EC2 instance
- AWS Security Group
- Ubuntu AMI
- Security rules for SSH, Flask and Express

## Application Ports

| Application | Port |
|-------------|------|
| Flask | 5000 |
| Express | 3000 |
| SSH | 22 |

## Terraform Commands

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply