output "public_url" {
  description = "Public URL of the Jenkins Instance"
  value       = "http://${aws_eip.jenkins.public_ip}:8080"
}

output "get_jenkins_password" {
  description = "Command to get default password via SSH"
  value       = "ssh -i jenkins-tf-key ec2-user@${aws_eip.jenkins.public_ip} sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
}
