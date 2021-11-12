output "public_ip" {
    description = "Public IP of the Jenkins Instance"
    value = aws_eip.jenkins.public_ip
}
