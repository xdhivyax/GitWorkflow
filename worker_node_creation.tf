provider "aws" {
  
  region = "ap-south-1"  
}
variable "client" {
  description = "Client name to distinguish resources"
  type        = string
}

resource "aws_instance" "worker" {
  ami           = "ami-07381000ce5b566ef"
  instance_type = "t2.medium"
  key_name      = "poc"
  user_data = <<-EOF
    #!/bin/bash
    hostnamectl set-hostname worker-node-01 
    systemctl enable docker && systemctl start docker
    sleep 10
    kubeadm join 172.31.15.168:6443 --token x31v4h.ojg4aakmrzas2cjg \
      --discovery-token-ca-cert-hash sha256:5b15698ea050b0ed4ec9a2d5dbff481e3ad0cfa7138dbadaea54439e3569f35e \
      --cri-socket unix:///var/run/cri-dockerd.sock
  EOF
  tags = {
    Name        = "${var.client}-worker-node"
    Environment = "Client-${var.client}"
    ManagedBy   = "Terraform"
  }
  root_block_device {
    volume_size           = 20
    volume_type           = "gp2"
    delete_on_termination = true
  }
 
}

