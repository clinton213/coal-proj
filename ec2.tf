resource "aws_instance" "RHEL_ec2" {
  ami                  = "ami-0583d8c7a9c35822c"
  instance_type        = "t2.micro"
  subnet_id            = aws_subnet.Sub2.id
  key_name             = "TF_key"
  security_groups      = ["${aws_security_group.ssh-security-group.id}"]
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  root_block_device {
    volume_size = 20
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              service httpd start
              chkconfig httpd on
              EOF

  tags = {
    Name = "RHEL-coalfire_ec2"
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