output "alb_dns" {
  description = "The DNS of the Application Load Balancer"
  value       = aws_lb.web_lb.dns_name
}
