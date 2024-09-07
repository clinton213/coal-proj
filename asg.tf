resource "aws_launch_template" "web_launch_template" {
  name_prefix = "web-launch-template"

  image_id      = var.redhat_ami
  instance_type = var.instance_type
  key_name      = "TF_key"

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }

  # Security group for the EC2 instances
  vpc_security_group_ids = [aws_security_group.auto_sg.id]

  user_data = base64encode(<<-EOF
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
  )

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 20
      volume_type = "gp2"
    }
  }
}


# Auto Scaling Group
resource "aws_autoscaling_group" "web_asg" {
  launch_template {
    id      = aws_launch_template.web_launch_template.id
    version = "$Latest"
  }

  min_size         = 2
  max_size         = 6
  desired_capacity = 2
  vpc_zone_identifier = [
    aws_subnet.Sub3.id,
    aws_subnet.Sub4.id
  ]

  # I attached to the target group for the Application Load Balancer (ALB)
  target_group_arns = [aws_lb_target_group.web_tg.arn]

  tag {
    key                 = "Name"
    value               = "private instance"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scale_out" {
  name                   = "scale-out"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "scale-in"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
}
