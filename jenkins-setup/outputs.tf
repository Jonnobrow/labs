output "public_url" {
  description = "Public URL of the Jenkins Instance"
  value       = "http://${aws_eip.jenkins.public_ip}:8080"
}
