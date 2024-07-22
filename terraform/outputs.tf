output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.web_server.id
}

output "alb_dns" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.alb.dns_name
}
