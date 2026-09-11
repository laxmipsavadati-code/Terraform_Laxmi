output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.single_ec2.id
}

output "public_ip" {
  description = "Public IP address of EC2"
  value       = aws_instance.single_ec2.public_ip
}

output "flask_url" {
  description = "Flask application URL"
  value       = "http://${aws_instance.single_ec2.public_ip}:5000"
}

output "express_url" {
  description = "Express application URL"
  value       = "http://${aws_instance.single_ec2.public_ip}:3000"
}