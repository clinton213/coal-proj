# I defined the Application Load Balancer (ALB) to listen on port 80 and forward traffic to ASG on port 443.
resource "aws_lb" "web_lb" {
  name               = "web-lb"
  internal           = false
  load_balancer_type = "application"


  subnets = [
    aws_subnet.Sub1.id,
    aws_subnet.Sub2.id
  ]
  security_groups            = [aws_security_group.alb-security-group.id]
  enable_deletion_protection = false
}

# I defined a target group for the ASG
resource "aws_lb_target_group" "web_tg" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  health_check {
    path                = "/health"
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }
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
