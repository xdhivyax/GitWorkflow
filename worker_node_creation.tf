provider "aws" {
  access_key = "AWS_ACCESS_KEY_ID"
  secret_key = "AWS_SECRET_ACCESS_KEY"  
  region = "ap-south-1"  
}
resource "aws_instance" "worker" {
  ami           = "ami-00d3c4ab760d46f3b"
  instance_type = "t2.medium"
  key_name      = "poc"
  user_data = <<-EOF
    #!/bin/bash
    hostnamectl set-hostname worker-node-01 
    systemctl enable docker && systemctl start docker
    sleep 10
    kubeadm join 172.31.14.94:6443 --token jf9lvs.94jrh9ooguuaimqk \
      --discovery-token-ca-cert-hash sha256:7216869f8d7575313196563ec7dc409b4cd8718ace0b70929a6420c8bda9b2e7 \
      --cri-socket unix:///var/run/cri-dockerd.sock
  EOF
  tags = {
    Name = "worker-node-01"
  }
  root_block_device {
    volume_size           = 20
    volume_type           = "gp2"
    delete_on_termination = true
  }
 
}

