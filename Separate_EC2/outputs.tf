output "flask_instance_id" {
  description = "Flask EC2 instance ID"
  value       = aws_instance.flask.id
}

output "flask_public_ip" {
  description = "Flask EC2 public IP"
  value       = aws_instance.flask.public_ip
}

output "flask_url" {
  description = "Flask application URL"
  value       = "http://${aws_instance.flask.public_ip}:5000"
}

output "express_instance_id" {
  description = "Express EC2 instance ID"
  value       = aws_instance.express.id
}

output "express_public_ip" {
  description = "Express EC2 public IP"
  value       = aws_instance.express.public_ip
}

output "express_url" {
  description = "Express application URL"
  value       = "http://${aws_instance.express.public_ip}:3000"
}