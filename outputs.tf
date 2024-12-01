output "web_instance_public_ip" {
  value       = aws_instance.web.public_ip
  description = "Public IP of the Web Server"
}

output "web_instance_url" {
  value       = "http://${aws_instance.web.public_ip}"
  description = "URL of the Web Server"
}
