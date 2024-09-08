# Coalfire Ask

- I defined the VPC with CIDR block `10.1.0.0/16`.
- Tag the VPC.
- Attach the IGW to the VPC for internet access.
- Create Sub1 (`10.1.0.0/24`, public).
- Create Sub2 (`10.1.1.0/24`, public).
- Create Sub3 (`10.1.2.0/24`, private).
- Create Sub4 (`10.1.3.0/24`, private).
- Create a public route table and associate it with Sub1 and Sub2.
- Create a private route table for Sub3 and Sub4 with Nat GW.
- Add an internet route (0.0.0.0/0) to the public route table via the IGW.
- Create security groups for the standalone EC2, ASG, and ALB with rules for SSH, HTTP, and internal traffic.
- I defined the EC2 instance with Red Hat Linux, t2.micro, 20GB storage.
- Attach a security group allowing SSH and HTTP.
- Use user data to install any required software (e.g., Apache).
- Associate an Elastic IP (EIP) for external access.
- I defined a launch template for Red Hat Linux with Apache installation script and AWS CLI.
- I defined the ASG across Sub3 and Sub4.
- Configure minimum 2 and maximum 6 instances.
- Attach the launch template and security group.
- I defined the ALB to listen on port 80 and forward traffic to the ASG on port 443.
- Attach the ALB security group.
- Assign an IAM role to allow reading from the "images" bucket by the ec2 instance.
- Create the images S3 bucket and configure lifecycle policies to move objects older than 90 days to Glacier.
- Create the logs S3 bucket and configure lifecycle policies for "active" (move objects to Glacier) and "inactive" (delete objects) folders.
- Grant the EC2 instances the permission to write logs to the Logs bucket.

## Prerequisites

Before starting, ensure you have the following:

- **AWS CLI** configured with appropriate credentials.
- **Terraform** installed and configured.

## Usage

### 1. Clone the Repository

```bash
git clone <git repository>
cd <repo name>
```

### 2. Initialize Terraform

Run the following command to initialize the Terraform project. This will download the required providers and initialize the backend.

```bash
terraform init
```

### 3. Review the Plan

To review the infrastructure changes Terraform will make, use the following command:

```bash
terraform plan
```

### 4. Apply the Configuration

After confirming the plan, apply the configuration to create the infrastructure:

```bash
terraform apply
```

Terraform will prompt you to confirm the changes. Type `yes` to proceed. Once applied, it will output the details of the created infrastructure, including the Application Load Balancer DNS name.

### 5. Access the Application

Once the infrastructure is provisioned, you can access the web application by visiting the DNS name of the Application Load Balancer:

```bash
terraform output alb_dns
```

### 6. Clean Up Resources

To avoid incurring charges, destroy the infrastructure once you're done:

```bash
terraform destroy
```
