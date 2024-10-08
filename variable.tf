# VPC Variables
variable "region" {
  default     = "us-east-1"
  description = "AWS Region"
  type        = string
}

variable "vpc-cidr" {
  default     = "10.1.0.0/16"
  description = "VPC CIDR Block"
  type        = string
}

variable "public-subnet-1-cidr" {
  default     = "10.1.0.0/24"
  description = "Public Subnet 1 CIDR Block"
  type        = string
}

variable "public-subnet-2-cidr" {
  default     = "10.1.1.0/24"
  description = "Public Subnet 2 CIDR Block"
  type        = string
}

variable "private-subnet-1-cidr" {
  default     = "10.1.2.0/24"
  description = "Private Subnet 1 CIDR Block"
  type        = string
}

variable "private-subnet-2-cidr" {
  default     = "10.1.3.0/24"
  description = "Private Subnet 2 CIDR Block"
  type        = string
}

variable "ssh-location" {
  default     = "0.0.0.0/0"
  description = "IP to ssh into EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "redhat_ami" {
  description = "AMI for the redhat instance"
  default     = "ami-0583d8c7a9c35822c"
}
