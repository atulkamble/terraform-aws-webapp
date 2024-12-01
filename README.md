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

## Project Structure
```
├── main.tf
├── variables.tf
├── outputs.tf
├── README.md
├── .gitignore
```

## Usage

1. Clone this repository:
   ```bash
   git clone https://github.com/atulkamble/terraform-aws-webapp.git
   cd terraform-aws-webapp
   ```

Here's a **Terraform project** to set up a simple **web application environment** on AWS with the following components: 

1. **VPC** with public and private subnets.  
2. **EC2 Instances**: One public-facing and one private (web server and database).  
3. **Security Groups** to control access.  
4. **Elastic IP** for the public instance.

---

### **Project Structure**
```
terraform-project/
├── main.tf
├── variables.tf
├── outputs.tf
```

---

### **1. main.tf**
```hcl
# Provider Configuration
provider "aws" {
  region = "us-east-1"
}

# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Terraform-VPC"
  }
}

# Subnets
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public-Subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "Private-Subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Terraform-IGW"
  }
}

# Route Table for Public Subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Public-Route-Table"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security Groups
resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.main.id
  description = "Allow HTTP and SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web-SG"
  }
}

resource "aws_security_group" "db_sg" {
  vpc_id = aws_vpc.main.id
  description = "Allow MySQL traffic"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DB-SG"
  }
}

# EC2 Instances
resource "aws_instance" "web" {
  ami           = "ami-0c02fb55956c7d316" # Use a valid AMI ID for your region
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
  security_groups = [aws_security_group.web_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              echo "Welcome to Terraform Web Server" > /var/www/html/index.html
              sudo systemctl start httpd
              sudo systemctl enable httpd
              EOF

  tags = {
    Name = "Web-Instance"
  }
}

resource "aws_instance" "db" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private.id
  security_groups = [aws_security_group.db_sg.name]

  tags = {
    Name = "DB-Instance"
  }
}
```

---

### **2. variables.tf**
```hcl
variable "region" {
  default = "us-east-1"
}
```

---

### **3. outputs.tf**
```hcl
output "web_instance_public_ip" {
  value = aws_instance.web.public_ip
  description = "Public IP of the Web Instance"
}

output "db_instance_private_ip" {
  value = aws_instance.db.private_ip
  description = "Private IP of the Database Instance"
}
```

---

### **Steps to Deploy**
1. **Initialize Terraform:**
   ```bash
   terraform init
   ```

2. **Validate the Configuration:**
   ```bash
   terraform validate
   ```

3. **Plan the Infrastructure:**
   ```bash
   terraform plan
   ```

4. **Apply the Configuration:**
   ```bash
   terraform apply
   ```

---

This project sets up a simple yet functional environment. Let me know if you'd like further enhancements or explanations!
   
