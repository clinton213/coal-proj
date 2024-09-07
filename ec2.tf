resource "aws_instance" "RHEL_ec2" {
  ami                  = var.redhat_ami
  instance_type        = var.instance_type
  subnet_id            = aws_subnet.Sub2.id
  key_name             = "TF_key"
  security_groups      = ["${aws_security_group.ssh-security-group.id}"]
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  root_block_device {
    volume_size = 20
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo yum install vim -y
              sudo yum install -y unzip
              curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
              unzip awscliv2.zip
              sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update
              sudo systemctl start httpd
              sudo systemctl enable httpd
              EOF

  user_data_replace_on_change = true
  tags = {
    Name = "rhat-coalfire_ec2"
  }
}


resource "aws_key_pair" "TF_key" {
  key_name   = "TF_key"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#Used to create local terraform resource to store key
resource "local_file" "TF-key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "tfkey"
}
