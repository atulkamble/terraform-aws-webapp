# Terraform Project: Deploying a Web Application on AWS

## Description
This project uses Terraform to provision AWS resources for a simple web application environment. It demonstrates Infrastructure as Code (IaC) to set up a highly available and scalable environment.

## Features
- A Virtual Private Cloud (VPC) with public and private subnets.
- An EC2 instance running a web server.
- Security Groups to control network access.
- Automatically configured web server with HTTPD.

## Prerequisites
- AWS CLI configured with appropriate permissions.
- Terraform installed (v1.x or later).

## Usage

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/terraform-aws-webapp.git
   cd terraform-aws-webapp
