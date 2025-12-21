output "load_balancer_dns" {
  value = aws_lb.nginx-alb.dns_name
}

output "efs_id" {
  value = aws_efs_file_system.wordpress-efs.id
}
