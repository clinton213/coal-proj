# I defined a launch configuration for Red Hat Linux with Apache installation script.
resource "aws_launch_configuration" "web_config" {
  image_id        = var.redhat_ami
  instance_type   = var.instance_type
  security_groups = [aws_security_group.auto_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              service httpd start
              chkconfig httpd on
              curl "https://d1uj6qtbmh3dt5.cloudfront.net/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
              unzip awscliv2.zip
              sudo ./aws/install
              rm awscliv2.zip
              EOF
}

# Minimum 2 and Maximum 6 instances.
resource "aws_autoscaling_group" "web_asg" {
  launch_configuration = aws_launch_configuration.web_config.id
  min_size             = 2
  max_size             = 6
  desired_capacity     = 2
  vpc_zone_identifier = [
    aws_subnet.Sub3.id,
    aws_subnet.Sub4.id
  ]


  # I attached to the target group for the Application Load Balancer (ALB)
  target_group_arns = [aws_lb_target_group.web_tg.arn]

  health_check_type         = "ELB"
  health_check_grace_period = 300


}
