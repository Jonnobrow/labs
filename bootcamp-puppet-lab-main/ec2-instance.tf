terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "eu-west-1"
}

resource "aws_security_group" "variable-demo" {
  name = "puppet machines"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.cidrip]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.cidrip]
  }
  ingress {
    from_port   = 8140
    to_port     = 8140
    protocol    = "tcp"
    cidr_blocks = [var.cidrip]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidrip]
  }

}

resource "aws_key_pair" "puppet_master" {
  key_name   = "master-key"
  public_key = file("./master_key.pub")
}

resource "aws_key_pair" "puppet_agent" {
  key_name   = "agent-key"
  public_key = file("./agent_key.pub")
}

resource "aws_instance" "master" {
  ami           = var.ubuntu_18_puppet_ami
  instance_type = "t3.large"
  tags = {
    Name = "puppet_master"
  }
  vpc_security_group_ids = [aws_security_group.variable-demo.id]
  key_name               = aws_key_pair.puppet_master.key_name
}

resource "aws_instance" "agent" {
  ami           = var.ubuntu_18_puppet_ami
  instance_type = "t2.micro"
  tags = {
    Name = "puppet_agent"
  }
  vpc_security_group_ids = [aws_security_group.variable-demo.id]
  key_name               = aws_key_pair.puppet_agent.key_name
}

resource "aws_eip" "eip_master" {
  vpc = true
}

resource "aws_eip_association" "eip_master_map" {
  instance_id   = aws_instance.master.id
  allocation_id = aws_eip.eip_master.id
}

resource "aws_eip" "eip_agent" {
  vpc = true
}

resource "aws_eip_association" "eip_agent_map" {
  instance_id   = aws_instance.agent.id
  allocation_id = aws_eip.eip_agent.id
}
