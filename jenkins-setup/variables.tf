variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "aws_region" {
  default = "eu-west-1"
}

variable "ec2_instance_type" {
  default = "t3.large"
}

variable "jenkins_volume_size" {
  default = 50
}
