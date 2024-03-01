terraform {
  required_version = "1.7.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.36.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-06cc514f1012a7431" # Imagem do Sistema Operacional Windows Server 2019
  instance_type = "t2.micro" # Tipo da máquina
  key_name      = "AWS_WindowsServer" # Associando a chave privada à instância
  tags = {
    Name = "WindowsServer-RodrigoPerin"
  }

  # Adicionando regras de segurança para permitir o acesso via RDP (porta 3389) e WinRM (porta 5986)
  security_groups = ["${aws_security_group.rdp_and_winrm_access.name}"]
}

resource "aws_security_group" "rdp_and_winrm_access" {
  name        = "rdp_and_winrm_access"
  description = "Allow RDP and WinRM access"

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permite acesso de qualquer IP
  }

  ingress {
    from_port   = 5986
    to_port     = 5986
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permite acesso de qualquer IP
  }
}