terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.65.0"
    }
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

data "aws_ami" "aws2_ami" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "jenkins" {
  key_name   = "jenkins-tf-key"
  public_key = file("jenkins-tf-key.pub")
}

resource "aws_instance" "jenkins" {
  ami                    = data.aws_ami.aws2_ami.id
  instance_type          = var.ec2_instance_type
  key_name               = aws_key_pair.jenkins.key_name
  user_data              = file("./user-data.sh")
  vpc_security_group_ids = [aws_security_group.jenkins.id]

  root_block_device {
    volume_size = var.jenkins_volume_size
  }

  tags = {
    Name = "Jenkins Build Server (tf)"
  }
}

resource "aws_eip" "jenkins" {
  instance = aws_instance.jenkins.id
  vpc      = true
}

resource "aws_security_group" "jenkins" {
  name        = "jenkins"
  description = "Allow jenkins web traffic and SSH"

  ingress {
    description      = "Jenkins Web"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Jenkins SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}
