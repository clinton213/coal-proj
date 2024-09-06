# I defined the Application Load Balancer (ALB) to listen on port 80 and forward traffic to ASG on port 443.
resource "aws_lb" "web_lb" {
  name               = "web-lb"
  internal           = false
  load_balancer_type = "application"

  access_logs {
    bucket  = aws_s3_bucket.logs2131_bucket.bucket # Reference your S3 logs bucket
    enabled = true
    prefix  = "alb-logs"
  }

  subnets = [
    aws_subnet.Sub1.id,
    aws_subnet.Sub2.id
  ]
  security_groups            = [aws_security_group.alb-security-group.id] # I attached the ALB security group
  enable_deletion_protection = false
}

# I defined a target group for the ASG
resource "aws_lb_target_group" "web_tg" {
  port     = 443
  protocol = "HTTPS"
  vpc_id   = aws_vpc.vpc.id
}

# I defined a Listener for the ALB
resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}
