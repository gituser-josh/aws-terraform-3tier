output "web_public_ip" {
  description = "Web server public IP"
  value       = aws_instance.web.public_ip
}

output "app_private_ip" {
  description = "App server private IP"
  value       = aws_instance.app.private_ip
}